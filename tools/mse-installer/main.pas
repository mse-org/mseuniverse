unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msetabs,msewidgets,
 msebitmap,msedataedits,mseedit,msegrids,msestrings,msetypes,msewidgetgrid,
 msedatanodes,msefiledialog,mselistbrowser,msescrollbar,msesys,msesysutils,
 msesysintf,sysutils,msestatfile,msetimer,msedispwidgets,msesimplewidgets,
 dateutils,classes,msefileutils,strutils,mseimage,mseeditglob,msegridsglob,
 msetextedit,mseformatjpgread,mseformatpngread,mseformatjpgwrite,msestringenter,
 mseformatpngwrite,msestream,mseformatstr,globmodul,msegraphedits,msedataimage,
 mseifiglob;

type
 tmainfo = class(tmainform)
   ttabwidget1: ttabwidget;
   timagelist1: timagelist;
   tabinfo: ttabpage;
   tabforms: ttabpage;
   tabfilescopy: ttabpage;
   wfilelist: twidgetgrid;
   wfilesource: tfilenameedit;
   wfilestore: tfilenameedit;
   wfolder: tdropdownlistedit;
   wfiletarget: tstringedit;
   wsample: tstringedit;
   tabenv: ttabpage;
   gridenv: twidgetgrid;
   wenv: tstringedit;
   tmainmenu1: tmainmenu;
   tstatfile1: tstatfile;
   ttimer1: ttimer;
   wstatusbar: tsimplewidget;
   wtime: tdatetimedisp;
   wdate: tdatetimedisp;
   wfilename: tstringdisp;
   www: tbutton;
   fdialog: tfiledialog;
   appname: tstringedit;
   appversion: tstringedit;
   apptagline: tstringedit;
   applogo: timage;
   appdescription: tmemoedit;
   btnclear: tbutton;
   btnopen: tbutton;
   imgdialog: tfiledialog;
   builddialog: tfiledialog;
   tabfolder: ttabpage;
   wlocation: twidgetgrid;
   wmacrodescription: tstringedit;
   wmacrofolder: tdropdownlistedit;
   wforms: twidgetgrid;
   wformtype: tdropdownlistedit;
   wformdescription: tmemoedit;
   wformimage: tfilenameedit;
   copyright: tstringedit;
   appwebsite: tstringedit;
   companyname: tstringedit;
   wdesktop: tstringedit;
   wprogramgroup: tstringedit;
   wprogramname: tstringedit;
   wiconname: tstringedit;
   wlanglist: twidgetgrid;
   tstatfile2: tstatfile;
   wlangname: tstringedit;
   wlangdisplay: tstringedit;
   btnadd: tbutton;
   btnsave: tbutton;
   btndel: tbutton;
   woutputname: tstringedit;
   woverwrite: tbooleanedit;
   procedure mainfo_onloaded(const sender: TObject);
   procedure ttimer1_ontimer(const sender: TObject);
   procedure buildproject(const sender: TObject);
   procedure wfilesource_ondataentered(const sender: TObject);
   procedure getsample(const sender: TObject);
   procedure clearproject;
   procedure clearlangdata;
   procedure showopen(const sender: TObject);
   procedure showsave(const sender: TObject);
   procedure shownew(const sender: TObject);
   procedure showclose(const sender: TObject);
   procedure btnclear_onexecute(const sender: TObject);
   procedure btnopen_onexecute(const sender: TObject);
   procedure tstatfile1_onstatwrite(const sender: TObject;
                   const writer: tstatwriter);
   procedure tstatfile2_onstatread(const sender: TObject;
                   const reader: tstatreader);
   procedure wfolder_onbeforedropdown(const sender: TObject);
   procedure wdesktop_ondataentered(const sender: TObject);
   procedure wfiletarget_onkeydown(const sender: twidget;
                   var ainfo: keyeventinfoty);
   procedure wfolder_onkeydown(const sender: twidget;
                   var ainfo: keyeventinfoty);
   procedure tstatfile2_onstatwrite(const sender: TObject;
                   const writer: tstatwriter);
   procedure btnadd_onexecute(const sender: TObject);
   procedure btnsave_onexecute(const sender: TObject);
   procedure btndel_onexecute(const sender: TObject);
   procedure wlanglist_oncellevent(const sender: TObject;
                   var info: celleventinfoty);
 end;
var
 mainfo: tmainfo;
 
implementation
uses
 main_mfm,zipper;

procedure tmainfo.mainfo_onloaded(const sender: TObject);
var
 str1: msestringarty;
 i: integer;
begin
 ttimer1_ontimer(nil);
 setlength(str1,GetEnvironmentVariableCount);
 for i:=1 to GetEnvironmentVariableCount do begin
  str1[i-1]:= GetEnvironmentString(i);
 end;
 wenv.gridvalues:= str1;
 with wmacrofolder.dropdown.cols do begin
  {$ifdef linux}
  addrow(['${HOMEDIR}']);
  addrow(['${MANPATH}']);
  addrow(['${TMPDIR}']);
  {$endif}
  {$ifdef mswindows}
  addrow(['${PROGRAMFILES}']);
  addrow(['${COMMONPROGRAMFILES}']);
  addrow(['${WINDIR}']);
  addrow(['${SYSTEMDIR}']);
  addrow(['${HOMEDIR}']);
  addrow(['${ALLUSERSPROFILE}']);
  addrow(['${USERPROFILE}']);
  addrow(['${USERAPPDATA}']);
  addrow(['${TMPDIR}']);
  {$endif}
 end;
