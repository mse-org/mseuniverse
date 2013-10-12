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
   tstatfile1: tstatfile;
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
 portfra.port.pipes.tx.write(avalue+portfra.eor.value);
end;

procedure tmainfo.inputavaileexe(const sender: tcustomcommpipes);
var
 str1: string;
begin
 str1:= sender.rx.readdatastring;
 rxdata[0].readpipe(str1);
// rxdata[0].readpipe(sender.rx); //direct alternative

 rxdata.showrow(bigint); //show last row
end;

end.
