{*********************************************************}
{            Repaz Variable Types and Utilities           }
{  Base idea from msereport written by :  Martin Schreiber}
{*********************************************************}
{            Copyright (c) 2011 Sri Wahono                }
{*********************************************************}
{ License Agreement:                                      }
{ This library is distributed in the hope that it will be }
{ useful, but WITHOUT ANY WARRANTY; without even the      }
{ implied warranty of MERCHANTABILITY or FITNESS FOR      }
{ A PARTICULAR PURPOSE.  See the GNU Lesser General       }
{ Public License for more details.                        }
{                                                         }
{ The source code of the Repaz libraries and packages are }
{ distributed under the Library GNU General Public        }
{ License with the following  modification:               }
{ As a special exception, the copyright holders of this   }
{ library give you permission to link this library with   }
{ independent modules to produce an executable,           }
{ regardless of the license terms of these independent    }
{ modules, and to copy and distribute the resulting       }
{ executable under terms of your choice, provided that    }
{ you also meet, for each linked independent module,      }
{ the terms and conditions of the license of that module. }
{ An independent module is a module which is not derived  }
{ from or based on this library.                          }
{                                                         }
{ Feel free to participate with reports bug, create new   }
{ report template, etc with join with Repaz forum  :      }
{                                                         }
{                http://www.msegui.org/repaz              }
{                                                         }
{*********************************************************}
unit repazglob;
{$ifdef FPC}{$mode objfpc}{$h+}{$GOTO ON}{$interfaces corba}{$endif}
interface
uses
 classes,msegui,msedrawtext,msegraphutils,msegraphics,variants,repazchart,barcode,
 msestrings,sysutils,msebitmap,universalprinter,universalprintertype,mseformatpngread,mseformatbmpicoread,
 mseformatjpgread,mseformatstr,repaztypes,mseglob,mselookupbuffer,msesysutils;

type
 reportactionty = (ra_save,ra_print,ra_preview,ra_design,ra_showdialog);
 repactionsty = set of reportactionty;
 raunitty = (Milimeter,Inch);
 lookupkindty = (lk_Text,lk_Integer,lk_int64,lk_Float,lk_Date,lk_Time,lk_DateTime);  

 ilbfieldinfo = interface(inullinterface)
 ['{DDFC9D98-D2B0-475A-B0CD-14042CDBC465}']
  function getlbdatakind(const apropname: string): lookupkindty;
  function getlb: tcustomlookupbuffer;
 end; 

 itemsumty = record
  count: integer;
  resetpending: boolean;
  reset: boolean;
  integervalue: integer;
  largeintvalue: int64;
  floatvalue: double;
  bcdvalue: currency;
 end;

 summarytypety = (st_None,st_Sum,st_Count,st_Average);
 zebraoptionty = (zo_ResetOnPageStart,zo_ResetParent);
 zebraoptionsty = set of zebraoptionty;
 
 recordareaty = (ra_AllRecord,ra_CurrentRecord,ra_FirstRecord,ra_LastRecord);
 hreportshowty = (hrs_FirstPageOnly,hrs_EveryPage);
 freportshowty = (frs_LastPageOnly,frs_EveryPage);
 freportoptionty = (fro_PrintOnBottomPage,fro_ResetEveryPage);
 freportoptionsty = set of freportoptionty;
 rapageorientationty = (rpo_Portrait,rpo_Landscape);
 reportoptionty = (reo_nodisablecontrols,
                  reo_autoreadstat,reo_autowritestat);
 reportoptionsty = set of reportoptionty;
 printdestinationty = (pd_Design,pd_Preview,pd_Printer,pd_PostScript,pd_PDF,pd_Text,pd_HTML);

 findtextinfoty = record
  text: msestring;
  options: searchoptionsty;
  allpage: boolean;
  history: msestringarty;
 end;

type
  
 replineinfoty = record
  linewidth: real;
  linecolor: colorty;
  capstyle: capstylety;
  linestyle: linestylety;
  startpoint: pointty;
  endpoint: pointty;
 end;

 reprectinfoty = record
  rectarea: rectty;
  color: colorty;
 end;

 repbitmapinfoty = record
  rectarea: rectty;
  bitmap: imagebufferinfoty;
  bitmapalignment: alignmentsty;
 end;

 tabinfoty = record
  text: msestring;
  dest: rectty;
  flags: textflagsty;
  fontcolor: colorty;
  fontname: string;
  fontsize: integer;
  fontstyle: fontstylesty;
  rawfont: rawfontty;
  rawpos: integer;
  rawwidth:integer;
  borderleft: replineinfoty;
  borderright: replineinfoty;
  bordertop: replineinfoty;
  borderbottom: replineinfoty;
 end;
 
 reptabinfoty = record
  tabs: array of tabinfoty;
  rawemptyrow: integer;
 end;

 tmetapage = record
  bitmap: imagebufferinfoty;
  bitmapalignment: alignmentsty;
  bitmaprect: rectty;
  tabobjects: array of reptabinfoty;
  rect1objects: array of reprectinfoty;
  rect2objects: array of reprectinfoty;
  bitmap1objects: array of repbitmapinfoty;
  bitmap2objects: array of repbitmapinfoty;
  chartobjects: TraCustomChart;
  chartrect: rectty;
  pagewidth: integer;
  pageheight: integer;
 end;
 tmetapages = array of tmetapage;
 pmetapages = ^tmetapages;

 procedure clearmetapages(var fmetapages: tmetapages);

 procedure printmetapages(const acanvas: tcanvas; const ametapages: tmetapages;
  const apage: integer; const ascale: real=1.0);

 function createrectinfo(const arect: rectty; acolor: colorty):reprectinfoty;

var
 fbarcode: tBarcode;
 
implementation

procedure clearmetapages(var fmetapages: tmetapages);
var
 int1,int2: integer;
begin
 for int1:=length(fmetapages)-1 downto 0 do begin
  if fmetapages[int1].chartobjects<>nil then begin
   fmetapages[int1].chartobjects.destroy;
  end;
  for int2:=length(fmetapages[int1].bitmap1objects)-1 downto 0 do begin
   freeimage(fmetapages[int1].bitmap1objects[int2].bitmap.image);
   freeimage(fmetapages[int1].bitmap1objects[int2].bitmap.mask);
  end;
  for int2:=length(fmetapages[int1].bitmap2objects)-1 downto 0 do begin
   freeimage(fmetapages[int1].bitmap2objects[int2].bitmap.image);
   freeimage(fmetapages[int1].bitmap2objects[int2].bitmap.mask);
  end;
  freeimage(fmetapages[int1].bitmap.image);
  freeimage(fmetapages[int1].bitmap.mask);
 end;
 fmetapages:=nil;
end;

procedure printmetapages(const acanvas: tcanvas; const ametapages: tmetapages;
 const apage: integer; const ascale: real=1.0);
var
 tmpinfo: drawtextinfoty;
 int1,int2: integer;
 tmprect: rectty;
 tmpstart,tmpend: pointty;
 tmpwidthmm: real;
 tmpbmp: tmaskedbitmap;
 afont: tfont;
begin
 if length(ametapages)>0 then begin
  tmpbmp:= tmaskedbitmap.create(false);
  tmpbmp.masked:= true;
  afont:= tfont.create;
  if ametapages[apage].bitmap.image.pixels<>nil then begin
   tmprect:= ametapages[apage].bitmaprect;
   if ascale<>1.0 then begin
    with tmprect do begin
     x:= round(x*ascale);
     y:= round(y*ascale);
     cx:= round(cx*ascale);
     cy:= round(cy*ascale);
    end;  
   end;
   tmpbmp.clear;
   tmpbmp.loadfromimagebuffer(ametapages[apage].bitmap);
   tmpbmp.alignment:= ametapages[apage].bitmapalignment;
   tmpbmp.paint(acanvas,tmprect);
  end;
  if length(ametapages[apage].rect1objects)>0 then begin
   for int1:=0 to length(ametapages[apage].rect1objects)-1 do begin
    with ametapages[apage].rect1objects[int1] do begin
     tmprect:= rectarea;
     if ascale<>1.0 then begin
      with tmprect do begin
       x:= round(x*ascale);
       y:= round(y*ascale);
       cx:= round(cx*ascale);
       cy:= round(cy*ascale);
      end;  
     end;
     acanvas.fillrect(tmprect,color);
    end;
   end;
  end;
  if length(ametapages[apage].rect2objects)>0 then begin
   for int1:=0 to length(ametapages[apage].rect2objects)-1 do begin
    with ametapages[apage].rect2objects[int1] do begin
     tmprect:= rectarea;
     if ascale<>1.0 then begin
      with tmprect do begin
       x:= round(x*ascale);
       y:= round(y*ascale);
       cx:= round(cx*ascale);
       cy:= round(cy*ascale);
      end;  
     end;
     acanvas.fillrect(tmprect,color);
    end;
   end;
  end;
  if length(ametapages[apage].bitmap1objects)>0 then begin
   for int1:=0 to length(ametapages[apage].bitmap1objects)-1 do begin
    with ametapages[apage].bitmap1objects[int1] do begin
     if bitmap.image.pixels<>nil then begin
      tmprect:= rectarea;
      if ascale<>1.0 then begin
       with tmprect do begin
        x:= round(x*ascale);
        y:= round(y*ascale);
        cx:= round(cx*ascale);
        cy:= round(cy*ascale);
       end;  
      end;
      tmpbmp.clear;
      tmpbmp.loadfromimagebuffer(bitmap);
      tmpbmp.alignment:= bitmapalignment;
      tmpbmp.paint(acanvas,tmprect);
     end;
    end;
   end;
  end;
  if length(ametapages[apage].bitmap2objects)>0 then begin
   for int1:=0 to length(ametapages[apage].bitmap2objects)-1 do begin
    with ametapages[apage].bitmap2objects[int1] do begin
     if bitmap.image.pixels<>nil then begin
      tmprect:= rectarea;
      if ascale<>1.0 then begin
       with tmprect do begin
        x:= round(x*ascale);
        y:= round(y*ascale);
        cx:= round(cx*ascale);
        cy:= round(cy*ascale);
       end;  
      end;
      tmpbmp.clear;
      tmpbmp.loadfromimagebuffer(bitmap);
      tmpbmp.alignment:= bitmapalignment;
      tmpbmp.paint(acanvas,tmprect);
     end;
    end;
   end;
  end;
  if length(ametapages[apage].tabobjects)>0 then begin
   for int1:=0 to length(ametapages[apage].tabobjects)-1 do begin
    for int2:=0 to length(ametapages[apage].tabobjects[int1].tabs)-1 do begin
     with ametapages[apage].tabobjects[int1].tabs[int2] do begin
      if text<>'' then begin
       tmpinfo.text.text:= text;
       tmpinfo.text.format:= nil;
       tmpinfo.dest:= dest;
       tmpinfo.flags:= flags;
       afont.color:= fontcolor;
       afont.height:= fontsize;
       afont.name:= fontname;
       afont.style:= fontstyle;
       tmpinfo.tabulators:= nil;
       if ascale<>1.0 then begin
        with tmpinfo.dest do begin
         x:= round(x*ascale);
         y:= round(y*ascale);
         cx:= round(cx*ascale);
         cy:= round(cy*ascale);
        end;  
        with tmpinfo.clip do begin
         x:= round(x*ascale);
         y:= round(y*ascale);
         cx:= round(cx*ascale);
         cy:= round(cy*ascale);
        end;  
        with tmpinfo.res do begin
         x:= round(x*ascale);
         y:= round(y*ascale);
         cx:= round(cx*ascale);
         cy:= round(cy*ascale);
        end;  
        afont.height:= round(fontsize * ascale);
       end;
       tmpinfo.font:= afont;
       if not ((tmpinfo.font.color=cl_none) or (tmpinfo.font.color=cl_transparent)) then begin
        drawtext(acanvas,tmpinfo);
       end;
      end;
      if borderleft.linewidth>0 then begin
       tmpwidthmm:= borderleft.linewidth;
       tmpstart:= borderleft.startpoint;
       tmpend:= borderleft.endpoint;
       if ascale<>1.0 then begin
        tmpwidthmm:= tmpwidthmm*ascale;
        tmpstart.x:= round(tmpstart.x*ascale);
        tmpstart.y:= round(tmpstart.y*ascale);
        tmpend.x:= round(tmpend.x*ascale);
        tmpend.y:= round(tmpend.y*ascale);
       end;
       acanvas.save;
       acanvas.linewidthmm:= tmpwidthmm;
       acanvas.capstyle:= borderleft.capstyle;
       acanvas.dashes:= linestyles[borderleft.linestyle];
       acanvas.drawline(tmpstart,tmpend,borderleft.linecolor);
       acanvas.restore;
      end;
      if bordertop.linewidth>0 then begin
       tmpwidthmm:= bordertop.linewidth;
       tmpstart:= bordertop.startpoint;
       tmpend:= bordertop.endpoint;
       if ascale<>1.0 then begin
        tmpwidthmm:= tmpwidthmm*ascale;
        tmpstart.x:= round(tmpstart.x*ascale);
        tmpstart.y:= round(tmpstart.y*ascale);
        tmpend.x:= round(tmpend.x*ascale);
        tmpend.y:= round(tmpend.y*ascale);
       end;
       acanvas.save;
       acanvas.linewidthmm:= tmpwidthmm;
       acanvas.capstyle:= bordertop.capstyle;
       acanvas.dashes:= linestyles[bordertop.linestyle];
       acanvas.drawline(tmpstart,tmpend,bordertop.linecolor);
       acanvas.restore;
      end;
      if borderright.linewidth>0 then begin
       tmpwidthmm:= borderright.linewidth;
       tmpstart:= borderright.startpoint;
       tmpend:= borderright.endpoint;
       if ascale<>1.0 then begin
        tmpwidthmm:= tmpwidthmm*ascale;
        tmpstart.x:= round(tmpstart.x*ascale);
        tmpstart.y:= round(tmpstart.y*ascale);
        tmpend.x:= round(tmpend.x*ascale);
        tmpend.y:= round(tmpend.y*ascale);
       end;
       acanvas.save;
       acanvas.linewidthmm:= tmpwidthmm;
       acanvas.capstyle:= borderright.capstyle;
       acanvas.dashes:= linestyles[borderright.linestyle];
       acanvas.drawline(tmpstart,tmpend,borderright.linecolor);
       acanvas.restore;
      end;
      if borderbottom.linewidth>0 then begin
       tmpwidthmm:= borderbottom.linewidth;
       tmpstart:= borderbottom.startpoint;
       tmpend:= borderbottom.endpoint;
       if ascale<>1.0 then begin
        tmpwidthmm:= tmpwidthmm*ascale;
        tmpstart.x:= round(tmpstart.x*ascale);
        tmpstart.y:= round(tmpstart.y*ascale);
        tmpend.x:= round(tmpend.x*ascale);
        tmpend.y:= round(tmpend.y*ascale);
       end;
       acanvas.save;
       acanvas.linewidthmm:= tmpwidthmm;
       acanvas.capstyle:= borderbottom.capstyle;
       acanvas.dashes:= linestyles[borderbottom.linestyle];
       acanvas.drawline(tmpstart,tmpend,borderbottom.linecolor);
       acanvas.restore;
      end;
     end;
    end;
   end;
  end;
  if ametapages[apage].chartobjects<>nil then begin
   tmprect:= ametapages[apage].chartrect;
   if ascale<>1.0 then begin
    with tmprect do begin
     x:= round(x*ascale);
     y:= round(y*ascale);
     cx:= round(cx*ascale);
     cy:= round(cy*ascale);
    end;  
    ametapages[apage].chartobjects.zoomscale:= ascale;
   end else begin
    ametapages[apage].chartobjects.zoomscale:= 1;
   end;
   ametapages[apage].chartobjects.paintchart(acanvas,tmprect);
  end;  
  tmpbmp.free;
  afont.free;
 end; 
end;

function createrectinfo(const arect: rectty; acolor: colorty):reprectinfoty;
begin
 result.rectarea:= arect;
 result.color:= acolor;
end;

initialization
 fbarcode:= TBarcode.create;
finalization
 fbarcode.free;
end.
