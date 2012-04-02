unit tagsform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,
 dispform;

type
 ttagsfo = class(tdispfo)
 end;
var
 tagsfo: ttagsfo;
implementation
uses
 tagsform_mfm;
end.
