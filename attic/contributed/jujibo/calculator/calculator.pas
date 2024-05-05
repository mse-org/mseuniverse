program calculator;
{*****************************************************
 *  Calculator   
 *  MSEide+MSEgui example
 *
 *  Author:  Julio Jiménez Borreguero
 *  License: Free Software (use at your own risk)
 *
 ******************************************************}
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype gui}{$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef linux}cthreads,{$endif}{$endif}msegui,mseforms,main,
 mseconsts{,mseconsts_es }{replace by your language unit},sysutils,msegraphics,
 msegraphutils;
begin
 //mseconsts.setlangconsts('es'); // set your language
 setcolormapvalue(cl_mapped+5{cl_background}, 237,240,221); // background color
 application.createform(tmainfo,mainfo);
 application.run;
end.