end;

procedure tmainfo.ttimer1_ontimer(const sender: TObject);
begin
 wtime.value:= time;
 if (hourof(wtime.value)=0) or (sender=nil) then begin
   wdate.value:= date;
 end;
end;

procedure tmainfo.buildproject(const sender: TObject);
var
 fzip: tzipper;
 strar1,ftmp: msestringarty;
 int1: integer;
 str1,str2: msestring;
begin
 builddialog.dialogkind:= fdk_save;
 if builddialog.execute=mr_ok then begin
  str1:= filedir(builddialog.controller.filename);
  fzip:= tzipper.create;
  fzip.BufferSize:= 65536;
  strar1:= wfilesource.gridvalues;
  for int1:= 0 to high(strar1) do begin
   //fzip.entries.addfileentry(tosysfilepath(strar1[int1]),tosysfilepath(wfilestore.gridvalues[int1]));
   fzip.entries.addfileentry(tosysfilepath(strar1[int1]),wfilestore.gridvalues[int1]);
  end;
  strar1:= wformimage.gridvalues;
  for int1:= 0 to high(strar1) do begin
   if strar1[int1]<>'' then begin
    //fzip.entries.addfileentry(tosysfilepath(strar1[int1]),tosysfilepath('formimages/'+filename(strar1[int1])));
    fzip.entries.addfileentry(tosysfilepath(strar1[int1]),'formimages/'+filename(strar1[int1]));
   end;
  end;
  strar1:= nil;
  strar1:= wlangname.gridvalues;
  ftmp:= nil;
  setlength(ftmp,length(strar1)+1);
  for int1:= 0 to high(strar1) do begin
   ftmp[int1]:= concatpath(filedir(tstatfile2.filename),'lang/'+strar1[int1]+'.lang','/');
   copyfile(ftmp[int1],ftmp[int1]+'.tmp',true);
   //fzip.entries.addfileentry(tosysfilepath(ftmp[int1]+'.tmp'),strar1[int1]+'.lang');
   fzip.entries.addfileentry(tosysfilepath(ftmp[int1]+'.tmp'),strar1[int1]+'.lang');
  end;
  int1:= high(ftmp);
  ftmp[int1]:= tstatfile2.filename;
  copyfile(ftmp[int1],ftmp[int1]+'.tmp',true);
  fzip.entries.addfileentry(tosysfilepath(ftmp[int1]),'setup.conf');
  if woutputname.value<>'' then begin
   str2:= woutputname.value;
  end else begin
   str2:= 'setup';
  end;
  fzip.filename:= tosysfilepath(concatpath(str1,str2+'-data.msd'));
  fzip.zipallfiles;
  fzip.free;
  for int1:= 0 to high(ftmp) do begin
   deletefile(ftmp[int1]+'.tmp');
  end;
  
  //encryptfile(concatpath(str1,str2+'-data.tmp'),concatpath(str1,str2+'-data.msd'));
  //deletefile(concatpath(str1,str2+'-data.tmp'));
  {$ifdef linux}
  copyfile(concatpath(installpath,'setup'),concatpath(str1,str2),true);
  {$endif}
  {$ifdef mswindows}
  copyfile(concatpath(installpath,'setup.exe'),concatpath(str1,str2+'.exe'),true);
  {$endif}
  showmessage('Build success!');
 end;
end;

procedure tmainfo.wfilesource_ondataentered(const sender: TObject);
var
 fn: filenamety;
begin
 fn:= filename(wfilesource.value);
 if wfilestore.value='' then begin
  wfilestore.value:= fn;
 end;
 if wfiletarget.value='' then begin
  wfiletarget.value:= fn;
 end;
end;

procedure tmainfo.getsample(const sender: TObject);
var
 str1,str2: msestring;
begin
 str1:= wfolder.value;
 fmacro.expandmacros(str1);
 str2:= tosysfilepath(concatpath(str1,wfiletarget.value));
 wsample.value:= str2;
end;

procedure tmainfo.clearproject;
begin
 appname.value:= '';
 appversion.value:= '';
 apptagline.value:= '';
 appdescription.value:= '';
 applogo.bitmap.clear;
 wfilelist.clear;
 wforms.clear;
 wlocation.clear;
 wlanglist.clear;
end;

procedure tmainfo.clearlangdata;
begin
 //apptagline.value:= '';
 appdescription.value:= '';
 wforms.clear;
 wlocation.clear;
end;

