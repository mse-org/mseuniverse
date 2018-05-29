unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msecommport,
 msecommutils,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,
 msestrings,msetypes,msegraphedits,msescrollbar,msegrids,msesimplewidgets,
 msewidgets,msestatfile,msesercomm,msetimer,portsettingsframe;

type
 tmainfo = class(tmainform)
   senddtexted: thistoryedit;
   rxdata: tstringgrid;
   clearbu: tbutton;
   tstatfile1: tstatfile;
   ttimer1: ttimer;
   portfra: tportsettingsfra;
   procedure clearexe(const sender: TObject);
   procedure sendtextexe(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure timerexe(const sender: TObject);
 end;
var
 mainfo: tmainfo;

implementation

uses
 main_mfm,sysutils;

procedure tmainfo.sendtextexe(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 if portfra.port.active then begin
  portfra.port.port.writestring(ansistring(avalue)+portfra.eor.value);
 end;
end;

procedure tmainfo.timerexe(const sender: TObject);
var
 str1: string;
begin
 if portfra.port.active then begin
  str1:= portfra.port.port.readavailstring(100); //max 100 byte
                                   //can break multi byte characters!
  if str1 <> '' then begin
   rxdata[0].readpipe(str1);   
   rxdata.showrow(bigint);
  end;
 end;
end;

procedure tmainfo.clearexe(const sender: TObject);
begin
 rxdata.clear;
end;

end.
