unit form2;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,mseimage;
type
 tform2fo = class(tmseform)
   timage1: timage;
 end;
var
 form2fo: tform2fo;
implementation
uses
 form2_mfm;
end.
