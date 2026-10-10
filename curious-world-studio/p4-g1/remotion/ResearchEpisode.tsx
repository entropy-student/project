import React from 'react';
import {AbsoluteFill, Audio, Img, Sequence, staticFile, useCurrentFrame} from 'remotion';

export type Caption = {caption_id:string;line_id:string;text:string;start_audio_ms:number;end_audio_ms:number};
export type Shot = {shot_id:string;asset_id:string;path:string;evidence_label:string;start_video_ms:number;end_video_ms:number};
export type PilotProps = {
  episodeId:string;
  durationFrames:number;
  audioStartVideoMs:number;
  aPrefixDurationMs:number;
  narrationPath:string;
  shots:Shot[];
  captions:Caption[];
  sourceCredit:string;
};
const FPS=30;
const at=(ms:number)=>Math.round(ms*FPS/1000);
const COLOR={blue:'#144D91',aqua:'#75C4EF',chrome:'#DAE3E9',line:'#8096A5',type:'#2E475C',progress:'#53B7E4'};
const baseFont='Microsoft YaHei, PingFang SC, Noto Sans CJK SC, sans-serif';
const aquaButton=(c:string)=>({width:15,height:15,borderRadius:'50%',background:c,border:'1px solid #778d98',boxShadow:'inset 0 2px 2px #fff8'});

export const ResearchEpisode:React.FC<PilotProps>=(p)=>{
  const frame=useCurrentFrame();
  const videoMs=frame*1000/FPS;
  const isA=videoMs<p.aPrefixDurationMs;
  const audioMs=videoMs-p.audioStartVideoMs;
  const currentShot=p.shots.find(s=>videoMs>=s.start_video_ms && videoMs<s.end_video_ms);
  const caption=p.captions.find(c=>audioMs>=c.start_audio_ms && audioMs<c.end_audio_ms);
  return <AbsoluteFill style={{fontFamily:baseFont,background:'#112d4d',overflow:'hidden'}}>
    {isA ? <AbsoluteFill style={{background:'linear-gradient(148deg, #75C4EF 0%, #144D91 65%, #0a2b55 100%)'}}>
      <div style={{height:46,background:'linear-gradient(#ffffffed,#a9bccaed)',color:'#243b4b',display:'flex',alignItems:'center',padding:'0 25px',gap:26,fontSize:21,boxShadow:'0 3px 6px #0004'}}>
        <b>◉</b><b>Finder</b><span>File</span><span>Edit</span><span>View</span><span>Go</span><span>Window</span>
        <span style={{marginLeft:'auto',fontSize:17}}>Curious World Studio</span>
      </div>
      <div style={{margin:'170px auto 0',width:410,height:275,border:'2px solid #7da0b5',borderRadius:14,overflow:'hidden',boxShadow:'0 28px 55px #061e4a99',background:'#f1f6f9'}}>
        <div style={{height:48,background:'linear-gradient(#fff,#c8d3dc)',display:'flex',gap:10,alignItems:'center',padding:'0 18px',color:COLOR.type}}>
          <span style={aquaButton('#ec786c')}/><span style={aquaButton('#fac657')}/><span style={aquaButton('#69cc6a')}/><b style={{marginLeft:22,fontSize:21}}>Research Files</b>
        </div>
        <div style={{display:'flex',flexDirection:'column',alignItems:'center',paddingTop:43,color:COLOR.type,fontSize:20}}>
          <span style={{fontSize:69,color:"#2f73b0",fontWeight:900,textShadow:"0 3px 1px white"}}>▣</span>
          <b>会回应的果冻</b>
          <span style={{fontSize:15,marginTop:8}}>正在打开研究文件…</span>
        </div>
      </div>
      <div style={{position:'absolute',bottom:29,left:'32%',width:'36%',height:69,borderRadius:18,background:'#f9fcffad',border:'1px solid #ffffffac',boxShadow:'0 8px 16px #0005',display:'flex',justifyContent:'center',alignItems:'center',gap:27,fontSize:40}}>
        <span style={{color:"#396d9c"}}>▣</span><span style={{color:"#396d9c"}}>⌕</span><span style={{color:"#396d9c"}}>▤</span><span style={{color:"#396d9c"}}>▶</span>
      </div>
    </AbsoluteFill> :
    <AbsoluteFill style={{background:'linear-gradient(#eff4f6,#d5e0e5)',color:COLOR.type}}>
      <div style={{height:68,background:'linear-gradient(#f8fbfd,#b9c7d0)',borderBottom:'2px solid #8096A5',display:'flex',alignItems:'center',gap:14,padding:'0 23px'}}>
        <span style={aquaButton('#e97f78')}/><span style={aquaButton('#f5d16d')}/><span style={aquaButton('#76ca8a')}/>
        <b style={{fontSize:25,marginLeft:35}}>Curious World · 会回应的果冻</b>
        <span style={{marginLeft:'auto',fontSize:17}}>QuickTime-style Research Viewer</span>
      </div>
      <div style={{position:'absolute',top:68,bottom:64,left:0,right:0,background:'#12191f',display:'flex',alignItems:'center',justifyContent:'center'}}>
        {currentShot && <>
          <Img src={staticFile(currentShot.path)} style={{maxWidth:'100%',maxHeight:'100%',objectFit:'contain',width:'100%',height:'100%'}}/>
          <div style={{position:'absolute',top:23,left:25,background:'#102f46e8',color:'#f1f9ff',padding:'9px 19px',fontSize:23,fontWeight:700,borderRadius:7}}>
            {currentShot.evidence_label}
          </div>
        </>}
        {caption && <div style={{position:'absolute',bottom:28,width:'100%',display:'flex',justifyContent:'center',pointerEvents:'none'}}>
          <span style={{fontFamily:baseFont,fontSize:56,fontWeight:700,color:'white',background:'rgba(9,18,23,0.84)',padding:'10px 25px',borderRadius:8,maxWidth:'95%',overflow:'hidden',whiteSpace:'nowrap',textOverflow:'clip',textAlign:'center',textShadow:'0px 2px 6px #0009'}}>
            {caption.text}
          </span>
        </div>}
      </div>
      <div style={{position:'absolute',bottom:0,height:64,left:0,right:0,background:'linear-gradient(#edf4f7,#b6c5ce)',borderTop:'2px solid #8e9fae',display:'flex',alignItems:'center',gap:27,padding:'0 26px',color:COLOR.type,fontSize:15}}>
        <b style={{fontSize:26}}>❚❚</b><div style={{flex:1,height:11,borderRadius:8,background:'#8299a9',boxShadow:'inset 0 2px 4px #0006',overflow:'hidden'}}><div style={{width:(100*frame/p.durationFrames)+'%',height:'100%',background:COLOR.progress}}/></div>
        <span>{Math.floor(videoMs/1000)}s / {Math.floor(p.durationFrames/FPS)}s</span><span>Research source · PLOS ONE 2026</span>
      </div>
    </AbsoluteFill>}
    {p.narrationPath && <Sequence from={at(p.audioStartVideoMs)}><Audio src={staticFile(p.narrationPath)}/></Sequence>}
  </AbsoluteFill>;
};
