unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,msewidgets,
 msedataedits,mseedit,msepostscriptprinter,mseprinter,msestrings,msetypes;

type
 tmainfo = class(tmseform)
   tbutton1: tbutton;
   printer: tpostscriptprinter;
   procedure printex(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,msedrawtext,msestream,msesys;
 
procedure tmainfo.printex(const sender: TObject);
var
 rect1: rectty;
begin
// printer.beginprint(ttextstream.create(
//         'test.ps',fm_create));//printing into file
 printer.beginprint;             //printing direct to default printer
                                 //needs installed ghostscript on win32
 rect1:= makerect(50,100,500,100);
 with printer.canvas do begin
  writeln('AAAAAAAAA');
  writeln('BBBBBBBBB');
  drawrect(rect1);
 end;
 drawtext(printer.canvas,'CCCCCCCCCC',rect1,[tf_xcentered,tf_ycentered]);
 printer.endprint;
end;

end.
