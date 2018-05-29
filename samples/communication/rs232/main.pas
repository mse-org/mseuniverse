unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msecommport,
 msecommutils,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,
 msestrings,msetypes,msegraphedits,msescrollbar,msegrids,msesimplewidgets,
 msewidgets,msestatfile,msesercomm,portsettingsframe;

type
 tmainfo = class(tmainform)
   senddtexted: thistoryedit;
   rxdata: tstringgrid;
   clearbu: tbutton;
   portstatx: tstatfile;
   portfra: tportsettingsfra;
   procedure clearexe(const sender: TObject);
   procedure sendtextexe(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure inputavaileexe(const sender: tcustomcommpipes);
 end;
var
 mainfo: tmainfo;

implementation

uses
 main_mfm,sysutils;

procedure tmainfo.clearexe(const sender: TObject);
begin
 rxdata.clear;
end;

procedure tmainfo.sendtextexe(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 if portfra.port.active then begin
  portfra.port.pipes.tx.write(avalue+msestring(portfra.eor.value));
 end;
end;

procedure tmainfo.inputavaileexe(const sender: tcustomcommpipes);
var
 str1: string;
begin
 str1:= sender.rx.readdatastring; //can split multi byte characters!
 rxdata[0].readpipe(str1);            
// rxdata[0].readpipe(sender.rx); //direct alternative

 rxdata.showrow(bigint); //show last row
end;

end.
