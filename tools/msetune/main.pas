{ Copyright (c) 2011 by Alexandre Minoshi
   
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; version 2 of the License.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
}

unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msescrollbar,msetabs,
 msewidgets,sysutils,msebitmap,msedataedits,msedatanodes,mseedit,msefiledialog,
 msegrids,mseifiglob,mselistbrowser,msestrings,msesys,msetypes,msewidgetgrid,
 msesimplewidgets,mseterminal, classes, inifiles, msesysintf, process,
 msedataimage,msegraphedits,mseformatpngread, mseformatjpgread,mseformatxpmread,
 mseformatbmpicoread,mseformatpnmread, mseformattgaread,mseimage,msesplitter,
 bmp2pas, msefileutils,mseeditglob,msetextedit, MSEPROCESS,msetimer;

type
 tmainfo = class(tmainform)
   tw_main: ttabwidget;
   ttabpage1: ttabpage;
   ddd_msedir: tdirdropdownedit;
   fne_ppcpath: tfilenameedit;
   fne_svnclient: tfilenameedit;
   tbutton1: tbutton;
   tbutton2: tbutton;
   ttabpage2: ttabpage;
   be_compile_mse: tbooleanedit;
   tbutton3: tbutton;
   tw_update: twidgetgrid;
   term_update: tterminal;
   l_update_status: tlabel;
   tgroupbox1: tgroupbox;
   be_update_contr: tbooleanedit;
   be_update_mseuniverse: tbooleanedit;
   be_update_help: tbooleanedit;
   be_update_mse: tbooleanedit;
   ttabpage3: ttabpage;
   se_prj_name: tstringedit;
   tbutton4: tbutton;
   tstockglyphbutton2: tstockglyphbutton;
   tstockglyphbutton1: tstockglyphbutton;
   tw_: twidgetgrid;
   fne: tfilenameedit;
   se_tab: tstringedit;
   se_type: tstringedit;
   se_icon: tstringedit;
   di: tdataicon;
   tdatabutton1: tdatabutton;
   tw_build: twidgetgrid;
   se1: tstringedit;
   se2: tstringedit;
   tw_install: twidgetgrid;
   term: tterminal;
   fd: tfiledialog;
   imlist: timagelist;
   ttabpage4: ttabpage;
   ttabwidget2: ttabwidget;
   ttabpage5: ttabpage;
   m_prj: tmemoedit;
   ttabpage6: ttabpage;
   m_inc: tmemoedit;
   ttabpage7: ttabpage;
   m_regpas: tmemoedit;
   ttabpage8: ttabpage;
   m_regpas_orig: tmemoedit;
   tlabel1: tlabel;
   tlabel2: tlabel;
   tlabel3: tlabel;
   tlabel4: tlabel;
   tlabel5: tlabel;
   tgroupbox2: tgroupbox;
   be_ctrl_space: tbooleanedit;
   be_insert: tbooleanedit;
   be_pascalscript: tbooleanedit;
   im: timage;
   ttimer1: ttimer;
   fne_msetune: tfilenameedit;
   rb: trichbutton;
   timagelist1: timagelist;
   timer: ttimer;
   procedure on_loaded(const sender: TObject);
   procedure on_savesettings(const sender: TObject);
   procedure on_close(const sender: TObject);
   procedure on_update_mse(const sender: TObject);
   procedure on_finish_update_mse(const sender: TObject);   
   procedure on_add_row(const sender: TObject);
   procedure on_delete_row(const sender: TObject);
   procedure on_compile(const sender: TObject);
   procedure on_loadicon(const sender: TObject);
   procedure on_finishcompile(const sender: TObject);
   procedure insert_tune_in_mse(idedir : string);
   procedure on_timer(const sender: TObject);
   procedure on_timer2(const sender: TObject);
 end;
 
