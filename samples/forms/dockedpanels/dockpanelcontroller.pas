program dockpanelcontroller;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype gui}{$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef unix}cthreads,{$endif}{$endif} 
 msegui,main,aform,bform,cform,dform,eform;
begin
 application.createform(tafo,afo);
 application.createform(tbfo,bfo);
 application.createform(tcfo,cfo);
 application.createform(tdfo,dfo);
 application.createform(tefo,efo);
 application.createform(tmainfo,mainfo);
 application.run;
end.
