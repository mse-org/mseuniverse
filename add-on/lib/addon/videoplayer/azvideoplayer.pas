{*********************************************************}
{            Copyright (c) 2011 Sri Wahono                }
{*********************************************************}

unit azvideoplayer;
{$ifdef FPC}{$mode objfpc}{$h+}{$interfaces corba}{$endif}

interface
uses
 classes,msegui,mseevent,msegraphutils,msegraphics,mseclasses,
 msestrings,msewidgets,mseglob,msesimplewidgets,msestatfile,msestat,
 msedrawtext,msetimer,mseguiglob,ctypes{$ifdef windows},windows{$endif},avformat,
 avcodec,avutil,swscale,sysutils,msebitmap,mseimage,msefileutils,msebits;

const
 maxanimtype = 4;
type
 animtypety = (at_none,at_right,at_left,at_down,at_up);
 tazvideoplayer = class(tpublishedwidget,istatfile)
  private
   ftext: msestring;
   zoomscale: real;
   finfo: drawtextinfoty;
   ftextflags: textflagsty;
   fanimtype: animtypety;
   ftimer: tsimpletimer;
   ffps: integer;
   fstartx,fstarty,fdelta: integer;
   fstatfile: tstatfile;
   fstatvarname: msestring;
   packet: TAVPacket;
   bytesremaining,videoStream: integer;
   arawdata: PBytearray;
   ffirsttime,fanimtextifempty,floop,fopened: boolean;
   fbmp: tmaskedbitmap;
   ffilename: filenamety;
   fendframe: boolean;
   pformatctx: PAVFormatContext;
   pcodecctx: PAVCodecContext;
   pcodec: PAVCodec;
   pframe: PAVFrame;
   pframeRGB: PAVFrame;
   pscalectx: PSwsContext;
   fvideoalignment: alignmentsty;
   procedure setstatfile(const avalue: tstatfile);
  protected
   procedure settextflags(const value: textflagsty);
   procedure settext(const avalue: msestring);
   procedure setfps(const avalue:integer);
   procedure setanimtype(const avalue: animtypety);
   procedure fontchanged; override;
   procedure internalcreateframe; override;
   procedure clientmouseevent(var info: mouseeventinfoty); override;
   procedure clientrectchanged;override;
   procedure doonpaint(const acanvas: tcanvas); override;
   procedure updatetextrect;
   procedure processtimer(const sender: TObject);
   //istatfile
   procedure dostatread(const reader: tstatreader);
   procedure dostatwrite(const writer: tstatwriter);
   procedure statreading;
   procedure statread;
   function getstatvarname: msestring;
   function getnextframe: boolean;
   procedure createbitmap;
   procedure freevideo;
   procedure setposition(time: real);
  public
   class function classskininfo: skininfoty; override;
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure initnewcomponent(const ascale: real); override;
   procedure zoom(const ascale: real); 
   procedure play;
   procedure pause;
   procedure resume;
   procedure stop;
  published
   property optionswidget default defaultgroupboxoptionswidget;
   property framepersecond: integer read ffps write setfps default 25;
   property animtextifempty: boolean read fanimtextifempty write fanimtextifempty default true;
   property loop: boolean read floop write floop default true;
   property text: msestring read ftext write settext;
   property font: twidgetfont read getfont write setfont stored isfontstored;
   property textflags: textflagsty read ftextflags write settextflags
                default [tf_ycentered,tf_xcentered];
   property textanimationtype: animtypety read fanimtype write setanimtype;
   property statfile: tstatfile read fstatfile write setstatfile;
   property statvarname: msestring read fstatvarname write fstatvarname;
   property filename: filenamety read ffilename write ffilename;
   property videoaligment: alignmentsty read fvideoalignment write fvideoalignment;
   property isopen: boolean read fopened;
 end;
 
implementation
type
 tmaskedbitmap1= class(tmaskedbitmap);
 
{ tazvideoplayer }
  
