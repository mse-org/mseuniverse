unit load_fsilverskin;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
implementation
uses
 msegui,fsilverskin;
initialization
 application.createdatamodule(tfsilverskinmo,skin);
end.
