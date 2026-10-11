import React from 'react';
import {Composition, registerRoot} from 'remotion';
import {ResearchAquaMediaAdapter} from './ResearchAquaMediaAdapter';

const Root: React.FC = () => (
  <Composition
    id="CWSG1VAM1"
    component={ResearchAquaMediaAdapter}
    width={1920}
    height={1080}
    fps={30}
    durationInFrames={270}
  />
);

registerRoot(Root);