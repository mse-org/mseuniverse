unit mainmodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseapplication,mseclasses,msedatamodules,mseact,mseificomp,
 mseificompglob,mseifiglob,msestat,msestatfile,mseactions,msedatanodes,
 mselistbrowser,mclasses,mserttistat,msestrings,msebitmap,msedataedits,mseedit,
 msefiledialog,msegraphics,msegraphutils,msegrids,msegui,mseguiglob,msemenus,
 msestream,msesys,sysutils;

type
 ttestnode = class(ttreelistedititem)
 end;

 tprojectoptions = class(toptions);
  
 tmainmo = class(tmsedatamodule)
   exitact: taction;
   newact: taction;
   saveact: taction;
   openact: taction;
   closeact: taction;
   saveasact: taction;
   projectstat: tstatfile;
   mainstat: tstatfile;
   taction1: taction;
   connectgui: tifiactionlinkcomp;
   trttistat1: trttistat;
   projectcaption: tifistringlinkcomp;
   projectfiledialog: tfiledialog;
   procedure exitexe(const sender: TObject);
   procedure openexe(const sender: TObject);
   procedure getstatobjexe(const sender: TObject; var aobject: TObject);
   procedure evenloopstartexe(const sender: TObject);
   procedure saveexe(const sender: TObject);
   procedure saveasexe(const sender: TObject);
   procedure projectupdateexe(const sender: TObject; const filer: tstatfiler);
   procedure aftermainstareadexe(const sender: TObject);
  private
   frootnode: ttestnode;
   fprojectoptions: tprojectoptions;
   fmodified: boolean;
   fprojectname: msestring;
   fprojectfile: filenamety;
  protected
   procedure updatecaption();
   procedure updateprojectname();
   procedure loadproject();
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy(); override;
   function closeproject(): boolean;
   procedure openproject();
   function saveproject(): boolean;
   function saveasproject(): boolean;
   procedure projectchanged();
   property rootnode: ttestnode read frootnode;
   property projectoptions: tprojectoptions read fprojectoptions;
 end;
 
var
 mainmo: tmainmo;
implementation
uses
 mainmodule_mfm,msewidgets,msefileutils;

{tmainmo}

constructor tmainmo.create(aowner: tcomponent);
begin
 frootnode:= ttestnode.create();
 fprojectoptions:= tprojectoptions.create();
 inherited;
end;

destructor tmainmo.destroy();
begin
 inherited;
 frootnode.free();
 fprojectoptions.free();
end;

procedure tmainmo.exitexe(const sender: TObject);
begin
 if closeproject() then begin
  application.terminated:= true;
 end;
end;

procedure tmainmo.updateprojectname();
begin
 fprojectfile:= projectfiledialog.controller.filename;
 fprojectname:= filename(fprojectfile);
 projectstat.filename:= fprojectfile;
 updatecaption();
end;

procedure tmainmo.loadproject();
begin
 updateprojectname();
 if fprojectfile <> '' then begin
  projectstat.readstat();
  connectgui.controller.execute();
 end;
end;

procedure tmainmo.openproject();
begin
 if closeproject() and
              (projectfiledialog.execute(fdk_open) = mr_ok) then begin
  loadproject();
 end;
end;

function tmainmo.saveproject(): boolean;
begin
 if fprojectfile = '' then begin
  result:= saveasproject();
 end
 else begin
  projectstat.writestat();
  fmodified:= false;
  updatecaption();
  result:= true;
 end;
end;

function tmainmo.saveasproject(): boolean;
begin
 result:= projectfiledialog.execute(fdk_save) = mr_ok;
 if result then begin
  updateprojectname();
  saveproject();
 end
end;

function tmainmo.closeproject(): boolean;
begin
 result:= true;
 if fmodified then begin
  case askyesnocancel('Project has been modified, save it?') of
   mr_yes: begin
    result:= saveproject();
   end;
   mr_no: begin 
    //do nothing
   end;
   else begin
    result:= false;
   end;
  end;
 end;
 if result then begin
  frootnode.clear();
  fmodified:= false;
  fprojectname:= '';
  fprojectfile:= '';
  updatecaption();
 end;
end;

procedure tmainmo.openexe(const sender: TObject);
begin
 openproject();
end;

procedure tmainmo.getstatobjexe(const sender: TObject; var aobject: TObject);
begin
 aobject:= projectoptions;
end;

procedure tmainmo.projectchanged();
begin
 if not fmodified then begin
  fmodified:= true;
  updatecaption();
 end;
end;

procedure tmainmo.updatecaption();
var
 mstr1: msestring;
begin
 mstr1:= '';
 if fmodified then begin
  mstr1:= '*';
 end;
 if fprojectname = '' then begin
  mstr1:= mstr1 + '<new>';
 end
 else begin
  mstr1:= mstr1+fprojectname;
 end;
 projectcaption.controller.value:= mstr1;
end;

procedure tmainmo.evenloopstartexe(const sender: TObject);
begin
 connectgui.controller.execute();
 updatecaption();
end;

procedure tmainmo.saveexe(const sender: TObject);
begin
 saveproject();
end;

procedure tmainmo.saveasexe(const sender: TObject);
begin
 saveasproject();
end;

procedure tmainmo.projectupdateexe(const sender: TObject;
               const filer: tstatfiler);
begin
 frootnode.dostatupdate(filer);
end;

procedure tmainmo.aftermainstareadexe(const sender: TObject);
begin
 loadproject(); 
end;

end.