procedure tmainfo.showopen(const sender: TObject);
begin
 fdialog.dialogkind:= fdk_open;
 if fdialog.execute=mr_ok then begin
  clearproject;
  tstatfile2.filename:= fdialog.controller.filename;
  tstatfile2.readstat;
  wfilename.text:= fdialog.controller.filename;
  wlanglist.firstrow(fca_focusin);
 end;
end;

procedure tmainfo.showsave(const sender: TObject);
begin
 if askyesno('Save project?','Confirmation') then begin
  tstatfile1.writestat;
  tstatfile2.writestat;
 end;
end;

procedure tmainfo.shownew(const sender: TObject);
var
 str1,str2: filenamety;
begin
 fdialog.dialogkind:= fdk_new;
 if fdialog.execute=mr_ok then begin
  clearproject;
  str1:= fdialog.controller.filename;
  wfilename.text:= str1;
  tstatfile2.filename:= str1;
  str2:= concatpath(filedir(str1),'lang');
  if not finddir(str2) then begin
   createdir(str2);
  end;
 end;
end;

procedure tmainfo.showclose(const sender: TObject);
begin
 if askyesno('Save project before close?','Confirmation') then begin
  tstatfile2.writestat;
 end;
 clearproject;
end;

procedure tmainfo.btnclear_onexecute(const sender: TObject);
begin
 applogo.bitmap.clear;
end;

procedure tmainfo.btnopen_onexecute(const sender: TObject);
var
 str1: string;
begin
 imgdialog.dialogkind:= fdk_open;
 if imgdialog.execute=mr_ok then begin
  str1:= fileext(imgdialog.controller.filename);
  applogo.helpcontext:= str1;
  applogo.bitmap.loadfromfile(imgdialog.controller.filename,'');
 end;
end;

procedure tmainfo.tstatfile1_onstatwrite(const sender: TObject;
               const writer: tstatwriter);
begin

end;

procedure tmainfo.tstatfile2_onstatread(const sender: TObject;
               const reader: tstatreader);
var
 str1,str2,str3: string;
begin
 str1:= reader.readstring('applogoformat','');
 if str1='' then exit;
 str2:= reader.readstring('applogo','');
 if str2<>'' then begin
  str3:= strtobytestr(str2);
  applogo.helpcontext:= str1;
  applogo.bitmap.loadfromstring(str3,str1);
 end else begin
  applogo.bitmap.clear;
 end;
end;

procedure tmainfo.wfolder_onbeforedropdown(const sender: TObject);
var
 int1: integer;
 ar1: msestringarty;
begin
 ar1:= wmacrofolder.gridvalues;
 with wfolder.dropdown.cols do begin
  clear;
  addrow(['']);
  for int1:=0 to high(ar1) do begin
   addrow([ar1[int1]]);
  end;
 end;
end;

procedure tmainfo.wdesktop_ondataentered(const sender: TObject);
begin
 if wprogramname.value='' then wprogramname.value:= wprogramgroup.value;
end;

procedure tmainfo.wfiletarget_onkeydown(const sender: twidget;
               var ainfo: keyeventinfoty);
begin
 if isenterkey(wfiletarget,ainfo.key) then begin
  getsample(nil);
 end;
end;

procedure tmainfo.wfolder_onkeydown(const sender: twidget;
               var ainfo: keyeventinfoty);
begin
 if isenterkey(wfolder,ainfo.key) then begin
  getsample(nil);
 end;
end;

procedure tmainfo.tstatfile2_onstatwrite(const sender: TObject;
               const writer: tstatwriter);
var
 str1,str2: string;
begin
 if applogo.bitmap.hasimage then begin
  applogo.bitmap.writetostring(str1,applogo.helpcontext,[]);
  str2:= bytestrtostr(str1,nb_hex);
  writer.writestring('applogoformat',applogo.helpcontext);
  writer.writestring('applogo',str2);
 end;
end;

procedure tmainfo.btnadd_onexecute(const sender: TObject);
var
 str1: msestring;
begin
 str1:= 'en';
 if stringenter(str1,'Please type language id (without space), such as ''en'' for English, ''id'' for Indonesia, etc',
   'Create new language')=mr_ok then begin
  if str1<>'' then begin
   wlanglist.appendrow(false);
   wlangname.value:= str1;
  end;
 end;
end;

procedure tmainfo.btnsave_onexecute(const sender: TObject);
begin
 if askyesno('Save this langugage data?','Confirmation') then begin
  tstatfile1.writestat;
 end;
end;

procedure tmainfo.btndel_onexecute(const sender: TObject);
begin
 if askyesno('Are you sure to delete this langugage data?','Confirmation') then begin
  deletefile(concatpath(filedir(tstatfile2.filename),'lang/'+wlangname.value+'.lang','/'));
  clearlangdata;
  wlanglist.deleterow(wlanglist.row,1);
 end;
end;

procedure tmainfo.wlanglist_oncellevent(const sender: TObject;
               var info: celleventinfoty);
begin
 if isrowchange(info) then begin
  clearlangdata;
  tstatfile1.filename:= concatpath(filedir(tstatfile2.filename),'lang/'+wlangname.value+'.lang','/');
  tstatfile1.readstat;
 end;
end;

end.
