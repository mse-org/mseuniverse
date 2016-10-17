unit productionpage;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msetabs;
type
 tproductionpagefo = class(ttabform)
 end;
var
 productionpagefo: tproductionpagefo;
implementation
uses
 productionpage_mfm;
end.
