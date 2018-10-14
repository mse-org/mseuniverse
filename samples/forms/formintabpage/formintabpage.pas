program formintabpage;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype gui}{$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef unix}cthreads,{$endif}{$endif} 
 msegui,mainmodule,main,editform,classes,mseclasses;
begin
 begingloballoading();
 application.createdatamodule(tmainmo,mainmo);
 application.createform(teditfo,editfo);
 application.createform(tmainfo,mainfo);
 endgloballoading(); //trigger loading of statfile
 application.run;
end.
