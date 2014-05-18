unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,mseaudio,
 msestrings,msesignal,msesigaudio,msesignoise,msechartedit,msedataedits,mseedit,
 mseificomp,mseificompglob,mseifiglob,msesiggui,msestatfile,msesigfft,
 msesigfftgui,msegraphedits,msescrollbar,msedispwidgets,mserichstring,
 msesplitter,msesimplewidgets;

type
 tmainfo = class(tmainform)
   cont: tsigcontroller;
   out: tsigoutaudio;
   noise: tsignoise;
   tsigslider1: tsigslider;
   sta: tstatfile;
   fft: tsigscopefft;
   scope: tsigscope;
   sampcount: tslider;
   sampcountdi: tintegerdisp;
   pink: tbooleanedit;
   tsplitter1: tsplitter;
   procedure onclosexe(const sender: TObject);
   procedure samcountsetexe(const sender: TObject; var avalue: realty;
                   var accept: Boolean);
   procedure pinksetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,defaultskin;

procedure tmainfo.onclosexe(const sender: TObject);
begin
 out.audio.active:= false;
end;

procedure tmainfo.samcountsetexe(const sender: TObject; var avalue: realty;
               var accept: Boolean);
begin
 noise.samplecount:= round(19*avalue)+1;
 sampcountdi.value:= noise.samplecount;
end;

procedure tmainfo.pinksetexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  noise.kind:= nk_pink;
 end
 else begin
  noise.kind:= nk_white;
 end;
end;

end.
