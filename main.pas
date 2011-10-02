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
 bmp2pas, msefileutils,mseeditglob,msetextedit;

type
 tmainfo = class(tmainform)
   imlist: timagelist;
   fd: tfiledialog;
   tw: ttabwidget;
   ttabpage11: ttabpage;
   ttabpage12: ttabpage;
   tw_inslall: ttabwidget;
   ttabpage10: ttabpage;
   tlabel8: tlabel;
   b01: tbutton;
   ttabpage8: ttabpage;
   ddd_msedir: tdirdropdownedit;
   fne_ppcpath: tfilenameedit;
   tlabel1: tlabel;
   b_2: tbutton;
   ttabpage1: ttabpage;
   tw_: twidgetgrid;
   fne: tfilenameedit;
   se_tab: tstringedit;
   se_type: tstringedit;
   se_icon: tstringedit;
   di: tdataicon;
   tdatabutton1: tdatabutton;
   tstockglyphbutton1: tstockglyphbutton;
   tstockglyphbutton2: tstockglyphbutton;
   tbutton1: tbutton;
   se_prj_name: tstringedit;
   b_1: tbutton;
   tlabel2: tlabel;
   im: timage;
   tlabel6: tlabel;
   ttabpage6: ttabpage;
   tw_build: twidgetgrid;
   se1: tstringedit;
   se2: tstringedit;
   twidgetgrid1: twidgetgrid;
   term: tterminal;
   button4: tbutton;
   bb2: tbutton;
   tlabel3: tlabel;
   ttabpage9: ttabpage;
   tlabel4: tlabel;
   tbutton2: tbutton;
   bs2: tbutton;
   l_inf: tlabel;
   ttabpage2: ttabpage;
   ttabwidget2: ttabwidget;
   ttabpage3: ttabpage;
   m_prj: tmemoedit;
   ttabpage4: ttabpage;
   m_inc: tmemoedit;
   ttabpage5: ttabpage;
   m_regpas: tmemoedit;
   ttabpage7: ttabpage;
   m_regpas_orig: tmemoedit;
   tbutton4: tbutton;
   tlabel5: tlabel;
   twidgetgrid2: twidgetgrid;
   term_update: tterminal;
   tbutton3: tbutton;
   ttabpage13: ttabpage;
   tbutton5: tbutton;
   be_insert: tbooleanedit;
   fne_updateutility: tfilenameedit;
   ddd_trunkdir: tdirdropdownedit;
   fne_ppcpath2: tfilenameedit;
   be_update_help: tbooleanedit;
   be_update_contr: tbooleanedit;
   be_update_mse: tbooleanedit;
   be_compile_mse: tbooleanedit;
   l_update_status: tlabel;
   ddd_trunkdir3: tdirdropdownedit;
   tlabel7: tlabel;
   fne_ppcpath3: tfilenameedit;
   be_ctrl_space: tbooleanedit;
   be_compile_mse3: tbooleanedit;
   twidgetgrid3: twidgetgrid;
   term_rebuild: tterminal;
   fne_msetune: tfilenameedit;
   procedure on_add_row(const sender: TObject);
   procedure on_delete_row(const sender: TObject);
   procedure on_compile(const sender: TObject);
   procedure on_loaded(const sender: TObject);
   procedure on_receive_text(const sender: TObject; var atext: AnsiString; const errorinput: Boolean);
   procedure on_finish(const sender: TObject);
   procedure on_step(const sender: TObject);
   procedure on_close(const sender: TObject);
   procedure on_run_new_mse(const sender: TObject);
   procedure on_closepr(const sender: TObject);
   procedure on_loadicon(const sender: TObject);
   procedure insert_msetune(const sender: TObject);
   procedure on_update_mse(const sender: TObject);
   procedure on_finish_update_mse(const sender: TObject);
   procedure on_finishbuild(const sender: TObject);
 end;
 
var
 mainfo : tmainfo;
    __s : string;
 
implementation

uses main_mfm;

