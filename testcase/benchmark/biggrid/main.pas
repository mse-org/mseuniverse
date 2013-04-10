unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseskin,mseforms,msegrids,msegui;

type
 tmainfo = class(tmainform)
   grid: tstringgrid;
   nullface: tfacecomp;
   fadecontainer: tfacecomp;
   skin: tskincontroller;
   fadevertconcave: tfacecomp;
   fadehorzconcave: tfacecomp;
   fadehorzconvex: tfacecomp;
   fadevertkonvex: tfacecomp;
   procedure createexe(const sender: TObject);
 end;
var
 mainfo: tmainfo;
 
implementation
uses
 main_mfm;

procedure tmainfo.createexe(const sender: TObject);
begin
 grid.rowcount:= 1000000;
end;

end.
