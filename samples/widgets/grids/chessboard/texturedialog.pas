unit texturedialog;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,mseact,
 msebitmap,msedataedits,msedatanodes,msedragglob,msedropdownlist,mseedit,
 msefiledialog,msegrids,msegridsglob,mseificomp,mseificompglob,mseifiglob,
 mselistbrowser,msestatfile,msestream,msesys,sysutils,msegraphedits,msescrollbar;
type
 ttexturedialogfo = class(tmseform)
   whiteboardtexture: tfilenameedit;
   tstatfile1: tstatfile;
   blackboardtexture: tfilenameedit;
   nohatching: tbooleanedit;
   procedure createev(const sender: TObject);
   procedure dataenteredev(const sender: TObject);
 end;

implementation
uses
 texturedialog_mfm,mserttistat,main;
 
procedure ttexturedialogfo.createev(const sender: TObject);
begin
 objecttovalues(mainfo.chessoptions,self);
end;

procedure ttexturedialogfo.dataenteredev(const sender: TObject);
begin
 with mainfo.chessoptions do begin
  whiteboardtexture:= self.whiteboardtexture.value;
  blackboardtexture:= self.blackboardtexture.value;
  nohatching:= self.nohatching.value;
 end;
end;

end.