//========================================================
//                    PROGRAM
//========================================================
procedure tmainfo.on_loaded(const sender: TObject);
var fi : tinifile;
     s : string;
     i : integer;
    sl : tstringlist;
begin
  //msetune pre settings
  se1[0] := 'Prepare directory for your MSEide version';
  se1[1] := 'Coping units';
  se1[2] := 'Prepare icons';
  se1[3] := 'Prepare templates';
  se1[4] := 'Compilng';
  l_update_status.caption := '';
  tw.activepageindex := 0;
  tw_inslall.activepageindex := 0;
  tw_inslall.top := tw_inslall.top - tw_inslall.tab_size;
  __s := {$ifdef windows}'\'{$endif}{$ifdef linux}'/'{$endif};

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
  
  //component params
  S := sys_getuserhomedir;
  {$ifdef windows} IF S > '' THEN IF S[1] = '/' THEN DELETE(S,1,1);{$endif}
  forcedirectories(S + '/.Almin-Soft/msetune');
  s := S + '/.Almin-Soft/msetune/msetune_components.conf';
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

  //update params
  s := extractfilepath(S) + 'msetune_updatemse.conf';
  fi := tinifile.create(s);
  fne_updateutility.value := fi.readstring('update_mse','svn_utility','');
  ddd_trunkdir.value := fi.readstring('update_mse','trunk_dir','');
  fne_ppcpath2.value :=  fi.readstring('update_mse','compiler','');
  fi.free;
  {$ifdef linux}
  if fne_updateutility.value = '' then fne_updateutility.value := 'svn co';
  if ddd_trunkdir.value = '' then ddd_trunkdir.value := '/usr/src/msetrunk';
  if fne_ppcpath2.value = '' then fne_ppcpath2.value := 'ppc386';
  {$endif}
  {$ifdef windows}
  // === any ideas ? ===
  {$endif}
  
  //tune mse
  s := extractfilepath(S) + 'msetune_tunemse.conf';
  fi := tinifile.create(s);
  ddd_trunkdir3.value := fi.readstring('tunemse','trunk_dir','');
  fne_ppcpath3.value :=  fi.readstring('tunemse','compiler','');
  fne_msetune.value :=  fi.readstring('tunemse','msetune','');

  be_insert.value := fi.readbool('tunemse','insert_in_menu',false);
  be_ctrl_space.value := fi.readbool('tunemse','ctrl_space',false);
  be_compile_mse3.value := fi.readbool('tunemse','compile_mse',false);
  fi.free;
  {$ifdef linux}
  if ddd_trunkdir3.value = '' then ddd_trunkdir3.value := '/usr/src/msetrunk/apps/ide';
  if fne_ppcpath3.value = '' then fne_ppcpath3.value := 'ppc386';
  {$endif}
  {$ifdef windows}
  // === any ideas ? ===
  {$endif}
  
end;

procedure tmainfo.on_closepr(const sender: TObject);
var fi : tinifile;
     i : integer;
     s : string;
