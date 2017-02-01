unit listreppage;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,basereppage,
 mdb,mseifiglob,msereport,mserichstring,msesplitter,msestrings,
 mainmodule;

type
 tlistreppa = class(tbasereppa)
   tbandarea2: tbandarea;
   title: trecordband;
  public
    constructor create(const apage: tdocupage);
end;

implementation
uses
 listreppage_mfm;

{ tlistreppa }

constructor tlistreppa.create(const apage: tdocupage);
begin
 inherited create(nil);
 title.tabs[0].value:= apage.title;
end;

end.
