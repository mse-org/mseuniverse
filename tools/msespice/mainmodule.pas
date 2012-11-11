{ MSEspice Copyright (c) 2012 by Martin Schreiber
   
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
unit mainmodule;
//under construction

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseapplication,mseclasses,msedatamodules,mserttistat,msestat,mseact,
 mseactions,mseifiglob,mseguirttistat,classes,msestatfile,msebitmap,
 msedataedits,msedatanodes,mseedit,msefiledialog,msegraphics,msegraphutils,
 msegrids,msegui,mseguiglob,mselistbrowser,msemenus,msestrings,msesys,msetypes,
 msepipestream,mseprocess,msengspice;

const
 ngspicename = 'ngspice';
 realformat = '0..######g';
 
type
 tprojectoptions = class(toptionsclass)
  private
   fngspice: filenamety;
   fnetlist: filenamety;
  public
   constructor create;
  published
   property ngspice: filenamety read fngspice write fngspice;
   property netlist: filenamety read fnetlist write fnetlist;
 end;
 
 tmainmo = class(tmsedatamodule)
   optionsact: taction;
   projectoptionscomp: tguirttistat;
   projectstat1: tstatfile;
   openprojectact: taction;
   mainstat: tstatfile;
   projectfiledialog: tfiledialog;
   newprojectact: taction;
   closeprojectact: taction;
   saveprojectasact: taction;
   tmseprocess1: tmseprocess;
   simustartact: taction;
   simustopact: taction;
   projectmainstat: tstatfile;
   saveprojectact: taction;
   projectstat2: tstatfile;
   tactivator1: tactivator;
   projectstat3: tstatfile;
   procedure getobjexe(const sender: TObject; var aobject: TObject);
   procedure optionsexe(const sender: TObject);
   procedure getoptionsobjexe(const sender: TObject; var aobject: TObject);
   procedure openprojectexe(const sender: TObject);
   procedure newprojectactexe(const sender: TObject);
   procedure closeprojectexe(const sender: TObject);
   procedure saveprojectasexe(const sender: TObject);
   procedure simustartexe(const sender: TObject);
   procedure simustopexe(const sender: TObject);
   procedure projreadexe(const sender: TObject; const reader: tstatreader);
   procedure projwriteexe(const sender: TObject; const writer: tstatwriter);
   procedure createexe(const sender: TObject);
   procedure saveprojectexe(const sender: TObject);
  private
   fprojectloaded: boolean;
   fsimurunning: boolean;
   fspicefile: filenamety;
   frawfile: filenamety;
  protected
   fprojectoptions: tprojectoptions;
   fspice: tngspice;
   procedure updateprojectstate;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure editoptions;
   procedure openproject;
   function closeproject: boolean;
   procedure newproject;
   procedure loadproject(const aname: filenamety); //'' -> statfilename
   procedure simuterminated;
   property projectloaded: boolean read fprojectloaded;
   property simurunning: boolean read fsimurunning;
 end;

var
 mainmo: tmainmo;

implementation
uses
 mainmodule_mfm,main,msefileutils,consoleform,msestream,msewidgets,plotsform,
 mseformatstr,plotpage,sysutils,msefloattostr;

{ tprojectoptions }

constructor tprojectoptions.create;
begin
 fngspice:= ngspicename;
end;

{ mainmo }

constructor tmainmo.create(aowner: tcomponent);
begin
 fprojectoptions:= tprojectoptions.create;
 fspice:= tngspice.create;
 inherited;
end;

destructor tmainmo.destroy;
begin
 fspice.free;
 inherited;
 fprojectoptions.free;
end;

procedure tmainmo.getobjexe(const sender: TObject; var aobject: TObject);
begin
end;

procedure tmainmo.optionsexe(const sender: TObject);
begin
 editoptions;
end;

procedure tmainmo.editoptions;
begin
 projectoptionscomp.edit;
end;

procedure tmainmo.getoptionsobjexe(const sender: TObject; var aobject: TObject);
begin
 aobject:= fprojectoptions;
end;

procedure tmainmo.openprojectexe(const sender: TObject);
begin
 openproject;
end;

procedure tmainmo.loadproject(const aname: filenamety);
begin
 if aname <> '' then begin
  projectmainstat.filename:= aname;
 end;
 projectmainstat.readstat;
 fprojectloaded:= true;
 updateprojectstate;
end;

procedure tmainmo.openproject;
begin
 if closeproject then begin
  with projectfiledialog do begin
   if execute = mr_ok then begin
    loadproject(controller.filename);
   end;
  end;
 end;
end;

procedure tmainmo.newprojectactexe(const sender: TObject);
begin
 newproject;
end;

function tmainmo.closeproject: boolean;
begin
 result:= true;
 if fprojectloaded then begin
  fprojectloaded:= false;
  updateprojectstate;
  projectmainstat.writestat;
 end;
end;

procedure tmainmo.closeprojectexe(const sender: TObject);
begin
 closeproject;
 updateprojectstate;
end;

procedure tmainmo.newproject;
begin
 if closeproject then begin
  with projectfiledialog do begin
   if execute(fdk_new) = mr_ok then begin
    projectmainstat.filename:= controller.filename;
    projectmainstat.writestat;
   end;
  end;
  updateprojectstate;
 end;
end;

procedure tmainmo.updateprojectstate;
begin
 closeprojectact.enabled:= projectloaded; 
 optionsact.enabled:= projectloaded;
 saveprojectasact.enabled:= projectloaded;
 saveprojectact.enabled:= projectloaded;
 simustopact.enabled:= simurunning;
 simustartact.enabled:= projectloaded and not simurunning;
 
 if projectloaded then begin
  mainfo.caption:= 'MSEspice '+filename(projectmainstat.filename);
 end
 else begin
  mainfo.caption:= 'MSEspice';
 end;
end;

procedure tmainmo.saveprojectexe(const sender: TObject);
begin
 projectmainstat.writestat;
end;

procedure tmainmo.saveprojectasexe(const sender: TObject);
begin
 with projectfiledialog do begin
  controller.filename:= projectmainstat.filename;
  if execute(fdk_save) = mr_ok then begin
   projectmainstat.filename:= controller.filename;
   projectmainstat.writestat;
   updateprojectstate;
  end;
 end;
end;

procedure tmainmo.simustartexe(const sender: TObject);
var
// fna1: filenamety;
 stream1: ttextstream;
 stream2: ttextstream = nil;
 int1,int2,int3: integer;
 str1: string;
 lstr1: lstringty;
 ar1: msestringarty;
 vectors: string;
 nums{,nums1}: array[plotkindty] of integer;
begin
 fspicefile:= replacefileext(projectmainstat.filename,'spi.tmp');
 frawfile:= replacefileext(projectmainstat.filename,'raw.tmp');
 deletefile(frawfile);
 stream1:= ttextstream.create(fprojectoptions.netlist,fm_read);
 try
  vectors:= '';
  stream2:= ttextstream.create(fspicefile,fm_create);
  while not stream1.eof do begin
   stream1.readln(str1);
   nextword(str1,lstr1);
   if lstringicomp(lstr1,'.END') = 0 then begin
    break;
   end;
   stream2.writeln(str1);
  end;
  stream2.writeln('.control');
  for int1:= 0 to plotsfo.tabs.count - 1 do begin
   with tplotpagefo(plotsfo.tabs[int1]) do begin
    if plotactive.value then begin
     if stepactive.value then begin
      for int2:= 0 to stepgrid.datarowhigh do begin
       stream2.writeln(' set b'+inttostr(int2)+' = '+stepdest[int2]);
                                     //backup original values
       stream2.writeln(' alter '+stepdest[int2]+' = '+
                                     doubletostring(stepstart[int2]));
      end;
      stream2.writeln(' let n = 0');
      stream2.writeln(' dowhile n <= '+inttostr(stepcount[int2]));
      stream2.writeln('  '+getplotstatement);
      stream2.writeln('  let n = n + 1');
      for int2:= 0 to stepgrid.datarowhigh do begin //restore original values
       stream2.writeln(' alter '+stepdest[int2]+' = $b'+inttostr(int2));
      end;
      for int2:= 1 to high(expressions) do begin
       stream2.writeln(' let '+exptag(int2)+'='+expressions[int2]);
      end;
      stream2.writeln(' end');
     end
     else begin
      stream2.writeln(' '+getplotstatement);
      for int2:= 1 to high(expressions) do begin
       stream2.writeln(' let '+exptag(int2)+'='+expressions[int2]);
      end;
     end;
    end;
   end;
  end;
  fillchar(nums,sizeof(nums),0);
  str1:= ' write '+tosysfilepath(frawfile,true); //'write' must be lowercase!
  for int1:= 0 to plotsfo.tabs.count - 1 do begin
   with tplotpagefo(plotsfo.tabs[int1]) do begin
    if plotactive.value then begin
     int3:= 0;
     if stepactive.value then begin
      int3:= stepcount.value;
     end;
     for int3:= 0 to int3 do begin
      str1:= str1+lineend+'+ ';
      if (kind = plk_ac) and (nums[plk_ac] = 0) and 
                                      (nums[plk_tran] = 0) then begin
       inc(nums[plk_tran]);
      end;
      inc(nums[kind]);
      for int2:= 1 to high(expressions) do begin
       str1:= str1 +' '+plotnames[kind]+inttostr(nums[kind])+'.'+exptag(int2);
      end;
     end;
    end;
   end;
  end;
  stream2.writeln(str1);                   
  stream2.writeln('.endc'+lineend+'.END');
 finally
  stream1.free;
  stream2.free;
 end;
 consolefo.term.clear;
 str1:= tosysfilepath(fprojectoptions.ngspice,true)+
   ' -b '+tosysfilepath(fspicefile,true);
 consolefo.term.addline('> '+str1);
 consolefo.term.execprog(str1);
 fsimurunning:= true;
 updateprojectstate;
end;

procedure tmainmo.simustopexe(const sender: TObject);
begin
 consolefo.term.killprocess;
 simuterminated;
end;

procedure tmainmo.simuterminated;
var
 stream1: ttextstream;
begin
 fsimurunning:= false;
 fspice.reset;
 if consolefo.term.exitcode <= 1 then begin
  if not ttextstream.trycreate(stream1,frawfile) then begin
   showerror('RAW file'+lineend+frawfile+lineend+'not found.');
  end
  else begin
   consolefo.term.addline('**** FINISHED ****');
   try
    fspice.readdata(stream1);
    plotsfo.updatecharts(fspice.plots);
   finally
    stream1.free;
    updateprojectstate;
   end;
  end;
 end
 else begin
  consolefo.term.addline('**** ERROR ****');
  consolefo.activate;
 end;
 updateprojectstate;
end;

procedure tmainmo.projreadexe(const sender: TObject; const reader: tstatreader);
begin
 plotsfo.readstat(reader);
end;

procedure tmainmo.projwriteexe(const sender: TObject;
               const writer: tstatwriter);
begin
 plotsfo.writestat(writer);
end;

procedure tmainmo.createexe(const sender: TObject);
begin
 formatmacros.add(['REAL'],[realformat]);
end;

end.
