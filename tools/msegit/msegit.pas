{ MSEgit Copyright (c) 2011 by Martin Schreiber
   
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
}
//
// under construction
//
program msegit;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype gui}{$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef linux}cthreads,{$endif}{$endif}
 msegui,mseforms,main,mainmodule,dirtreeform,filesform,guitemplates,
 remotesform,gitconsole;
 
begin
 application.createdatamodule(tguitemplatesmo,guitemplatesmo);
 application.createform(tdirtreefo,dirtreefo);
 application.createform(tfilesfo,filesfo);
 application.createform(tremotesfo,remotesfo);
 application.createform(tgitconsolefo,gitconsolefo);
 application.createdatamodule(tmainmo,mainmo);
 application.createform(tmainfo,mainfo); //last
 application.run;
end.
