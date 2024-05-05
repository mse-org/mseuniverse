unit logfeatures;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msedataedits,msedatanodes,mseedit,
 msegrids,mselistbrowser,msestrings,msetypes;
 
type
 tlogfeaturesfo = class(tmseform)
   memoLogs: tmemoedit;
   gridFeatures: tstringgrid;
 end;
var
 logfeaturesfo: tlogfeaturesfo;
implementation
uses
 logfeatures_mfm;
end.
