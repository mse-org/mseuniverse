{*********************************************************}
{                 Repaz Preview Form                      }
{             Form to  show Repaz metadata                }
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
unit repazpreviewform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,msewidgets,
 repazpreview,mseact,msetoolbar,msestatfile,msedataedits,mseedit,msestrings,
 msetypes,msereal,sysutils,mseimage,msebitmap,msedock,msefiledialog,mseconsts,
 mseconsts_id,repazconsts,msesplitter,msescrollbar;
type
 trepazpreviewfo = class(tdockform)
   tscrollbox1: tscrollbox;
   tpreview1: tpreview;
   tmainmenu1: tmainmenu;
   timagelist1: timagelist;
   tsimplewidget1: tsimplewidget;
   ttoolbar1: ttoolbar;
   cbzoom: tdropdownlistedit;
   cpage: tintegeredit;
   ttoolbar2: ttoolbar;
   callpage: tintegeredit;
   tspacer1: tspacer;
   procedure cpage_onchange(const sender: TObject);
   procedure tpreview1_onfileopened(const sender: TObject);
   procedure btnzoom_onexecute(const sender: TObject);
   procedure btnfirst_onexecute(const sender: TObject);
   procedure btnprior_onexecute(const sender: TObject);
   procedure btnnext_onexecute(const sender: TObject);
   procedure btnlast_onexecute(const sender: TObject);
   procedure mnuexitexec(const sender: TObject);
   procedure mnugotoexecute(const sender: TObject);
   procedure zoomexecute(const avalue: integer);
   procedure mnuzoomexec(const sender: TObject);
   procedure mnuhelpexec(const sender: TObject);
   procedure mnuaboutexec(const sender: TObject);
   procedure btnfind_onexecute(const sender: TObject);
   procedure tpreview1_onpagereposition(const sender: TObject);
   procedure updatelang;
   procedure repazpreviewfo_onloaded(const sender: TObject);
   procedure repazpreviewfo_ondestroy(const sender: TObject);
   procedure tscrollbox1_onbeforeevent(const sender: tcustomscrollbar;
                   var akind: scrolleventty; var avalue: Real);
   procedure repazpreviewfo_onclose(const sender: TObject);
 end;

implementation
uses
 repazpreviewform_mfm,math,mseintegerenter,frmabout;
procedure trepazpreviewfo.cpage_onchange(const sender: TObject);
begin
 if cpage.value>0 then begin
  tpreview1.activepage:=cpage.value-1;
  btnzoom_onexecute(cbzoom);
 end;
end;

procedure trepazpreviewfo.tpreview1_onfileopened(const sender: TObject);
begin
 cpage.max:= tpreview1.pagecount;
 if tpreview1.pagecount>=1 then cpage.value:=1;
end;

procedure trepazpreviewfo.btnzoom_onexecute(const sender: TObject);
begin
 zoomexecute(cbzoom.dropdown.itemindex);
end;

procedure trepazpreviewfo.zoomexecute(const avalue: integer);
begin
 if avalue=0 then begin
  tpreview1.zoom(0.5);
 end else if avalue=1 then begin
  tpreview1.zoom(0.75);
 end else if avalue=2 then begin
  tpreview1.zoom(1.0);
 end else if avalue=3 then begin
  tpreview1.zoom(1.25);
 end else if avalue=4 then begin
  tpreview1.zoom(1.5);
 end else if avalue=5 then begin
  tpreview1.zoom(1.75);
 end else if avalue=6 then begin
  tpreview1.zoom(2.0);
 end;
end;

procedure trepazpreviewfo.btnfirst_onexecute(const sender: TObject);
begin
 if cpage.value<>cpage.min then begin
  cpage.value:= cpage.min;
 end;
end;

procedure trepazpreviewfo.btnprior_onexecute(const sender: TObject);
begin
 if (cpage.value-1)>=cpage.min then begin
  cpage.value:= cpage.value-1;
 end;
end;

procedure trepazpreviewfo.btnnext_onexecute(const sender: TObject);
begin
 if (cpage.value+1)<=cpage.max then begin
  cpage.value:= cpage.value+1;
 end;
end;

procedure trepazpreviewfo.btnlast_onexecute(const sender: TObject);
begin
 if cpage.value<>cpage.max then begin
  cpage.value:= cpage.max;
 end;
end;

procedure trepazpreviewfo.mnuexitexec(const sender: TObject);
begin
 close;
end;

procedure trepazpreviewfo.mnugotoexecute(const sender: TObject);
var
 avalue: integer;
begin
 avalue:=1;
 if integerenter(avalue,cpage.min,cpage.max,'Goto page : ','Goto Page')=mr_ok then begin
  if avalue>0 then begin
   cpage.value:= avalue;
  end;
 end;
