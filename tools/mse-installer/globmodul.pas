unit globmodul;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msegui{$ifdef linux},baseunix{$endif},mseclasses,mseforms,msestrings,mseconsts,msei18nutils,strutils,math,dateutils,msesys,
 sysutils,msefileutils,msereal,msesysintf,msesysenv,msetypes,mseprocutils{,idea},msestream,classes
 {$ifdef mswindows}
 ,windows,shlobj,activex,comobj
 {$endif};
 
var
 installpath: filenamety;
 fmacro: tmacrolist;
 tmpdir: filenamety;
 
function replacemsestring(source: msestring; fromstring,tostring: msestring; options: searchoptionsty=[]): msestring;
procedure changelanguage(alang: string);
procedure removeduplicatestrings(var value: msestringarty);
function concatpath(const path1,path2: filenamety; const adelim: char = '/'): filenamety;
function removeendpath(const path1: filenamety; const adelim: char = '/'): filenamety;
function removebeginpath(const path1: filenamety; const adelim: char = '/'): filenamety;
function getapppath: filenamety;
{$ifdef mswindows}
procedure createshortcutdesktop(const targetname: filenamety; const shortcutname: msestring);
procedure createshortcutprogram(const targetname,programgroup: filenamety; const shortcutname: msestring);
{$endif}
{$ifdef linux}
procedure createshortcutdesktop(const targetname,iconfile: filenamety; shortcutname: msestring);
procedure createshortcutprogram(const targetname,iconfile,programgroup: filenamety; const shortcutname: msestring);
{$endif}
procedure encryptfile(const asourcefile,atargetfile: filenamety);
procedure decryptfile(const asourcefile,atargetfile: filenamety);

implementation


function replacemsestring(source: msestring; fromstring,tostring: msestring; options: searchoptionsty=[]): msestring;
  //replaces a by b
var
 int2: integer;
begin
 int2:= 1;
 result:= source;
 while int2>0 do begin
  int2:= msestringsearch(fromstring,result,int2,options);
  if int2>0 then begin
   result:= leftstr(result,int2-1)+tostring+
     midstr(result,int2+length(fromstring),length(result)-int2+length(fromstring));
   int2:= int2+(length(tostring)-length(fromstring))+1;
   if int2>=length(result) then int2:= -1;
  end;
 end;
end;

procedure changelanguage(alang: string);
var
 str1: string;
begin
 alang:= lowercase(alang);
 str1:= tosysfilepath(installpath+'/lang/');
 if alang='english' then begin
  setlangconsts('en');
  loadlangunit(str1+'azinstall_English');
 end else if alang='indonesia' then begin
  setlangconsts('id');
  loadlangunit(str1+'azinstall_Indonesia');
 end else if alang='malaysia' then begin
  setlangconsts('id');
  loadlangunit(str1+'azinstall_Malaysia');
 end;
 application.invalidate;
end;

procedure removeduplicatestrings(var value: msestringarty);
var
 int1,int2: integer;
begin
 for int1:= 0 to high(value) do begin //remove duplicates
  if value[int1] <> '' then begin
   for int2:= int1 + 1 to high(value) do begin
    if value[int2] = value[int1] then begin
     value[int2]:= '';
    end;
   end;
  end;
 end;
 int2:= 0;
 for int1:= 0 to high(value) do begin
  if value[int1] <> '' then begin
   value[int2]:= value[int1];
   inc(int2);
  end;
 end;
 setlength(value,int2);
end;

function concatpath(const path1,path2: filenamety; const adelim: char = '/'): filenamety;
begin
 result:= removeendpath(path1)+adelim+removebeginpath(path2);
end;

function removeendpath(const path1: filenamety; const adelim: char = '/'): filenamety;
var
 int1: integer;
 apath: filenamety;
begin
 if path1='' then begin
  result:= '';
  exit;
 end;
 apath:= filenamety(path1);
 if apath[length(apath)]=adelim then begin
  result:= '';
  for int1:=1 to length(apath)-1 do begin
   result:= result+apath[int1];
  end;
 end else begin
  result:= apath;
 end;
end;

function removebeginpath(const path1: filenamety; const adelim: char = '/'): filenamety;
var
 int1: integer;
 apath: filenamety;
begin
 if path1='' then begin
  result:= '';
  exit;
 end;
 apath:= filenamety(path1);
 if apath[1]=adelim then begin
  result:= '';
  for int1:=2 to length(apath) do begin
   result:= result+apath[int1];
  end;
 end else begin
  result:= apath;
 end;
end;

function getapppath: filenamety;
begin
 installpath:= extractfilepath(sys_getapplicationpath);
 result:= installpath;
end;