constructor tazvideoplayer.create(aowner: tcomponent);
begin
 inherited;
 fopened:= false;
 floop:= true;
 fdelta:= 1;
 fanimtextifempty:= true;
 fvideoalignment:= [al_fit,al_xcentered,al_ycentered];
 bytesremaining:= 0;
 fendframe:= false;
 ffirsttime:= true;
 fbmp:= tmaskedbitmap.create(false);
 zoomscale:= 1.0;
 ftimer:= tsimpletimer.create(40000,nil,false,[]);
 ftimer.enabled:= false;
 ffps:= 25;
 ftimer.ontimer:= @processtimer;
end;

class function tazvideoplayer.classskininfo: skininfoty;
begin
 result:= inherited classskininfo;
 result.objectkind:= sok_widget;
end;

destructor tazvideoplayer.destroy;
begin
 inherited;
 fbmp.free;
 ftimer.free;
end;

procedure tazvideoplayer.initnewcomponent(const ascale: real);
begin
 inherited;
 internalcreateframe;
 fframe.scale(ascale);
end;

procedure tazvideoplayer.createbitmap;
var
 i: integer;
 po1: plongword;
 po2: pointer;
begin
 fbmp.size:= makesize(pcodecctx^.width,pcodecctx^.height);
 for i:= 0 to fbmp.size.cy - 1 do begin
  {$ifdef windows}
  copymemory(fbmp.scanline[i],pointer(integer(pframeRGB^.data[0])+fbmp.size.cx*4*i),fbmp.size.cx*4);
  {$endif}
  {$ifdef linux}
  po1:= pointer(integer(pframeRGB^.data[0])+fbmp.size.cx*4*i);
  po2:= fbmp.scanline[i];
  move(po1^,po2^,fbmp.size.cx*4);
  {$endif}
 end;
end;

procedure tazvideoplayer.updatetextrect;
var
 tflag: textflagsty;
begin
 if fanimtype=at_none then begin
  tflag:= ftextflags;
  include(tflag,tf_xcentered);
  settextflags(tflag);
  finfo.dest:= innerclientrect;
  finfo.dest.x:= innerclientrect.x;
  finfo.dest.y:= innerclientrect.y;
  invalidate;
 end else begin
  finfo.dest:= textrect(getcanvas,finfo.text,finfo.flags,finfo.font,nil);
  if (fanimtype=at_left) or (fanimtype=at_right) then begin
   finfo.dest.x:= fstartx;
   finfo.dest.y:= innerclientrect.y+((innerclientrect.cy-finfo.dest.cy) div 2);
  end else if (fanimtype=at_up) or (fanimtype=at_down) then begin
   finfo.dest.cx:= innerclientrect.cx;
   finfo.dest.x:= fstartx;
   finfo.dest.y:= fstarty;
  end;
 end;
end;

function tazvideoplayer.getnextframe: boolean;
var
  bytesdecoded, framefinished: integer;
label
  loop_exit;
begin
 if ffirsttime then begin
  ffirsttime:= false;
  packet.data:= nil;
 end;
 result:= false;
 while true do begin
  while bytesremaining>0 do begin
   bytesdecoded:= avcodec_decode_video(pcodecctx,pframe,framefinished,arawdata,bytesremaining);
   if bytesdecoded < 0 then begin
    ShowMessage('Error while decoding frame');
    stop;
    exit;
   end;
   dec(bytesremaining, bytesdecoded);
   inc(arawdata,bytesdecoded);
   if framefinished <> 0 then begin
    result:= true;
    exit;
   end;
  end;
  repeat
   if av_read_packet(pformatctx, packet)< 0 then begin
    goto loop_exit;
   end;
   until packet.stream_index = videoStream;
   bytesremaining:= packet.size;
   arawdata:= packet.data;
  end;
loop_exit:
 bytesdecoded:= avcodec_decode_video(pcodecctx,pframe,framefinished,arawdata,bytesremaining);
 if packet.data <> nil then begin
  av_free_packet(@packet);
 end;
 result:= framefinished<>0;
