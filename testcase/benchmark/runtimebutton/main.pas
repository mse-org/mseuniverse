unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseforms,msesimplewidgets,msedataedits,msegui,msegraphutils,
 msewidgets,classes,mclasses;

type
 tmainfo = class(tmainform)
   tbutton1: tbutton;
   bucoed: tintegeredit;
   tbutton2: tbutton;
   fadevertkonvex: tfacecomp;
   fadehorzconvex: tfacecomp;
   procedure creexe(const sender: TObject);
   procedure freeexe(const sender: TObject);
   procedure loadedexe(const sender: TObject);
  private
   initwidgetcount: integer;
 end;
 
var
 mainfo: tmainfo;
 
implementation
uses
 main_mfm;
const
 smallbuttonsize: sizety = (cx: 7; cy: 7);
 
type
 tsmallbutton = class(tbutton)
  public
   constructor create(aowner: tcomponent); override;
   constructor create(const aowner: tcomponent; const aparent: twidget;
                                               const apos: pointty);
 end;

{ tsmallbutton }

constructor tsmallbutton.create(aowner: tcomponent);
begin
 inherited;
 fwidgetrect.size:= smallbuttonsize;
end;

constructor tsmallbutton.create(const aowner: tcomponent;
               const aparent: twidget; const apos: pointty);
begin
 create(aowner);
 fwidgetrect.pos:= apos;
// fwidgetrect.size:= smallbuttonsize;
// size:= smallbuttonsize;
 setlockedparentwidget(aparent);
end;

procedure tmainfo.creexe(const sender: TObject);
var
 pt1: pointty;
 int1,cx1,cy1: integer;
 co1: twidget;
begin
 freeexe(nil);
 co1:= container;
 co1.beginupdate;
 cx1:= smallbuttonsize.cx+1;
 cy1:= smallbuttonsize.cy+1;
 pt1.y:= 32-smallbuttonsize.cy;
 for int1:= 0 to bucoed.value-1 do begin
  pt1.x:= pt1.x+cx1;
  if int1 mod 100 = 0 then begin
   pt1.y:= pt1.y + cy1;
   pt1.x:= 8;
  end;
//  tsmallbutton.create(nil,co1,pt1);
  with tsimplebutton.create(nil) do begin
   widgetrect:= mr(pt1,smallbuttonsize);
   parentwidget:= co1;
  end;
 end;
 co1.endupdate;
end;

procedure tmainfo.freeexe(const sender: TObject);
var
 int1: integer;
begin
 container.beginupdate;
 for int1:= container.widgetcount-1 downto initwidgetcount do begin
  container.widgets[int1].free;
 end;
 container.endupdate;
end;

procedure tmainfo.loadedexe(const sender: TObject);
begin
 initwidgetcount:= container.widgetcount;
end;

end.