unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,mseifi,msedispwidgets,msestrings,
 msetypes,msegrids,mseifigui,msedataedits,mseedit,msestatfile,msetimer,
 mseifilink,msesimplewidgets,msewidgets,db,msebufdataset,msedb,mseifids,
 msesqldb,msqldb,sysutils,msedbedit,msedialog,msegraphedits,mseact,mseactions;

type 
 tmainfo = class(tmseform)
   channel: tpipeiochannel;
   prociddisp: tintegerdisp;
   formlink: tformlink;
   tstringedit1: tstringedit;
   tstatfile1: tstatfile;
   buttondisp: tstringdisp;
   timer: ttimer;
   tbutton1: tbutton;
   timer2: ttimer;
   tdbstringgrid1: tdbstringgrid;
   datasource: tmsedatasource;
   query: ttxsqlquery;
   slider: tslider;
   menu1a: taction;
   menu1b: taction;
   menu1c: taction;
   menu2a: taction;
   procedure onstart(const sender: TObject);
   procedure buttonexe(const sender: trxlinkaction; const atag: Integer;
                   const aparams: Variant);
   procedure ti(const sender: TObject);
   procedure buttonex(const sender: TObject);
   procedure ti2(const sender: TObject);
   procedure setdsactive(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure menuexe(const sender: TObject);
   procedure quitexe(const sender: trxlinkaction; const atag: Integer;
                   const aparams: Variant);
   procedure afterdisconn(const sender: tcustomiochannel);
   procedure asyncev(const sender: TObject; var atag: Integer);
 end;
var
 mainfo: tmainfo;
implementation
uses
 classes,clientform,main_mfm;
const
 showtime = 2000000;
  
procedure showaction(const adisp: tstringdisp; atext: msestring);
begin
 with adisp do begin
  color:= cl_red;
  value:= atext;
  mainfo.timer.interval:= -showtime;
  mainfo.timer.enabled:= true;
 end;
end;

procedure clearaction(const adisp: tstringdisp);
begin
 with adisp do begin
  color:= cl_default;
  value:= '';
 end;
end;

 {tmainfo}
 
procedure tmainfo.onstart(const sender: TObject);
begin
 prociddisp.value:= getprocessid;
 formlink.modulestx[0].sendmodule;
end;

procedure tmainfo.buttonexe(const sender: trxlinkaction; const atag: Integer;
               const aparams: Variant);
begin
 showaction(buttondisp,'Button clicked');
end;

procedure tmainfo.ti(const sender: TObject);
begin
 clearaction(buttondisp);
end;

procedure tmainfo.buttonex(const sender: TObject);
begin
 with formlink.valuewidgets[1] do begin
  asstring:= 'Button clicked';
  sendvalue('color',cl_red);
 end;
 timer2.interval:= -showtime;
 timer2.enabled:= true;
end;

procedure tmainfo.ti2(const sender: TObject);
begin
 with formlink.valuewidgets[1] do begin
  asstring:= '';
  sendvalue('color',cl_default);
 end;
end;

procedure tmainfo.setdsactive(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 query.active:= avalue;
end;

const
 menutexts: array[0..3] of msestring = 
  ('Menu1 A clicked','Menu1 B clicked','Menu1 C clicked',
   'Menu2 clicked');
   
procedure tmainfo.menuexe(const sender: TObject);
begin
 showaction(buttondisp,menutexts[tcomponent(sender).tag]);
end;

procedure tmainfo.asyncev(const sender: TObject; var atag: Integer);
begin
 close;
end;

procedure tmainfo.quitexe(const sender: trxlinkaction; const atag: Integer;
               const aparams: Variant);
begin
 formlink.modulestx[0].close;
 asyncevent;
end;

procedure tmainfo.afterdisconn(const sender: tcustomiochannel);
begin
 close;
end;

end.
