unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedial,
 msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,msestatfile,
 msestream,msestrings,sysutils,msegraphedits,msescrollbar,msetimer,
 msedispwidgets,mserichstring;

type
 tmainfo = class(tmainform)
   disp: tdial;
   valueed: trealedit;
   slider: tslider;
   timer: ttimer;
   samplinged: trealedit;
   damped: trealedit;
   lped: trealedit;
   currentvalue: trealdisp;
   tstatfile1: tstatfile;
   procedure sliderset(const sender: TObject; var avalue: realty;
                   var accept: Boolean);
   procedure valueset(const sender: TObject; var avalue: realty;
                   var accept: Boolean);
   procedure paramchangeexe(const sender: TObject);
   procedure tiexe(const sender: TObject);
   procedure dispdatachange(const sender: TObject; var avalue: Real);
  private
   fz1,fz2: real; //sample storage
   fa1,fa2: real; //fa0 = 1
   fb0,fb1,fb2: real; //coeffitients
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
 
procedure tmainfo.sliderset(const sender: TObject; var avalue: realty;
               var accept: Boolean);
begin
 valueed.value:= avalue;
end;

procedure tmainfo.valueset(const sender: TObject; var avalue: realty;
               var accept: Boolean);
begin
 slider.value:= avalue;
end;

procedure tmainfo.paramchangeexe(const sender: TObject);
var
 w0T: real; //normalised lowpass frequency
 damp: real;
 dcgaincorr: real;
begin
 w0T:= 2*pi*lped.value*samplinged.value;
 damp:= damped.value;
 dcgaincorr:= (-w0T*exp(-w0T*damp)*sin(w0T*sqrt(-damp*damp +1)))/
              (sqrt(-damp*damp + 1)*
                (2*cos(w0T*sqrt(-damp*damp +1))*exp(-w0T*damp) -
                 exp(-2*w0T*damp) - 1
                )
              );
 fb0:= 0;
 fb1:= (w0T/(sqrt(1-damp*damp))) * exp(-damp*w0T) * sin(w0T*sqrt(1-damp*damp));
 fb2:= 0;
 fa1:= -2*exp(-damp*w0T)*cos(w0T*sqrt(1-damp*damp));
 fa2:= exp(-2*damp*w0T); 

 fb0:= fb0/dcgaincorr; 
 fb1:= fb1/dcgaincorr; 
 fb2:= fb2/dcgaincorr;
 
 timer.interval:= round(samplinged.value*1000000); //micro seconds
 timer.enabled:= true;
end;

//     +---------+---------+---------+--->
//     |       -a1       -a2       -aN-1
//     +---(z)<--+---(z)<--+---(z)<--+
//     b0       b1        b2        bN-1
// >---+---------+---------+---------+

procedure tmainfo.tiexe(const sender: TObject);
var
 Ue,Ua: real;
begin
 Ue:= valueed.value;
 Ua:= Ue*fb0 + fz1;
 fz1:= fz2 + Ue*fb1 - fa1*Ua;
 fz2:= Ue*fb2 - fa2*Ua;
 if abs(currentvalue.value - Ua) > 0.0002 then begin
  currentvalue.value:= Ua;
 end;
end;

procedure tmainfo.dispdatachange(const sender: TObject; var avalue: Real);
begin
 disp.dial.markers[0].value:= avalue*10;
end;

end.
