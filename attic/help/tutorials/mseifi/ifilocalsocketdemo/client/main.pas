unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 classes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedispwidgets,
 msestrings,msetypes,msedataedits,mseedit,mseifiglob,msesimplewidgets,
 msewidgets,msegrids,mseifigui,mseifilink,msesockets,msesys,msestatfile,
 mseificomp,mseificompglob,mseifi,msessl;

type
 tmainfo = class(tmainform)
   url: tstringedit;
   port: tintegeredit;
   tbutton1: tbutton;
   tstatfile1: tstatfile;
   tbutton2: tbutton;
   conndisp: tstringdisp;
   socketkind: tenumtypeedit;
   channel: tsocketclientiochannel;
   modulelink: tmodulelink;
   ssl: tssl;
   procedure urlsetexe(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure portsetexe(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
   procedure connectexe(const sender: TObject);
   procedure disconnectexe(const sender: TObject);
   procedure setsocketkindexe(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
   procedure intsocketkindexe(const sender: tenumtypeedit);
   procedure aftterconnectexe(const sender: tcustomiochannel);
   procedure afterdisconnectexe(const sender: tcustomiochannel);
   procedure loadedexe(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,mseifidbgui;
 
procedure tmainfo.loadedexe(const sender: TObject);
begin
 registerclasses([tdbrxwidgetgrid,tintegeredit,tstringedit]);
end;

procedure tmainfo.aftterconnectexe(const sender: tcustomiochannel);
begin
 conndisp.value:= 'connected';
end;

procedure tmainfo.afterdisconnectexe(const sender: tcustomiochannel);
begin
 conndisp.value:= 'disconnected';
end;

procedure tmainfo.urlsetexe(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 channel.socket.url:= avalue;
end;

procedure tmainfo.portsetexe(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
 channel.socket.port:= avalue;
end;

procedure tmainfo.connectexe(const sender: TObject);
begin
 channel.active:= true;
end;

procedure tmainfo.disconnectexe(const sender: TObject);
begin
 channel.active:= false;
end;

procedure tmainfo.setsocketkindexe(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
 channel.socket.kind:= socketkindty(avalue);
end;

procedure tmainfo.intsocketkindexe(const sender: tenumtypeedit);
begin
 sender.typeinfopo:= typeinfo(socketkindty);
end;

end.
