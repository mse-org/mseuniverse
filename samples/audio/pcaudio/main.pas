unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,mseact,
 msedataedits,msedropdownlist,mseedit,mseificomp,mseificompglob,mseifiglob,
 msestatfile,msestream,sysutils,msebitmap,msedatanodes,msefiledialog,msegrids,
 mselistbrowser,msesys,msegraphedits,msescrollbar,msethreadcomp,msechart,
 msepcaudio;

type

//     +---------+---------+--->
//     |       -a1       -a2     
//     +--(z2)<--+--(z1)<--+
//     b0       b1        b2
// >---+---------+---------+
//
 iir2ty = record
  z1,z2: flo64;
  a1,a2: flo64;
  b0,b1,b2: flo64;
 end;

 tmainfo = class(tmainform)
   libnameed: tfilenameedit;
   tstatfile1: tstatfile;
   oned: tbooleanedit;
   wavethread: tthreadcomp;
   sinefrequed: trealedit;
   samplingfrequed: trealedit;
   chart: tchart;
   samplesed: tintegeredit;
   amplitudeed: trealedit;
   blocklened: trealedit;
   amplitudeed2: trealedit;
   sinefrequed2: trealedit;
   ch1on: tbooleanedit;
   ch2on: tbooleanedit;
   alsaed: tbooleanedit;
   procedure onsetev(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure waveexe(const sender: tthreadcomp);
   procedure datentev(const sender: TObject);
   procedure createev(const sender: TObject);
   procedure ch1setev(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure ch2seev(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure sampfreqsetev(const sender: TObject; var avalue: realty;
                   var accept: Boolean);
   procedure alsasetev(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
  protected
   fblocklen: int32;
   famplitude1: flo64;
   famplitude2: flo64;
   faudioobj: paudio_object;
   procedure initwave(var sinegen: iir2ty;
                       const sinefrequency: flo64; samplingfrequency: flo64);
   procedure updatesound();
   procedure soundoff();
 end;
var
 mainfo: tmainfo;
 
implementation
uses
 main_mfm,msectypes;

var
 sinegen1: iir2ty;
 sinegen2: iir2ty;
 
procedure tmainfo.initwave(var sinegen: iir2ty; const sinefrequency: flo64;
                                           samplingfrequency: flo64);
{      z*sin(wT)
 --------------------           z-transform of sin(wT)
 z^2 - 2z*cos(wT) + 1
}
var
 wT: flo64;
begin
 wT:= (sinefrequency*2*pi)/samplingfrequency;
 with sinegen do begin
  b0:= 0;
  b1:= 0;
  b2:= 0;
  a1:= 2*cos(wT);
  a2:= -1;
  z1:= 0;
  z2:= sin(wT); //initial value
 end;
end;

function iir2step(const inp: flo64; var filter: iir2ty): flo64;
begin
 with filter do begin
  result:= inp*b0 + z2;
  z2:= z1+result*a1+inp*b1;
  z1:= result*a2+inp*b2;
 end;
end;

function iir2sinstep(var filter: iir2ty): flo64;
begin
 with filter do begin       //todo: amplitude stabilisation
  result:= z2;
  z2:= z1 + result*a1;
  z1:= result*a2;
 end;
end;

procedure tmainfo.waveexe(const sender: tthreadcomp);

var
 ar1: array of int16;
 p1,pe: pint16;
 f1,f2: flo64;
 i1: int32;
 twochannel: boolean;
 bytelen: int32;
 
begin
 f1:= famplitude1;
 f2:= famplitude2;
 twochannel:= ch1on.value and ch2on.value;
 if twochannel then begin
  setlength(ar1,fblocklen*2);
 end
 else begin
  setlength(ar1,fblocklen);
 end;
 bytelen:= length(ar1)*sizeof(ar1[0]);
 p1:= pointer(ar1);
 pe:= pointer(p1) + bytelen;
 
 while not sender.terminated do begin
  if twochannel then begin
   if ch1on.value then begin
    while p1 < pe do begin
     p1^:= round(iir2sinstep(sinegen1)*f1);
     inc(p1);
     p1^:= round(iir2sinstep(sinegen2)*f2);
     inc(p1);
    end;
   end
  end
  else begin
   if ch1on.value then begin
    while p1 < pe do begin
     p1^:= round(iir2sinstep(sinegen1)*f1);
     inc(p1);
    end;
   end
   else begin
    while p1 < pe do begin
     p1^:= round(iir2sinstep(sinegen2)*f2);
     inc(p1);
    end;
   end;
  end;
  p1:= pointer(ar1); //reset buffer pointer
  
  if not sender.terminated then begin
   i1:= audio_object_write(faudioobj,p1,bytelen);
   if (i1 <> 0) and not sender.terminated then begin
    raise exception.create(string(audio_object_strerror(faudioobj,i1)));
   end;
  end;
 end;
 
end;

procedure tmainfo.updatesound();
var
 ar1: realarty;
 i1: int32;
 b1: boolean;
 f1: flo64;
begin
 b1:= wavethread.active;
 wavethread.active:= false;
 if faudioobj <> nil then begin
  audio_object_flush(faudioobj);
 end;
 initwave(sinegen1,sinefrequed.value,samplingfrequed.value);
 initwave(sinegen2,sinefrequed2.value,samplingfrequed.value);
 fblocklen:= round(blocklened.value*samplingfrequed.value);
 chart.clear;
 setlength(ar1,samplesed.value);
 chart.traces[0].visible:= false;
 chart.traces[1].visible:= false;
 if ch1on.value then begin
  chart.traces[0].visible:= true;
  f1:= amplitudeed.value;
  famplitude1:= f1*$7fff;
  for i1:= 0 to high(ar1) do begin
   ar1[i1]:= iir2sinstep(sinegen1)*f1;
  end;
  chart.traces[0].ydata:= copy(ar1);
 end;
 if ch2on.value then begin
  chart.traces[1].visible:= true;
  f1:= amplitudeed2.value;
  famplitude2:= f1*$7fff;
  for i1:= 0 to high(ar1) do begin
   ar1[i1]:= iir2sinstep(sinegen2)*f1;
  end;
  chart.traces[1].ydata:= ar1;
 end;
 wavethread.active:= b1;
end;

procedure tmainfo.soundoff();
begin
 if oned.value then begin
  wavethread.terminate();
  if faudioobj <> nil then begin
   audio_object_flush(faudioobj);
  end;
  wavethread.active:= false;
  audio_object_close(faudioobj);
  if faudioobj <> nil then begin
   audio_object_destroy(faudioobj);
   faudioobj:= nil;
  end;
  releasepcaudio();
  oned.value:= false;
 end;
end;
 
procedure tmainfo.onsetev(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
var
 i1: cint;
 channels: int32;
begin
 if avalue <> oned.value then begin
  if avalue then begin
   initializepcaudio([libnameed.sysvalue]);
   if alsaed.value then begin
    faudioobj:= create_audio_device_object(nil,nil,nil); 
                                   //does not load pulseaudio
   end
   else begin
    faudioobj:= create_audio_device_object(nil,pchar(''),pchar(''));
   end;
   if faudioobj = nil then begin
    raise exception.create('create_audio_device_object() failed');
   end;
   channels:= 1;
   if ch1on.value and ch2on.value then begin
    channels:= 2;
   end;
   i1:= audio_object_open(faudioobj,AUDIO_OBJECT_FORMAT_S16LE,
                                        round(samplingfrequed.value),channels);
   if i1 <> 0 then begin
    audio_object_destroy(faudioobj);
    raise exception.create(string(audio_object_strerror(faudioobj,i1)));
   end;
   wavethread.active:= true;
  end
  else begin
   soundoff();
  end;
 end;
end;

procedure tmainfo.datentev(const sender: TObject);
begin
 updatesound();
end;

procedure tmainfo.createev(const sender: TObject);
begin
{$ifndef mswindows}
 libnameed.value:= 'libpcaudio.so.0';
{$endif}
end;

procedure tmainfo.ch1setev(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 soundoff();
 if not avalue then begin
  ch2on.value:= true;
 end;
end;

procedure tmainfo.ch2seev(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 soundoff();
 if not avalue then begin
  ch1on.value:= true;
 end;
end;

procedure tmainfo.sampfreqsetev(const sender: TObject; var avalue: realty;
               var accept: Boolean);
begin
 soundoff();
end;

procedure tmainfo.alsasetev(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 soundoff();
end;

end.