end;

procedure tazvideoplayer.zoom(const ascale: real);
begin
 zoomscale:= ascale;
end;

procedure tazvideoplayer.doonpaint(const acanvas: tcanvas);
begin
 inherited;
 if not fopened and fanimtextifempty then begin
  msedrawtext.drawtext(acanvas,finfo);
 end else begin
  fbmp.paint(acanvas,innerclientrect,fvideoalignment);
 end;
end;

procedure tazvideoplayer.processtimer(const sender: TObject);
begin
 if not fopened and fanimtextifempty then begin
  with innerclientrect do begin
   case fanimtype of
    at_left: begin
     finfo.dest.x:= fstartx;
     finfo.dest.y:= fstarty;
     dec(fstartx,fdelta);
     if fstartx+finfo.dest.cx<x then fstartx:= x+cx;
    end;
    at_right: begin
     finfo.dest.x:= fstartx-finfo.dest.cx;
     finfo.dest.y:= fstarty;
     inc(fstartx,fdelta);
     if fstartx>x+cx+finfo.dest.cx then fstartx:= x;
    end;
    at_down: begin
     finfo.dest.x:= fstartx;
     finfo.dest.y:= fstarty-finfo.dest.cy;
     inc(fstarty,fdelta);
     if fstarty>y+cy+finfo.dest.cy then fstarty:= y;
    end;
    at_up: begin
     finfo.dest.x:= fstartx;
     finfo.dest.y:= fstarty;
     dec(fstarty,fdelta);
     if fstarty<y-finfo.dest.cy then fstarty:= y+cy;
    end;
   end;
  end;
  invalidate;
 end else begin
  if not fendframe and getnextFrame then begin
   sws_scale(pscalectx, @pframe^.data, @pframe^.linesize,
               0, pcodecctx^.height,
               @pframeRGB^.data, @pframeRGB^.linesize);
   createbitmap;
   invalidate;
  end else begin
   if floop then begin
    freevideo;
    play;
   end else begin
    fendframe:= true;
    freevideo;
   end;
  end;
 end;
end;

procedure tazvideoplayer.settextflags(const value: textflagsty);
begin
 if ftextflags <> value then begin
  ftextflags:= value;
  finfo.flags:= value;
  updatetextrect;
  invalidate;
 end;
end;

procedure tazvideoplayer.fontchanged;
begin
 inherited;
 finfo.font:= getfont;
 updatetextrect;
 invalidate;
end;

procedure tazvideoplayer.settext(const avalue: msestring);
begin
 ftext:= avalue;
 if avalue = '' then begin
  finfo.text.text:= ftext;
 end
 else begin
  finfo.text.text:= avalue;
 end;
 updatetextrect;
 invalidate;
end;

procedure tazvideoplayer.setfps(const avalue: integer);
begin
 if (avalue<>ffps) and (avalue<>0) then begin
  ffps:= avalue;
  ftimer.interval:= round(1000000/avalue);
 end;
end;

procedure tazvideoplayer.setanimtype(const avalue: animtypety);
begin
 if avalue<>fanimtype then begin
  fanimtype:= avalue;
  with innerclientrect do begin
   case avalue of
    at_left: begin
     fstartx:= x+cx;
     fstarty:= y;
     if not (csdesigning in componentstate) then begin
      application.beginhighrestimer;
      ftimer.enabled:= true;
     end;
    end;
    at_right: begin
     fstartx:= x;
     fstarty:= y;
     if not (csdesigning in componentstate) then begin
      application.beginhighrestimer;
      ftimer.enabled:= true;
     end;
    end;
    at_up: begin
     fstartx:= x;
     fstarty:= y+cy;
     if not (csdesigning in componentstate) then begin
      application.beginhighrestimer;
      ftimer.enabled:= true;
     end;
    end;
    at_down: begin
     fstartx:= x;
     fstarty:= y;
     if not (csdesigning in componentstate) then begin
      application.beginhighrestimer;
      ftimer.enabled:= true;
     end;
    end;
    at_none: begin
     ftimer.enabled:= false;
     application.endhighrestimer;
     fstartx:= x;
     fstarty:= y;
    end;
   end;
  end;
  updatetextrect;
 end;
