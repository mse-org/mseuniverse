unit baseeditpageform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,mdb,msedb,
 mseifiglob;
type
 tbaseeditpagefo = class(tsubform)
   dataso: tmsedatasource;
 end;
 editpageclassty = class of tbaseeditpagefo;

implementation
uses
 baseeditpageform_mfm;
end.
