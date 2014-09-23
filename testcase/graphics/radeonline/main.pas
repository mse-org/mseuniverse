unit main;
{$ifdef FPC}{$mode delphi}{$h+}{$endif}
interface
uses
 msegui,mseforms,mseguiglob,msescrollbar,msegrids_test,msetimer;
 
type
 tmainfo = class(tmseform)
   grid: msegrids_test.tstringgrid;
   ttimer1: ttimer;
   procedure loadedexe(const sender: TObject);
   procedure tiexe(const sender: TObject);
  private
 end;

var
 mainfo: tmainfo;

implementation
uses
 main_mfm,mseeditglob;

procedure tmainfo.loadedexe(const sender: TObject);
begin
 grid:= msegrids_test.tstringgrid.create(self);
 with grid do begin
  frame.sbvert.options:= [sbo_thumbtrack];
  frame.sbhorz.options:= [sbo_thumbtrack];
  anchors:= [];
  datacols.count:= 1;
  with datacols[0] do begin    
   width:= 439;
   options:= options+[co_readonly];
   optionsedit:= optionsedit - [scoe_focusrectonreadonly];
  end;
  rowcount:= 1;
  datarowheight:= 12;
 end;
 grid.parentwidget:= container; 
end;

procedure tmainfo.tiexe(const sender: TObject);
begin
 grid[0].invalidatecell(0);
end;

end.