unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msecommport,
 msecommutils,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,
 msestrings,msetypes,msegraphedits,msescrollbar,msegrids,msesimplewidgets,
 msewidgets,msestatfile,msesercomm;

type
 tmainfo = class(tmainform)
   ported: tcommselector;
   activeed: tbooleanedit;
   senddtexted: thistoryedit;
   rxdata: tstringgrid;
   clearbu: tbutton;
   tstatfile1: tstatfile;
   port: tsercommcomp;
   eor: thexstringedit;
   procedure clearexe(const sender: TObject);
   procedure portsetexe(const sender: TObject; var avalue: commnrty;
                   var accept: Boolean);
   procedure setactiveexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure sendtextexe(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure inputavaileexe(const sender: tcustomcommpipes);
   procedure befdropexe(const sender: TObject);
   procedure afterdrop(const sender: TObject);
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

procedure tmainfo.portsetexe(const sender: TObject; var avalue: commnrty;
               var accept: Boolean);
begin
 port.port.commnr:= avalue;
end;

procedure tmainfo.setactiveexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 port.active:= avalue;
end;

procedure tmainfo.sendtextexe(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 port.pipes.tx.write(avalue+eor.value);
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

procedure tmainfo.befdropexe(const sender: TObject);
begin
 port.port.close;
 sleep(500); //sometimes necessary on windows
end;

procedure tmainfo.afterdrop(const sender: TObject);
begin
 port.active:= activeed.value;
end;

end.
