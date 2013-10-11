unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msecommport,
 msecommutils,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,
 msestrings,msetypes,msegraphedits,msescrollbar,msegrids,msesimplewidgets,
 msewidgets,msestatfile,msesercomm,msetimer;

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
   ttimer1: ttimer;
   procedure clearexe(const sender: TObject);
   procedure portsetexe(const sender: TObject; var avalue: commnrty;
                   var accept: Boolean);
   procedure setactiveexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure sendtextexe(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure getactivecommexe(const sender: TObject; var avalue: commnrty);
   procedure timerexe(const sender: TObject);
 end;
var
 mainfo: tmainfo;

implementation

uses
 main_mfm,sysutils;

procedure tmainfo.portsetexe(const sender: TObject; var avalue: commnrty;
               var accept: Boolean);
begin
 try
  if avalue = cnr_invalid then begin 
   port.port.commname:= tcommselector(sender).valuename; //special comm name
  end
  else begin
   port.port.commname:= '';         
   port.port.commnr:= avalue;               //normal comm number
  end;
 finally
  activeed.value:= port.active; //reset in case of error
 end;
end;

procedure tmainfo.getactivecommexe(const sender: TObject; var avalue: commnrty);
 //add current port to dropdown list
begin
 if port.active and (port.port.commname = '') then begin
  avalue:= port.port.commnr;
 end;
end;

procedure tmainfo.setactiveexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 port.active:= avalue;
end;

procedure tmainfo.sendtextexe(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 port.port.writestring(avalue+eor.value);
end;

procedure tmainfo.timerexe(const sender: TObject);
var
 str1: string;
begin
 if port.active then begin
  str1:= port.port.readavailstring(100); //max 100 byte
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