procedure getmacros;
var
 str2: stringarty;
begin
 fmacro:= tmacrolist.create([mao_caseinsensitive]);
 {$ifdef linux}
 fmacro.add(['HOMEDIR'],[removeendpath(sys_getapphomedir)]);
 str2:= splitstring(getenvironmentvariable('MANPATH'),':');
 if str2<>nil then begin
  fmacro.add(['MANPATH'],[removeendpath(str2[0])]);
 end;
 fmacro.add(['TMPDIR'],[removeendpath(sys_gettempdir)]);
 {$endif}
 {$ifdef mswindows}
 fmacro.add(['PROGRAMFILES'],[removeendpath(sysutils.getenvironmentvariable('ProgramFiles'),'\')]);
 fmacro.add(['COMMONPROGRAMFILES'],[removeendpath(sysutils.getenvironmentvariable('CommonProgramFiles'),'\')]);
 fmacro.add(['WINDIR'],[removeendpath(sysutils.getenvironmentvariable('windir'),'\')]);
 fmacro.add(['SYSTEMDIR'],[concatpath(sysutils.getenvironmentvariable('SystemRoot'),'system32','\')]);
 fmacro.add(['HOMEDIR'],[concatpath(sysutils.getenvironmentvariable('HOMEDRIVE'),sysutils.getenvironmentvariable('HOMEPATH'),'\')]);
 fmacro.add(['ALLUSERSPROFILE'],[removeendpath(sysutils.getenvironmentvariable('ALLUSERSPROFILE'),'\')]);
 fmacro.add(['USERPROFILE'],[removeendpath(sysutils.getenvironmentvariable('USERPROFILE'),'\')]);
 fmacro.add(['USERAPPDATA'],[removeendpath(sysutils.getenvironmentvariable('APPDATA'),'\')]);
 fmacro.add(['TMPDIR'],[removeendpath(sysutils.getenvironmentvariable('TEMP'),'\')]);
 {$endif}
end;

{$ifdef mswindows}
//Create a Windows shortcut to desktop
procedure createshortcutdesktop(const targetname: filenamety; const shortcutname: msestring);
var
 iobject : iunknown;
 islink : ishelllink;
 ipfile : ipersistfile;
 linkname: msestring;
 str1: string;
begin
 iobject := createcomobject(CLSID_ShellLink) ;
 islink := iobject as ishelllink;
 ipfile := iobject as ipersistfile;  
 with islink do begin
  str1:= tosysfilepath(targetname);
  setpath(pchar(str1));
  setworkingdirectory(pchar(extractfilepath(str1))) ;
 end;
 linkname:= tosysfilepath(concatpath(sysutils.getenvironmentvariable('ALLUSERSPROFILE'), 'Desktop\'+shortcutname+'.lnk','\'));
 ipfile.save(pwchar(linkname), false) ;    
end;

procedure createshortcutprogram(const targetname,programgroup: filenamety; const shortcutname: msestring);
var
 iobject : iunknown;
 islink : ishelllink;
 ipfile : ipersistfile;
 linkname: msestring;
 fgroup: msestring;
 str1: string;
begin
 iobject := createcomobject(CLSID_ShellLink) ;
 islink := iobject as ishelllink;
 ipfile := iobject as ipersistfile;  
 with islink do begin
  str1:= tosysfilepath(targetname);
  setpath(pchar(str1));
  setworkingdirectory(pchar(extractfilepath(str1))) ;
 end;
 fgroup:= concatpath(sysutils.getenvironmentvariable('ALLUSERSPROFILE'), 'Start Menu\Programs\'+programgroup,'\');
 if not finddir(fgroup) then begin
  createdirpath(fgroup);
 end;
 linkname:= tosysfilepath(concatpath(fgroup,shortcutname+'.lnk','\'));
 ipfile.save(pwchar(linkname), false) ;    
end;
{$endif}
{$ifdef linux}
procedure createshortcutdesktop(const targetname,iconfile: filenamety; shortcutname: msestring);
var
 //str1: string;
 mstr1: msestring;
 fstream: ttextstream;
begin
 //str1:= sysutils.getenvironmentvariable('DESKTOP_SESSION');
 //if str1='kde4' then begin
  mstr1:= concatpath(sysutils.getenvironmentvariable('HOME'),'Desktop/'+shortcutname+'.desktop');
  fstream:= ttextstream.create(mstr1,fm_create);
  fstream.writeln('[Desktop Entry]');
  fstream.writeln('Comment[en_US]=');
  fstream.writeln('Comment=');
  fstream.writeln('Exec='+targetname);
  fstream.writeln('GenericName[en_US]=');
  fstream.writeln('GenericName=');
  fstream.writeln('Icon='+iconfile);
  fstream.writeln('MimeType=');
  fstream.writeln('Name[en_US]='+shortcutname);
  fstream.writeln('Name='+shortcutname);
  fstream.writeln('Path='+filedir(targetname));
  fstream.writeln('StartupNotify=true');
  fstream.writeln('Terminal=false');
  fstream.writeln('TerminalOptions=');
  fstream.writeln('Type=Application');
  fstream.writeln('X-DBUS-ServiceName=');
  fstream.writeln('X-DBUS-StartupType=');
  //fstream.writeln('Categories='+programgroup);
  //fstream.writeln('X-KDE-SubstituteUID=false');
  //fstream.writeln('X-KDE-Username=');
  fstream.close;
  fstream.free;
  FPchmod(tosysfilepath(mstr1),&777);
 //end else if str1='gnome' then begin
 //end;
end;

procedure createshortcutprogram(const targetname,iconfile,programgroup: filenamety; const shortcutname: msestring);
var
 //str1: string;
 mstr1,mstr2,mstr3: msestring;
 fstream: ttextstream;
begin
 //str1:= sysutils.getenvironmentvariable('DESKTOP_SESSION');
 //if str1='kde4' then begin
  mstr3:= removechar(shortcutname,msechar(' '));
  mstr1:= concatpath(tmpdir,mstr3+'.desktop');
  mstr2:= '/usr/share/applications/'+mstr3+'.desktop';
  fstream:= ttextstream.create(mstr1,fm_create);
  fstream.writeln('[Desktop Entry]');
  fstream.writeln('Comment[en_US]=');
  fstream.writeln('Comment=');
  fstream.writeln('Exec='+targetname);
  fstream.writeln('GenericName[en_US]=');
  fstream.writeln('GenericName=');
  fstream.writeln('Icon='+iconfile);
  fstream.writeln('MimeType=');
  fstream.writeln('Name[en_US]='+shortcutname);
  fstream.writeln('Name='+shortcutname);
  fstream.writeln('Path='+filedir(targetname));
  fstream.writeln('StartupNotify=true');
  fstream.writeln('Terminal=false');
  fstream.writeln('TerminalOptions=');
  fstream.writeln('Type=Application');
  fstream.writeln('X-DBUS-ServiceName=');
  fstream.writeln('X-DBUS-StartupType=');
  fstream.writeln('Categories='+programgroup);
  //fstream.writeln('X-KDE-SubstituteUID=false');
  //fstream.writeln('X-KDE-Username=');
  fstream.close;
  fstream.free;
  execmse('sudo mv -f '+mstr1+' '+mstr2);
  FPchmod(tosysfilepath(mstr2),&777);
 //end;
end;
{$endif}

procedure encryptfile(const asourcefile,atargetfile: filenamety);
var
 {fencrypt: TIDEAEncryptStream;
 inbuffer:array[0..32767] of byte;
 instream,outstream: tmsefilestream;}
 bufcount: integer;
begin
 {instream:= tmsefilestream.create(asourcefile,fm_read);
 outstream:= tmsefilestream.create(atargetfile,fm_create);
 fencrypt:= TIDEAEncryptStream.create('7E7A7EC8-5F18-4CC9-BE6B-1CB6795F6B3A',outstream);
 instream.seek(0,sofrombeginning);
 bufcount:= instream.read(inbuffer,32768);
 repeat
  fencrypt.write(inbuffer,32768);
  bufcount:= instream.read(inbuffer,32768);
 until bufcount=0;
 fencrypt.flush;
 fencrypt.free;
 instream.close;
 instream.free;
 outstream.close;
 outstream.free;}
end;

procedure decryptfile(const asourcefile,atargetfile: filenamety);
var
 {fencrypt: TIDEADecryptStream;
 inbuffer:array[0..32767] of byte;
 instream,outstream: tmsefilestream;}
 bufcount: integer;
begin
 {instream:= tmsefilestream.create(asourcefile,fm_read);
 outstream:= tmsefilestream.create(atargetfile,fm_create);
 fencrypt:= TIDEADecryptStream.create('7E7A7EC8-5F18-4CC9-BE6B-1CB6795F6B3A',outstream);
 instream.seek(0,sofrombeginning);
 bufcount:= instream.read(inbuffer,32768);
 repeat
  fencrypt.write(inbuffer,32768);
  bufcount:= instream.read(inbuffer,32768);
 until bufcount=0;
 fencrypt.free;
 instream.close;
 instream.free;
 outstream.close;
 outstream.free;}
end;

initialization
 getapppath;
 getmacros; 
finalization
 fmacro.destroy;
end.
