{ Contributed module by Tolstov Igor  (attid@yandex.ru) for MSEgui(c)

    See the file COPYING.MSE the part of the MSEgui distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
program printtest;

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype console}{$endif}
{$endif}

uses
 {$ifdef FPC}{$ifdef linux}cthreads,{$endif}{$endif}msegui,
 mseforms,main;

begin
 application.createform(tmainfo,mainfo);
 application.run;
end.
