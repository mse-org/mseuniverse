{ MSEgit Copyright (c) 2011-2012 by Martin Schreiber
   
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
program msegit;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}
  {$ifdef mse_debug}
   {$apptype console}
  {$else}
   {$apptype gui}
  {$endif}
 {$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef unix}cthreads,{$endif}{$endif}
 skinmodule,msegui,mseforms,main,mainmodule,gitdirtreeform,filesform,stashform,
 remotesform,gitconsole,diffwindow,branchform,logform,tagsform,
 commitdispform;
begin
// application.createdatamodule(tguitemplatesmo,guitemplatesmo);
 application.createform(tcommitdispfo,commitdispfo);
 application.createform(tgitdirtreefo,gitdirtreefo);
 application.createform(tfilesfo,filesfo);
 application.createform(tstashfo,stashfo);
 application.createform(tremotesfo,remotesfo);
 application.createform(tbranchfo,branchfo);
 application.createform(tgitconsolefo,gitconsolefo);
 application.createform(tdiffwindowfo,diffwindowfo);
 application.createform(tlogfo,logfo);
 application.createform(ttagsfo,tagsfo);
 application.createdatamodule(tmainmo,mainmo);
 application.createform(tmainfo,mainfo); //last
 application.run;
end.
