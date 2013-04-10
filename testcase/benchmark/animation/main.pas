unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseforms,msedataedits,msegraphedits,msegui,msesimplewidgets,
 msetimer,msestatfile,msewidgets,msetypes,msegraphics,mseifiglob,msemenus;

type
 tmainfo = class(tmainform)
   tbooleanedit2: tbooleanedit;
   fadehorzconcave: tfacecomp;
   bu: tbutton;
   ti: ttimer;
   tstatfile1: tstatfile;
   trealedit1: trealedit;
   step: tintegeredit;
   tsimplewidget1: tsimplewidget;
   mmtimer: tbooleanedit;
   procedure tiexe(const sender: TObject);
   procedure onsetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure tiset(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
   procedure fpssetexe(const sender: TObject; var avalue: realty;
                   var accept: Boolean);
   procedure mmtimersetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
  private
   up: boolean;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,msegraphutils{$ifdef mswindows},msesystimer{$endif};
 
procedure tmainfo.tiexe(const sender: TObject);
var
 int1: integer;
 co1: colorty;
 pt1: pointty;
begin
 int1:= step.value;
 pt1:= bu.pos;
 with pt1 do begin
  if up then begin
   y:= y - int1;
   if y < 100 then begin
    up:= false;
   end;
  end
  else begin
   y:= y + int1;
   if y > 200 then begin
    up:= true;
   end;
  end;
  int1:= 300 - y;
  x:= y;
 end;
 with rgbtriplety(co1) do begin
  res:= 0;
  red:= int1;
  green:= int1;
  blue:= int1;
 end;
 bu.face.fade_color[2]:= co1;
 bu.face.fade_pos[1]:= (int1-50) / 100;
 bu.font.color:= hsbtorgb(38,95,int1*100 div 200);
 bu.pos:= pt1;
end;

procedure tmainfo.onsetexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 ti.enabled:= avalue;
end;

procedure tmainfo.tiset(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
 ti.interval:= avalue;
end;

procedure tmainfo.fpssetexe(const sender: TObject; var avalue: realty;
               var accept: Boolean);
begin
 ti.interval:= round(1000000/avalue);
end;

procedure tmainfo.mmtimersetexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
{$ifdef mswindows}
 setmmtimer(avalue);
{$endif}
end;

end.
