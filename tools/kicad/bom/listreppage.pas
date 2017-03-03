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
    constructor create(const areport: treport; const adocuinfo: docuinfoty;
                                               const apage: docupageinfoty);
end;

implementation
uses
 listreppage_mfm;

{ tlistreppa }

constructor tlistreppa.create(const areport: treport; 
                     const adocuinfo: docuinfoty; const apage: docupageinfoty);
const
 titlescale = 1.3;
begin
 inherited;
 title.font.name:= font.name;
 if font.height = 0 then begin
  title.font.height:= round(font.glyphheight*titlescale);
 end
 else begin
  title.font.heightflo:= font.heightflo*titlescale;
 end;
 title.tabs[0].value:= apage.title;
end;

end.
