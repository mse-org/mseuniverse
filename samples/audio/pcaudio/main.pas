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
   procedure onsetev(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure waveexe(const sender: tthreadcomp);
   procedure datentev(const sender: TObject);
   procedure createev(const sender: TObject);
  protected
   fblocklen: int32;
   famplitude: flo64;
   faudioobj: paudio_object;
   procedure initwave(const sinefrequency: flo64; samplingfrequency: flo64);
   procedure updatesound();
 end;
var
 mainfo: tmainfo;
 
implementation
uses
 main_mfm,msectypes;

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

var
 sinegen: iir2ty;
 
procedure tmainfo.initwave(const sinefrequency: flo64;
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
 f1: flo64;
 i1: int32;
begin
 setlength(ar1,fblocklen);
 f1:= famplitude;
 while not sender.terminated do begin
  p1:= pointer(ar1);
  pe:= p1+fblocklen;
  while p1 < pe do begin
   p1^:= round(iir2sinstep(sinegen)*f1);
   inc(p1);
  end;
  if not sender.terminated then begin
   i1:= audio_object_write(faudioobj,pointer(ar1),fblocklen*sizeof(ar1[0]));
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
 initwave(sinefrequed.value,samplingfrequed.value);
 f1:= amplitudeed.value;
 famplitude:= f1*$7fff;
 fblocklen:= round(blocklened.value*samplingfrequed.value);
 setlength(ar1,samplesed.value);
 for i1:= 0 to high(ar1) do begin
  ar1[i1]:= iir2sinstep(sinegen)*f1;
 end;
 chart.traces[0].ydata:= ar1;
 wavethread.active:= b1;
end;
 
procedure tmainfo.onsetev(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
var
 i1: cint;
begin
 if avalue <> oned.value then begin
  if avalue then begin
   initializepcaudio([libnameed.sysvalue]);
   faudioobj:= create_audio_device_object(nil,pchar(''),pchar(''));
//   faudioobj:= create_audio_device_object(nil,nil,nil); 
                                   //does not load pulseaudio
   if faudioobj = nil then begin
    raise exception.create('create_audio_device_object() failed');
   end;
   i1:= audio_object_open(faudioobj,AUDIO_OBJECT_FORMAT_S16LE,
                                              round(samplingfrequed.value),1);
   if i1 <> 0 then begin
    audio_object_destroy(faudioobj);
    raise exception.create(string(audio_object_strerror(faudioobj,i1)));
   end;
   wavethread.active:= true;
  end
  else begin
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

end.
