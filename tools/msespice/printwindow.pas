unit printwindow;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msestatfile,
 msedataedits,mseedit,mseifiglob,mseprinter,msestrings,msetypes,msegraphedits,
 msesimplewidgets,msewidgets,msesplitter,msepostscriptprinter,sysutils,
 msebitmap,msedatanodes,msefiledialog,msegrids,mselistbrowser,msesys;
type
 tprintwindowfo = class(tmseform)
   tstatfile1: tstatfile;
   pasize: tpagesizeselector;
   shrink: tbooleanedit;
   enlarge: tbooleanedit;
   tlayouter1: tlayouter;
   tbutton2: tbutton;
   tbutton3: tbutton;
   psprinter: tpostscriptprinter;
   printcommand: tdropdownlistedit;
   prcolor: tbooleanedit;
   pdffile: tfilenameedit;
   pdf: tbooleanedit;
   margleft: trealedit;
   margright: trealedit;
   centerhorz: tbooleanedit;
   centervert: tbooleanedit;
   margbottom: trealedit;
   margtop: trealedit;
   landscape: tbooleanedit;
   procedure okexe(const sender: TObject);
   procedure pdfsetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
  private
   fwidget: twidget;
  public
   constructor create(const awidget: twidget);
 end;

implementation
uses
 printwindow_mfm,msefileutils,msestream,mainmodule,mseprocutils;
 
{ tprintwindowfo }

constructor tprintwindowfo.create(const awidget: twidget);
begin
 fwidget:= awidget;
 inherited create(nil);
 try
  show(ml_application);
 finally
  release;
 end; 
end;

procedure tprintwindowfo.okexe(const sender: TObject);
 procedure updatecanvas;
 var
  pt1: pointty;
 begin
  with psprinter.canvas do begin
   ppmm:= 3;
   if landscape.value then begin
    printorientation:= pao_landscape;
   end
   else begin
    printorientation:= pao_portrait;
   end;   
   if prcolor.value then begin
    colorspace:= cos_rgb;
   end
   else begin
    colorspace:= cos_gray;
   end;
   if enlarge.value or shrink.value and ((fwidget.width > clientwidth) or 
                              (fwidget.height > clientheight)) then begin
    fitppmm(fwidget.size);
   end;
   pt1:= nullpoint;
   if centerhorz.value then begin
    pt1.x:= (clientwidth - fwidget.width) div 2;
   end;
   if centervert.value then begin
    pt1.y:= (clientheight - fwidget.height) div 2;
   end;
   move(pt1);
   fwidget.paint(psprinter.canvas);
  end;
 end; //updatecanvas

var
 fna1,fna2,fna3: filenamety;
 str1: string;
 int1: integer;
begin
 if pdf.value then begin
  fna1:= tosysfilepath(intermediatefilename('msespice.ps'),true);
  try
   with psprinter do begin
    pa_frameleft:= margleft.value;
    pa_frameright:= margright.value;
    pa_frametop:= margtop.value;
    pa_framebottom:= margbottom.value;
   end;
   psprinter.beginprint(ttextstream.create(fna1,fm_create));
   updatecanvas;
   psprinter.endprint;
   fna2:= mainmo.globaloptions.ps2pdf;
//   if fna2 = '' then begin
//    fna2:= 'ps2pdf';
//   end;
   fna3:= pdffile.sysvaluequoted;
   if fna3 = '' then begin
    fna3:= 'msespice.pdf';
   end;
   str1:= tosysfilepath(fna2,true)+
         ' -sPAPERSIZE='+lowercase(pasize.pagesizename)+' '+fna1+' '+fna3;
   int1:= execwaitmse(str1);
   if int1 <> 0 then begin
    showmessage('ps2pdf error '+inttostr(int1)+' with command'+lineend+str1,
                                                                      'ERROR');
   end;
  finally
   deletefile(fna1);
  end;
 end
 else begin
  psprinter.beginprint(printcommand.value);
  updatecanvas; 
  psprinter.endprint;
 end;
end;

procedure tprintwindowfo.pdfsetexe(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 pdffile.enabled:= avalue;
 printcommand.enabled:= not avalue;
end;

end.
