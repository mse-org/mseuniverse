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
   commited: tstringedit;
   messageed: tstringedit;
   commitdateed: tdatetimeedit;
   committered: tstringedit;
   tpopupmenu1: tpopupmenu;
   procedure updaterowvaluesexe(const sender: TObject; const aindex: Integer;
                   const aitem: tlistitem);
   procedure messagecellevent(const sender: TObject; var info: celleventinfoty);
   procedure updateexe(const sender: tcustommenu);
   procedure deletetagexe(const sender: TObject);
   procedure pushexe(const sender: TObject);
   procedure branchexe(const sender: TObject);
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
 tagsform_mfm,sysutils,main,msegridsglob,msewidgets,branchform;
 
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
 grid.endupdate;
 if fexpandedsave <> nil then begin
  treeed.itemlist.expandedstate:= fexpandedsave;
 end;
 ftagstreebefore.releaseowner;
 freeandnil(ftagstreebefore);
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

procedure ttagsfo.updaterowvaluesexe(const sender: TObject;
               const aindex: Integer; const aitem: tlistitem);
begin
 if aitem is tgittagstreenode then begin
  with tgittagstreenode(aitem) do begin
   commited[aindex]:= commit;
   commitdateed[aindex]:= commitdate;
   committered[aindex]:= committer;
   messageed[aindex]:= removelinebreaks(message);
  end;
 end;
end;

procedure ttagsfo.messagecellevent(const sender: TObject;
               var info: celleventinfoty);
var
 n1: ttreelistitem;
begin
 if (info.eventkind = cek_firstmousepark) and
    application.active and  messageed.textclipped(info.cell.row) then begin
  n1:= treeed[info.cell.row];
  if n1 is tgittagstreenode then begin
   application.showhint(grid,tgittagstreenode(n1).message);
  end;
 end;
end;

procedure ttagsfo.updateexe(const sender: tcustommenu);
var
 bo1: boolean;
begin
 bo1:= treeed.item is tgittagstreenode;
 sender.menu.itembyname('delete').enabled:= bo1;
 sender.menu.itembyname('push').enabled:= bo1 and (mainmo.activeremote <> '');
 sender.menu.itembyname('branch').enabled:= bo1;
end;

procedure ttagsfo.deletetagexe(const sender: TObject);
var
 mstr1: msestring;
begin
 mstr1:= tgittagstreenode(treeed.item).tagref;
 if askyesno('Do you want to delete the tag "'+
            mstr1+'"?') then begin
  mainmo.deletetag('',mstr1);
 end;
end;

procedure ttagsfo.pushexe(const sender: TObject);
var
 mstr1: msestring;
begin
 mstr1:= tgittagstreenode(treeed.item).tagref;
 if askyesno('Do you want to push the tag "'+
            mstr1+'" to '+mainmo.activeremote+'?') then begin
  mainmo.pushtag(mainmo.activeremote,mstr1);
 end;
end;

procedure ttagsfo.branchexe(const sender: TObject);
begin
 branchfo.createbranch(commited.value);
end;

end.
