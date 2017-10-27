unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,mseact,
 msedataedits,msedropdownlist,mseedit,msegrids,mseificomp,mseificompglob,
 mseifiglob,msestatfile,msestream,msewidgetgrid,sysutils,mseeditglob,
 msetextedit,msedataimage,msebitmap,msedatanodes,msefiledialog,mselistbrowser,
 msesys,mserichstring;

type
 tmainfo = class(tmainform)
   grid: twidgetgrid;
   edit: tundotextedit;
   tstatfile1: tstatfile;
   image: tdataimage;
   tpopupmenu1: tpopupmenu;
   imagefiledialog: tfiledialog;
   procedure insertimageev(const sender: TObject);
   procedure drawtextev(const sender: tcustomtextedit; const canvas: tcanvas;
                   const atext: richstringty; const cellinfo: pcellinfoty;
                   var handled: Boolean);
   procedure setupeditorev(const sender: tcustomtextedit);
 end;
var
 mainfo: tmainfo;
 
implementation
uses
 main_mfm,mseformatpngread,mseformatjpgread;
 
procedure tmainfo.insertimageev(const sender: TObject);
begin
 if imagefiledialog.execute() = mr_ok then begin
  grid.row:= grid.insertrow(grid.row);
  image.loadfromfile(imagefiledialog.controller.filename);
 end;
end;

procedure tmainfo.drawtextev(const sender: tcustomtextedit;
               const canvas: tcanvas; const atext: richstringty;
               const cellinfo: pcellinfoty; var handled: Boolean);
begin
 if cellinfo <> nil then begin
  if image[cellinfo^.cell.row] <> '' then begin
   image.drawimage(canvas,cellinfo,cellinfo^.innerrect);
   handled:= true;
  end;
 end
 else begin //focused cell
  if (grid.row >= 0) and (image.value <> '') then begin
   image.drawimage(canvas,nil,
                       deflaterect(sender.paintrect,sender.getcellframe()));
   handled:= true;
  end;
 end;
end;

procedure tmainfo.setupeditorev(const sender: tcustomtextedit);
begin
 sender.readonly:= image.value <> '';
end;

end.
