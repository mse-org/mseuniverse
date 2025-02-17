unit frmbasePage;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,mdb,msedb,
 mseifiglob,msedbedit,dbgroup,sysutils,strutils,msestrings,mseact,msedataedits,
 msedragglob,msedropdownlist,mseedit,msegraphedits,msegrids,msegridsglob,
 mseificomp,mseificompglob,mselookupbuffer,msescrollbar,msestatfile,msestream,
 msebufdataset,msedatabase,msesqldb,msqldb,mseactions,variants,msesimplewidgets,
 mseifiendpoint,msewidgetgrid,msedbdispwidgets,msedispwidgets,mclasses,
 mserichstring,msekeyboard;
//type
{TObjet = class
private
FOnKeyDown: TmseEvent;
//procedure WhenKeyDown(const sender: twidget; var ainfo: keyeventinfoty);
public
property OnKeyDown: TmseEvent read FOnKeyDown write FOnKeyDown;
constructor Create;
destructor Destroy; override;
//procedure WhenKeyDown(const sender: twidget; var ainfo: keyeventinfoty);
end;}


type
 tfrmbasePagefo = class(tsubform)
 procedure DoenterGroup(const sender:TObject);
 procedure DoexitGroup (const sender:TObject);
 end;
 
implementation
uses
 frmbasePage_mfm, frmbase;
var
 frmbasePagefo: tfrmbasePagefo;

procedure tfrmbasePagefo.DoEnterGroup(const sender: TObject);
begin
tfrmbasefo(window.owner).switchds(sender); 
twidget(sender).frame.framewidth:=3;
end;

procedure tfrmbasePagefo.DoExitGroup(const sender:TObject);
begin
twidget(sender).frame.framewidth:=1;
end;

end.
