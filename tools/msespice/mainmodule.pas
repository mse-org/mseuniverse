{ MSEgit Copyright (c) 2012 by Martin Schreiber
   
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
 realformat = '0.#########g';
 
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
   projectstat: tstatfile;
   openprojectact: taction;
   mainstat: tstatfile;
   projectfiledialog: tfiledialog;
   newprojectact: taction;
   closeprojectact: taction;
   saveasact: taction;
   tmseprocess1: tmseprocess;
   simustartact: taction;
   simustopact: taction;
   procedure getobjexe(const sender: TObject; var aobject: TObject);
   procedure optionsexe(const sender: TObject);
   procedure getoptionsobjexe(const sender: TObject; var aobject: TObject);
   procedure openprojectexe(const sender: TObject);
   procedure newprojectactexe(const sender: TObject);
   procedure closeprojectexe(const sender: TObject);
   procedure saveasexe(const sender: TObject);
   procedure simustartexe(const sender: TObject);
   procedure simustopexe(const sender: TObject);
   procedure projreadexe(const sender: TObject; const reader: tstatreader);
   procedure projwriteexe(const sender: TObject; const writer: tstatwriter);
   procedure createexe(const sender: TObject);
  private
   fprojectloaded: boolean;
   fsimurunning: boolean;
   frawname: filenamety;
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
 mseformatstr;

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
  projectstat.filename:= aname;
 end;
 projectstat.readstat;
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
  projectstat.writestat;
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
    projectstat.filename:= controller.filename;
    projectstat.writestat;
   end;
  end;
  updateprojectstate;
 end;
end;

procedure tmainmo.updateprojectstate;
begin
 closeprojectact.enabled:= projectloaded; 
 optionsact.enabled:= projectloaded;
 saveasact.enabled:= projectloaded;
 simustopact.enabled:= simurunning;
 simustartact.enabled:= projectloaded and not simurunning;
 
 if projectloaded then begin
  mainfo.caption:= 'MSEspice '+filename(projectstat.filename);
 end
 else begin
  mainfo.caption:= 'MSEspice';
 end;
end;

procedure tmainmo.saveasexe(const sender: TObject);
begin
 with projectfiledialog do begin
  if execute(fdk_save) = mr_ok then begin
   projectstat.filename:= controller.filename;
   projectstat.writestat;
   updateprojectstate;
  end;
 end;
end;

procedure tmainmo.simustartexe(const sender: TObject);
begin
 frawname:= replacefileext(projectstat.filename,'raw');
 consolefo.term.execprog(tosysfilepath(fprojectoptions.ngspice,true)+
   ' -b -r'+tosysfilepath(frawname,true)+
   ' '+tosysfilepath(fprojectoptions.netlist,true));
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
 if consolefo.term.exitcode = 0 then begin
  if not ttextstream.trycreate(stream1,frawname) then begin
   showerror('RAW file'+lineend+frawname+lineend+'not found.');
  end
  else begin
   try
    fspice.readdata(stream1);
   finally
    stream1.free;
   end;
  end;
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
