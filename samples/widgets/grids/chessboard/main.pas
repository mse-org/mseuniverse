unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{The example is based on eschecs
http://www.eschecs.fr/
from Roland Chastain
}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msegrids,
 msebitmap,msedragglob,msestatfile;

const
 cellwidth = 40;
 cellheight = 40;
 
type
 piecekindty = (pk_none,pk_pawn,pk_knight,
                    pk_bishop,pk_rook,pk_queen,pk_king);
 piececolorty = (pc_white,pc_black);

 cellstatety = (cs_black,cs_dragsource,cs_reject,cs_accept);
 cellstatesty = set of cellstatety;
 
 colty = (col_a,col_b,col_c,col_d,col_e,col_f,col_g,col_h);
 rowty = (row_1,row_2,row_3,row_4,row_5,row_6,row_7,row_8);
 
 cellty = record
  col: colty;
  row: rowty;
 end;

 celldataty = record
  piece: piecekindty;
  color: piececolorty;
  state: cellstatesty;
 end;

 cellsty = array[colty,rowty] of celldataty;
 
 boardty = record
  cells: cellsty;
  dragpiece: celldataty;
  dragpos: pointty;
  dragdest: cellty;
 end;
 pboardty = ^boardty;
 
 tmainfo = class(tmainform)
   grid: tdrawgrid;
   pieceimages: timagelist;
   cellimages: timagelist;
   tmainmenu1: tmainmenu;
   concave: tfacecomp;
   tstatfile1: tstatfile;
   mainmenuframe: tframecomp;
   menuitemframe: tframecomp;
   procedure createev(const sender: TObject);
   procedure drawcellev(const sender: tcol; const canvas: tcanvas;
                   var cellinfo: cellinfoty);
   procedure boardpaintev(const sender: twidget; const acanvas: tcanvas);
   procedure exitev(const sender: TObject);
   procedure resetev(const sender: TObject);
   procedure dragbeginev(const asender: TObject; const apos: pointty;
                   var adragobject: tdragobject; var processed: Boolean);
   procedure dragoverev(const asender: TObject; const apos: pointty;
                   var adragobject: tdragobject; var accept: Boolean;
                   var processed: Boolean);
   procedure dragdropev(const asender: TObject; const apos: pointty;
                   var adragobject: tdragobject; var processed: Boolean);
   procedure dragendev(const asender: TObject; const apos: pointty;
                   var adragobject: tdragobject; const accepted: Boolean;
                   var processed: Boolean);
  private
   fboard: boardty;
   function getcells(const acell: cellty): celldataty;
   procedure setcells(const acell: cellty; const avalue: celldataty);
   function getcellpiece(const acell: cellty): piecekindty;
   procedure setcellpiece(const acell: cellty; const avalue: piecekindty);
   function getcellcolor(const acell: cellty): piececolorty;
   procedure setcellcolor(const acell: cellty; const avalue: piececolorty);
   function getcellstate(const acell: cellty): cellstatesty;
   procedure setcellstate(const acell: cellty; const avalue: cellstatesty);
  protected
   fdragsource: cellty;
   fdragdest: cellty;
   procedure boardchanged();
   procedure invalidateboardcell(const acell: cellty);
   function dragrect(): rectty;
   function cellbygridcoord(const gridcell: gridcoordty): celldataty;
   procedure drawcell(const acanvas: tcanvas; const apos: pointty;
                                              const acelldata: celldataty);
   procedure checkdrag(const adragobject: tdragobject; const apos: pointty;
                                   var accept: boolean; const amove: boolean);
   property cells[const acell: cellty]: celldataty read getcells write setcells;
   property cellpiece[const acell: cellty]: piecekindty read getcellpiece
                                                             write setcellpiece;
   property cellcolor[const acell: cellty]: piececolorty read getcellcolor
                                                             write setcellcolor;
   property cellstate[const acell: cellty]: cellstatesty read getcellstate
                                                             write setcellstate;
  public
 end;

var
 mainfo: tmainfo;

implementation

uses
 main_mfm;

type
 tpiecedragobject = class(tcelldragobject)
  private
   fboardcell: cellty;
   fboard: pboardty;
  public
   constructor create(const board: boardty;
                   const agrid: tcustomgrid; var ainstance: tdragobject;
                                                          const apos: pointty);
   property boardcell: cellty read fboardcell;
 end;
 
const
 pieceorder: array[colty] of piecekindty = 
    (pk_rook,pk_knight,pk_bishop,pk_queen,pk_king,pk_bishop,pk_knight,pk_rook);

function gridcoordtocell(const acoord: gridcoordty): cellty;
begin
 result.col:= colty(acoord.col);
 result.row:= rowty(7-acoord.row);
