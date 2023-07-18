unit load_fcarbonskin;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
implementation
uses
 msegui,fcarbonskin;
initialization
 application.createdatamodule(tfcarbonskinmo,skin);
end.
