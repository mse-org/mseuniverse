unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,
 msewidgets,sysutils,mseimage,msepolygon,msestrings,msetypes,
 msekeyboard;

type
 tmainfo = class(tmainform)
   tbutton1: tbutton;
   timage1: timage;
   tpaintbox1: tpaintbox;
   tbutton2: tbutton;
   tscrollbox1: tscrollbox;
   tbutton3: tbutton;
   tbutton4: tbutton;
   tpolygon1: tpolygon;
   procedure mainfo_onmouseevent(const sender: twidget;
                   var ainfo: mouseeventinfoty);
   procedure mainfo_onkeydown(const sender: twidget; var ainfo: keyeventinfoty);
   procedure mainfo_onkeyup(const sender: twidget; var ainfo: keyeventinfoty);
   procedure timage1_onmouseevent(const sender: twidget;
                   var ainfo: mouseeventinfoty);
   procedure tstockglyphbutton1_onexecute(const sender: TObject);
   procedure tpaintbox1_onpaint(const sender: twidget; const acanvas: tcanvas);
   procedure tpaintbox1_onmouseevent(const sender: twidget;
                   var ainfo: mouseeventinfoty);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,msesysutils;
procedure tmainfo.mainfo_onmouseevent(const sender: twidget;
               var ainfo: mouseeventinfoty);
begin
 debugwriteln('mouse move '+inttostr(ainfo.pos.x)+'; '+inttostr(ainfo.pos.y));
end;

procedure tmainfo.mainfo_onkeydown(const sender: twidget;
               var ainfo: keyeventinfoty);
begin
 debugwriteln(ainfo.chars);
end;

procedure tmainfo.mainfo_onkeyup(const sender: twidget;
               var ainfo: keyeventinfoty);
begin
 debugwriteln(ainfo.chars);
end;

procedure tmainfo.timage1_onmouseevent(const sender: twidget;
               var ainfo: mouseeventinfoty);
begin
 debugwriteln('mouse move (timage1) '+inttostr(ainfo.pos.x)+'; '+inttostr(ainfo.pos.y));
end;

procedure tmainfo.tstockglyphbutton1_onexecute(const sender: TObject);
begin
 showmessage('Test klik!');
end;

procedure tmainfo.tpaintbox1_onpaint(const sender: twidget;
               const acanvas: tcanvas);
begin
 acanvas.fillellipse(makerect(0,0,100,100),cl_blue, cl_red);
end;

procedure tmainfo.tpaintbox1_onmouseevent(const sender: twidget;
               var ainfo: mouseeventinfoty);
begin
 sender.getcanvas.drawpoint(ainfo.pos,cl_blue);
end;

end.
