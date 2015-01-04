{*
   MSEgui Dark theme by cefou [ mr.cefou@gmail.com ]
*} 

unit darkskin;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
implementation
uses
 msegui,dark;
initialization
 application.createdatamodule(tdarkmo,darkmo);
end.
