unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msechart,msedataedits,
 mseedit,msegrids,msestrings,msetypes,msewidgetgrid,msestatfile,msebitmap;

type
 tmainfo = class(tmainform)
   chart: tchart;
   twidgetgrid1: twidgetgrid;
   xval: trealedit;
   yval: trealedit;
   tstatfile1: tstatfile;
   frequ: trealedit;
   amp: trealedit;
   imagelist: timagelist;
   xymarker: trealedit;
   procedure xymarkersetval(const sender: TObject; var avalue: realty;
                   var accept: Boolean);
   procedure sigdataentered(const sender: TObject);
   procedure yvalchange(const sender: tdatacol; const aindex: Integer);
   procedure xvalchange(const sender: tdatacol; const aindex: Integer);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;

procedure tmainfo.xymarkersetval(const sender: TObject; var avalue: realty;
               var accept: Boolean);
begin
 chart.ydials[0].markers[0].value:= avalue;
end;

procedure tmainfo.sigdataentered(const sender: TObject);
var
 ar1: complexarty;
 ar2: realarty;
 step: real;
 int1: integer;
begin
 setlength(ar1,round(frequ.value*200)+1);
 step:= 1/(length(ar1)-1);
 for int1:= 0 to high(ar1) do begin
  with ar1[int1] do begin
   re:= step * int1;
   im:= sin(2*pi*re*frequ.value) * amp.value;
  end;
 end;
 chart.traces.itembyname('xysinus').xydata:= ar1;
 setlength(ar2,length(ar1));
 for int1:= 0 to high(ar2) do begin
  ar2[int1]:= frac(step*int1*frequ.value+0.5) * (amp.value) + 0.5 - amp.value/2;
 end;
 chart.traces.itembyname('xseries').ydata:= ar2;
end;

procedure tmainfo.xvalchange(const sender: tdatacol; const aindex: Integer);
begin
 chart.traces.itembyname('xyscatter').xdata:= xval.gridvalues;
end;

procedure tmainfo.yvalchange(const sender: tdatacol; const aindex: Integer);
begin
 chart.traces.itembyname('xyscatter').ydata:= yval.gridvalues;
end;

end.