begin
  S := sys_getuserhomedir;
  {$ifdef windows} IF S > '' THEN IF S[1] = '/' THEN DELETE(S,1,1);{$endif}
  forcedirectories(S + '/.Almin-Soft/msetune');
  s := S + '/.Almin-Soft/msetune/msetune_components.conf';
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

  s := extractfilepath(S) + 'msetune_updatemse.conf';
  if fileexists(s) then 
     if not deletefile(s) then
        begin
          showmessage('Can`t update conf file !' + #10 + s + #10 + 'Check rights!');
          exit;
        end;
  fi := tinifile.create(s);
  fi.writestring('update_mse','svn_utility',fne_updateutility.value);
  fi.writestring('update_mse','trunk_dir',ddd_trunkdir.value);
  fi.writestring('update_mse','compiler',fne_ppcpath2.value);
  fi.free;
  
  s := extractfilepath(S) + 'msetune_tunemse.conf';
  if fileexists(s) then 
     if not deletefile(s) then
        begin
          showmessage('Can`t update conf file !' + #10 + s + #10 + 'Check rights!');
          exit;
        end;
  fi := tinifile.create(s);
  fi.writestring('tunemse','trunk_dir', ddd_trunkdir3.value);
  fi.writestring('tunemse','compiler', fne_ppcpath3.value);
  fi.writestring('tunemse','msetune', fne_msetune.value);

  fi.writebool('tunemse','insert_in_menu', be_insert.value);
  fi.writebool('tunemse','ctrl_space', be_ctrl_space.value);
  fi.writebool('tunemse','compile_mse', be_compile_mse3.value);
  fi.free;
end;

procedure tmainfo.on_close(const sender: TObject);
begin
  close;
end;
//========================================================
//                    INSTALL COMPONENTS
//========================================================
//  navigate steps
procedure tmainfo.on_step(const sender: TObject);
begin
  tw_inslall.activepageindex := (sender as tcomponent).tag;
end;

//add row for new component
procedure tmainfo.on_add_row(const sender: TObject);
begin
 tw_.rowcount := tw_.rowcount + 1;
end;
//delete row for new component
procedure tmainfo.on_delete_row(const sender: TObject);
begin
 if tw_.row >= 0 then tw_.deleterow(tw_.row);
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

//build new ide
procedure tmainfo.on_compile(const sender: TObject);
var s, cmd, 
    prjdir, msedir,
    n : string;
    i,
    y : integer;
    fs:tsearchrec;
    f : textfile;
begin
 tw_inslall.activepageindex := 3;
 m_regpas.value := m_regpas_orig.value;
 button4.visible := false;
 for i := 0 to 3 do se2[i] := '';

 msedir := ddd_msedir.value;
 {$ifdef windows}if system.pos('/',msedir) = 1 then delete(msedir,1,1);{$endif}
 if msedir[length(msedir)] <> __s then msedir := msedir + __s;

 prjdir := msedir + 'apps'+ __s + se_prj_name.value;
 if prjdir[length(prjdir)] <> __s then prjdir := prjdir + __s;

 {$ifdef windows}
 for i := 0 to length(msedir) do if msedir[i] = '/' then msedir[i] := __s;
 for i := 0 to length(prjdir) do if prjdir[i] = '/' then prjdir[i] := __s;
 {$endif}
 
 l_inf.caption := prjdir + se_prj_name.value;
 
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
  term.execprog(cmd);    
end;  

procedure tmainfo.on_receive_text(const sender: TObject; var atext: AnsiString;const errorinput: Boolean);
begin
 if (system.pos('Fatal', atext) > 0)
  or(system.pos('Error', atext) > 0) 
  then se2[4] := 'ERROR compiling';
end;

procedure tmainfo.on_finish(const sender: TObject);
begin
 if se2[4] = 'Wait ...'
  then begin 
        se2[4] := 'Ok';
        button4.visible := true;
       end; 
end;

procedure tmainfo.on_run_new_mse(const sender: TObject);
var p : tprocess;
begin
  p := tprocess.create(nil);
  p.commandline := l_inf.caption;
  p.execute;
  p.free;
end;

//========================================================
//                    UPDATE MSE, help, contributed
//========================================================
procedure tmainfo.on_update_mse(const sender: TObject);
var cmd : string;
begin
 IF forcedirectories(ddd_trunkdir.value) 
 then chdir(ddd_trunkdir.value)
 else begin
        term_update.addline('ERROR create directory ' + ddd_trunkdir.value);
        exit;
      end;
 
 cmd := '';
 if be_update_mse.value 
    then cmd := fne_updateutility.value  + ' https://mseide-msegui.svn.sourceforge.net/svnroot/mseide-msegui/trunk ' + ddd_trunkdir.value;

 if be_update_help.value 
    then begin
          if cmd = '' 
            then cmd := cmd + fne_updateutility.value  + ' https://msedocumenting.svn.sourceforge.net/svnroot/msedocumenting/mse/trunk/help ' + ddd_trunkdir.value + __s + 'help' + __s + 'trunk'
            else cmd := cmd + ' ; ' + fne_updateutility.value  + ' https://msedocumenting.svn.sourceforge.net/svnroot/msedocumenting/mse/trunk/help ' + ddd_trunkdir.value + __s + 'help' + __s + 'trunk';
         end;            

 if be_update_contr.value 
    then begin
          if cmd = ''
            then cmd := fne_updateutility.value  + ' https://msedocumenting.svn.sourceforge.net/svnroot/msedocumenting/mse/trunk/contributed ' + ddd_trunkdir.value + __s + 'contributed' + __s + 'trunk'
            else cmd := cmd + ' ; ' + fne_updateutility.value  + ' https://msedocumenting.svn.sourceforge.net/svnroot/msedocumenting/mse/trunk/contributed ' + ddd_trunkdir.value + __s + 'contributed' + __s + 'trunk';
         end;

 if be_compile_mse.value 
    then begin
          if cmd = ''
            then cmd := fne_ppcpath2.value + ' -B -Fulib/common/* -Fulib/common/kernel/i386-linux -Filib/common/kernel apps/ide/mseide.pas'
            else cmd := cmd + ' ; ' + fne_ppcpath2.value + ' -B -Fulib/common/* -Fulib/common/kernel/i386-linux -Filib/common/kernel apps/ide/mseide.pas';
         end;

 if cmd = '' 
    then begin 
           term_update.addline('MSEtune : Choose what you want update, man!');
           exit;
         end;

 term_update.addline('MSEtune : Starting update/compile MSEide (and components)...');
 l_update_status.caption := 'Be patient, man, I still update ... ';
 term_update.execprog(cmd);
end;

procedure tmainfo.on_finish_update_mse(const sender: TObject);
begin
  term_update.addline('MSEtune : Finish update MSEide');
  l_update_status.caption := 'Finished';
end;


//========================================================
//                    UPDATE MSE, help, contributed
//========================================================
procedure tmainfo.insert_msetune(const sender: TObject);
var s, cmd, 
    prjdir, 
    n : string;
    i,y : integer;
    f : textfile;
begin
 //STEP 1 - INSERTING IN MENU
 prjdir := ddd_trunkdir3.value;
 chdir(prjdir);
 if prjdir[length(prjdir)] <> __s then prjdir := prjdir + __s;

 {$ifdef windows}
 for i := 0 to length(prjdir) do if prjdir[i] = '/' then prjdir[i] := __s;
 {$endif}

 if be_insert.value then
  begin
     assignfile(f,prjdir + 'main.pas');
     reset(f);
     s := '';
     while not eof(f) do 
      begin
        readln(f,n);
        s := s + n + #10;
      end;  
     closefile(f);
     
   if system.pos(#10 + ' process,' + #10 ,s) = 0 then
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
  end;
 //STEP 2 - switch on ctrl+space
 if be_ctrl_space.value then
  begin
     assignfile(f,prjdir + 'sourcepage.pas');
     reset(f);
     s := '';
     while not eof(f) do 
      begin
        readln(f,n);
        s := s + n + #10;
      end;  
     closefile(f);    
     
     if system.pos('{$ifdef mse_with_showsourceitems}',s) > 0 then
     begin
       i := system.pos('{$ifdef mse_with_showsourceitems}',s);
       delete(s,i,length('{$ifdef mse_with_showsourceitems}'));
       repeat
         inc(i);
       until s[i] = '{';
     
       delete(s,i,length('{$endif}'));
     end;
     
     rewrite(f);
     writeln(f,s);
     closefile(f);     
  end;   
  //step 3 - compile mse
  if be_compile_mse3.value then 
    begin
      chdir('..');
      chdir('..');
      term_rebuild.execprog(fne_ppcpath3.value + ' -B -Fulib/common/* -Fulib/common/kernel/i386-linux -Filib/common/kernel apps/ide/mseide.pas');
    end;   
end;

procedure tmainfo.on_finishbuild(const sender: TObject);
begin
  term_update.addline('MSEtune : Finish build MSEide');  
end;

end.