end;

procedure tazvideoplayer.clientmouseevent(var info: mouseeventinfoty);
var
 int1: integer;
begin
 inherited;
 if csdesigning in componentstate then exit;
 with info do begin
  if isdblclick(info) then begin
   if (pcodecctx=nil) and fanimtextifempty then begin
    int1:= ord(fanimtype)+1;
    if int1>maxanimtype then int1:=0;
    setanimtype(animtypety(int1));
   end;
  end;
  if isclick(info) then begin
   //
  end;
 end;
end;

procedure tazvideoplayer.internalcreateframe;
begin
 tcaptionframe.create(iscrollframe(self));
end;

procedure tazvideoplayer.clientrectchanged;
begin
 inherited;
 updatetextrect;
end;

procedure tazvideoplayer.dostatread(const reader: tstatreader);
var
 int1: integer;
 al1: alignmentsty;
begin
 with reader do begin
  setfps(readinteger('fps',ffps));
  finfo.font.height:= readinteger('fontheight',finfo.font.height);
  setanimtype(animtypety(readinteger('animationtype',ord(fanimtype))));
  ffilename:= readmsestring('filename',ffilename);
  ftext:= readmsestring('text',ftext);
  int1:= readinteger('halignment',int1);
  al1:= fvideoalignment;
  case int1 of
  0: al1:= al1+[al_left]-[al_xcentered]-[al_right];
  1: al1:= al1-[al_left]+[al_xcentered]-[al_right];
  2: al1:= al1-[al_left]-[al_xcentered]+[al_right];
  end;
  fvideoalignment:= al1;
  int1:= readinteger('valignment',int1);
  al1:= fvideoalignment;
  case int1 of
  0: al1:= al1+[al_top]-[al_ycentered]-[al_bottom];
  1: al1:= al1-[al_top]+[al_ycentered]-[al_bottom];
  2: al1:= al1-[al_top]-[al_ycentered]+[al_bottom];
  end;
  fvideoalignment:= al1;
 end;
end;

procedure tazvideoplayer.dostatwrite(const writer: tstatwriter);
var
 int1: integer;
begin
 with writer do begin
  writeinteger('fps',ffps);
  writeinteger('fontheight',finfo.font.height);
  writeinteger('animationtype',ord(fanimtype));
  writemsestring('filename',ffilename);
  writemsestring('text',ftext);
  if al_left in fvideoalignment then int1:= 0
  else if al_xcentered in fvideoalignment then int1:= 1
  else if al_right in fvideoalignment then int1:= 2;
  writeinteger('halignment',int1);
  if al_top in fvideoalignment then int1:= 0
  else if al_ycentered in fvideoalignment then int1:= 1
  else if al_bottom in fvideoalignment then int1:= 2;
  writeinteger('valignment',int1);
 end;
end;

procedure tazvideoplayer.statreading;
begin
 //dummy
end;

procedure tazvideoplayer.statread;
begin
 //dummy
end;

function tazvideoplayer.getstatvarname: msestring;
begin
 result:= fstatvarname;
end;

procedure tazvideoplayer.setstatfile(const avalue: tstatfile);
begin
 setstatfilevar(istatfile(self),avalue,fstatfile);
end;

procedure tazvideoplayer.play;
var
 numBytes: integer;
 buffer: PByte;
 i: integer;
 afilename: string;
