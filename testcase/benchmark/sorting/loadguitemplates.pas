unit loadguitemplates;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
implementation
uses
 msegui,guitemplates;
initialization
 application.createdatamodule(tguitemplatesmo,guitemplatesmo);
end.
