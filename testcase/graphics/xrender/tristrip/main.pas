unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msewindowwidget;

type
 tmainfo = class(tmainform)
   xrenderwidget: twindowwidget;
   procedure clientpaintexe(const sender: tcustomwindowwidget;
                   const aupdaterect: rectty);
 end;
var
 mainfo: tmainfo;

implementation
uses
 main_mfm,mxrender,msex11gdi,mxft,xlib,xutil,x;
 
procedure tmainfo.clientpaintexe(const sender: tcustomwindowwidget;
                                                const aupdaterect: rectty);
const
 white: txrendercolor = (red: $ffff; green: $ffff; blue: $ffff; alpha: $ffff);
 black: txrendercolor = (red: $0000; green: $0000; blue: $0000; alpha: $ffff);
 points: array[0..5] of txpointfixed = (
  (x: 10 shl 16; y: 10 shl 16),
  (x: 10 shl 16; y: 30 shl 16),
  (x: 30 shl 16; y: 10 shl 16),
  (x: 30 shl 16; y: 30 shl 16),
  (x: 50 shl 16; y: 15 shl 16),
  (x: 50 shl 16; y: 25 shl 16)
 );
 
var
 format: pxrenderpictformat;
 picture: tpicture;
 attributes: txrenderpictureattributes;
 fill: tpicture;

begin
 format:= xrenderfindstandardformat(msedisplay,pictstandardrgb24);
 attributes.poly_edge:= polyedgesmooth;
 attributes.poly_mode:= polymodeprecise; 
   //no difference with polymodeimprecise
 picture:= xrendercreatepicture(msedisplay,sender.clientwinid,format,
                                    cppolyedge or cppolymode,@attributes);
 fill:= xrendercreatesolidfill(msedisplay,@black);
 xrenderfillrectangle(msedisplay,pictopsrc,picture,@white,
                           0,0,sender.viewport.cx,sender.viewport.cy);
 xrendercompositetristrip(msedisplay,pictopover,fill,picture,nil,0,0,
                                                @points,length(points));
 xrenderfreepicture(msedisplay,fill);
 xrenderfreepicture(msedisplay,picture);
end;

end.