begin
 if ffilename='' then begin
  if fanimtype<>at_none then begin
   ftimer.enabled:= true;
  end;
  exit;
 end else begin
  if not findfile(ffilename) then exit;
 end;
 fendframe:= false;
 fopened:= true;
 afilename:= tosysfilepath(ffilename);
 av_register_all();
 if av_open_input_file(pformatctx, pchar(afilename), nil, 0, nil)<> 0 then begin
  fendframe:= true;
  fopened:= false;
  raise exception.Create('Couldn''t open file!!!');
 end;
 if av_find_stream_info(pformatctx)< 0 then begin
  fendframe:= true;
  fopened:= false;
  raise exception.Create('Couldn''t find stream information!!!');
 end;
 dump_format(pformatctx, 0, pchar(afilename), 0); // <<<<<< i dont know how its works
 videoStream:= -1;
 for i:= 0 to pformatctx^.nb_streams - 1 do begin
  if pformatctx^.streams [i]^.codec^.codec_type = AVMEDIA_TYPE_VIDEO then begin
   videoStream:= i;
   break;
  end;
 end;

 if videoStream = -1 then begin
  fendframe:= true;
  fopened:= false;  
  raise exception.Create ('Didn''t find a video stream!');
 end;

 pcodecctx:= pformatctx^.streams[videoStream]^.codec;
 pcodec:= avcodec_find_decoder(pcodecctx^.codec_id);
 if pcodec = nil then begin
  fendframe:= true;
  fopened:= false;
  raise exception.Create('Codec not found!');
 end;
 if (pcodec^.capabilities and CODEC_CAP_TRUNCATED)= CODEC_CAP_TRUNCATED then
  pcodecctx^.flags:= pcodecctx^.flags or CODEC_FLAG_TRUNCATED;

 if avcodec_open(pcodecctx, pcodec)< 0 then begin
  fendframe:= true;
  fopened:= false;
  raise exception.Create('Could not open codec!');
 end;
 if(pcodecctx^.time_base.num>1000) and (pcodecctx^.time_base.den = 1) then
  pcodecctx^.time_base.den:= 1000;

 pframe:= avcodec_alloc_frame();

 pframeRGB:= avcodec_alloc_frame;
 avpicture_alloc(PAVPicture(pframeRGB), PIX_FMT_RGB32, pcodecctx^.width, pcodecctx^.height);

 pscalectx:= sws_getContext(pcodecctx^.width, pcodecctx^.height, pcodecctx^.pix_fmt,
                                pcodecctx^.width, pcodecctx^.height, PIX_FMT_RGB32, SWS_BICUBIC, nil, nil, nil );
 ftimer.enabled:= true;
end;

procedure tazvideoplayer.pause;
begin
 ftimer.enabled:= false;
end;

procedure tazvideoplayer.resume;
begin
 ftimer.enabled:= true;
end;

procedure tazvideoplayer.stop;
begin
 ftimer.enabled:= false;
 if fopened then begin
  freevideo;
 end;
 fendframe:= true;
 fopened:= false;
end;

procedure tazvideoplayer.freevideo;
begin
 ftimer.enabled:= false;
 if packet.data <> nil then begin
  av_free_packet(@packet);
 end;
 sws_freeContext(pscalectx);
 avpicture_free(PAVPicture(pframeRGB));
 av_free(pframeRGB);
 av_free(pframe);
 avcodec_close(pcodecctx);
 av_close_input_file(pformatctx);
end;

procedure tazvideoplayer.setposition(time: real);
var
 seekflags: integer;
begin
 if not fopened then
   exit;

 if (time < 0) then
   time := 0;

 seekflags := AVSEEK_FLAG_BACKWARD;

{ fframetime := time;

 if (av_seek_frame(PAVFormatContext,
    fStreamIndex,
    Round(Time / av_q2d(fStream^.time_base)),
    SeekFlags) < 0) then
 begin
   Log.LogError('av_seek_frame() failed', 'TVideoPlayback_ffmpeg.SetPosition');
   Exit;
 end;

 avcodec_flush_buffers(PAVCodecContext);}
end;

end.
