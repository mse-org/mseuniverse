unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msefft,
 msesimplewidgets,mseact,msedataedits,mseedit,mseificomp,mseificompglob,
 mseifiglob,msestatfile,msestream,msestrings,sysutils,mserealsumedit,msechart,
 msesplitter;

type
 signalkindty = (sk_sine,sk_square,sk_sawtooth,sk_triangle);
 
 tmainfo = class(tmainform)
   fftcomp: tfft;
   tbutton1: tbutton;
   samplecounted: tintegeredit;
   tstatfile1: tstatfile;
   samplefrequed: trealsumedit;
   signaled: tenumedit;
   sigfrequed: trealsumedit;
   windowed: tenumedit;
   timedisp: tchart;
   frequdisp: tchart;
   tsplitter1: tsplitter;
   procedure runev(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
 
procedure tmainfo.runev(const sender: TObject);
var
 ar1: realarty;
 timescale: flo64;
 i1: int32;
 f1: flo64;
begin
 setlength(ar1,samplecounted.value);
 timescale:= sigfrequed.value / samplefrequed.value;
 case signalkindty(signaled.value) of
  sk_sine: begin
   timescale:= timescale*2*pi;
   for i1:= 0 to high(ar1) do begin
    ar1[i1]:= sin(i1*timescale);
   end;
  end;
  sk_square: begin
   timescale:= timescale*2;
   for i1:= 0 to high(ar1) do begin
    if odd(trunc(i1*timescale)) then begin
     ar1[i1]:= -1;
    end
    else begin
     ar1[i1]:= 1;
    end;
   end;
  end;
  sk_sawtooth: begin
   for i1:= 0 to high(ar1) do begin
    ar1[i1]:= 2*frac(i1*timescale)-1;
   end;
  end;
  sk_triangle: begin
   for i1:= 0 to high(ar1) do begin
    f1:= frac(i1*timescale)*4;
    if f1 >= 3 then begin
     ar1[i1]:= f1-4;
    end
    else begin
     if f1 >= 2 then begin
      ar1[i1]:= 2-f1;
     end
     else begin
      if f1 >= 1 then begin
       ar1[i1]:= 2-f1;
      end
      else begin
       ar1[i1]:= f1;
      end;
     end;
    end;
   end;
  end;
 end;
 timedisp.traces[0].ydata:= ar1;
 fftcomp.windowfunc:= windowfuncty(windowed.value);
 fftcomp.inpreal:= ar1;
 frequdisp.traces[0].ydata:= fftcomp.outreal;
end;

end.
