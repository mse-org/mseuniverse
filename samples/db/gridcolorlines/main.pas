unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,mdb,msebufdataset,msedb,
 mseifiglob,mselocaldataset,msedataedits,msedbedit,mseedit,msegraphedits,
 msegrids,mseificomp,mseificompglob,mselookupbuffer,msescrollbar,msestrings,
 msetypes;

type
 tmainfo = class(tmainform)
   ds: tlocaldataset;
   dataso: tmsedatasource;
   tdbnavigator1: tdbnavigator;
   tdbwidgetgrid1: tdbwidgetgrid;
   colornumed: tdbintegeredit;
   stringed: tdbstringedit;
   tdbstringgrid1: tdbstringgrid;
   procedure befdraw(const sender: tcol; const canvas: tcanvas;
                   var cellinfo: cellinfoty; var processed: Boolean);
   procedure afraw(const sender: tcol; const canvas: tcanvas;
                   const cellinfo: cellinfoty);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
 
procedure tmainfo.befdraw(const sender: tcol; const canvas: tcanvas;
               var cellinfo: cellinfoty; var processed: Boolean);
begin
 if ds.fieldbyname('str1').isnull then begin
  cellinfo.color:= cl_infobackground;
 end;
// if stringed[cellinfo.cell.row] = '' then begin
//  cellinfo.color:= cl_infobackground;
// end;
end;

procedure tmainfo.afraw(const sender: tcol; const canvas: tcanvas;
               const cellinfo: cellinfoty);
begin
 if ds.fieldbyname('str1').isnull then begin
  canvas.drawline(nullpoint,mp(20,20), cl_red);
 end;
end;

end.
