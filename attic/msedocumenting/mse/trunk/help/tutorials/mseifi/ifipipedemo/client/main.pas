unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 mclasses,mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msebitmap,msedataedits,msedatanodes,
 mseedit,msefiledialog,msegrids,mselistbrowser,msestrings,msesys,msetypes,
 msegraphedits,msestatfile,mseifi,mseifigui,msedispwidgets;

type
 tmainfo = class(tmseform)
   serverapp: tfilenameedit;
   tbooleanedit1: tbooleanedit;
   tstatfile1: tstatfile;
   channel: tpipeiochannel;
   tformlink1: tformlink;
   prociddisp: tintegerdisp;
   statedisp: tstringdisp;
   tframecomp1: tframecomp;
   procedure setconnected(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure afterconn(const sender: tcustomiochannel);
   procedure afterdisconn(const sender: tcustomiochannel);
   procedure cre(const sender: TObject);
   procedure afterstatread(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,msesimplewidgets,mseactions,msedbedit,db,mseifids,
 msedb,mseskin,msefileutils;
 
procedure tmainfo.setconnected(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  channel.serverapp:= tosysfilepath(serverapp.value);
  channel.active:= true;
 end
 else begin
  channel.active:= false;
  statedisp.value:= '';
 end;
end;

procedure tmainfo.afterconn(const sender: tcustomiochannel);
begin
 with statedisp do begin
  value:= 'Connected';
  font.color:= $008000;
 end; 
end;

procedure tmainfo.afterdisconn(const sender: tcustomiochannel);
begin
 with statedisp do begin
  statedisp.value:= '***Disconnected***';
  font.color:= cl_red;
 end;
end;

procedure tmainfo.cre(const sender: TObject);
begin
 prociddisp.value:= getprocessid;
end;

procedure tmainfo.afterstatread(const sender: TObject);
begin
 {$ifdef linux}
 if serverapp.value = '' then begin
  serverapp.value:= './ifipipedemoserver';
 end;
 {$else}
 if serverapp.value = '' then begin
  serverapp.value:= './ifipipedemoserver.exe';
 end;
 {$endif}
end;

initialization
 registerclasses([tstringedit,tformlink,tbutton,taction,tstringdisp,
                  tdbstringgrid,tmsedatasource,trxdataset,tprogressbar,
                  tmainmenu,tfacecomp,tframecomp,tskincontroller,
                  tdbnavigator]);
end.
