unit loadguitemplates;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
implementation
uses
 msegit,guitemplates;
initialization
 application.createdatamodule(tguitemplatesmo,guitemplatesmo);
end.
