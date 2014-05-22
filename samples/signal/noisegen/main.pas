unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,mseaudio,
 msestrings,msesignal,msesigaudio,msesignoise,msechartedit,msedataedits,mseedit,
 mseificomp,mseificompglob,mseifiglob,msesiggui,msestatfile,msesigfft,
 msesigfftgui,msegraphedits,msescrollbar,msedispwidgets,mserichstring,
 msesplitter,msesimplewidgets,msefilter;

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
   tsplitter1: tsplitter;
   kinded: tenumtypeedit;
   procedure onclosexe(const sender: TObject);
   procedure samcountsetexe(const sender: TObject; var avalue: realty;
                   var accept: Boolean);
   procedure typinitexe(const sender: tenumtypeedit);
   procedure kindsetexe(const sender: TObject; var avalue: Integer;
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

procedure tmainfo.typinitexe(const sender: tenumtypeedit);
begin
 sender.typeinfopo:= typeinfo(noisekindty);
end;

procedure tmainfo.kindsetexe(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
 noise.kind:= noisekindty(avalue);
end;

end.
