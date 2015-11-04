unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,mseimage,
 msetimer;

type
 tmainfo = class(tmainform)
   image: timage;
   timer: ttimer;
   procedure timerexe(const sender: TObject);
   procedure createexe(const sender: TObject);
   procedure clientmouseexe(const sender: twidget; var ainfo: mouseeventinfoty);
  private
   fup: boolean;
   fopacity: real;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;

const
 fps = 20;
 animtime = 0.3; //seconds 
 opacitystep = 1/(animtime*fps);

procedure tmainfo.timerexe(const sender: TObject);
begin
 if fup then begin
  fopacity:= fopacity + opacitystep;
  if fopacity > 1 then begin
   fopacity:= 1;
   timer.enabled:= false;
  end;
 end
 else begin
  fopacity:= fopacity - opacitystep;
  if fopacity < 0 then begin
   fopacity:= 0;
   timer.enabled:= false;
  end;
 end;
 image.face.fade_opacity:= opacitycolor(fopacity);
end;

procedure tmainfo.createexe(const sender: TObject);
begin
 timer.interval:= round(1000000 / fps); //micro seconds
end;

procedure tmainfo.clientmouseexe(const sender: twidget;
               var ainfo: mouseeventinfoty);
begin
 case ainfo.eventkind of
  ek_clientmouseenter: begin
   fup:= true;
   timer.enabled:= true;
  end;
  ek_clientmouseleave: begin
   fup:= false;
   timer.enabled:= true;
  end;
 end;
end;

end.
