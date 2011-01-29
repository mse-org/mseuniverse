unit mainsetup;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,mseimage,
 msesimplewidgets,msewidgets,globmodul,msestatfile,msestrings,mseformatstr,
 mseformatjpgread,mseformatpngread,msedock,msepointer,msedataedits,mseedit,
 msetypes,msebitmap,msetabs,msegrids,msewidgetgrid,msedatanodes,msefiledialog,
 mselistbrowser,msescrollbar,msesys,msefileutils,msegraphedits,msesysenv;
type
 tmainsetupfo = class(tmainform)
   applogo: timage;
   appname: tlabel;
   tstatfile1: tstatfile;
   appversion: tlabel;
   ttabwidget1: ttabwidget;
   btnclose: tbutton;
   btnnext: tbutton;
   btnprev: tbutton;
   wcompanyname: tlabel;
   tsimplewidget1: tsimplewidget;
   wtagline: tlabel;
   timagelist1: timagelist;
   wintro: ttabpage;
   wimgintro: timage;
   bmpintro: tbitmapcomp;
   bmpinstall: tbitmapcomp;
   tlabel2: tlabel;
   introdescription: tmemoedit;
   www: tlabel;
   ttabpage2: ttabpage;
   wimglocation: timage;
   locationdescription: tmemoedit;
   wlocation: twidgetgrid;
   wtarget: tstringedit;
   wtargetfolder: tfilenameedit;
   bmplogo: tbitmapcomp;
   tlabel3: tlabel;
   wcopyright: tlabel;
   appdescription: tmemoedit;
   tabcopyfiles: ttabpage;
   wimgcopy: timage;
   copydescription: tmemoedit;
   wfilelist: twidgetgrid;
   wfilecopy: tstringedit;
   bmplocation: tbitmapcomp;
   tabfinish: ttabpage;
   wimgfinish: timage;
   finishdescription: tmemoedit;
   bmpfinish: tbitmapcomp;
   tprogressbar1: tprogressbar;
   wcopyto: tstringedit;
   wref: tstringedit;
   wtmp: tstringedit;
   wdesktop: tstringedit;
   wprogramgroup: tstringedit;
   wprogramname: tstringedit;
   wlang: tkeystringedit;
   tstatfile2: tstatfile;
   wiconfile: tstringedit;
   procedure mainsetupfo_onloaded(const sender: TObject);
   procedure tstatfile1_onstatread(const sender: TObject;
                   const reader: tstatreader);
   procedure btnclose_onexecute(const sender: TObject);
   procedure updatestatus;
   procedure copyallfiles;
   procedure wtargetfolder_ondataentered(const sender: TObject);
   procedure btnprev_onexecute(const sender: TObject);
   procedure btnnext_onexecute(const sender: TObject);
   procedure ttabwidget1_onactivepagechanged(const sender: TObject);
   procedure mainsetupfo_onclose(const sender: TObject);
   procedure tstatfile2_onstatread(const sender: TObject;
                   const reader: tstatreader);
   procedure wlang_ondataentered(const sender: TObject);
 end;
var
 mainsetupfo: tmainsetupfo;
implementation
uses
 mainsetup_mfm,msegridsglob,mseerr,msesysintf;
 
procedure tmainsetupfo.mainsetupfo_onloaded(const sender: TObject);
begin
 tstatfile1.filename:= tmpdir+'/setup.conf';
 tstatfile1.readstat;
end;

procedure tmainsetupfo.tstatfile1_onstatread(const sender: TObject;
               const reader: tstatreader);
var
 str1,str2,str3: string;
 mstr1,mstr2: msestring;
 strar1,strar2,strar3,strar4,strar5,strar6,strar7,strar8,
 strar9,strar10,strar11: msestringarty;
 int1,int2: integer;
