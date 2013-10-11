unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msecommport,
 msecommutils,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,
 msestrings,msetypes,msegraphedits,msescrollbar,msegrids,msesimplewidgets,
 msewidgets,msestatfile,msesercomm,msedispwidgets,mserichstring;

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
   conn: tasynsercommchannel;
   statusdisp: tstringdisp;
   procedure clearexe(const sender: TObject);
   procedure portsetexe(const sender: TObject; var avalue: commnrty;
                   var accept: Boolean);
   procedure setactiveexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure sendtextexe(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure responseexe(const sender: tcustomsercommchannel;
                   var adata: AnsiString; var aflags: commresponseflagsty);
   procedure seteorexe(const sender: TObject; var avalue: AnsiString;
                   var accept: Boolean);
   procedure getactivecomexe(const sender: TObject; var avalue: commnrty);
 end;
var
 mainfo: tmainfo;

implementation

uses
 main_mfm,typinfo;

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
 conn.connected:= avalue;
 if not avalue then begin
  port.active:= false;
 end;
end;

procedure tmainfo.sendtextexe(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 conn.transmiteor(avalue,length(avalue),-1);
end;

procedure tmainfo.responseexe(const sender: tcustomsercommchannel;
               var adata: AnsiString; var aflags: commresponseflagsty);
begin
 rxdata[0].readpipe(adata+c_linefeed);
 statusdisp.value:= settostring(ptypeinfo(typeinfo(commresponseflagsty)),
                                                       integer(aflags),false);
 rxdata.showrow(bigint);
end;

procedure tmainfo.seteorexe(const sender: TObject; var avalue: AnsiString;
               var accept: Boolean);
begin
 conn.eor:= avalue;
end;

procedure tmainfo.getactivecomexe(const sender: TObject; var avalue: commnrty);
begin
 if port.active and (port.port.commname = '') then begin
  avalue:= port.port.commnr;
 end;
end;

end.
