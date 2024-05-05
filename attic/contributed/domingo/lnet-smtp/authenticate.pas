unit authenticate;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msedataedits,mseedit,msestrings,
 msetypes,msesimplewidgets,msewidgets;
type
 tauthenticatefo = class(tmseform)
   loginName: tstringedit;
   loginPassword: tstringedit;
   btnOk: tbutton;
   btnCancel: tbutton;
 end;
var
 authenticatefo: tauthenticatefo;
implementation
uses
 authenticate_mfm;
end.
