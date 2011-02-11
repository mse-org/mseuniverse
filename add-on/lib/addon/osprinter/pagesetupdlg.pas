{*********************************************************}
{                 OSPrinter Components                    }
{            Page Setup Dialog for OSPrinter              }
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
{              http://www.msegui.org/osprinter            }
{                                                         }
{*********************************************************}
unit pagesetupdlg;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msegui,msegraphics,msegraphutils,
 mseclasses,mseforms,msesimplewidgets,msedataedits,mseedit,msestrings,
 msedispwidgets,msegraphedits,msetabs,classes,sysutils,osprinterstype,mseimage,
 msegrids,msesplitter,msecommport,msecommutils,msemenus,msetypes;
 
type
 tpagesetupdlgfo = class(tmseform)
  tgroupbox1: tgroupbox;
  cprinters: tdropdownlistedit;
  btnok: tbutton;
  btncancel: tbutton;
  cinfo: tstringgrid;
   boolrawmode: tbooleanedit;
   ttabwidget1: ttabwidget;
   ttabpage1: ttabpage;
   ttabpage2: ttabpage;
   tlayouter1: tlayouter;
   papersample: tgroupbox;
   tlayouter2: tlayouter;
   tstringdisp1: tstringdisp;
   tstringdisp2: tstringdisp;
   tstringdisp3: tstringdisp;
   tstringdisp4: tstringdisp;
   tstringdisp5: tstringdisp;
   tstringdisp6: tstringdisp;
   tstringdisp7: tstringdisp;
   tgroupbox5: tgroupbox;
   cleft: trealedit;
   cright: trealedit;
   ctop: trealedit;
   cbottom: trealedit;
   tgroupbox4: tgroupbox;
   clandscape: tbooleaneditradio;
   cportrait: tbooleaneditradio;
   cpaperheight: trealedit;
   cpaperwidth: trealedit;
   cpapers: tdropdownlistedit;
   tgroupbox2: tgroupbox;
   callpages: tbooleaneditradio;
   crangepage: tbooleaneditradio;
   crangestring: tstringedit;
   tlabel1: tlabel;
   edcopies: trealspinedit;
   listprintercode: tdropdownlistedit;
   boolcontpage: tbooleanedit;
   boolejectonfinished: tbooleanedit;
   tgroupbox3: tgroupbox;
   cdnotopen: tbooleaneditradio;
   cdopenbefore: tbooleaneditradio;
   cdopenafter: tbooleaneditradio;
   boolcutpaper: tbooleanedit;
   wdpi: tintegeredit;
   procedure pagesetupdlgfo_oncreate(const sender: TObject);
   procedure pagesetupdlgfo_ondestroy(const sender: TObject);
   procedure cpapers_ondataentered(const sender: TObject);
   procedure crangepage_onfocus(const sender: TObject);
   procedure crangestring_ontextedited(const sender: tcustomedit;
                   var atext: msestring);
   procedure updatepaper(const sender: TObject);
   procedure boolrawmode_ondataentered(const sender: TObject);
 public
  fprinters: printerarty;     //printers names list
  fpapers  : stdpagearty;
 end;
var
 pagesetupdlgfo: tpagesetupdlgfo;
implementation
uses
 pagesetupdlg_mfm,mseconsts,repazconsts;

procedure tpagesetupdlgfo.pagesetupdlgfo_oncreate(const sender: TObject);
begin
 fprinters:=nil;
 fpapers:=nil;
 cprinters.frame.caption:= uc(ord(rcsLblprintname));
 boolrawmode.frame.caption:= uc(ord(rcsLblrawmode));
 cinfo.frame.caption:= uc(ord(rcsLblprintinfo));
 ttabpage1.caption:= uc(ord(rcsCapgeneral));
 ttabpage2.caption:= uc(ord(rcsCaprawmode));
 tgroupbox2.frame.caption:= uc(ord(rcsCappagessel));
 callpages.frame.caption:= uc(ord(rcsLblall));
 crangepage.frame.caption:= uc(ord(rcsLblrange));
 edcopies.frame.caption:= uc(ord(rcsLblcopies));
 cpapers.frame.caption:= uc(ord(rcsCappapersize));
 cpaperwidth.frame.caption:= uc(ord(rcsLblwidth));
 cpaperheight.frame.caption:= uc(ord(rcsLblheight));
 listprintercode.frame.caption:= uc(ord(rcsLblprintercode));
 boolcontpage.frame.caption:= uc(ord(rcsLblcontinuespage));
 boolejectonfinished.frame.caption:= uc(ord(rcsLbleject));
 boolcutpaper.frame.caption:= uc(ord(rcsLblcutpaper));
 cdnotopen.frame.caption:= uc(ord(rcsLbldontopen));
 cdopenbefore.frame.caption:= uc(ord(rcsLblopenbefore));
 cdopenafter.frame.caption:= uc(ord(rcsLblopenafter));
end;

procedure tpagesetupdlgfo.pagesetupdlgfo_ondestroy(const sender: TObject);
begin
 fprinters:=nil;
 fpapers:=nil;
end;

procedure tpagesetupdlgfo.cpapers_ondataentered(const sender: TObject);
begin
 cpaperwidth.value:= fpapers[cpapers.dropdown.itemindex].width;
 cpaperheight.value:= fpapers[cpapers.dropdown.itemindex].height;
end;

procedure tpagesetupdlgfo.crangepage_onfocus(const sender: TObject);
begin
 crangestring.activate;
end;

procedure tpagesetupdlgfo.crangestring_ontextedited(const sender: tcustomedit;
               var atext: msestring);
begin
 if atext='' then begin
  callpages.value:=true;
  crangepage.value:=false; 
 end else begin
  callpages.value:=false;
  crangepage.value:=true; 
 end;
end;

procedure tpagesetupdlgfo.updatepaper(const sender: TObject);
var
 fscale: real;
begin
 fscale:= 1.0;
 papersample.scale(fscale);
 if cpaperwidth.value>0 then begin
  if cportrait.value then begin
   papersample.width:= round(cpaperwidth.value/2);
  end else begin
   papersample.height:= round(cpaperwidth.value/2);
  end;
 end;
 if cpaperheight.value>0 then begin
  if cportrait.value then begin
   papersample.height:= round(cpaperheight.value/2);
  end else begin
   papersample.width:= round(cpaperheight.value/2);
  end;
 end;
 while (papersample.width>tlayouter1.width) or
   (papersample.height>tlayouter1.height) do begin
  papersample.scale(fscale);
  fscale:= fscale - 0.1;
 end;
end;

procedure tpagesetupdlgfo.boolrawmode_ondataentered(const sender: TObject);
begin
 if boolrawmode.value then begin
  cportrait.value:=false;
  clandscape.value:=false;
  cportrait.enabled:=false;
  clandscape.enabled:=false;
  callpages.enabled:=false;
  crangepage.enabled:=false;
  crangestring.value:='';
  crangestring.enabled:=false;
  ttabpage2.invisible:= false;
 end else begin
  cportrait.enabled:=true;
  clandscape.enabled:=true;
  callpages.enabled:=true;
  crangepage.enabled:=true;
  crangestring.enabled:=true;
  ttabpage2.invisible:= true;
 end;
end;

end.