begin
 reader.findsection('mainfo.tstatfile2');
 str1:= reader.readstring('applogoformat','');
 if str1<>'' then begin
  str2:= reader.readstring('applogo','');
  if str2<>'' then begin
   str3:= strtobytestr(str2);
   applogo.helpcontext:= str1;
   applogo.bitmap.source:= nil;
   applogo.bitmap.loadfromstring(str3,str1);
  end else begin
   applogo.bitmap.source:= bmplogo;
  end;
 end;
 reader.findsection('mainfo.appname');
 mstr1:= reader.readmsestring('value','Application Name');
 appname.caption:= mstr1;
 self.caption:= mstr1+' Installation';
 fmacro.add(['APPNAME'],[mstr1]);
 reader.findsection('mainfo.appversion');
 mstr1:= reader.readmsestring('value','Version');
 appversion.caption:= 'Version : ' + mstr1;
 fmacro.add(['APPVERSION'],[mstr1]);
 reader.findsection('mainfo.companyname');
 mstr1:= reader.readmsestring('value','');
 wcompanyname.caption:= mstr1;
 fmacro.add(['COMPANYNAME'],[mstr1]);
 reader.findsection('mainfo.copyright');
 mstr1:= reader.readmsestring('value','');
 if mstr1='' then begin
  strar1:= nil;
  strar1:= reader.readarray('valuear',strar1);
  mstr1:= concatstrings(strar1,lineend);
 end;
 wcopyright.caption:= mstr1;
 fmacro.add(['COPYRIGHT'],[mstr1]);
 reader.findsection('mainfo.appwebsite');
 mstr1:= reader.readmsestring('value','');
 www.caption:= mstr1;
 fmacro.add(['WEBSITE'],[mstr1]);
 reader.findsection('mainfo.apptagline');
 mstr1:= reader.readmsestring('value','');
 wtagline.caption:= mstr1;
 fmacro.add(['APPTAGLINE'],[mstr1]);
 //file list
 reader.findsection('mainfo.wfilelist');
 strar1:= nil;
 strar2:= nil;
 strar3:= nil;
 strar4:= nil;
 strar5:= nil;
 strar6:= nil;
 strar7:= nil;
 strar8:= nil;
 strar9:= nil;
 strar10:= nil;
 strar11:= nil;
 strar1:= reader.readarray('values1',strar1);
 strar2:= reader.readarray('values2',strar2);
 strar3:= reader.readarray('values3',strar3);
 strar7:= reader.readarray('values5',strar7); //desktop
 strar8:= reader.readarray('values6',strar8); //program group
 strar9:= reader.readarray('values7',strar9); //program name
 strar10:= reader.readarray('values8',strar10); //program icon
 int2:= length(strar1);
 setlength(strar4,int2);
 setlength(strar5,int2);
 setlength(strar6,int2);
 setlength(strar7,int2);
 setlength(strar8,int2);
 setlength(strar9,int2);
 setlength(strar11,int2);
 for int1:=0 to int2-1 do begin
  strar4[int1]:= strar1[int1];
  mstr1:= concatpath(strar2[int1],strar3[int1]);
  strar6[int1]:= mstr1;
  fmacro.expandmacros(mstr1);
  strar5[int1]:= tosysfilepath(mstr1); 
  mstr1:= strar10[int1];
  fmacro.expandmacros(mstr1);
  strar11[int1]:= mstr1;
 end;
 wfilecopy.gridvalues:= strar4;
 wcopyto.gridvalues:= strar5;
 wtmp.gridvalues:= strar6;
 wdesktop.gridvalues:= strar7;
 wprogramgroup.gridvalues:= strar8;
 wprogramname.gridvalues:= strar9;
 wiconfile.gridvalues:= strar11;
 strar1:= nil;
 strar2:= nil;
 reader.findsection('mainfo.wlanglist');
 strar1:= reader.readarray('values0',strar1);
 strar2:= reader.readarray('values1',strar2);
 for int1:=0 to high(strar2) do begin
  wlang.dropdown.cols.addrow([strar2[int1],strar1[int1]]);
 end;
 wlang.dropdown.itemindex:= 0;
 wlang_ondataentered(nil);
end;

procedure tmainsetupfo.btnclose_onexecute(const sender: TObject);
begin
 self.close;
end;

procedure tmainsetupfo.updatestatus;
begin
 case ttabwidget1.activepageindex of
 0: begin
     btnprev.enabled:= false;
     btnnext.enabled:= true;
    end;
 1: begin
     btnprev.enabled:= true;
     btnnext.enabled:= true;
    end;
 2: begin
     btnprev.enabled:= true;
     btnnext.enabled:= tabfinish.enabled;
    end;
 3: begin
     btnprev.enabled:= true;
     btnnext.enabled:= false;
    end;
 end;
end;

procedure tmainsetupfo.copyallfiles;
var
 int1,int2: integer;
 strar1: msestringarty;
 fdir: filenamety;
begin
 try
  application.cursorshape:= cr_wait;
  strar1:= wfilecopy.gridvalues;
  int2:= wfilelist.rowcount;
  tprogressbar1.value:= 0;
  wfilelist.firstrow(fca_none);
  for int1:=0 to int2 do begin
   try
    fdir:= filedir(wcopyto.value);
    if not finddir(fdir) then begin
     createdirpath(fdir);
    end;
    copyfile(concatpath(tmpdir,wfilecopy.value),wcopyto.value,true);
    if wdesktop.value<>'' then begin
     {$ifdef mswindows}
     createshortcutdesktop(wcopyto.value,wdesktop.value);
     {$endif}
     {$ifdef linux}
     createshortcutdesktop(wcopyto.value,wiconfile.value,wdesktop.value);
     {$endif}
    end;
    if (wprogramgroup.value<>'') and (wprogramname.value<>'') then begin
     {$ifdef mswindows}
     createshortcutprogram(wcopyto.value,wprogramgroup.value,wprogramname.value);
     {$endif}
     {$ifdef linux}
     createshortcutprogram(wcopyto.value,wiconfile.value,wprogramgroup.value,wprogramname.value);
     {$endif}
    end;
   except
    //raise syserror(syelasterror,'Copy error: ');
    showmessage(sys_geterrortext(mselasterror));
    exit;
   end;
   tprogressbar1.value:= int1/int2;
   tprogressbar1.update;
   wfilelist.rowdown(fca_none);
  end;
  tprogressbar1.value:= 1;
  application.cursorshape:= cr_arrow;
  btnnext.enabled:= true;
 except
  application.cursorshape:= cr_arrow;
 end;
