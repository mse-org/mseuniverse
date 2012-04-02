unit tagsform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,dispform,msedataedits,
 mseedit,msegrids,mseifiglob,msestrings,msetypes,msewidgetgrid,msedatanodes,
 mselistbrowser,mainmodule;

type
 ttagsfo = class(tdispfo)
   grid: twidgetgrid;
   treeed: ttreeitemedit;
  private
   fexpandedsave: expandedinfoarty;
   ftagstreebefore: tgittagstreenode;  
  public
   procedure savestate;
   procedure restorestate;
   procedure dorepoloaded; override;
//   procedure dorefresh; override;
   procedure doclear; override;
 end;
 
var
 tagsfo: ttagsfo;
implementation
uses
 tagsform_mfm,sysutils,main;
 
{ ttagsfo }

procedure ttagsfo.savestate;
begin
 grid.beginupdate;
 fexpandedsave:= treeed.itemlist.expandedstate;
 ftagstreebefore:= mainmo.tagstree;
 mainmo.releasetagstree;
end;

procedure ttagsfo.restorestate;
begin
 freeandnil(ftagstreebefore);
 grid.endupdate;
 if fexpandedsave <> nil then begin
  treeed.itemlist.expandedstate:= fexpandedsave;
 end;
 {
 if grid.row < 0 then begin
  grid.row:= 0;
 end;
 }
end;

procedure ttagsfo.dorepoloaded;
begin
// mainmo.tagstree.expanded:= true;
 if mainfo.refreshing then begin
  grid.clear;
 end;
 treeed.itemlist.addchildren(mainmo.tagstree); 
end;

procedure ttagsfo.doclear;
begin
 if not mainfo.refreshing then begin
  treeed.itemlist.clear;
 end;
 fexpandedsave:= nil;
end;

end.