end;

procedure trepazpreviewfo.mnuzoomexec(const sender: TObject);
begin
 zoomexecute((sender as tmenuitem).tag);
end;

procedure trepazpreviewfo.mnuhelpexec(const sender: TObject);
begin
 showmessage('Help not yet created!');
end;

procedure trepazpreviewfo.mnuaboutexec(const sender: TObject);
begin
 frmaboutfo:= tfrmaboutfo.create(nil);
 frmaboutfo.show;
end;

procedure trepazpreviewfo.btnfind_onexecute(const sender: TObject);
begin
 tpreview1.findtext;
end;

procedure trepazpreviewfo.tpreview1_onpagereposition(const sender: TObject);
begin
 cpage.value:= tpreview1.activepage+1;
end;

procedure trepazpreviewfo.updatelang;
begin
 with tmainmenu1.menu do begin
  itembyname('mnurep').caption:= uc(ord(rcsMnureport));
  with itembyname('mnurep') do begin
   itembyname('mnurepprint').caption:= uc(ord(rcsMnuprint));
   itembyname('mnureptext').caption:= uc(ord(rcsMnusavetotext));
   itembyname('mnureppostscript').caption:= uc(ord(rcsMnusavetops));
   itembyname('mnureppdf').caption:= uc(ord(rcsMnusavetopdf));
   itembyname('mnurepexit').caption:= uc(ord(rcsMnuexit));
  end;
  itembyname('mnupage').caption:= uc(ord(rcsMnupages));
  with itembyname('mnupage') do begin
   itembyname('mnupagefirst').caption:= uc(ord(rcsMnufirst));
   itembyname('mnupageprev').caption:= uc(ord(rcsMnuprev));
   itembyname('mnupagegoto').caption:= uc(ord(rcsMnugoto));
   itembyname('mnupagenext').caption:= uc(ord(rcsMnunext));
   itembyname('mnupagelast').caption:= uc(ord(rcsMnulast));
  end;
  itembyname('mnuzoom').caption:= uc(ord(rcsMnuzoom));
  itembyname('mnufind').caption:= uc(ord(rcsMnufind));
  with itembyname('mnufind') do begin
   itembyname('mnufindtext').caption:= uc(ord(rcsMnufindtext));
  end;
  itembyname('mnuhelp').caption:= uc(ord(rcsMnuhelp));
  with itembyname('mnuhelp') do begin
   itembyname('mnuhelphelp').caption:= uc(ord(rcsMnuhelp));
   itembyname('mnuhelpabout').caption:= uc(ord(rcsMnuabout));
  end;
 end;
 cpage.hint:= uc(ord(rcsPagenumberinfo));
 callpage.hint:= uc(ord(rcsTotalpagesinfo));
 cbzoom.hint:= uc(ord(rcsZoominfo));
 with ttoolbar1 do begin
  buttons[0].hint:= uc(ord(rcsFirstinfo));
  buttons[1].hint:= uc(ord(rcsPrevinfo));
  buttons[2].hint:= uc(ord(rcsNextinfo));
  buttons[3].hint:= uc(ord(rcsLastinfo));
 end;
 with ttoolbar2 do begin
  buttons[1].hint:= uc(ord(rcsPrintrepinfo));
  buttons[2].hint:= uc(ord(rcsSaverepinfo));
  buttons[3].hint:= uc(ord(rcsSave2psinfo));
  buttons[4].hint:= uc(ord(rcsSave2pdfinfo));
  buttons[5].hint:= uc(ord(rcsFindtextinfo));
 end;
end;

procedure trepazpreviewfo.repazpreviewfo_onloaded(const sender: TObject);
begin
 setlangconsts(getcurrentlangconstsname);
 updatelang;
end;

procedure trepazpreviewfo.repazpreviewfo_ondestroy(const sender: TObject);
begin
 
end;

//contrib from Domingo Alvarez Duarte
//Should improve next time with real multiple pages
procedure trepazpreviewfo.tscrollbox1_onbeforeevent(const sender: tcustomscrollbar;
               var akind: scrolleventty; var avalue: Real);
begin
 if sender.value = 0 then begin //user tries to go beyond beginning of page
  if cpage.value > 1 then begin 
   btnprior_onexecute(sender);
   sender.value := 0.999999;
   akind := sbe_none;
  end;
 end;
 if sender.value = 1 then begin //user tries to go beyond end of page
  if cpage.value < callpage.value then begin
   btnnext_onexecute(sender);
   sender.value := 0.000001;
   akind := sbe_none;
  end;
 end;
end;

procedure trepazpreviewfo.repazpreviewfo_onclose(const sender: TObject);
begin
end;

end.
