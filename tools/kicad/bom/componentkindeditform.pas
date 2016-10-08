unit componentkindeditform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 recordnameeditform,msesplitter,mdb,mseact,msedataedits,msedbedit,mseedit,
 msegraphedits,msegrids,mseificomp,mseificompglob,mseifiglob,mselookupbuffer,
 msescrollbar,msestatfile,msestream,msestrings,sysutils,msedbdialog;

type
 tcomponentkindeditfo = class(trecordnameeditfo)
   tlayouter1: tlayouter;
   designationed: tdbdialogstringedit;
   param1ed: tdbmemodialogedit;
   param2ed: tdbmemodialogedit;
   commented: tdbmemodialogedit;
   param3ed: tdbmemodialogedit;
   footprinted: tdbenum64editdb;
   tdbmemodialogedit2: tdbmemodialogedit;
   distributored: tdbenum64editdb;
   manufacturered: tdbenum64editdb;
   procedure footprintedev(const sender: TObject);
 end;

implementation
uses
 componentkindeditform_mfm,main,mainmodule;
 
procedure tcomponentkindeditfo.footprintedev(const sender: TObject);
begin
 mainfo.editfootprint(mainmo.k_footprint);
end;

end.
