import React, {useEffect, useLayoutEffect, useMemo, useRef, useState} from 'react';
import {
  AbsoluteFill,
  OffthreadVideo,
  Img,
  Sequence,
  cancelRender,
  continueRender,
  delayRender,
  staticFile,
  useCurrentFrame,
  useVideoConfig,
} from 'remotion';

type Props = {
  assetPath?: string;
  posterPath?: string;
  prototypePath?: string;
  assetDurationMs?: number;
  assetFrameCount?: number;
  assetWidth?: number;
  assetHeight?: number;
  assetFpsNumerator?: number;
  assetFpsDenominator?: number;
  playStartFrame?: number;
  assetFileName?: string;
  assetRightsBasis?: string;
};

type PrototypeWindow = Window & {
  renderAt?: (time: number) => void;
  setWallpaperStyle?: (style: string) => void;
};

type WindowGeometry = {
  x: number;
  y: number;
  w: number;
  h: number;
  a: number;
  full: number;
};

const clamp = (x: number, low = 0, high = 1) => Math.max(low, Math.min(high, x));
const smooth = (x: number) => {
  const value = clamp(x);
  return value * value * (3 - 2 * value);
};
const mix = (a: number, b: number, t: number) => a + (b - a) * t;

// Keep the original V2 Research Aqua canvas source intact and change only its
// placeholder media clock/content hooks for this real local media adapter.
const patchResearchAquaHtml = (
  html: string,
  durationSeconds: number,
  playStartSeconds: number,
): string => {
  const replaceOnce = (input: string, find: string, replacement: string, label: string) => {
    const first = input.indexOf(find);
    if (first < 0 || input.indexOf(find, first + find.length) >= 0) {
      throw new Error(`V2 adapter patch target must occur once: ${label}`);
    }
    return input.slice(0, first) + replacement + input.slice(first + find.length);
  };
  const playLine = `const PROTOTYPE_DURATION=9, PLAY_START=4.76, ASSET_DURATION=12.0;`;
  const patchedPlayLine = `const PROTOTYPE_DURATION=9, PLAY_START=${playStartSeconds}, ASSET_DURATION=${durationSeconds};`;
  let patched = replaceOnce(html, playLine, patchedPlayLine, 'duration and play start');
  const formatterAnchor = `const clamp=(x,a=0,b=1)=>Math.max(a,Math.min(b,x));`;
  patched = replaceOnce(
    patched,
    formatterAnchor,
    `${formatterAnchor}\nfunction formatClock(seconds){const n=Math.max(0,Math.floor(seconds));return String(Math.floor(n/60)).padStart(2,'0')+':'+String(n%60).padStart(2,'0')}`,
    'clock formatter insertion',
  );
  patched = replaceOnce(
    patched,
    `if(innerH>30){setupIllustration(x,top,innerW,innerH,Math.max(0,t-PLAY_START),t>=PLAY_START);`,
    `if(innerH>30){`,
    'replace V2 illustration with input media layer',
  );
  patched = replaceOnce(
    patched,
    "txt(`00:${String(Math.floor(clipTime)).padStart(2,'0')}`,progressX-50",
    `txt(formatClock(clipTime),progressX-50`,
    'elapsed media time display',
  );
  patched = replaceOnce(
    patched,
    `txt('00:12',progressX+progressW+54`,
    `txt(formatClock(ASSET_DURATION),progressX+progressW+54`,
    'actual media duration display',
  );
  return replaceOnce(
    patched,
    `G1V-A V2  /  ORIGINAL ILLUSTRATION`,
    `G1V-A V2  /  LOCAL TEST MEDIA`,
    'test media watermark',
  );
};

const replaceMediaFilename = (html: string, assetFileName: string): string => {
  if (!/^[A-Z0-9_-]+\.mp4$/.test(assetFileName)) {
    throw new Error('Media display filename must be a simple uppercase MP4 filename');
  }
  const matches = html.match(/JELLY_01\.mov/g) ?? [];
  if (matches.length !== 2) throw new Error('Expected the archived V2 filename in exactly two UI labels');
  return html.replaceAll('JELLY_01.mov', assetFileName);
};