end;

procedure tmainsetupfo.wtargetfolder_ondataentered(const sender: TObject);
var
 int1,int2: integer;
 strar1: msestringarty;
 mstr1: msestring;
begin
 fmacro.add([wref.value],[removeendpath(wtargetfolder.value)]);
 strar1:= wtmp.gridvalues;
 int2:= length(strar1);
 for int1:=0 to int2-1 do begin
  mstr1:= strar1[int1];
  fmacro.expandmacros(mstr1);
  wcopyto[int1]:= mstr1; 
 end; 
end;

procedure tmainsetupfo.btnprev_onexecute(const sender: TObject);
var
 int1: integer;
begin
 if ttabwidget1.activepageindex>0 then begin
  int1:= ttabwidget1.activepageindex-1;
  ttabwidget1.items[int1].enabled:= true;
  ttabwidget1.activepageindex:= int1;
 end;
end;

procedure tmainsetupfo.btnnext_onexecute(const sender: TObject);
var
 int1: integer;
begin
 if ttabwidget1.activepageindex<ttabwidget1.count-1 then begin
  int1:= ttabwidget1.activepageindex+1;
  ttabwidget1.items[int1].enabled:= true;
  ttabwidget1.activepageindex:= int1;
 end;
end;

procedure tmainsetupfo.ttabwidget1_onactivepagechanged(const sender: TObject);
begin
 updatestatus;
 if not tabfinish.enabled and (ttabwidget1.activepageindex=2) then begin
  copyallfiles;
 end;
end;

procedure tmainsetupfo.mainsetupfo_onclose(const sender: TObject);
begin
 //delete tmp folder
end;

procedure tmainsetupfo.tstatfile2_onstatread(const sender: TObject;
               const reader: tstatreader);
var
 str1,str2,str3: string;
 mstr1,mstr2: msestring;
 strar1,strar2,strar3,strar4,strar5: msestringarty;
 int1,int2: integer;
begin
 strar1:= nil;
 strar2:= nil;
 reader.findsection('mainfo.appdescription');
 strar1:= reader.readarray('valuear',strar1);
 mstr1:= concatstrings(strar1,lineend);
 appdescription.value:= mstr1;
 fmacro.add(['APPDESCRIPTION'],[mstr1]);
 //forms
 reader.findsection('mainfo.wforms');
 strar1:= reader.readarray('values1',strar1);
 strar2:= reader.readarray('values2',strar2);
 introdescription.value:= strar1[0];
 if strar2[0]<>'' then begin
  str1:= filename(strar2[0]);
  wimgintro.bitmap.source:= nil;
  wimgintro.bitmap.loadfromfile(tmpdir+'formimages/'+str1,fileext(str1));
 end else begin
  wimgintro.bitmap.source:= bmpintro;
 end;
 locationdescription.value:= strar1[1];
 if strar2[1]<>'' then begin
  str1:= filename(strar2[1]);
  wimglocation.bitmap.source:= nil;
  wimglocation.bitmap.loadfromfile(tmpdir+'formimages/'+str1,fileext(str1));
 end else begin
  wimglocation.bitmap.source:= bmplocation;
 end;
 copydescription.value:= strar1[2];
 if strar2[2]<>'' then begin
  str1:= filename(strar2[2]);
  wimgcopy.bitmap.source:= nil;
  wimgcopy.bitmap.loadfromfile(tmpdir+'formimages/'+str1,fileext(str1));
 end else begin
  wimgcopy.bitmap.source:= bmpinstall;
 end;
 finishdescription.value:= strar1[3];
 if strar2[3]<>'' then begin
  str1:= filename(strar2[3]);
  wimgfinish.bitmap.source:= nil;
  wimgfinish.bitmap.loadfromfile(tmpdir+'formimages/'+str1,fileext(str1));
 end else begin
  wimgfinish.bitmap.source:= bmpfinish;
 end;
 //macro location
 strar1:= nil;
 strar2:= nil;
 reader.findsection('mainfo.wlocation');
 strar1:= reader.readarray('values0',strar1);
 strar2:= reader.readarray('values1',strar2);
 setlength(strar3,length(strar2));
 setlength(strar4,length(strar2));
 setlength(strar5,length(strar2));
 for int1:=0 to high(strar2) do begin
  strar3[int1]:= strar2[int1];
  mstr1:= strar1[int1];
  mstr2:= mstr1;
  mstr2:= removechar(mstr2,msechar('$'));
  mstr2:= removechar(mstr2,msechar('{'));
  mstr2:= removechar(mstr2,msechar('}'));
  strar5[int1]:= mstr2;
  fmacro.expandmacros(mstr1);
  strar4[int1]:= mstr1;
 end;
 wtarget.gridvalues:= strar3;
 wtargetfolder.gridvalues:= strar4;
 wref.gridvalues:= strar5;
end;

procedure tmainsetupfo.wlang_ondataentered(const sender: TObject);
begin
 tstatfile2.filename:= concatpath(tmpdir,wlang.value+'.lang');
 tstatfile2.readstat;
end;

end.
