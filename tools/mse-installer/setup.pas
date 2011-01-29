program setup;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype gui}{$endif}
{$endif}
uses
 {$ifdef FPC}{$ifdef linux}cthreads,{$endif}{$endif}msegui,mseforms,mainsetup,skinblue,
 zipper,msestrings,globmodul,msepointer,msefileutils;

{$ifdef mswindows} 
 {$R mse-installer-icon.res} 
 {$R mse-installer-ver.res} 
{$endif} 
var
 fzip: tunzipper;
 str1,str2: msestring;
begin
 str1:= '${TMPDIR}';
 str2:= filenamebase(Paramstr(0));
 fmacro.expandmacros(str1);
 tmpdir:= concatpath(str1,str2+'/');
 fzip:= tunzipper.create;
 fzip.filename:= tosysfilepath(concatpath(installpath,str2+'-data.msd'));
 fzip.outputpath:= tosysfilepath(tmpdir);
 application.beginwait;
 fzip.unzipallfiles;
 fzip.free;
 application.endwait;
 application.createdatamodule(tskinblue,skinbluemo);
 application.createform(tmainsetupfo,mainsetupfo);
 application.run;
end.
