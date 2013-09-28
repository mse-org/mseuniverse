{ MSEspice Copyright (c) 2012-2013 by Martin Schreiber
   
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

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msewidgets,mseglob,mseapplication,mseclasses,msedatamodules,mserttistat,
 msestat,mseact,mseactions,mseifiglob,mseguirttistat,classes,mclasses,
 msestatfile,msemacros,msebitmap,msedataedits,msedatanodes,mseedit,
 msefiledialog,msegraphics,msegraphutils,msegrids,msegui,mseguiglob,
 mselistbrowser,msemenus,msestrings,msesys,msetypes,msepipestream,mseprocess,
 msengspice,mseificomp,mseificompglob,mseprocmonitorcomp,msesystypes;

const
{$ifdef mswindows}
 ngspicename = 'ngspice.exe';
 ps2pdfname = 'ps2pdf.bat';
{$else}
 ngspicename = 'ngspice';
 ps2pdfname = 'ps2pdf';
{$endif}
 realformat = '0..######g';
 defaultfontname = 'Arial';
 defaultfontheight = 12;
 
type
 ttextglobaloptions = class
  private
   fschematiccapture: msestring;
  published
   property schematiccapture: msestring read fschematiccapture 
                                                  write fschematiccapture;
 end;
 
 tglobaloptions = class(toptions)
  private
   fngspice: filenamety;
   fps2pdf: filenamety;
   fchartfontname: msestring;
   fchartfontheight: integer;
   fglobmacnames: msestringarty;
   fglobmacvalues: msestringarty;
   ft: ttextglobaloptions;
   ftexp: ttextglobaloptions;
   procedure setngspice(const avalue: filenamety);
   procedure setps2pdf(const avalue: filenamety);
  protected
   function gett: tobject; override;
   function gettexp: tobject; override;
  public
   constructor create;
   property texp: ttextglobaloptions read ftexp;
  published
   property ngspice: filenamety read fngspice write setngspice;
   property ps2pdf: filenamety read fps2pdf write setps2pdf;
   property chartfontname: msestring read fchartfontname write fchartfontname;
   property chartfontheight: integer read fchartfontheight 
                                                       write fchartfontheight;
   property globmacnames: msestringarty read fglobmacnames write fglobmacnames;
   property globmacvalues: msestringarty read fglobmacvalues write fglobmacvalues;
   property t: ttextglobaloptions read ft;
 end;

 ttextprojectoptions = class
  private
   fnetlist: filenamety;
   fnetlistrel: filenamety;
   flibfiles: filenamearty;
   flibnames: filenamearty;
  protected
  public
//   constructor create;
  published
   property netlist: filenamety read fnetlist write fnetlist;
   property netlistrel: filenamety read fnetlistrel write fnetlistrel;
   property libfiles: filenamearty read flibfiles write flibfiles;
   property libnames: filenamearty read flibnames write flibnames;
 end;
 
 tprojectoptions = class(toptions)
  private
   ft: ttextprojectoptions;
   ftexp: ttextprojectoptions;
   flocmacnames: msestringarty;
   flocmacvalues: msestringarty;
  protected
   procedure dostatwrite(const writer: tstatwriter); override;
   function gett: tobject; override;
   function gettexp: tobject; override;
  public
   constructor create;
   property texp: ttextprojectoptions read ftexp;
  published
   property t: ttextprojectoptions read ft;
   property locmacnames: msestringarty read flocmacnames write flocmacnames;
   property locmacvalues: msestringarty read flocmacvalues write flocmacvalues;
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
   libfiledialog: tfiledialog;
   stringlink: tifistringlinkcomp;
   booleanlink: tifibooleanlinkcomp;
   reallink: tifireallinkcomp;
   integerlink: tifiintegerlinkcomp;
   enumlink: tifienumlinkcomp;
   tracesymbols: timagelist;
   spiceoptionscomp: tguirttistat;
   schematiccapture: tmseprocess;
   schematiccaptureact: taction;
   procedure getobjexe(const sender: TObject; var aobject: toptions);
   procedure optionsexe(const sender: TObject);
   procedure getoptionsobjexe(const sender: TObject; var aobject: tobject);
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
   procedure aftereditoptionsexe(const sender: TObject);
   procedure afteroptionsreadexe(const sender: TObject);
   procedure projectdataenteredexe(const sender: tcustomificlientcontroller;
                   const aclient: iificlient; const aindex: Integer);
   procedure getoptionsobjsexe(const sender: TObject;
                   var aobjects: objectinfoarty);
   procedure getspiceobjexe(const sender: TObject; var aobject: tobject);
   procedure getfilenamexe(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure schematicexe(const sender: TObject);
  private
   fprojectloaded: boolean;
   fsimurunning: boolean;
   fspicefile: filenamety;
   frawfile: filenamety;
   fmodified: boolean;
  protected
   fprojectoptions: tprojectoptions;
   fglobaloptions: tglobaloptions;
   fspice: tngspice;
   function getmacros: macroinfoarty;
   procedure updateprojectstate;
   procedure expandprojectmacros;
  public
   tracesymbolnames: msestringarty;
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   function expandmacros(const atext: msestring): msestring;
   procedure hintmacros(const avalue: msestring; var ainfo: hintinfoty);
   function checkfilesave: boolean; //true if ok
   procedure editoptions;
   procedure openproject;
   function closeproject: boolean;
   procedure newproject;
   procedure loadproject(const aname: filenamety); //'' -> statfilename
   procedure simuterminated;
   procedure projectmodified;
   function spicelines(const atext: msestring): string;
                     //break lines with + linestart
   property projectloaded: boolean read fprojectloaded;
   property simurunning: boolean read fsimurunning;
   property projectoptions: tprojectoptions read fprojectoptions;
   property globaloptions: tglobaloptions read fglobaloptions;
 end;

var
 mainmo: tmainmo;

implementation
uses
 mainmodule_mfm,main,consoleform,msestream,plotsform,
 mseformatstr,plotpage,sysutils,msefloattostr,math,netlistform,paramform,
 msestockobjects,typinfo,msearrayutils,optionsform,msefileutils;

{ tglobaloptions }

constructor tglobaloptions.create;
begin
 fngspice:= ngspicename;
 fps2pdf:= ps2pdfname;
 fchartfontname:= defaultfontname;
 fchartfontheight:= defaultfontheight;
 ft:= ttextglobaloptions.create;
 ftexp:= ttextglobaloptions.create;
end;

procedure tglobaloptions.setngspice(const avalue: filenamety);
begin
 if avalue = '' then begin
  fngspice:= ngspicename;
 end
 else begin
  fngspice:= avalue;
 end;
end;

procedure tglobaloptions.setps2pdf(const avalue: filenamety);
begin
 if avalue = '' then begin
  fps2pdf:= ps2pdfname;
 end
 else begin
  fps2pdf:= avalue;
 end;
end;

function tglobaloptions.gett: tobject;
begin
 result:= ft;
end;

function tglobaloptions.gettexp: tobject;
begin
 result:= ftexp;
end;

{ tprojectoptions }

constructor tprojectoptions.create;
begin
 ft:= ttextprojectoptions.create;
 ftexp:= ttextprojectoptions.create;
end;

procedure tprojectoptions.dostatwrite(const writer: tstatwriter);
begin
 ft.fnetlistrel:= relativepath(ft.fnetlist);
end;

function tprojectoptions.gett: tobject;
begin
 result:= ft;
end;

function tprojectoptions.gettexp: tobject;
begin
 result:= ftexp;
end;

{ mainmo }

constructor tmainmo.create(aowner: tcomponent);
begin
 fprojectoptions:= tprojectoptions.create;
 fglobaloptions:= tglobaloptions.create;
 fspice:= tngspice.create;
 inherited;
end;

destructor tmainmo.destroy;
begin
 fspice.free;
 inherited;
 fprojectoptions.free;
 fglobaloptions.free;
end;

procedure tmainmo.getobjexe(const sender: TObject; var aobject: toptions);
begin
 aobject:= projectoptions;
end;

procedure tmainmo.optionsexe(const sender: TObject);
begin
 editoptions;
end;

procedure tmainmo.editoptions;
begin
 if projectoptionscomp.edit = mr_ok then begin
  mainstat.writestat;
 end;
end;

function tmainmo.checkfilesave: boolean;
begin
 result:= netlistfo.checksave;
end;

procedure tmainmo.openprojectexe(const sender: TObject);
begin
 openproject;
end;

function tmainmo.getmacros: macroinfoarty;
begin
 if optionsfo <> nil then begin
  with optionsfo do begin
   result:= initmacros([opentodynarraym(['PROJECTNAME','NETLIST']),
            globmacnames.gridvalues,locmacnames.gridvalues],
             [opentodynarraym([filenamebase(projectmainstat.filename),
                                                          netlist.value]),
              globmacvalues.gridvalues,locmacvalues.gridvalues]);
  end;
 end
 else begin
  result:= initmacros([opentodynarraym(['PROJECTNAME','NETLIST']),
            fglobaloptions.globmacnames,fprojectoptions.locmacnames],
             [opentodynarraym([filenamebase(projectmainstat.filename),
              fprojectoptions.t.netlist]),
              fglobaloptions.globmacvalues,fprojectoptions.locmacvalues]);
 end;
end;

procedure tmainmo.expandprojectmacros;
var
 ar1: macroinfoarty;
begin
 ar1:= getmacros;
 fglobaloptions.expandmacros(ar1);
 fprojectoptions.expandmacros(ar1);
end;

function tmainmo.expandmacros(const atext: msestring): msestring;
begin
 result:= msemacros.expandmacros(atext,getmacros);
end;

procedure tmainmo.loadproject(const aname: filenamety);
begin
 if aname <> '' then begin
  projectmainstat.filename:= aname;
 end;
 setcurrentdirmse(filedir(projectmainstat.filename)); 
 projectmainstat.readstat;
 fprojectloaded:= true;
 fmodified:= false;
 expandprojectmacros;
 plotsfo.updatechartsettings;
 if projectoptions.texp.netlist <> '' then begin
  if findfile(projectoptions.texp.netlistrel) then begin
   netlistfo.loadfile(projectoptions.texp.netlistrel);
  end
  else begin
   netlistfo.loadfile(projectoptions.texp.netlist);
  end;
 end;
 updateprojectstate;
end;

procedure tmainmo.openproject;
begin
 with projectfiledialog do begin
  if (execute = mr_ok) and closeproject then begin
   loadproject(controller.filename);
  end;
 end;
end;

procedure tmainmo.newprojectactexe(const sender: TObject);
begin
 newproject;
end;

function tmainmo.closeproject: boolean;
begin
 result:= checkfilesave;
 if result and fprojectloaded then begin
  if fmodified then begin
   case askyesnocancel('Project '+projectmainstat.filename+
                                     ' is modified. Save?') of
    mr_yes,mr_no: begin
    end;
    else begin
     result:= false;
    end;
   end;
  end;
  if result then begin
//   if schematiccapture.active then begin
//    schematiccapture.terminate;
    schematiccapture.active:= false;
//   end;
   netlistfo.close;
   fprojectloaded:= false;
   updateprojectstate;
   projectmainstat.writestat;
//   plotsfo.tabs.clear;
   plotsfo.clear;
   paramfo.grid.clear;
   mainfo.setstattext('');
   fprojectoptions.free;
   fprojectoptions:= tprojectoptions.create;
  end;
 end;
end;

procedure tmainmo.closeprojectexe(const sender: TObject);
begin
 closeproject;
 updateprojectstate;
end;

procedure tmainmo.newproject;
begin
 with projectfiledialog do begin
  controller.filename:= '';
  if (execute(fdk_new) = mr_ok) and closeproject then begin
   projectmainstat.filename:= controller.filename;
   projectmainstat.writestat;
   plotsfo.init;
   fprojectloaded:= true;
   netlistfo.activate;
  end;
 end;
 updateprojectstate;
end;

procedure tmainmo.updateprojectstate;
var
 mstr1: msestring;
begin
 closeprojectact.enabled:= projectloaded; 
 optionsact.enabled:= projectloaded;
 saveprojectact.enabled:= projectloaded and fmodified;
 saveprojectasact.enabled:= projectloaded;
 simustopact.enabled:= simurunning;
 simustartact.enabled:= projectloaded and not simurunning;
 
 if projectloaded then begin
  if fmodified then begin
   mstr1:= '*';
  end;
  mainfo.caption:= 'MSEspice '+mstr1+filename(projectmainstat.filename);
 end
 else begin
  mainfo.caption:= 'MSEspice';
 end;
end;

procedure tmainmo.saveprojectexe(const sender: TObject);
begin
 if checkfilesave then begin
  projectmainstat.writestat;
  fmodified:= false;
  updateprojectstate;
 end;
end;

procedure tmainmo.saveprojectasexe(const sender: TObject);
begin
 if checkfilesave then begin
  with projectfiledialog do begin
   controller.filename:= projectmainstat.filename;
   if execute(fdk_save) = mr_ok then begin
    projectmainstat.filename:= controller.filename;
    projectmainstat.writestat;
    loadproject(controller.filename);
//    fmodified:= false;
//    updateprojectstate;
   end;
  end;
 end;
end;

procedure tmainmo.simustartexe(const sender: TObject);
const
 varplotname = 'unknown1'; 
        //"set var curplot" "$var.vector" does not work
var
 stream2: ttextstream = nil;
 writestatement: string;
 
 procedure dowrite(const vectors: stringarty; const indent: string = '');
 var
  int1: integer;
  str1: string;
 begin
  str1:= '';
  for int1:= 0 to high(vectors) do begin
   str1:= str1 + ' {$curplot}.'+vectors[int1];
  end;
  stream2.writeln(indent+writestatement+str1);
  stream2.writeln(indent+' destroy {$curplot}');
 end;

var
 int1,int2: integer;
 str1: string;
 lstr1: lstringty;
 sk1: stepkindty;
 ar1: stringarty;
 
begin
 fspicefile:= replacefileext(projectmainstat.filename,'spi.tmp');
 frawfile:= replacefileext(projectmainstat.filename,'raw.tmp');
 deletefile(frawfile);
 writestatement:= ' write '+tosysfilepath(frawfile,true);
                                       //'write' must be lowercase!
 try
  stream2:= ttextstream.create(fspicefile,fm_create);
  for int1:= 0 to netlistfo.grid.rowhigh do begin
   str1:= netlistfo.edit[int1];
   nextword(str1,lstr1);
   if lstringicomp(lstr1,'.END') = 0 then begin
    break;
   end;
   stream2.writeln(str1);
  end;
  with paramfo do begin
   for int1:= 0 to grid.datarowhigh do begin
    stream2.writeln('.param '+paramname[int1]+'='+
                             spicelines(paramexpression[int1]));
   end;
  end;

  with projectoptions.texp do begin
   for int1:= 0 to high(libfiles) do begin
    if libfiles[int1] <> '' then begin
     if libnames[int1] = '' then begin
      stream2.writeln('.include '+tosysfilepath(libfiles[int1],true));
     end
     else begin
      stream2.writeln('.lib '+tosysfilepath(libfiles[int1],true)+' '+
                                                             libnames[int1]);
     end;
    end;
   end;
  end;
  stream2.writeln('.control');
  stream2.writeln(' set appendwrite');
  stream2.writeln(
  ' define unif(nom, rvar) (nom + (nom*rvar) * sunif(0))'+lineend+
  ' define aunif(nom, avar) (nom + avar * sunif(0))'+lineend+
  ' define gauss(nom, rvar, sig) (nom + (nom*rvar)/sig * sgauss(0))'+lineend+
  ' define agauss(nom, avar, sig) (nom + avar/sig * sgauss(0))'+lineend+
  ' define limit(nom, avar) (nom + ((sgauss(0) >= 0) ? avar : -avar))');
  stream2.writeln(' set curplot = new');
  for int1:= 0 to plotsfo.tabs.count - 1 do begin
   with tplotpagefo(plotsfo.tabs[int1]) do begin
    if plotactive.value then begin
     str1:= ' save all';
     if savegrid.datarowhigh >= 0 then begin
      for int2:= 0 to savegrid.datarowhigh do begin
       str1:= str1 + ' '+unifyexpression(savevector[int2]);
      end;
     end;
     stream2.writeln(str1);
     if stepactive.value then begin
      ar1:= exptags;
      stream2.writeln(' set curplot = '+varplotname);
      for int2:= 0 to stepgrid.datarowhigh do begin
       stream2.writeln(' let b'+inttostr(int2)+' = '+stepdest[int2]);
                                     //backup original values
       sk1:= stepkindty(stepkind[int2]);
       if (stepcount.value > 0) and (sk1 <= sk_log) then begin
        if sk1 = sk_log then begin
         stream2.writeln(' let a'+inttostr(int2)+' = '+
            doubletostring(ln(stepstop[int2]/stepstart[int2])/stepcount.value));
        end
        else begin //lin
         stream2.writeln(' let a'+inttostr(int2)+' = '+
            doubletostring((stepstop[int2]-stepstart[int2])/stepcount.value));
        end;
       end;
      end;
      stream2.writeln(' let n = 0');
      stream2.writeln(' dowhile '+varplotname+'.n <= '+inttostr(stepcount.value));
      for int2:= 0 to stepgrid.datarowhigh do begin
       sk1:= stepkindty(stepkind[int2]);
       case sk1 of
        sk_gauss,sk_agauss: begin
         stream2.writeln('  alter '+stepdest[int2]+' = '+
           stepfunctions[sk1]+'('+
                           doubletostring(stepstart[int2])+','+
                           doubletostring(stepstop[int2])+','+
                           doubletostring(stepsigma[int2])+')');
        end;
        sk_unif,sk_aunif,sk_limit: begin
         stream2.writeln('  alter '+stepdest[int2]+' = '+
           stepfunctions[sk1]+'('+
                           doubletostring(stepstart[int2])+','+
                           doubletostring(stepstop[int2])+')');
        end;
        else begin
         if stepcount.value = 0 then begin
          stream2.writeln('  alter '+stepdest[int2]+' = '+
                                            doubletostring(stepstart[int2]));
         end
         else begin
          if stepkindty(stepkind[int2]) = sk_log then begin
           stream2.writeln('  alter '+stepdest[int2]+' = '+
               doubletostring(stepstart[int2])+
               '*exp('+varplotname+'.n*'+varplotname+'.a'+inttostr(int2)+')');
          end
          else begin //lin
           stream2.writeln('  alter '+stepdest[int2]+' = '+
                        doubletostring(stepstart[int2])+
                        '+'+varplotname+'.n*'+varplotname+'.a'+inttostr(int2));
          end;
         end;
        end;
       end;
      end;
      stream2.writeln('  '+getplotstatement);
      stream2.writeln('  let '+varplotname+'.n = '+varplotname+'.n + 1');
      for int2:= 1 to high(expressions) do begin
       stream2.writeln('  let '+exptag(int2)+'='+expressions[int2]);
      end;
      dowrite(ar1,' ');
      stream2.writeln(' end');
      for int2:= 0 to stepgrid.datarowhigh do begin //restore original values
       stream2.writeln(' alter '+stepdest[int2]+' = '+
                                    varplotname+'.b'+inttostr(int2));
      end;
     end
     else begin
      stream2.writeln(' '+getplotstatement);
      for int2:= 1 to high(expressions) do begin
       stream2.writeln(' let '+exptag(int2)+'='+spicelines(expressions[int2]));
      end;
      dowrite(exptags);
     end;
    end;
   end;
  end;
  stream2.writeln('.endc'+lineend+'.END');
 finally
  stream2.free;
 end;
 consolefo.term.clear;
 str1:= tosysfilepath(fglobaloptions.ngspice,true)+
   ' -b '+tosysfilepath(fspicefile,true);
 consolefo.term.addline('> '+str1);
 consolefo.beginsimu;
 try
  consolefo.term.execprog(str1);
 except
  application.handleexception;
  consolefo.endsimu;
  exit;
 end;
 mainfo.setstattext('*** Simulation running ***',mtk_running);
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
 consolefo.endsimu;
 fsimurunning:= false;
 fspice.reset;
 if (consolefo.term.exitcode <= 1) and 
                        ttextstream.trycreate(stream1,frawfile) then begin
  consolefo.term.addline('**** FINISHED ****');
  mainfo.setstattext('Simulation OK',mtk_finished);
  try
   fspice.readdata(stream1);
   plotsfo.updatecharts(fspice.plots);
  finally
   stream1.free;
   updateprojectstate;
  end;
 end
 else begin
  mainfo.setstattext('Simulation Error',mtk_error);
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
var
 bmp1: tmaskedbitmap;
 int1,int2: integer;
begin
 formatmacros.add(['REAL'],[realformat]);
 bmp1:= tmaskedbitmap.create(true);
 bmp1.masked:= true;
 int2:= 0;
 setlength(tracesymbolnames,ord(lasttracesymbol)-ord(firsttracesymbol)+1);
 for int1:= ord(firsttracesymbol) to ord(lasttracesymbol) do begin
  stockobjects.glyphs.getimage(int1,bmp1);
  tracesymbols.addimage(bmp1);
  tracesymbolnames[int2]:= 
                    copy(getenumname(typeinfo(stockglyphty),int1),5,bigint);
  inc(int2);  
 end;
 bmp1.free;
end;

procedure tmainmo.aftereditoptionsexe(const sender: TObject);
begin
 expandprojectmacros;
 plotsfo.updatechartsettings;
 if projectoptions.texp.netlist <> netlistfo.edit.filename then begin
  netlistfo.loadfile(projectoptions.texp.netlist);
 end;
end;

procedure tmainmo.afteroptionsreadexe(const sender: TObject);
begin
 with projectoptions.texp do begin
  setlength(flibnames,length(flibfiles));
 end;
end;

function tmainmo.spicelines(const atext: msestring): string;
var
 ar1: msestringarty;
 int1: integer;
begin
 if atext = '' then begin
  result:= '';
 end
 else begin
  ar1:= breaklines(atext);
  result:= ar1[0];
  for int1:= 1 to high(ar1) do begin
   result:= result + lineend + '+ '+ar1[int1];
  end;
 end;
end;

procedure tmainmo.projectdataenteredexe(
               const sender: tcustomificlientcontroller;
                     const aclient: iificlient; const aindex: Integer);
begin
 projectmodified;
end;

procedure tmainmo.projectmodified;
begin
 fmodified:= true;
 updateprojectstate;
end;

procedure tmainmo.getoptionsobjsexe(const sender: TObject;
               var aobjects: objectinfoarty);
begin
 if tguirttistat(sender).editing then begin
  setlength(aobjects,2);
  aobjects[0].obj:= fglobaloptions;
  aobjects[1].obj:= fprojectoptions;
 end;
end;

procedure tmainmo.getoptionsobjexe(const sender: TObject;
                                            var aobject: tobject);
begin
 aobject:= fprojectoptions;
end;

procedure tmainmo.getspiceobjexe(const sender: TObject; 
                                               var aobject: tobject);
begin
 aobject:= fglobaloptions;
end;

procedure tmainmo.hintmacros(const avalue: msestring; var ainfo: hintinfoty);
begin
 ainfo.caption:= expandmacros(avalue);
 include(ainfo.flags,hfl_show); //show empty caption
end;

procedure tmainmo.getfilenamexe(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 avalue:= expandmacros(avalue);
end;

procedure tmainmo.schematicexe(const sender: TObject);
begin
 if schematiccapture.running then begin
  activateprocesswindow(schematiccapture.prochandle);
 end
 else begin
  schematiccapture.commandline:= fglobaloptions.texp.schematiccapture;
  schematiccapture.active:= true;
 end;
end;

end.
