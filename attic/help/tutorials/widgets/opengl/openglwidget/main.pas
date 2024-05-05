unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 msegui,mseclasses,mseforms,msetypes,msewindowwidget,mseopenglwidget,
 msegraphutils,msedrawtext,mseevent,msegraphics,msesimplewidgets,msestrings,
 msewidgets,msedataedits,msedatalist,msedropdownlist,mseformatstr,
 mseinplaceedit,msestat,msestatfile,msewidgetgrid,msedispwidgets,mseguiglob,
 mseedit,mseglob,mseifiglob,msemenus,msetimer;

type
 tmainfo = class(tmseform)
   openglwidget: topenglwidget;
   rotx: trealedit;
   roty: trealedit;
   rotz: trealedit;
   tstatfile1: tstatfile;
   fps: trealedit;
   fpsdisp: trealdisp;
   procedure clientrectchangedexe(const sender: tcustomwindowwidget);
   procedure fpssetvalue(const sender: TObject; var avalue: realty;
                   var accept: Boolean);
   procedure showexe(const sender: TObject);
   procedure rotentexe(const sender: TObject);
   procedure createwinidexe(const sender: tcustomwindowwidget;
                   const aparent: winidty; const awidgetrect: rectty;
                   var aid: winidty);
   procedure renderexe(const sender: tcustomopenglwidget;
                   const aupdaterect: rectty);
  private
   rendercount: integer;
   renderstart: longword;
   frotx,froty,frotz: real;
 end;

var
 mainfo: tmainfo;

implementation
uses
 main_mfm,msegl,mseglu,msesysutils; 

procedure tmainfo.renderexe(const sender: tcustomopenglwidget;
               const aupdaterect: rectty);
var
 lwo1: longword;
 int1: integer;
begin
 glclear(gl_color_buffer_bit);

 frotx:= frac(frotx+rotx.value*sender.renderstep);
 froty:= frac(froty+roty.value*sender.renderstep);
 frotz:= frac(frotz+rotz.value*sender.renderstep);

 glpushmatrix();
 glrotatef(frotx*360,1,0,0);
 glrotatef(froty*360,0,1,0);
 glrotatef(frotz*360,0,0,1);

 glbegin(gl_quads);
   glcolor3f(1,0,0);
   glvertex3f(-0.5,-0.5,0);
   glcolor3f(0,1,0);
   glvertex3f(0.5,-0.5,0);
   glcolor3f(0,0,1);
   glvertex3f(0.5,0.5,0);
   glcolor3f(1,1,1);
   glvertex3f(-0.5,0.5,0);
 glend();
 glpopmatrix();

 inc(rendercount);
 int1:= integer(sender.rendertimestampus-renderstart);
 if int1 > 1000000 then begin
  fpsdisp.value:= (rendercount*1000000)/int1;
  rendercount:= 0;
  renderstart:= sender.rendertimestampus;
 end;
end;

procedure tmainfo.clientrectchangedexe(const sender: tcustomwindowwidget);
begin
 glmatrixmode(gl_projection);
 glloadidentity();
 gluperspective(45,sender.aspect,1,10);
 glmatrixmode(gl_modelview);
end;

procedure tmainfo.fpssetvalue(const sender: tobject; var avalue: realty;
               var accept: boolean);
begin
 openglwidget.fpsmax:= avalue;
 renderstart:= timestamp;
end;

procedure tmainfo.rotentexe(const sender: tobject);
begin
 frotx:= 0;
 froty:= 0;
 frotz:= 0;
end;

procedure tmainfo.createwinidexe(const sender: tcustomwindowwidget;
               const aparent: winidty; const awidgetrect: rectty;
               var aid: winidty);
begin
{ does not work
 glenable(gl_blend);
 glblendfunc(gl_src_alpha_saturate,gl_one);
 glenable(gl_polygon_smooth);
}
 glmatrixmode(gl_modelview);
 glloadidentity();
 gltranslatef(0,0,-2);
end;

procedure tmainfo.showexe(const sender: tobject);
begin
 renderstart:= timestamp;
end;

end.
