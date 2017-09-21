unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msegraphedits,mseificomp,mseificompglob,mseifiglob,msescrollbar,msebitmap,
 msesimplewidgets,msestatfile,msetimer;

type
 tmainfo = class(tmainform)
   frameimage: timagelist;
   tframecomp1: tframecomp;
   button1: tdatabutton;
   button0: tdatabutton;
   button2: tdatabutton;
   button3: tdatabutton;
   button4: tdatabutton;
   icons: timagelist;
   tstatfile1: tstatfile;
   tanimtimer1: tanimtimer;
   anim: tanimitemcomp;
   panel: tgroupbox;
   tbutton1: tbutton;
   procedure clientmouseev(const sender: twidget; var ainfo: mouseeventinfoty);
   procedure createev(const sender: TObject);
   procedure animtickev(const sender: tanimitem; const avalue: Real);
   procedure animstartev(const sender: TObject);
   procedure clearev(const sender: TObject);
   procedure setvalueev(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
  private
   fbuttons: array[0..4] of tdatabutton;
   startcolor,endcolor: colorty;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
 
procedure tmainfo.clientmouseev(const sender: twidget;
               var ainfo: mouseeventinfoty);
var
 bu1: tcustomdatabutton;
begin
 case ainfo.eventkind of
  ek_clientmouseenter: begin
   endcolor:= fbuttons[sender.tag].valuefaces[0].fade_color[1];
   anim.restart();
  end;
  ek_clientmouseleave: begin
   bu1:= fbuttons[0].checkeditem;
   if bu1 <> nil then begin
    endcolor:= bu1.valuefaces[0].fade_color[1];
   end
   else begin
    endcolor:= cl_background;
   end;
   anim.restart();
  end;
 end;
end;

procedure tmainfo.createev(const sender: TObject);
begin
 fbuttons[0]:= button0;
 fbuttons[1]:= button1;
 fbuttons[2]:= button2;
 fbuttons[3]:= button3;
 fbuttons[4]:= button4;
end;

procedure tmainfo.animstartev(const sender: TObject);
begin
 startcolor:= panel.color;
end;

procedure tmainfo.animtickev(const sender: tanimitem; const avalue: Real);
begin
 panel.color:= blendcolor(avalue,startcolor,endcolor);
end;

procedure tmainfo.setvalueev(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
 if avalue = 0 then begin
  anim.enabled:= false;
  with fbuttons[twidget(sender).tag] do begin
   panel.color:= valuefaces[0].fade_color[1];
   panel.frame.caption:= caption;
  end;
 end;
end;

procedure tmainfo.clearev(const sender: TObject);
var
 bu1: tcustomdatabutton;
begin
 bu1:= fbuttons[0].checkeditem;
 if bu1 <> nil then begin
  bu1.value:= -1;
 end;
 anim.enabled:= false;
 panel.frame.caption:= '';
 panel.color:= cl_background;
end;

end.
