unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,azvideoplayer,msebitmap,
 msedataedits,msedatanodes,mseedit,msefiledialog,msegrids,mselistbrowser,
 msescrollbar,msestrings,msesys,msetypes,msesimplewidgets,msewidgets,
 msestatfile,msegraphedits;

type
 tmainfo = class(tmainform)
   tazvideoplayer1: tazvideoplayer;
   tfilenameedit1: tfilenameedit;
   tbutton1: tbutton;
   tstatfile1: tstatfile;
   tbutton2: tbutton;
   tbutton3: tbutton;
   tbutton4: tbutton;
   tprogressbar1: tprogressbar;
   wfps: tintegeredit;
   procedure tbutton1_onexecute(const sender: TObject);
   procedure tfilenameedit1_ondataentered(const sender: TObject);
   procedure tbutton2_onexecute(const sender: TObject);
   procedure tbutton3_onexecute(const sender: TObject);
   procedure tbutton4_onexecute(const sender: TObject);
   procedure wfps_ondataentered(const sender: TObject);
   procedure mainfo_onloaded(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
procedure tmainfo.tbutton1_onexecute(const sender: TObject);
begin
 tazvideoplayer1.play;
end;

procedure tmainfo.tfilenameedit1_ondataentered(const sender: TObject);
begin
 tazvideoplayer1.filename:= tfilenameedit1.controller.filename;
end;

procedure tmainfo.tbutton2_onexecute(const sender: TObject);
begin
 tazvideoplayer1.pause;
end;

procedure tmainfo.tbutton3_onexecute(const sender: TObject);
begin
 tazvideoplayer1.resume;
end;

procedure tmainfo.tbutton4_onexecute(const sender: TObject);
begin
 tazvideoplayer1.stop;
end;

procedure tmainfo.wfps_ondataentered(const sender: TObject);
begin
 tazvideoplayer1.framepersecond:= wfps.value;
end;

procedure tmainfo.mainfo_onloaded(const sender: TObject);
begin
 wfps.value:= tazvideoplayer1.framepersecond;
end;

end.