end;

function gridcoordtocell(const acoord: gridcoordty; out cell: cellty): boolean;
begin
 result:= (acoord.col >= 0) and (acoord.row >= 0) and 
                                    (acoord.col < 8) and (acoord.row < 8);
 if result then begin
  cell:= gridcoordtocell(acoord);
 end;
end;

function celltogridcoord(const acell: cellty): gridcoordty;
begin
 result.col:= ord(acell.col);
 result.row:= 7-ord(acell.row);
end;

function piecemove(var board: boardty; const source,dest: cellty;
                                             const move: boolean): boolean;
                                                   //returns true if allowed
var
 state1: cellstatesty;
begin
 //check chess rules here

 result:= board.cells[dest.col,dest.row].piece = pk_none;
 if result and move then begin
  state1:= board.cells[dest.col,dest.row].state;
  board.cells[dest.col,dest.row]:= board.cells[source.col,source.row];
  board.cells[dest.col,dest.row].state:= state1; //restore
  board.cells[source.col,source.row].piece:= pk_none;
 end;
end;

procedure enddrag(var board: boardty);
var
 c1: colty;
 r1: rowty;
begin
 with board do begin
  dragpiece.piece:= pk_none;
  for c1:= low(c1) to high(c1) do begin
   for r1:= low(r1) to high(r1) do begin
    cells[c1,r1].state:= cells[c1,r1].state - 
                       [cs_dragsource,cs_reject,cs_accept]; //remove drag states
   end;
  end;
 end;
end;

{ tpiecedragobject }

constructor tpiecedragobject.create(const board: boardty;
               const agrid: tcustomgrid; var ainstance: tdragobject;
               const apos: pointty);
begin
 fboard:= @board;
 if not gridcoordtocell(agrid.cellatpos(apos),fboardcell) then begin
  componentexception(agrid,'Invalid cell');
 end;
 inherited create(agrid,ainstance,apos);
end;

procedure initboard(var board: boardty);
var
 c1: colty;
 r1: rowty;
begin
 fillchar(board,sizeof(board),0);
 for c1:= low(colty) to high(colty) do begin
  with board.cells[c1,row_2] do begin
   piece:= pk_pawn;
   color:= pc_white;
  end;
  with board.cells[c1,row_1] do begin
   color:= pc_white;
   piece:= pieceorder[c1];
  end;
  with board.cells[c1,row_7] do begin
   piece:= pk_pawn;
   color:= pc_black;
  end;
  with board.cells[c1,row_8] do begin
   color:= pc_black;
   piece:= pieceorder[c1];
  end;
  if odd(ord(c1)) then begin
   for r1:= low(r1) to high(r1) do begin
    if odd(ord(r1)) then begin
     board.cells[c1,r1].state:= [cs_black];
    end;
   end;
  end
  else begin
   for r1:= low(r1) to high(r1) do begin
    if not odd(ord(r1)) then begin
     board.cells[c1,r1].state:= [cs_black];
    end;
   end;
  end;
 end;
end;
 
{ tmainfo }

procedure tmainfo.createev(const sender: TObject);
begin
 resetev(nil); //init board
end;

function tmainfo.getcells(const acell: cellty): celldataty;
begin
 result:= fboard.cells[acell.col,acell.row];
end;

procedure tmainfo.setcells(const acell: cellty; const avalue: celldataty);
begin
 fboard.cells[acell.col,acell.row]:= avalue;
 grid.invalidatecell(celltogridcoord(acell));
end;

function tmainfo.getcellpiece(const acell: cellty): piecekindty;
begin
 result:= fboard.cells[acell.col,acell.row].piece;
end;

procedure tmainfo.setcellpiece(const acell: cellty; const avalue: piecekindty);
begin
 with fboard.cells[acell.col,acell.row] do begin
  if piece <> avalue then begin
   piece:= avalue;
   invalidateboardcell(acell);
  end;
 end;
end;

function tmainfo.getcellcolor(const acell: cellty): piececolorty;
begin
 result:= fboard.cells[acell.col,acell.row].color;
end;

procedure tmainfo.setcellcolor(const acell: cellty; const avalue: piececolorty);
begin
 with fboard.cells[acell.col,acell.row] do begin
  if color <> avalue then begin
   color:= avalue;
   invalidateboardcell(acell);
  end;
 end;
end;

function tmainfo.getcellstate(const acell: cellty): cellstatesty;
begin
 result:= fboard.cells[acell.col,acell.row].state;
end;

procedure tmainfo.setcellstate(const acell: cellty; const avalue: cellstatesty);
begin
 with fboard.cells[acell.col,acell.row] do begin
  if state <> avalue then begin
   state:= avalue;
   invalidateboardcell(acell);
  end;
 end;