type tstatus = (_download,_compile);
var   mainfo : tmainfo;
     homedir : string;
         __s : char;
         dir : string;
      kernel : string;
      status : tstatus;
         _im : integer = 0;
implementation
uses  main_mfm;

procedure tmainfo.insert_tune_in_mse(idedir : string);
var s, n : string;  
    i, y : integer; 
    f : textfile; 
    msetunepath, msetunepathnew : string;
begin
 if idedir[length(idedir)] <> __s then idedir := idedir + __s;
 {$ifdef windows}for i := 0 to length(idedir) do if idedir[i] = '/' then idedir[i] := __s;{$endif}
 if not fileexists(idedir + 'main.pas') then exit;
 if be_insert.value then
  begin
     assignfile(f,idedir + 'main.pas');
     reset(f);
     s := '';
     while not eof(f) do 
      begin
        readln(f,n);
        s := s + n + #10;
      end;  
     closefile(f);

    if system.pos(#10 + ' process,' + #10 ,s) = 0 then //decide checking value
    begin    
     insert( #10 + ' process,' + #10, s, system.pos('uses',s) + 4); 

     i := system.pos('public',s);
     y := system.pos('end;',s);
     repeat
      inc(i);
     until i > y;
     
     insert( #10 + ' procedure execute0(const sender : tobject);' + #10, s, i - 1); 

     i := system.pos('pascform'']);',s);
     repeat
      inc(i);
     until s[i] = '}';
     
     insert( #10 + ' mainmenu1.menu.submenu.count := 8;// mainmenu1.menu.submenu.count + 1;' + #10 +
                   ' mainmenu1.menu.items[7].caption := ''Outside tools'';' + #10 +
                   ' mainmenu1.menu.items[7].submenu.count := 1;' + #10 +
                   ' mainmenu1.menu.items[7].items[0].caption := ''MSEtune ...'';' + #10 +
                   ' mainmenu1.menu.items[7].items[0].onexecute := @execute0;' + #10 +
                   'end;' + #10 +
                   '' + #10 +
                   'procedure tmainfo.execute0(const sender : tobject);' + #10 +
                   'var p : tprocess;' + #10 +
                   'begin' + #10 +
                   ' p := tprocess.create(nil);' + #10 +
                   ' p.commandline := ''' + fne_msetune.value + ''';' + #10 +
                   ' p.execute;' + #10 +
                   ' p.free;'
                   + #10, 
                   s, i + 1); 

     rewrite(f);
     writeln(f,s);
     closefile(f);
    end;  
    //check msetune path
    if system.pos('p.commandline := ',s) <> 0 then
    begin
    
     i := system.pos('p.commandline := ',s) + length('p.commandline := ') + 1;
     y := i;
     repeat
      inc(y);
     until s[y] = '''';
    
    msetunepath := trim(copy(s,i, y - i) );
    msetunepathnew := trim(fne_msetune.value);
    {$ifdef windows} IF msetunepathnew > '' THEN IF msetunepathnew[1] = '/' THEN DELETE(msetunepathnew,1,1);{$endif}
    if msetunepath <> msetunepathnew then
      begin
        delete(s,i, y - i);
        insert(msetunepathnew, s, i);
        rewrite(f);
        writeln(f,s);
        closefile(f);        
      end;
    end;
   end //if be_insert.value then ...
  else
  begin //witch off
     assignfile(f,idedir + 'main.pas');
     reset(f);
     s := '';
     while not eof(f) do 
      begin
        readln(f,n);
        s := s + n + #10;
      end;  
     closefile(f);

    if system.pos(#10 + ' process,' + #10 ,s) > 0 then //decide checking value
      delete(s, system.pos(#10 + ' process,' + #10 ,s), length(#10 + ' process,' + #10)); 

    if system.pos(#10 + ' procedure execute0(const sender : tobject);' + #10, s ) > 0 then     
      delete(s, system.pos(#10 + ' procedure execute0(const sender : tobject);' + #10, s ), 
             length(#10 + ' procedure execute0(const sender : tobject);' + #10)); 

    if system.pos(#10 + ' mainmenu1.menu.submenu.count := 8;// mainmenu1.menu.submenu.count + 1;' + #10 +
                   ' mainmenu1.menu.items[7].caption := ''Outside tools'';' + #10 +
                   ' mainmenu1.menu.items[7].submenu.count := 1;' + #10 +
                   ' mainmenu1.menu.items[7].items[0].caption := ''MSEtune ...'';' + #10 +
                   ' mainmenu1.menu.items[7].items[0].onexecute := @execute0;' + #10 +
                   'end;' + #10 +
                   '' + #10 +
                   'procedure tmainfo.execute0(const sender : tobject);' + #10 +
                   'var p : tprocess;' + #10 +
                   'begin' + #10 +
                   ' p := tprocess.create(nil);' + #10, s ) > 0 then     
      delete(s, system.pos(#10 + ' mainmenu1.menu.submenu.count := 8;// mainmenu1.menu.submenu.count + 1;' + #10 +
                   ' mainmenu1.menu.items[7].caption := ''Outside tools'';' + #10 +
                   ' mainmenu1.menu.items[7].submenu.count := 1;' + #10 +
                   ' mainmenu1.menu.items[7].items[0].caption := ''MSEtune ...'';' + #10 +
                   ' mainmenu1.menu.items[7].items[0].onexecute := @execute0;' + #10 +
                   'end;' + #10 +
                   '' + #10 +
                   'procedure tmainfo.execute0(const sender : tobject);' + #10 +
                   'var p : tprocess;' + #10 +
                   'begin' + #10 +
                   ' p := tprocess.create(nil);' + #10, s), 
            length(#10 + ' mainmenu1.menu.submenu.count := 8;// mainmenu1.menu.submenu.count + 1;' + #10 +
                   ' mainmenu1.menu.items[7].caption := ''Outside tools'';' + #10 +
                   ' mainmenu1.menu.items[7].submenu.count := 1;' + #10 +
                   ' mainmenu1.menu.items[7].items[0].caption := ''MSEtune ...'';' + #10 +
                   ' mainmenu1.menu.items[7].items[0].onexecute := @execute0;' + #10 +
                   'end;' + #10 +
                   '' + #10 +
                   'procedure tmainfo.execute0(const sender : tobject);' + #10 +
                   'var p : tprocess;' + #10 +
                   'begin' + #10 +
                   ' p := tprocess.create(nil);' + #10)); 

     i := system.pos('p.commandline',s);
     y := system.pos('p.free;',s);
     delete(s,i,y + 7 - i);

     rewrite(f);
     writeln(f,s);
     closefile(f);
   end; //if be_insert.value then ... switch off
end;

procedure tmainfo.on_loaded(const sender: TObject);
var fi : tinifile;
     s : string;
    sl : tstringlist; 
     I : INTEGER;
begin
  //msetune pre settings
  se1[0] := 'Prepare directory for your MSEide version';
  se1[1] := 'Coping units';
  se1[2] := 'Prepare icons';
  se1[3] := 'Prepare templates';
  se1[4] := 'Compilng';  
  l_update_status.caption := '';
  tw_main.activepageindex := 0;
 {$ifdef windows} kernel := 'i386-win32'; {$endif}
 {$ifdef linux}   kernel := 'i386-linux'; {$endif}  
  __s := {$ifdef windows}'\'{$endif}{$ifdef linux}'/'{$endif};
 {$ifdef mswindows}
 term_update.optionsprocess := term_update.optionsprocess + [pro_inactive]; // pro_inactive hide cmd.exe window in mswindows
 {$endif}
  
  //mseide params
  {$ifdef windows}
  s := sys_getapphomedir + '/.mseide/mseidewi.sta';
  delete(s,1,1);
  {$endif}
  {$ifdef linux}
  s := sys_getuserhomedir + '/.mseide/mseideli.sta';
  {$endif}
  if not fileexists(s) 
  then showmessage('Can`t find MSEide configuration file' + #10 + s)
  else begin
        fi := tinifile.create(s);
        ddd_msedir.value := fi.readstring('mainfo.mainstatfile', 'msedir', '');
        fne_ppcpath.value := fi.readstring('mainfo.mainstatfile', 'compiler', '');
        fi.free;
      end;  

  //main params
  homedir := sys_getuserhomedir;
  {$ifdef windows} IF homedir > '' THEN IF homedir[1] = '/' THEN DELETE(homedir,1,1);{$endif}
  forcedirectories(homedir + '/.Almin-Soft/msetune');
  fi := tinifile.create(homedir + '/.Almin-Soft/msetune/main_settings.conf');
  fne_svnclient.value := fi.readstring('utils', 'svnclient', '');
  fne_msetune.value := fi.readstring('utils', 'msetune', '');

  be_insert.value := fi.readbool('tune', 'insert', false);
  be_ctrl_space.value := fi.readbool('tune', 'ctrl_space', false);
  be_pascalscript.value := fi.readbool('tune', 'pascalscript', false);
  fi.free;
  
  //component params
  forcedirectories(homedir + '/.Almin-Soft/msetune');
  s := homedir + '/.Almin-Soft/msetune/msetune_components.conf';
  fi := tinifile.create(s);
  sl := tstringlist.create;

  fi. ReadSections(sl);
  if sl.count > 0 then
  for i := 0 to sl.count - 1 do
    begin
      tw_.rowcount := tw_.rowcount + 1;
      fne[tw_.rowcount - 1] := fi.readstring(sl[i],'unit','');
      se_tab[tw_.rowcount - 1] := fi.readstring(sl[i],'tab','');
      se_type[tw_.rowcount - 1] := fi.readstring(sl[i],'type','');
      se_icon[tw_.rowcount - 1] := fi.readstring(sl[i],'icon','');
      if se_icon[tw_.rowcount - 1] > '' then   //->need think about this block
      try
        im.bitmap.loadfromfile(se_icon[tw_.rowcount - 1]);
        imlist.addimage(im.bitmap);
        di[tw_.rowcount - 1] := imlist.count - 1;
      except
        se_icon[tw_.rowcount - 1] := '';
      end;                                     //<- 
    end;
  sl.free;   
  fi.free;
  
end;

procedure tmainfo.on_savesettings(const sender: TObject);
var fi : tinifile;
     S : STRING;
     I : INTEGER;
begin
  //main params
  forcedirectories(homedir + '/.Almin-Soft/msetune');
  fi := tinifile.create(homedir + '/.Almin-Soft/msetune/main_settings.conf');
  fi.writestring('utils', 'svnclient', fne_svnclient.value);
  fi.writestring('utils', 'msetune', fne_msetune.value);
  fi.writebool('tune', 'insert', be_insert.value);
  fi.writebool('tune', 'ctrl_space', be_ctrl_space.value);
  fi.writebool('tune', 'pascalscript', be_pascalscript.value);
  fi.free; 
  
  //COMPONENTS
  s := homedir + '/.Almin-Soft/msetune/msetune_components.conf';
  if fileexists(s) then 
     if not deletefile(s) then
        begin
          showmessage('Can`t update conf file !' + #10 + s + #10 + 'Check rights!');
          exit;
        end;
  fi := tinifile.create(s);
  for i := 0 to tw_.rowhigh do
    begin
      fi.writestring(se_type[i],'unit',fne[i]);
      fi.writestring(se_type[i],'tab',se_tab[i]);
      fi.writestring(se_type[i],'type',se_type[i]);
      fi.writestring(se_type[i],'icon',se_icon[i]);
    end;
  fi.free;  
end;

procedure tmainfo.on_close(const sender: TObject);
begin
  close;
end;

procedure tmainfo.on_update_mse(const sender: TObject);
var cmd : string;
  
begin
 status := _download;

 // STEP 1 UPDATE
 tw_update.clear;
 dir := ddd_msedir.value;
 {$ifdef windows} IF dir > '' THEN IF dir[1] = '/' THEN DELETE(dir,1,1);{$endif}


 IF forcedirectories(dir) 
 then setcurrentdir(dir)
 else begin
        term_update.addline('ERROR create directory ' + dir);
        exit;
      end;
 
 cmd := '';
 if be_update_mse.value 
    then cmd := fne_svnclient.value  + ' https://mseide-msegui.svn.sourceforge.net/svnroot/mseide-msegui/trunk ' + dir;

 if be_update_help.value 
    then begin
          if cmd = '' 
            then cmd := cmd + fne_svnclient.value  + ' https://msedocumenting.svn.sourceforge.net/svnroot/msedocumenting/mse/trunk/help ' + dir + __s + 'help' + __s + 'trunk'
            else cmd := cmd + ' ; ' + fne_svnclient.value  + ' https://msedocumenting.svn.sourceforge.net/svnroot/msedocumenting/mse/trunk/help ' + dir + __s + 'help' + __s + 'trunk';
         end;            

 if be_update_contr.value 
    then begin
          if cmd = ''
            then cmd := fne_svnclient.value  + ' https://msedocumenting.svn.sourceforge.net/svnroot/msedocumenting/mse/trunk/contributed ' + dir + __s + 'contributed' + __s + 'trunk'
            else cmd := cmd + ' ; ' + fne_svnclient.value  + ' https://msedocumenting.svn.sourceforge.net/svnroot/msedocumenting/mse/trunk/contributed ' + dir + __s + 'contributed' + __s + 'trunk';
         end;

 if be_update_mseuniverse.value 
    then begin
          if cmd = ''
            then cmd := fne_svnclient.value  + ' http://svn.berlios.de/svnroot/repos/mseuniverse/trunk ' + dir + __s + 'mseuniverse' + __s + 'trunk'
            else cmd := cmd + ' ; ' + fne_svnclient.value  + ' http://svn.berlios.de/svnroot/repos/mseuniverse/trunk ' + dir + __s + 'mseuniverse' + __s + 'trunk';
         end;

 if (cmd = '') and (not be_insert.value) and (not be_ctrl_space.value) and (not be_compile_mse.value)
    then begin 
           term_update.addline('MSEtune : Choose, what you want update, man!');
           exit;
         end;
          
 term_update.addline('MSEtune : Starting download MSEide (and components)...');
 l_update_status.caption := 'Be patient, I still update ... ';
 rb.visible := true;
 term_update.execprog(cmd);
 setcurrentdir(dir);
end;

procedure tmainfo.on_finish_update_mse(const sender: TObject);
var cmd : string;
begin
  term_update.addline('MSEtune : Finish update MSEide');
  l_update_status.caption := 'Finished';
  if status = _download then ttimer1.enabled := true;  
  rb.visible := false;
end;

procedure tmainfo.on_timer(const sender: TObject);
var cmd : string;
begin
  ttimer1.enabled := false; 
  status := _compile;
 //STEP 2 - COMPILE
 cmd := '';
 if be_compile_mse.value 
    then cmd := fne_ppcpath.value + ' -B -Fulib/common/* -Fulib/common/kernel/' + kernel + ' -Filib/common/kernel apps/ide/mseide.pas';
 if cmd = '' then exit;
 insert_tune_in_mse(dir + 'apps/ide/');
 if be_ctrl_space.value then cmd := cmd + ' -dmse_with_showsourceitems';
 if be_pascalscript.value then cmd := cmd + ' -dmse_with_pascalscript';

 term_update.addline('MSEtune : Starting compile MSEide (and components)...');
 l_update_status.caption := 'Be patient, man, I still compile ... ';
 rb.visible := true;
 term_update.execprog(cmd);  
end;

procedure tmainfo.on_add_row(const sender: TObject);
begin
 tw_.rowcount := tw_.rowcount + 1;
end;

procedure tmainfo.on_delete_row(const sender: TObject);
begin
 if tw_.row >= 0 then tw_.deleterow(tw_.row);
end;

procedure tmainfo.on_compile(const sender: TObject);
var s, cmd, 
    prjdir, msedir,
    n : string;
    i, y : integer;
    fs:tsearchrec;
    f : textfile;
begin
 tw_install.clear;
 m_regpas.value := m_regpas_orig.value;
 for i := 0 to 3 do se2[i] := '';

 msedir := ddd_msedir.value;
 {$ifdef windows}if system.pos('/',msedir) = 1 then delete(msedir,1,1);{$endif}
 {$ifdef windows}for i := 0 to length(msedir) do if msedir[i] = '/' then msedir[i] := __s;{$endif}
 if msedir[length(msedir)] <> __s then msedir := msedir + __s;

 prjdir := msedir + 'apps'+ __s + se_prj_name.value;
 if prjdir[length(prjdir)] <> __s then prjdir := prjdir + __s;

 {$ifdef windows}for i := 0 to length(prjdir) do if prjdir[i] = '/' then prjdir[i] := __s;{$endif}

 //STEP 0 - CREATE DIRECTORY FOR NEW MSEIDE BINARY
 se2[0] := 'Wait ...';
 IF forcedirectories(prjdir) 
 then begin 
        findfirst(prjdir + '*.*', faanyfile, fs);
        repeat
          deletefile(prjdir + fs.name);
        until findnext(fs) <> 0;
        findclose(fs);
        se2[0] := 'Ok';
      end
 else begin
        se2[0] := 'ERROR create directory ' + prjdir;
        exit;
      end;

 //STEP 1 - COPY UNIT
 se2[1] := 'Wait ...';
 if tw_.rowcount > 0 
 then
 begin
 for i := 0 to tw_.rowhigh do
   begin
     s := msedir + 'lib' + __s + 'common' + __s + se_tab[i];
     IF forcedirectories(s)
        then se2[1] := 'Ok'
        else begin
               se2[1] := 'ERROR create directory ' + s;
               exit;
             end;
             
     s := msedir + 'lib' + __s + 'common'+ __s + se_tab[i] + __s + extractfilename(fne[i]);
     if copyfile(fne[i], s) 
        then se2[1] := 'Ok'
        else begin
               se2[1] := 'ERROR create file ' + s;
               exit;
             end;       
   end;
 end
 else se2[1] := 'No new components';

 //STEP 2 - PREPARE ICONS
 se2[2] := 'Wait ...';
 if tw_.rowcount >= 0 
 then
 begin 
  for i := tw_.rowhigh downto 0 do
   IF SE_ICON[i] > '' THEN 
   BEGIN
     s := msedir + 'lib' + __s + 'common' + __s + se_tab[i] + __s + extractfilename(SE_ICON[i]);
     if copyfile(SE_ICON[i], s) 
        then se2[2] := 'Ok'
        else begin
               se2[2] := 'ERROR create file ' + s;
               exit;
             end;  
     n := msedir + 'lib' + __s + 'common' + __s + se_tab[i];

     renamefile(s, n + __s + se_type[i] + extractfileext(SE_ICON[i]) );             

     PREPAREICON(n + __s + se_type[i] + '_icon.pas', n + __s + se_type[i] + extractfileext(SE_ICON[i]));
  
     assignfile(f, n + __s + extractfilename(fne[i]));
     reset(f);
     s := '';
     while not eof(f) do 
      begin
        readln(f,n);
        s := s + n + #10;
      end;  
     closefile(f);
     y := system.pos('uses',s); 
     n := #10 + ' ' + se_type[i] + '_icon' + ',';
     if system.pos(n,s) = 0 then
     begin
     insert(n, s, y + 4);
     
     rewrite(f);
     writeln(f,s);
     closefile(f);
     end;
     //SE_ICON[i] := msedir + 'lib'+ __s +'common' + __s + se_tab[i] + __s + se_type[i] + extractfileext(SE_ICON[i]); 
   END;
  se2[2] := 'Ok';
 end  
 else se2[2] := 'No icons';

 //STEP 3 - PREPARE TEMPLATES
 se2[3] := 'Wait ...';
 if tw_.rowcount >= 0 
 then
 begin
  for i := tw_.rowhigh downto 0 do
   begin
    n := removefileext(extractfilename(fne[i])); 
    
    s := m_regpas.value;
    y := system.pos('uses',s); 
    n := #10 + ' ' + n + ',';

    insert(n, s, y + 4);
    m_regpas.value := s;
  
    y := system.pos('procedure register;' + #10 + 'begin',s); 
    n := #10 + ' registercomponents('''+ se_tab[i] +''',['+ se_type[i] + ']);';
    insert(n, s, y + length('procedure register;' + #10 + 'begin'));
    m_regpas.value := s;
   end; 
   
     if copyfile(msedir + 'apps/ide/mseide.pas', prjdir + '/mseide.pas') 
        then se2[1] := 'Ok'
        else begin
               se2[1] := 'ERROR coping file mseide.pas';
               exit;
             end;        
 //insrt in mseide
 insert_tune_in_mse(msedir + 'apps/ide/');                
 
 assignfile(f, prjdir + 'mymseide.prj');
 rewrite(f);
 writeln(f,m_prj.value);
 closefile(f);

 assignfile(f, prjdir + 'regcomponents.inc');
 rewrite(f);
 writeln(f,m_inc.value);
 closefile(f);

 assignfile(f, prjdir + 'regmycomps.pas');
 rewrite(f);
 writeln(f,m_regpas.value);
 closefile(f);  

 {$ifdef windows}
 if fileexists(msedir + 'apps\ide\mseide.pas') then
   begin
    assignfile(f, msedir + 'apps\ide\mseide.pas');
    reset( f );
    n := '';
    while not eof( f ) do begin
     readln( f, s );
     n := n + s + #10;
    end;
    
    closefile(f);
    if system.pos('{$R mseide.res}', n) > 0 
         then delete(n,system.pos('{$R mseide.res}',n),length('{$R mseide.res}'));
    rewrite(f);
    writeln(f,n);
    closefile(f); 
    end;   
 {$endif} 

    
 
 IF (fileexists(prjdir + 'mymseide.prj'))
    and(fileexists(prjdir + 'regcomponents.inc'))
    and(fileexists(prjdir + 'regmycomps.pas'))
 then se2[3] := 'Ok'
 else begin
        se2[3] := 'ERROR create templates';
        exit;
      end;
 end
 else se2[3] := 'No components to inserting';

 //STEP 4 - compile
 se2[4] := 'Wait ...';
 
// === original lines ===
// for linux
// ppc386 -omymseide -Fu/usr/src/mse2.6/msegui/lib/addon/*/ -Fi/usr/src/mse2.6/msegui/lib/addon/*/ -Fu/usr/src/mse2.6/msegui/lib/common/kernel/i386-linux/ -Fu/usr/src/mse2.6/msegui/lib/common/kernel/ -Fi/usr/src/mse2.6/msegui/lib/common/kernel/ -Fu/usr/src/mse2.6/msegui/lib/common/*/ -Fu../ide/ -Fi../ide/ -l -Mobjfpc -Sh -Fcutf8 -FE../myide -FU. -dmorecomponents -gl -O- ../ide/mseide.pas 
//
// for windows
// C:\lazarus2\fpc\2.4.2\bin\i386-win32\ppc386.exe -omymseide.exe -FuD:\BIN\mse2.6\msegui\lib\addon\*\ -FiD:\BIN\mse2.6\msegui\lib\addon\*\ -FuD:\BIN\mse2.6\msegui\lib\common\kernel\i386-win32\ -FuD:\BIN\mse2.6\msegui\lib\common\kernel\ -FiD:\BIN\mse2.6\msegui\lib\common\kernel\ -FuD:\BIN\mse2.6\msegui\lib\common\*\ -Fu..\ide\ -Fi..\ide\ -l -Mobjfpc -Sh -Fcutf8 -FE../myide -FU. -dmorecomponents -gl -O- ..\ide\mseide.pas
// =====================
 {$ifdef windows}
 chdir(prjdir);
 cmd := fne_ppcpath.value + ' -o' +
      prjdir + se_prj_name.value + '.exe' + 
      ' -Fu' + msedir + 'lib\addon\*\' +
      ' -Fi' + msedir + 'lib\addon\*\' +
      ' -Fu' + msedir + 'lib\common\kernel\i386-win32\' +
      ' -Fu' + msedir + 'lib\common\kernel\' +
      ' -Fi' + msedir + 'lib\common\kernel\' +
      ' -Fu' + msedir + 'lib\common\*\' +
      ' -Fu' + msedir + 'apps\ide\' +
      ' -Fi' + msedir + 'apps\ide\' +
      ' -l -Mobjfpc -Sh -Fcutf8' +
      ' -FE' + prjdir +
      ' -FU. -dmorecomponents -gl -O-' +
//      ' ' + msedir + 'apps\ide\mseide.pas';
      ' ' + prjdir + 'mseide.pas';

 {$endif}
 {$ifdef linux}
 chdir(prjdir);
 cmd := fne_ppcpath.value + ' -o' + 
      prjdir + se_prj_name.value +
      ' -Fu' + msedir + 'lib/addon/*/' +
      ' -Fi' + msedir + 'lib/addon/*/' +
      ' -Fu' + msedir + 'lib/common/kernel/i386-linux/' + 
      ' -Fu' + msedir + 'lib/common/kernel/' +
      ' -Fi' + msedir + 'lib/common/kernel/' +
      ' -Fu' + msedir + 'lib/common/*/' + 
      ' -Fu' + msedir + 'apps/ide/' +
      ' -Fi' + msedir + 'apps/ide/' +
      ' -l -Mobjfpc -Sh -Fcutf8' +
      ' -FE' + prjdir +
      ' -FU. -dmorecomponents -gl -O-' +
//      ' ' + msedir + 'apps/ide/mseide.pas';
      ' ' +prjdir + 'mseide.pas';
 {$endif}  

 //switch on ctrl+space
 if be_ctrl_space.value then cmd := cmd + ' -dmse_with_showsourceitems';
 //switch on pascal script support
 if be_pascalscript.value then cmd := cmd + ' -dmse_with_pascalscript';
 
  term.addline('MSEtune : Starting compile ...');
  rb.visible := true;
  term.execprog(cmd);    
end;  

procedure tmainfo.on_loadicon(const sender: TObject);
begin
 if fd.execute = mr_ok then
    begin
      se_icon.value := fd.controller.filename;
      im.bitmap.loadfromfile(fd.controller.filename);
      imlist.addimage(im.bitmap);
      di[tw_.row] := imlist.count - 1;
    end;
end;

procedure tmainfo.on_finishcompile(const sender: TObject);
begin
 if se2[4] = 'Wait ...'
  then begin 
        se2[4] := 'Ok';
        term.addline('MSEtune : END process');
        rb.visible := false;
       end;   
end;

procedure tmainfo.on_timer2(const sender: TObject);
begin
 rb.imagenr := _im;
 if _im = timagelist1.count - 1 then _im := 0 else inc(_im); 
end;


end.
