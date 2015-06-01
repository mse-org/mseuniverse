unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 mseassistive,msegrids,msestrings,msesimplewidgets,msedataedits,mseedit,
 mseificomp,mseificompglob,mseifiglob,msestatfile,msestream,sysutils;

type
 tassistivemonitor = class(tobject,iassistiveserver)
  private
   fgrid: tstringgrid;
  protected
   procedure track(const sender: iassistiveclient; const atext: msestring);
    //iassistiveserver
   procedure doenter(const sender: iassistiveclient);
   procedure clientmouseevent(const sender: iassistiveclient;
                                           var info: mouseeventinfoty);
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
  private
   fmonitor: tassistivemonitor;
 end;
 
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,typinfo,mclasses;
 
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

procedure tassistivemonitor.doenter(const sender: iassistiveclient);
begin
 track(sender,'<doenter>');
end;

procedure tassistivemonitor.clientmouseevent(const sender: iassistiveclient;
               var info: mouseeventinfoty);
begin
 track(sender,'<clientmouseevent '+getenumname(typeinfo(eventkindty),
                                              ord(info.eventkind))+'>');
end;

procedure tassistivemonitor.track(const sender: iassistiveclient;
                                               const atext: msestring);
var
 mstr1: msestring;
 inst1: tobject;               
begin
 mstr1:= '<'+sender.getassistivename+'> ';
 inst1:= sender.getinstance();
 if inst1 is tcomponent then begin
  mstr1:= mstr1+tcomponent(inst1).name+' ';
 end;
 fgrid.appendrow(mstr1+atext);
 fgrid.showlastrow();
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

end.
