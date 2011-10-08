unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 SysUtils,mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msegrids,msedataedits,mseedit,
 msestrings,msetypes,msesimplewidgets,msewidgets,msedispwidgets,msestatfile;

type
 tmainfo = class(tmseform)
   tbutton4: tbutton;
   tgroupbox3: tgroupbox;
   tgroupbox2: tgroupbox;
   coled: tintegeredit;
   colsed: tintegeredit;
   rowsed: tintegeredit;
   rowed: tintegeredit;
   tstringedit1: tstringedit;
   grid: tstringgrid;
   textdi: tstringdisp;
   tstatfile1: tstatfile;
   procedure button4_click(const sender: TObject);
   procedure colssetval(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
   procedure rowssetval(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
   procedure settext(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure layoutcha(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;

procedure tmainfo.layoutcha(const sender: TObject);
begin
 //set grid size before loading grid content fron statfile
 grid.datacols.count:= colsed.value;
 grid.rowcount:= rowsed.value;
end;
 
procedure tmainfo.colssetval(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
 grid.datacols.count:= avalue;
end;

procedure tmainfo.rowssetval(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
 grid.rowcount:= avalue;
end;

procedure tmainfo.settext(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 grid[coled.value][rowed.value]:= avalue;
end;

procedure tmainfo.button4_click(const sender: TObject);
begin
 if canparentclose then begin 
  //triggers storing of all edited values in form
  textdi.value:= grid[coled.value][rowed.value];
 end;
end;

end.
