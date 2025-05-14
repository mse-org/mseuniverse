unit loaddefaultskin;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
implementation
uses
 msegui,defaultskin;
initialization
 application.createdatamodule(tdefaultskinmo,skin);
end.
