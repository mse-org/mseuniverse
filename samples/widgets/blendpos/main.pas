unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,mseimage,
 msebitmap;

type
 tmainfo = class(tmainform)
   image: timage;
   tbitmapcomp1: tbitmapcomp;
   procedure childmouseeventexe(const sender: twidget;
                   var ainfo: mouseeventinfoty);end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;

procedure tmainfo.childmouseeventexe(const sender: twidget;
                                                  var ainfo: mouseeventinfoty);
begin
 image.face.image.center:= TranslateWidgetToPaintPoint(ainfo.pos,sender,image);
end;

end.