function assertMediaProps(props: Props): asserts props is Required<Props> {
  const paths = [props.assetPath, props.posterPath, props.prototypePath];
  if (!paths.every((value) => typeof value === 'string' && value.length > 0)) {
    throw new Error('Media, poster, and locked prototype paths are required');
  }
  const legacyM1Input =
    props.assetFileName === undefined &&
    props.assetRightsBasis === undefined &&
    typeof props.assetPath === 'string' &&
    /^cws-g1va-v2-media-m1-[a-z0-9-]+\/local-demo\.mp4$/.test(props.assetPath.replaceAll('\\', '/')) &&
    props.assetDurationMs === 6000 &&
    props.assetFrameCount === 180 &&
    props.assetWidth === 1920 &&
    props.assetHeight === 1080 &&
    props.assetFpsNumerator === 30 &&
    props.assetFpsDenominator === 1 &&
    props.playStartFrame === 143;
  if (legacyM1Input) {
    props.assetFileName = 'LOCAL-DEMO.mp4';
    props.assetRightsBasis = 'self_generated_local_test_only';
  }
  if (typeof props.assetFileName !== 'string' || !/^[A-Z0-9_-]+\.mp4$/.test(props.assetFileName)) {
    throw new Error('Media display filename must be a simple uppercase MP4 filename');
  }
  if (
    typeof props.assetDurationMs !== 'number' || !Number.isSafeInteger(props.assetDurationMs) || props.assetDurationMs <= 0 ||
    typeof props.assetFrameCount !== 'number' || !Number.isSafeInteger(props.assetFrameCount) || props.assetFrameCount <= 0 ||
    typeof props.assetWidth !== 'number' || !Number.isSafeInteger(props.assetWidth) || props.assetWidth <= 0 ||
    typeof props.assetHeight !== 'number' || !Number.isSafeInteger(props.assetHeight) || props.assetHeight <= 0 ||
    typeof props.assetFpsNumerator !== 'number' || !Number.isSafeInteger(props.assetFpsNumerator) || props.assetFpsNumerator <= 0 ||
    typeof props.assetFpsDenominator !== 'number' || !Number.isSafeInteger(props.assetFpsDenominator) || props.assetFpsDenominator <= 0
  ) {
    throw new Error('Media metadata must contain positive integer duration, dimensions, frame count, and FPS');
  }
  if (typeof props.playStartFrame !== 'number' || !Number.isSafeInteger(props.playStartFrame) || props.playStartFrame < 0) {
    throw new Error('Media play start must be a non-negative composition frame');
  }
  if (props.assetRightsBasis !== 'self_generated_local_test_only') {
    throw new Error('Only self-generated local test media is allowed in this gate');
  }
}

const getWindowGeometry = (time: number): WindowGeometry | null => {
  if (time < 1.92) return null;
  const opening = smooth((time - 1.92) / 0.68);
  const base = {x: 390, y: 156, w: 1140, h: 744};
  if (time <= 3.23) {
    return {
      x: mix(1518, base.x, opening),
      y: mix(335, base.y, opening),
      w: mix(120, base.w, opening),
      h: mix(105, base.h, opening),
      a: smooth((time - 1.92) / 0.15),
      full: 0,
    };
  }
  const expansion = smooth((time - 3.23) / 0.52);
  return {
    x: mix(base.x, 0, expansion),
    y: mix(base.y, 0, expansion),
    w: mix(base.w, 1920, expansion),
    h: mix(base.h, 1080, expansion),
    a: 1,
    full: expansion,
  };
};

