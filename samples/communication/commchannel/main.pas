unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msecommport,
 msecommutils,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,
 msestrings,msetypes,msegraphedits,msescrollbar,msegrids,msesimplewidgets,
 msewidgets,msestatfile,msesercomm,msedispwidgets,mserichstring,
 portsettingsframe,msesplitter,mseact,msedropdownlist,msestream,sysutils;

type
 tmainfo = class(tmainform)
   rxdata: tstringgrid;
   clearbu: tbutton;
   tstatfile1: tstatfile;
   conn: tasynsercommchannel;
   statusdisp: tstringdisp;
   portfra: tportsettingsfra;
   tlayouter1: tlayouter;
   loopon: tbooleanedit;
   senddtexted: thistoryedit;
   loopnum: tintegeredit;
   procedure clearexe(const sender: TObject);
   procedure sendtextexe(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure responseexe(const sender: tcustomsercommchannel;
                   var adata: AnsiString; var aflags: commresponseflagsty);
   procedure seteorexe(const sender: TObject; var avalue: AnsiString;
                   var accept: Boolean);
   procedure looponset(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure activeset(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
  protected
   procedure repeatsend();
 end;
var
 mainfo: tmainfo;

implementation

uses
 main_mfm,typinfo,mseformatstr;

procedure tmainfo.clearexe(const sender: TObject);
begin
 rxdata.clear();
 loopnum.value:= loopnum.valuemin;
 statusdisp.value:= '';
end;

procedure tmainfo.sendtextexe(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 if portfra.port.active then begin
  conn.transmiteor(ansistring(avalue),length(avalue),-1);
 end;
end;

procedure tmainfo.repeatsend();
var
 b1: boolean;
 s1: msestring;
begin
 s1:= inttostrmse(loopnum.value)+' '+senddtexted.value;
 sendtextexe(nil,s1,b1);
 loopnum.value:= loopnum.value+1;
end;

procedure tmainfo.responseexe(const sender: tcustomsercommchannel;
               var adata: AnsiString; var aflags: commresponseflagsty);
begin
 rxdata[0].readpipe(adata+c_linefeed);
 statusdisp.value:= msestring(
                        settostring(ptypeinfo(typeinfo(commresponseflagsty)),
                                                       integer(aflags),false));
 rxdata.showrow(bigint);
 if loopon.value then begin
  repeatsend();
 end;
end;

procedure tmainfo.seteorexe(const sender: TObject; var avalue: AnsiString;
               var accept: Boolean);
begin
 conn.eor:= avalue;
end;

procedure tmainfo.looponset(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  repeatsend();
 end;
end;

procedure tmainfo.activeset(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 portfra.activeset(sender,avalue,accept);
 if avalue and loopon.value then begin
  repeatsend();
 end;
end;


end.
