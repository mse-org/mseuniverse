unit clientmodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 classes,mseglob,mseapplication,mseclasses,msedatamodules,msethreadcomp,
 msestrings,
 mseifi,db,msebufdataset,msedatabase,msedb,mseifids,msesqldb,msqldb,sysutils,
 msesqlite3conn,mseifiglob,mseifilink,mseificomp,mseificompglob;

type
 tclientmo = class(tmsedatamodule)
   channel: tsocketserveriochannel;
   query: ttxsqlquery;
   conn: tsqlite3connection;
   trans: tmsesqltransaction;
   modulelink: tmodulelink;
   procedure afterconnectexe(const sender: tcustomiochannel);
   procedure afterdisconnectexe(const sender: tcustomiochannel);
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
 end;
var
 clientmo: tclientmo;
implementation
uses
 clientmodule_mfm,clientmain;

procedure tclientmo.afterconnectexe(const sender: tcustomiochannel);
begin
 writeln('Clientmodule started.');
 modulelink.modulestx[0].sendmodule; //send main form
end;

procedure tclientmo.afterdisconnectexe(const sender: tcustomiochannel);
begin
 writeln('Clientmodule terminated.');
end;

destructor tclientmo.destroy;
begin
 inherited;
end;

constructor tclientmo.create(aowner: tcomponent);
begin
 inherited;
end;

end.