export const ResearchAquaMediaAdapter: React.FC<Props> = (props) => {
  assertMediaProps(props);
  const frame = useCurrentFrame();
  const {fps, durationInFrames} = useVideoConfig();
  if (fps !== 30 || durationInFrames !== 270) {
    throw new Error('M2 output composition must remain 1920x1080 at 30fps for 270 frames');
  }
  const outerTime = frame / fps;
  const assetDurationSeconds = props.assetDurationMs / 1000;
  const playStartSeconds = props.playStartFrame / fps;
  const assetDurationOutputFrames = Math.ceil((props.assetDurationMs * fps) / 1000);
  const innerHandle = useRef<number | null>(null);
  if (innerHandle.current === null) {
    innerHandle.current = delayRender('Load the archived Research Aqua canvas');
  }
  const handle = innerHandle.current;
  const iframe = useRef<HTMLIFrameElement>(null);
  const [prototypeHtml, setPrototypeHtml] = useState<string | null>(null);
  const [frameReady, setFrameReady] = useState(false);
  const continued = useRef(false);
  const sourceUrl = staticFile(props.prototypePath);
  const mediaUrl = staticFile(props.assetPath);
  const posterUrl = staticFile(props.posterPath);
  const windowGeometry = getWindowGeometry(outerTime);
  const footerHeight = windowGeometry?.full ? 70 : 68;
  const contentHeight = windowGeometry
    ? Math.max(0, windowGeometry.h - 63 - footerHeight)
    : 0;
  const contentTop = windowGeometry ? windowGeometry.y + 63 : 0;
  const contentOpacity = windowGeometry?.a ?? 0;
  const playStartFrame = props.playStartFrame;
  const availableFrames = Math.max(1, Math.min(assetDurationOutputFrames, durationInFrames - playStartFrame));
  const patchedHtml = useMemo(
    () => prototypeHtml === null
      ? null
      : replaceMediaFilename(patchResearchAquaHtml(prototypeHtml, assetDurationSeconds, playStartSeconds), props.assetFileName),
    [prototypeHtml, assetDurationSeconds, playStartSeconds, props.assetFileName],
  );

  useEffect(() => {
    let cancelled = false;
    fetch(sourceUrl)
      .then((response) => {
        if (!response.ok) throw new Error(`Reference HTML fetch failed: ${response.status}`);
        return response.text();
      })
      .then((html) => {
        if (!cancelled) setPrototypeHtml(html);
      })
      .catch((error) => cancelRender(error instanceof Error ? error : new Error(String(error))));
    return () => {
      cancelled = true;
    };
  }, [sourceUrl]);

  useEffect(() => {
    if (!frameReady || continued.current) return;
    continued.current = true;
    continueRender(handle);
  }, [frameReady, handle]);

  useLayoutEffect(() => {
    const child = iframe.current?.contentWindow as PrototypeWindow | undefined;
    if (!child?.renderAt) return;
    child.renderAt(outerTime);
  }, [outerTime, patchedHtml]);

  const handleFrameLoad = () => {
    const child = iframe.current?.contentWindow as PrototypeWindow | undefined;
    if (!child?.renderAt || !child.setWallpaperStyle) {
      cancelRender(new Error('Archived V2 HTML did not expose renderAt/prototype controls'));
      return;
    }
    child.setWallpaperStyle('research');
    child.renderAt(outerTime);
    setFrameReady(true);
  };

  const playing = frame >= playStartFrame;
  const showFirstFrame = frame >= Math.ceil(1.92 * fps) && !playing;
  const showWindowMedia = Boolean(windowGeometry && contentHeight > 30 && (showFirstFrame || playing));

  return (
    <AbsoluteFill style={{overflow: 'hidden', backgroundColor: '#11294e'}}>
      {patchedHtml !== null && (
        <iframe
          ref={iframe}
          title="Archived Assistant V2 Research Aqua prototype"
          srcDoc={patchedHtml}
          onLoad={handleFrameLoad}
          style={{position: 'absolute', inset: 0, width: 1920, height: 1080, border: 0, zIndex: 0, pointerEvents: 'none'}}
        />
      )}
      {showWindowMedia && windowGeometry && (
        <div
          aria-label="Local demonstration media"
          style={{
            position: 'absolute',
            left: windowGeometry.x,
            top: contentTop,
            width: windowGeometry.w,
            height: contentHeight,
            opacity: contentOpacity,
            overflow: 'hidden',
            backgroundColor: '#08151e',
            zIndex: 1,
            pointerEvents: 'none',
          }}
        >
          {playing ? (
            <Sequence from={playStartFrame} durationInFrames={availableFrames} name="Source MP4 from frame zero">
              <AbsoluteFill>
                <OffthreadVideo
                  src={mediaUrl}
                  trimBefore={0}
                  trimAfter={assetDurationOutputFrames}
                  playbackRate={1}
                  muted
                  volume={0}
                  style={{width: '100%', height: '100%', objectFit: 'contain', display: 'block'}}
                />
              </AbsoluteFill>
            </Sequence>
          ) : (
            <Img src={posterUrl} style={{width: '100%', height: '100%', objectFit: 'contain', display: 'block'}} />
          )}
        </div>
      )}
      {windowGeometry?.full !== undefined && windowGeometry.full > 0.65 && showWindowMedia && (
        <div
          style={{
            position: 'absolute',
            left: windowGeometry.x + 32,
            top: contentTop + 30,
            width: 116,
            height: 39,
            borderRadius: 8,
            display: 'grid',
            placeItems: 'center',
            backgroundColor: 'rgba(13,40,54,0.86)',
            color: '#ebf8fa',
            fontFamily: 'Arial, Microsoft YaHei, sans-serif',
            fontSize: 20,
            fontWeight: 700,
            opacity: contentOpacity,
            zIndex: 2,
            pointerEvents: 'none',
          }}
        >
          示意画面
        </div>
      )}
    </AbsoluteFill>
  );
};
