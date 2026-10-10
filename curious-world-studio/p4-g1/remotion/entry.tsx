import React from 'react';
import {Composition,registerRoot} from 'remotion';
import {ResearchEpisode, type PilotProps} from './ResearchEpisode';

// Fallback defaults are composition-registration data, NOT an approved render fixture.
// The authorized real props must be built from a WAV, rights review and manually checked caption timings.
const placeholder:PilotProps={
  episodeId:'NOT_READY',
  durationFrames:900,
  audioStartVideoMs:1800,
  aPrefixDurationMs:1800,
  narrationPath:'',
  captions:[],
  shots:[],
  sourceCredit:''
};
const Root=()=> <Composition
  id="CWSG1"
  component={ResearchEpisode}
  durationInFrames={900}
  fps={30}
  width={1920}
  height={1080}
  defaultProps={placeholder}
  calculateMetadata={({props})=>({durationInFrames:props.durationFrames})}
/>;
registerRoot(Root);
