{ MSEgui Copyright (c) 2007-2008 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
{*********************************************************}
{ Original file is mseprinter.pas, msegdiprint.pas, and   }
{ msepostscriptprinter.pas                                }
{            Modified by : Sri Wahono '2008               }
{             Included package with Repaz                 }
{*********************************************************}
{ Feel free to participate with reports bug, create new   }
{ report template, etc with join with Repaz forum  :      }
{                                                         }
{              http://www.msegui.org/osprinter            }
{                                                         }
{*********************************************************}
unit osprinters;

{$ifdef fpc}{$mode objfpc}{$goto on}{$h+}{$endif}

interface

uses
 classes,osprinter,msegraphics,msegraphutils,msedrawtext,
 msegui,mseguiglob,mseformatstr,osprinterstype,msesys,sysutils;
const
 mmtoinch = 1/25.4;
 defaultgdiprintppmm = mseguiglob.defaultppmm;
 
type

tosprintercanvas = class(tprintercanvas)
 protected
  procedure beginpage; override;
  procedure endpage; override;
  procedure checkgcstate(state: canvasstatesty); override;
 public
  constructor create(const user: tprinter; const intf: icanvas);
  procedure drawtext(var info: drawtextinfoty); override;  
end;
 
 tosprinter = class(tprinter,icanvas)
  private
   fppinchx: integer;
   fppinchy: integer;
   fpoffsetx: integer;
   fpoffsety: integer;
   fprinterhandle: dword;
   fgcprinter: cardinal;
   fdefaultprinter: string;
  protected
   //icanvas
   procedure gcneeded(const sender: tcanvas);
   function getmonochrome: boolean;
   function getgcprinter: gcty;

   function getprinterpapers(aprintername: string): stdpagearty; override;
   function getprinters: printerarty; override; 
   function getdefaultprinter: string; override; 
   procedure unlinkcanvas; override;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure beginprint; override;
   procedure endprint; override;
   function writetoprinter(const buffer; count: integer): dword;
   procedure senddata(const text: string);override;
 end;


implementation

uses
 windows,gdiapi,mseguiintf;
var
 hasgdiprint: boolean;
 
procedure checkprinterror(const aresult: integer; const atext: string = '');
begin
 if aresult <= 0 then begin
  syserror(syelasterror,atext);
 end;
end;

procedure checkprintboolerror(const aresult: boolean; const atext: string = '');
begin
 if not aresult then begin
  syserror(syelasterror,atext);
 end;
end;

procedure checkgdiprint;
begin
 if not hasgdiprint then begin
  exception.create('gdi printing not supported.');
 end;
end;

{ tosprintercanvas }

constructor tosprintercanvas.create(const user: tprinter;
               const intf: icanvas);
begin
 inherited;
 exclude(fstate,cs_internaldrawtext);
end;

procedure tosprintercanvas.drawtext(var info: drawtextinfoty);
begin
 if cs_inactive in fstate then exit;
 msedrawtext.drawtext(self,info);
end;

procedure tosprintercanvas.beginpage;
begin
 initgcvalues;
 exclude(fpstate,pcs_matrixvalid);
 include(fstate,cs_inactive);
 if not (pcs_dryrun in fpstate) and active then begin
  exclude(fstate,cs_inactive);
 end;   
 if not (cs_inactive in fstate) then begin
  include(fstate,cs_pagestarted);
  checkprinterror(startpage(gchandle)); 
 end;
 inherited;
end;

procedure tosprintercanvas.endpage;
begin
 inherited;
 if not (cs_inactive in fstate) and (cs_pagestarted in fstate) then begin
  exclude(fstate,cs_pagestarted);
  checkprinterror(windows.endpage(gchandle)); 
 end;
end;

procedure tosprintercanvas.checkgcstate(state: canvasstatesty);
var
 mat1: txform;
begin
 inherited;
 if not (pcs_matrixvalid in fpstate) then begin
  fillchar(mat1,sizeof(mat1),0);
  with mat1,tosprinter(fprinter) do begin
   if printorientation = pao_landscape then begin
    em21:= (fppinchx*mmtoinch) / ppmm;
    em12:= -(fppinchy*mmtoinch) / ppmm;
    edx:= -fpoffsetx + pa_margintop*mmtoinch*fppinchx;
    edy:= -fpoffsety + (pa_width - pa_marginleft)*mmtoinch*fppinchy;
   end
   else begin
    em11:= (fppinchx*mmtoinch) / ppmm;
    em22:= (fppinchy*mmtoinch) / ppmm;
    edx:= -fpoffsetx + pa_marginleft*mmtoinch*fppinchx;
    edy:= -fpoffsety + pa_margintop*mmtoinch*fppinchy;
   end;
   checkprintboolerror(setworldtransform(fdrawinfo.gc.handle,mat1));
  end;
  include(fpstate,pcs_matrixvalid);
 end;
end;

{ tosprinter }

constructor tosprinter.create(aowner: tcomponent);
begin
 inherited;
 fcanvas:= tosprintercanvas.create(self,icanvas(self));
 fcanvas.ppmm:= defaultgdiprintppmm;
end;

destructor tosprinter.destroy;
begin
 inherited;
end;

function tosprinter.getmonochrome: boolean;
begin
 result:= false;
end;

function tosprinter.getgcprinter: gcty;
var
 mstr1: string;
begin
 checkgdiprint;
 mstr1:= printername;
 fillchar(result,sizeof(result),0);
 result.paintdevicesize:= getwindowsize; //wahono
 include(result.drawingflags,df_highresfont);
 guierror(gui_creategc(0,gck_printer,result,mstr1),'for "'+mstr1+'"');
 fgcprinter:= result.handle;
end;  

procedure tosprinter.gcneeded(const sender: tcanvas);
var
 gc1: gcty;
begin
 gc1:= getgcprinter;
 if not (sender is tosprintercanvas) then begin
  guierror(gue_invalidcanvas);
 end;
 with tosprintercanvas(sender) do begin
  exclude(fstate,cs_pagestarted);
  checkprinterror(setgraphicsmode(gc1.handle,gm_advanced));
  fppinchx:= getdevicecaps(gc1.handle,logpixelsx);
  fppinchy:= getdevicecaps(gc1.handle,logpixelsy);
  fpoffsetx:= getdevicecaps(gc1.handle,physicaloffsetx);
  fpoffsety:= getdevicecaps(gc1.handle,physicaloffsety);
  linktopaintdevice(ptrint(self),gc1{,getwindowsize},nullpoint);
 end;
end;

procedure tosprinter.beginprint;
var
 info: tdocinfow;
 docinfo: tdocinfo1;
begin
 inherited;
 checkgdiprint;
 endprint;
 if not rawmode then begin
  exclude(tosprintercanvas(fcanvas).fpstate,pcs_dryrun);
  tosprintercanvas(fcanvas).initprinting;
  fillchar(info,sizeof(info),0);
  info.cbsize:= sizeof(info);
  info.lpszdocname:= pwidechar(self.title);
  checkprinterror(startdocw(fcanvas.gchandle,@info),
    'can not start print job for "'+fcanvas.title+'".');
 end else begin
  checkprinterror(integer(openprinter(pchar(printername), fprinterhandle, nil)),'Can''t open printer!');
  with docinfo do
  begin
    pdocname := pchar(string(self.title));
    poutputfile := nil;
    pdatatype := pchar('raw');
  end;
  checkprinterror(startdocprinter(fprinterhandle, 1, @docinfo),'Can''t open printer!');
 end;
 if not rawmode then begin
  tosprintercanvas(fcanvas).beginpage;
 end else begin
  senddata(esclist[esc_init]);
  if raw_draweraction=cdaOpenBefore then begin
   senddata(esclist[esc_open_drawer]);
  end;
 end;
end;

procedure tosprinter.unlinkcanvas;
begin
 checkgdiprint;
 if not rawmode and (fcanvas<>nil) then begin
  with tosprintercanvas(fcanvas) do begin
   if fdrawinfo.gc.handle <> 0 then begin
    try
     try
      endpage;
      if not (pcs_dryrun in fpstate) then begin
       enddoc(gchandle);
      end;
     finally
      unlink;
     end;
    except
    end;
   end;
  end;
 end;
end;
procedure tosprinter.endprint;
begin
 if not rawmode then begin
  unlinkcanvas;
 end else begin
  if raw_cutpaperonfinish then begin
   senddata(esclist[esc_cut_paper]);
  end;
  if raw_ejectonfinish then begin
   senddata(esclist[esc_form_feed]);   
  end;
  if raw_draweraction=cdaOpenAfter then begin
   senddata(esclist[esc_open_drawer]);
  end;
 end;
 closeprinter(fprinterhandle);
 inherited;
end;

function tosprinter.writetoprinter(const buffer; count: integer): dword;
begin
 writeprinter(fprinterhandle, pointer(buffer), count, result);
end;

procedure tosprinter.senddata(const text: string);
var
 success: boolean;
begin
 if fprinterhandle<>0 then begin
  success:= (writetoprinter(text, length(text))<>0);
 end;
end;

function tosprinter.getdefaultprinter: string;
const
 maxlen = 2048;
var
 int1: integer;
 aresult: boolean;
begin
 checkgdiprint;
 int1:= maxlen;
 setlength(result,int1);
 aresult:= getdefaultprintera(pchar(result),@int1);
 setlength(result,int1-1);
 fdefaultprinter:= result;
 inherited;
end;

function tosprinter.getprinters: printerarty;
var
 flags: dword;
 needed: dword;
 level: dword;
 infobuffer: pchar;
 infoptr: pchar;
 printercount: dword;
 counter: longint;
begin
 inherited;
 result:= nil;
 flags:= 2 or 4;
 needed:= 0;
 level:= 2;

 enumprinters(flags,nil,level,nil,0,needed,printercount);
 if needed > 0 then begin
  getmem(infobuffer,needed);
  fillchar(infobuffer^,needed,0);

  enumprinters(flags,nil,level,infobuffer,needed,needed,printercount);
  infoptr:= infobuffer;
  setlength(result, printercount);

  for counter:= 0 to high(result) do begin
   result[counter].printername:= strpas(pprinter_info_2(infoptr)^.pprintername);
   result[counter].drivername:= strpas(pprinter_info_2(infoptr)^.pdrivername);
   result[counter].location:= strpas(pprinter_info_2(infoptr)^.plocation);
   result[counter].port:= strpas(pprinter_info_2(infoptr)^.pportname);
   result[counter].description:= strpas(pprinter_info_2(infoptr)^.pcomment);
   result[counter].isdefault:= (fdefaultprinter = strpas(pprinter_info_2(infoptr)^.pprintername));
   result[counter].servername:= strpas(pprinter_info_2(infoptr)^.pservername);
   result[counter].sharename:= strpas(pprinter_info_2(infoptr)^.psharename);
   inc(infoptr,sizeof(printer_info_2));
  end;
  freemem(infobuffer);
 end;
end;

function tosprinter.getprinterpapers(aprintername: string): stdpagearty;
var 
 int1     : integer;
 typeloop,suportedpapers,namecount,ppapersizecount: integer;
 papersize : pointarty;
 papername : pchar;
begin
 int1:= printerindex;
 result:=nil;
 papersize:=nil;
 if int1=-1 then begin
  printername:= getdefaultprinter;
  int1:= printerindex;
  if int1=-1 then exit;
 end;
 suportedpapers:=devicecapabilities(pchar(printers[int1].printername),pchar(printers[int1].port),
 dc_papers,nil,nil);
 setlength(result,suportedpapers+1);
 setlength(papersize,suportedpapers);
 //papersize names
 namecount := devicecapabilities(pchar(printers[int1].printername),pchar(printers[int1].port),
 dc_papernames, nil, nil);
 if namecount <> 0 then begin
  getmem(papername,64*namecount);
  namecount := devicecapabilities(pchar(printers[int1].printername),pchar(printers[int1].port),
  dc_papernames, pchar(@papername[0]), nil)
 end;
 //papersize dimensions
 ppapersizecount := devicecapabilities(pchar(printers[int1].printername),pchar(printers[int1].port),
 dc_papersize, nil, nil);
 if ppapersizecount <> 0 then begin
  ppapersizecount := devicecapabilities(pchar(printers[int1].printername),pchar(printers[int1].port),
  dc_papersize, @papersize[0], nil);
 end;
 for typeloop := 0 to suportedpapers-1 do begin
  if namecount > 0 then begin
   result[typeloop].name:= strpas(papername+typeloop*64);
  end else begin
   result[typeloop].name := 'custom (' + realtostr(result[typeloop].width) +
   ' x ' + realtostr(result[typeloop].height) + 'mm'; 
  end;
  if ppapersizecount > 0 then begin
   result[typeloop].width := (papersize[typeloop].x / 10);;
   result[typeloop].height := (papersize[typeloop].y / 10);
  end;
  result[typeloop].paperindex := typeloop;
 end;
 result[suportedpapers].name:='Custom Paper';
 result[suportedpapers].width:=0;
 result[suportedpapers].height:=0;
 result[suportedpapers].paperindex:=suportedpapers;
 freemem(papername);
 papersize:=nil;
end;

procedure doinit;
begin
 hasgdiprint:= initgdiprint;
end;

initialization
 doinit;

end.
