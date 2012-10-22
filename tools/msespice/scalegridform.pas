unit scalegridform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedataedits,mseedit,
 msegrids,mseifiglob,msestrings,msetypes,msewidgetgrid,msegraphedits,
 mserealsumedit;
type
 tscalegridfo = class(tsubform)
   scalegrid: twidgetgrid;
   log: tbooleanedit;
   maingridlinewidth: trealsumedit;
 end;
var
 scalegridfo: tscalegridfo;
implementation
uses
 scalegridform_mfm;
end.