end;

procedure tmainfo.boardchanged();
begin
 grid.invalidate();
end;

procedure tmainfo.invalidateboardcell(const acell: cellty);
begin
 grid.invalidatecell(celltogridcoord(acell));
end;

function tmainfo.dragrect(): rectty;
begin
 if fboard.dragpiece.piece <> pk_none then begin
  result.x:= fboard.dragpos.x - cellwidth div 2;
  result.y:= fboard.dragpos.y - cellheight div 2;
  result.cx:= cellwidth;
  result.cy:= cellheight;
 end
 else begin
  result:= nullrect;
 end;
end;

function tmainfo.cellbygridcoord(const gridcell: gridcoordty): celldataty;
begin
 result:= fboard.cells[colty(gridcell.col),rowty(7-gridcell.row)];
end;

procedure tmainfo.drawcell(const acanvas: tcanvas; const apos: pointty;
                                               const acelldata: celldataty);
begin
 with acelldata do begin
  if cs_dragsource in state then begin
   acanvas.fillrect(mr(0,0,cellwidth,cellheight),cl_ltyellow);
  end
  else begin
   if cs_reject in state then begin
    acanvas.fillrect(mr(0,0,cellwidth,cellheight),cl_ltred);
   end
   else begin
    if cs_accept in state then begin
     acanvas.fillrect(mr(0,0,cellwidth,cellheight),cl_ltgreen);
    end;
   end;
  end;
  if cs_black in state then begin
   cellimages.paint(acanvas,1,apos);
  end
  else begin
   cellimages.paint(acanvas,0,apos);
  end;
  pieceimages.paint(acanvas,ord(piece)-1,apos,
                cl_default,cl_default,cl_default,ord(color));
 end;
end;

procedure tmainfo.drawcellev(const sender: tcol; const canvas: tcanvas;
               var cellinfo: cellinfoty);
begin
 drawcell(canvas,nullpoint,cellbygridcoord(cellinfo.cell));
end;

procedure tmainfo.boardpaintev(const sender: twidget; const acanvas: tcanvas);
begin
 drawcell(acanvas,dragrect().pos,fboard.dragpiece); 
end;

procedure tmainfo.checkdrag(const adragobject: tdragobject; const apos: pointty;
                                  var accept: boolean; const amove: boolean);
var
 cell1: cellty;
begin
 grid.invalidaterect(dragrect()); //old pos
 fboard.dragpos:= apos;
 grid.invalidaterect(dragrect()); //new pos
 cellstate[fboard.dragdest]:= cellstate[fboard.dragdest] - 
                                             [cs_accept,cs_reject];
 accept:= gridcoordtocell(grid.cellatpos(fboard.dragpos),cell1);
 if accept then begin
  fboard.dragdest:= cell1;
  with tpiecedragobject(adragobject) do begin
   accept:= piecemove(self.fboard,boardcell,cell1,amove);
  end;
  if accept then begin
   cellstate[cell1]:= cellstate[cell1] + [cs_accept];
  end
  else begin
   cellstate[cell1]:= cellstate[cell1] + [cs_reject];
  end;
 end;
end;

procedure tmainfo.dragbeginev(const asender: TObject; const apos: pointty;
               var adragobject: tdragobject; var processed: Boolean);
var
 cell1: cellty;
begin
 if gridcoordtocell(grid.cellatpos(apos),cell1) then begin
  if cellpiece[cell1] <> pk_none then begin
   adragobject:= tpiecedragobject.create(fboard,grid,adragobject,apos);
   fboard.dragpiece:= cells[cell1];
   fboard.dragpiece.state:= [];
   fboard.dragpos:= apos;
   cellstate[cell1]:= cellstate[cell1] + [cs_dragsource];
  end;
 end;
end;

procedure tmainfo.dragoverev(const asender: TObject; const apos: pointty;
               var adragobject: tdragobject; var accept: Boolean;
               var processed: Boolean);
begin
 checkdrag(adragobject,apos,accept,false);
end;

procedure tmainfo.dragdropev(const asender: TObject; const apos: pointty;
               var adragobject: tdragobject; var processed: Boolean);
var
 b1: boolean;
begin
 b1:= true;
 checkdrag(adragobject,apos,b1,true);
end;

procedure tmainfo.dragendev(const asender: TObject; const apos: pointty;
               var adragobject: tdragobject; const accepted: Boolean;
               var processed: Boolean);
begin
 grid.invalidate();
 enddrag(fboard);
end;

procedure tmainfo.resetev(const sender: TObject);
begin
 initboard(fboard);
 boardchanged();
end;

procedure tmainfo.exitev(const sender: TObject);
begin
 application.terminate();
end;

end.
