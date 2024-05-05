unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msegrids,msestatfile,msestrings,
 msesplitter;

type
 tmainfo = class(tmseform)
   tstringgrid1: tstringgrid;
   tstatfile1: tstatfile;
   tsplitter1: tsplitter;
   tdrawgrid1: tdrawgrid;
   procedure onlo(const sender: TObject);
  private
   procedure dodrawcell(const sender: tcol; const canvas: tcanvas;
                   const cellinfo: cellinfoty);
 end;

var
 mainfo: tmainfo;

implementation
uses
 sysutils,mseeditglob,msedrawtext,main_mfm;

procedure tmainfo.dodrawcell(const sender: tcol; const canvas: tcanvas;
               const cellinfo: cellinfoty);
begin
 with cellinfo,cell do begin
  drawtext(canvas,'test '+inttostr(col)+','+inttostr(row),
                                            innerrect,[tf_ycentered]);
 end;
end;
 
procedure tmainfo.onlo(const sender: TObject);
var
 int1,int2: integer;
 mstr1: msestring;
begin
 with tstringgrid1 do begin
  fixcols.width:= 24; //default colwidth
  fixcols.count:= 1;
  with fixcols[-1] do begin
   numstart:= 1;
   numstep:= 1;
  end; 
  fixrows.count:= 1; //not needed, default is 1
  with fixrows[-1] do begin
   captions.count:= 2;
   captions[0].caption:= 'aa';
   captions[1].caption:= 'bb';
  end;
  datacols.count:= 2;
  datarowheight:= 16;
  rowcount:= 12;
  for int1:= 0 to 1 do begin
   mstr1:= 'test ' + inttostr(int1)+',';
   for int2:= 0 to rowhigh do begin
    items[makegridcoord(int1,int2)]:= mstr1 + inttostr(int2);
   end;
  end;
 end;
 
 with tdrawgrid1 do begin
  fixcols.width:= 24; //default colwidth
  fixcols.count:= 1;
  with fixcols[-1] do begin
   numstart:= 1;
   numstep:= 1;
  end; 
  fixrows.count:= 1; //not needed, default is 1
  with fixrows[-1] do begin
   captions.count:= 2;
   captions[0].caption:= 'aa';
   captions[1].caption:= 'bb';
  end;
  datacols.count:= 2;
  datacols[0].ondrawcell:= {$ifdef FPC}@{$endif}dodrawcell;
  datacols[1].ondrawcell:= {$ifdef FPC}@{$endif}dodrawcell;
  datarowheight:= 16;
  rowcount:= 12;
 end;
end;

end.
