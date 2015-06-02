unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 mseassistive,msegrids,msestrings,msesimplewidgets,msedataedits,mseedit,
 mseificomp,mseificompglob,mseifiglob,msestatfile,msestream,sysutils,
 mseact;

type
 tassistivemonitor = class(tobject,iassistiveserver)
  private
   fgrid: tstringgrid;
  protected
   procedure track(const prefix: msestring; const sender: iassistiveclient; 
                                                   const atext: msestring);
   procedure track(const prefix: msestring; const sender: tobject; 
                                                     const atext: msestring);
    //iassistiveserver
   procedure doenter(const sender: iassistiveclient);
   procedure clientmouseevent(const sender: iassistiveclient;
                                           var info: mouseeventinfoty);
   procedure dofocuschanged(const oldwidget,newwidget: iassistiveclient);
   procedure dokeydown(const sender: iassistiveclient;
                                        const info: keyeventinfoty);
   procedure doactionexecute(const sender: tobject; const info: actioninfoty);
  public
   constructor create(const agrid: tstringgrid);
   destructor destroy(); override;
 end;
 
 tmainfo = class(tmainform)
   grid: tstringgrid;
   tbutton1: tbutton;
   tbutton2: tbutton;
   tstringedit1: tstringedit;
   tstringedit2: tstringedit;
   procedure createexe(const sender: TObject);
   procedure destroyexe(const sender: TObject);
   procedure exe(const sender: TObject);
  private
   fmonitor: tassistivemonitor;
 end;
 
var
 mainfo: tmainfo;

implementation
uses
 main_mfm,typinfo,mclasses,mseactions;

function getname(const sender: iassistiveclient): msestring;
begin
 if sender = nil then begin
  result:= 'NIL';
 end
 else begin
  result:= sender.getassistivename;
 end;
end;
 
{ tassistivemonitor }

constructor tassistivemonitor.create(const agrid: tstringgrid);
begin
 fgrid:= agrid;
 assistiveserver:= iassistiveserver(self);
end;

destructor tassistivemonitor.destroy();
begin
 assistiveserver:= nil;
 fgrid.free();
end;

procedure tassistivemonitor.track(const prefix: msestring; 
                       const sender: iassistiveclient; const atext: msestring);
var
 mstr1: msestring;
// inst1: tobject;               
begin
 if (sender = nil) or (sender.getinstance <> fgrid) then begin
  mstr1:= '<'+getname(sender)+'> ';
  fgrid.appendrow(prefix+mstr1+atext);
  fgrid.showlastrow();
 end;
end;

procedure tassistivemonitor.track(const prefix: msestring;
                                const sender: tobject; const atext: msestring);
var
 intf1: iassistiveclient;
 mstr1: msestring;
begin
 if getcorbainterface(sender,typeinfo(iassistiveclient),intf1) then begin
  track(prefix,intf1,atext);
 end
 else begin
  mstr1:= '';
  if sender is tcomponent then begin
   mstr1:= tcomponent(sender).name+' ';
  end;
  track(prefix,iassistiveclient(nil),mstr1+atext);
 end;
end;

procedure tassistivemonitor.doenter(const sender: iassistiveclient);
begin
 track('<doenter>',sender,'');
end;

procedure tassistivemonitor.clientmouseevent(const sender: iassistiveclient;
               var info: mouseeventinfoty);
begin
 track('<clientmouseevent '+getenumname(typeinfo(eventkindty),
                       ord(info.eventkind))+'>',sender,'');
end;

procedure tassistivemonitor.dofocuschanged(const oldwidget: iassistiveclient;
               const newwidget: iassistiveclient);
begin
 track('<dofocuschanged '+getname(newwidget)+'>',oldwidget,'');
end;

procedure tassistivemonitor.dokeydown(const sender: iassistiveclient;
               const info: keyeventinfoty);
begin
 track('<dokeydown '+
//          getenumname(typeinfo(eventkindty),ord(info.eventkind)) + ' ' +
          getshortcutname(shortcutty(info.key)) + ' "'+info.chars + '" ' +
  settostring(ptypeinfo(typeinfo(shiftstatesty)),
                              int32(info.shiftstate),true) + ' ' +
  settostring(ptypeinfo(typeinfo(eventstatesty)),
                              int32(info.eventstate),true) + '>',sender,'');
end;

procedure tassistivemonitor.doactionexecute(const sender: tobject;
               const info: actioninfoty);
begin
 track('<doactionexecute>',sender,'');
end;

{ tmainfo }

procedure tmainfo.createexe(const sender: TObject);
begin
 fmonitor:= tassistivemonitor.create(grid);
end;

procedure tmainfo.destroyexe(const sender: TObject);
begin
 fmonitor.free();
end;

procedure tmainfo.exe(const sender: TObject);
begin
 guibeep();
end;

end.
