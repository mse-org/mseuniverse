unit regvideoplayer;

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface

implementation
uses
 msedesignintf,azvideoplayer;

procedure register;
begin
 registercomponents('Video Player',[tazvideoplayer]);
end;


initialization
 register;
end.
