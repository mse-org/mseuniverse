unit regcompdesigner;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 classes,msecomponenteditors,msedesignintf,sysutils,compdesigner,mseglob,
 regcompdesigner_bmp;
 
implementation
procedure Register;
begin
 registercomponents('Repaz Tools',[tcomponentdesigner,tcomponentpallete,tobjectinspector]); 
 registercomponenttabhints(['Tools for Repaz and Others'],['Component Designer','Component Pallete',' Object Inspector']);
end;

initialization
 register;
end.
