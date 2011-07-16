{*********************************************************}
{               Report Designer for Repaz                 }
{         Base idea from IDE of MSEide+MSEgui             }
{            Written by : Martin Schreiber                }
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
unit repazdesign;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,msewidgets,
 msebitmap,msetabs,msedataedits,msestrings,msetypes,classes,db,msegrids,
 msesplitter,compdesigner,msedial,msedispwidgets,msereal,mseimage,
 repaz_bmp,compdesignintf,msedb,msefiledialog,msesys,sysutils,msedatalist,
 typinfo,mselookupbuffer,msestatfile,msetoolbar,repazglob,msedock,msesqldb,
 mseact,msesysutils;
type
 raeditorstatety = (ras_tabupdating,ras_mouseinclient);
 raeditorstatesty = set of raeditorstatety;

 tdatasourcepropeditor = class(tstringpropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
  public
   //procedure setvalue(const value: msestring); override;
   function getvalues: msestringarty; override;
 end;

 tlookupbufferpropeditor = class(tstringpropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
  public
   function getvalues: msestringarty; override;
 end;

 tdbfieldnamepropeditor = class(tstringpropeditor)
  private
   fnocalc: boolean;
  protected
   fdbeditinfointf: idbeditinfo;
   function getdefaultstate: propertystatesty; override;
  public
   function getvalues: msestringarty; override;
 end;

 tdbparamnamepropeditor = class(tstringpropeditor)
  protected
   fdbparaminfointf: idbparaminfo;
   function getdefaultstate: propertystatesty; override;
  public
   function getvalues: msestringarty; override;
 end;

 treptabulatoreditor = class(tclasselementeditor)
  public
   function getvalue: msestring; override;
 end;
 
 treptabulatorseditor = class(tpersistentarraypropeditor)
  protected
   function geteditorclass: propeditorclassty; override;
 end;

 texpressionpropeditor = class(tstringpropeditor)
   function getdefaultstate: propertystatesty;override;
  public
   procedure edit; override;
   function getvalue: msestring; override;
   procedure setvalue(const value: msestring); override;
 end;

 trepformatpropeditor = class(tstringpropeditor)
  protected
   function getdefaultstate: propertystatesty; override;
  public
   function getvalues: msestringarty; override;
 end;

 tlookupbufferfieldnopropeditor = class(tordinalpropeditor)
  private
   fintf: ilbfieldinfo;
   flbdatakind,flbkeykind: lookupkindty;
  protected
   function getdefaultstate: propertystatesty; override;
   function getnames: msestringarty;virtual;
   function getvalue1: msestring; virtual;
   procedure setvalue1(const value: msestring); virtual;
  public
   constructor create(const adesigner: tcomponentdesigner;
        const acomponent: tcomponent;
            const aobjectinspector: iobjectinspector;
            const aprops: propinstancearty; atypeinfo: ptypeinfo); override;
   function getvalues: msestringarty; override;
   function getvalue: msestring; override;
   procedure setvalue(const value: msestring); override;
 end;

 tlookupbufferkeyfieldnopropeditor = class(tlookupbufferfieldnopropeditor)
  protected
   function getnames: msestringarty;override;
   function getvalue1: msestring; override;
   procedure setvalue1(const value: msestring); override;
 end;

 trepazdesignfo = class(tdockform)
   tsplitter1: tsplitter;
   ttabpage4: ttabpage;
   tstringgrid2: tstringgrid;
   cunit: tdropdownlistedit;
   tbutton2: tbutton;
   tmainmenu1: tmainmenu;
   tfiledialog1: tfiledialog;
   tstatfile1: tstatfile;
   tsimplewidget2: tsimplewidget;
   tobjectinspector1: tobjectinspector;
   timagelist1: timagelist;
   tscrollbox1: tscrollbox;
   dialh: tdial;
   dialv: tdial;
   cpaper: tcomponentdesigner;
   tdockpanel1: tdockpanel;
   ttoolbar1: ttoolbar;
   tcomponentpallete1: tcomponentpallete;
   ttoolbar2: ttoolbar;
   cpage: tdropdownlistedit;
   tdropdownlistedit2: tdropdownlistedit;
   tpopupmenu1: tpopupmenu;
   tsimplewidget1: tsimplewidget;
   tspacer1: tspacer;
   frepfilename: tstringdisp;
   xdisp: trealdisp;
   ydisp: trealdisp;
   procedure repazdesignfo_oncreate(const sender: TObject);
   procedure repazdesignfo_onloaded(const sender: TObject);
   procedure repazdesignfo_onshow(const sender: TObject);
   procedure cpaper_onresize(const sender: TObject);
   procedure cpaper_onmouseevent(const sender: twidget;
                   var info: mouseeventinfoty);
   procedure reportcont_onchildscaled(const sender: TObject);
   procedure reportexit(const sender: TObject);
   procedure reportopen(const sender: TObject);
   procedure reportsave(const sender: TObject);
   procedure reportnew(const sender: TObject);
   procedure reportpreview(const sender: TObject);
   procedure reportsaveas(const sender: TObject);
   procedure newpage(const sender: TObject);
   procedure repazdesignfo_onclose(const sender: TObject);   
   procedure reportoptions(const sender: TObject);
   function getactivepage: string;
   procedure deletepage(const sender: TObject);
   procedure showhidegrid(const sender: TObject);
   procedure snaponoff(const sender: TObject);
   procedure mnuhelp(const sender: TObject);
   procedure mnuabout(const sender: TObject);
   procedure showpages;
   procedure updatelanguage;
   procedure cpage_ondataentered(const sender: TObject);
   procedure reportcont_onscroll(const sender: twidget; const point: pointty);
   procedure cunit_ondataentered(const sender: TObject);
   procedure copyexec(const sender: TObject);
   procedure cutexec(const sender: TObject);
   procedure pasteexec(const sender: TObject);
   procedure deleteexec(const sender: TObject);
   procedure undeleteexec(const sender: TObject);
   procedure tofrontexec(const sender: TObject);
   procedure tobackexec(const sender: TObject);
   procedure langen(const sender: TObject);
   procedure langid(const sender: TObject);
   procedure repazdesignfo_onclosequery(const sender: tcustommseform;
                   var amodalresult: modalresultty);
   procedure cpaper_onchange(const sender: TObject);
   procedure repazdesignfo_ondestroy(const sender: TObject);
  protected
   factivepage: string;
   fstate: raeditorstatesty;
   fpixelperunit:real;
   freportunit: raunitty;
   procedure reportopen; virtual;
   procedure reportsave; virtual;
   procedure reportnew; virtual;
   procedure reportpreview; virtual;
   procedure reportsaveas; virtual;
   procedure newpage; virtual;
   procedure report_onclose; virtual;  
   procedure updatedials;virtual;
   procedure setmousemarkers(const avalue: pointty; const source: twidget);                   
  public
   property pixelperunit: real read fpixelperunit write fpixelperunit;
   property reportunit: raunitty read freportunit write freportunit;
 end;
 
implementation
uses
 repazdesign_mfm,msefileutils,frmabout,frmreportoptions,mseconsts,
 repazconsts,mseconsts_id,repazclasses;
type
 tcomponent1 = class(tcomponent);
 tpropeditor1 =  class(tpropeditor);

procedure trepazdesignfo.cpaper_onresize(const sender: TObject);
begin
 updatedials;
end;

procedure trepazdesignfo.cpaper_onmouseevent(const sender: twidget;
               var info: mouseeventinfoty);
begin
 with info do begin
  case eventkind of
   ek_mouseleave: begin
    exclude(fstate,ras_mouseinclient);
    xdisp.value:= emptyreal;
    ydisp.value:= emptyreal;
    dialh.dial.markers[0].value:= emptyreal;
    dialv.dial.markers[0].value:= emptyreal;
   end;
   ek_mouseenter: begin
    include(fstate,ras_mouseinclient);
   end;
  end;
  if (eventkind in mouseposevents) and (ras_mouseinclient in fstate) then begin
   setmousemarkers(pos,sender);
  end;
 end;
end;

procedure trepazdesignfo.updatedials;
begin

end;

procedure trepazdesignfo.setmousemarkers(const avalue: pointty;
                                                    const source: twidget);
var
 pt1: pointty;
begin
 pt1:= avalue;
 xdisp.value:= pt1.x/fpixelperunit + dialh.dial.start;
 dialh.dial.markers[0].value:= xdisp.value;
 ydisp.value:= pt1.y/fpixelperunit + dialv.dial.start;
 dialv.dial.markers[0].value:= ydisp.value;
end;

procedure trepazdesignfo.reportcont_onchildscaled(const sender: TObject);
begin
 updatedials;
end;

procedure trepazdesignfo.repazdesignfo_onloaded(const sender: TObject);
var
 xx: string;
begin
 xx:= getcurrentlangconstsname;
 setlangconsts(xx);
 if xx='en' then
  tmainmenu1.menu.itembyname('mnulang').itembyname('mnuen').checked:= true
 else if xx='id' then
  tmainmenu1.menu.itembyname('mnulang').itembyname('mnuid').checked:= true;
 updatelanguage;
 updatedials;
 showpages;
 //tdockpanel1.invalidate;
end;

procedure trepazdesignfo.repazdesignfo_onshow(const sender: TObject);
begin
 updatedials;
end;

procedure trepazdesignfo.reportexit(const sender: TObject);
begin
 close;
end;

procedure trepazdesignfo.reportopen;
begin

end;

procedure trepazdesignfo.reportsave;
begin

end;

procedure trepazdesignfo.reportnew;
begin

end;

procedure trepazdesignfo.reportpreview;
begin

end;

procedure trepazdesignfo.reportsaveas;
begin

end;

procedure trepazdesignfo.newpage;
begin

end;

procedure trepazdesignfo.report_onclose;
begin

end;

procedure trepazdesignfo.reportopen(const sender: TObject);
begin
 reportopen;
end;

procedure trepazdesignfo.reportsave(const sender: TObject);
begin
 reportsave;
end;

procedure trepazdesignfo.reportnew(const sender: TObject);
begin
 reportnew;
end;

procedure trepazdesignfo.reportpreview(const sender: TObject);
begin
 reportpreview;
end;

procedure trepazdesignfo.reportsaveas(const sender: TObject);
begin
 reportsaveas;
end;

procedure trepazdesignfo.reportoptions(const sender: TObject);
begin
 try
  frmreportoptionsfo:= tfrmreportoptionsfo.create(nil);
  with frmreportoptionsfo do begin
   cshowgrid.value:= cpaper.showgrid;
   csnap.value:= cpaper.snaptogrid;
   cgridx.value:= cpaper.gridsizex;
   cgridy.value:= cpaper.gridsizey;
   cunits.dropdown.itemindex:= cunit.dropdown.itemindex;
   if show(true)=mr_ok then begin
    cpaper.showgrid:= cshowgrid.value;
    cpaper.snaptogrid:= csnap.value;
    cpaper.gridsizex:= realtytoint(cgridx.value);
    cpaper.gridsizey:= realtytoint(cgridy.value);    
    ttoolbar2.buttons[1].checked:= cshowgrid.value;
    ttoolbar2.buttons[2].checked:= csnap.value;
    cunit.dropdown.itemindex:= cunits.dropdown.itemindex;
    cunit_ondataentered(sender);
   end;
  end;
 finally
  frmreportoptionsfo.free;
 end;
end;

function trepazdesignfo.getactivepage: string;
var
 int1: integer;
begin
 result:='';
 for int1:=0 to cpaper.widgetcount-1 do begin
  if (cpaper.widgets[int1] is TraPage) and (cpaper.widgets[int1].visible) then begin
   result:= cpaper.widgets[int1].name;
   break;
  end;
 end;
end;

procedure trepazdesignfo.newpage(const sender: TObject);
begin
 newpage;
end;

procedure trepazdesignfo.deletepage(const sender: TObject);
var
 fdelpage: twidget;
 int1: integer; 
begin
 if cpaper.widgetcount<=1 then begin
  showmessage(uc(ord(rcsMsgmin1page)));
 end else begin
  fdelpage:= cpaper.findwidget(cpage.value);
  if fdelpage<>nil then begin
   if askyesno(uc(ord(rcsMsgdeletepage)),uc(ord(rcsCapdeletepage)),mr_cancel) then begin
    for int1:=0 to cpaper.widgetcount-1 do begin
     if cpaper.widgets[int1]=TraPage(fdelpage) then begin
      if int1>0 then begin
       cpaper.widgets[int1-1].visible:=true;
      end else begin
       cpaper.widgets[int1+1].visible:=true;
      end;
     end;
    end;
    fdelpage.free;
    showpages;
   end;
  end;  
 end;
end;

procedure trepazdesignfo.showhidegrid(const sender: TObject);
begin
 cpaper.showgrid:= (sender as ttoolbutton).checked;
end;

procedure trepazdesignfo.snaponoff(const sender: TObject);
begin
 cpaper.snaptogrid:= (sender as ttoolbutton).checked;
end;

procedure trepazdesignfo.mnuhelp(const sender: TObject);
begin
 showmessage('not yet created!');
end;

procedure trepazdesignfo.mnuabout(const sender: TObject);
begin
 frmaboutfo:= tfrmaboutfo.create(nil);
 frmaboutfo.show;
end;

procedure trepazdesignfo.showpages;
var
 int1: integer;
 fname: string;
begin
 cpage.dropdown.cols.clear;
 for int1:=0 to cpaper.widgetcount-1 do begin
  if cpaper.widgets[int1] is TraPage then begin
   cpage.dropdown.cols.addrow([cpaper.widgets[int1].name]);
  end;
 end;
 cpage.value:= factivepage;
 cpage_ondataentered(cpage);
end;

procedure trepazdesignfo.cpage_ondataentered(const sender: TObject);
var
 int1: integer;
 widget1: twidget;
begin
 for int1:=0 to cpaper.widgetcount-1 do begin
  TraPage(cpaper.widgets[int1]).visible:= false;
 end;
 widget1:= cpaper.findwidget(cpage.value);
 if widget1<>nil then begin
  TraPage(widget1).visible:= true;
  factivepage:= cpage.value;
  widget1.bringtofront;
 end;
end;

procedure trepazdesignfo.reportcont_onscroll(const sender: twidget;
               const point: pointty);
begin
 updatedials;
end;

procedure trepazdesignfo.cunit_ondataentered(const sender: TObject);
var
 int1: integer;
begin
 for int1:=0 to cpaper.widgetcount-1 do begin
  if cpaper.widgets[int1] is TraPage then begin
   TraPage(cpaper.widgets[int1]).reportunit:= raunitty(cunit.dropdown.itemindex);
  end;
 end;
 updatedials;
end;

procedure trepazdesignfo.updatelanguage;
begin
 with tmainmenu1.menu do begin
  itembyname('mnufile').caption:= uc(ord(rcsMnufile));
  with itembyname('mnufile') do begin
   itembyname('mnufilenew').caption:= uc(ord(rcsMnufilenew));
   itembyname('mnufileopen').caption:= uc(ord(rcsMnufileopen));
   itembyname('mnufilesave').caption:= uc(ord(rcsMnufilesave));
   itembyname('mnufilesaveas').caption:= uc(ord(rcsMnufilesaveas));
   itembyname('mnufileexit').caption:= uc(ord(rcsMnuexit));
  end;
  itembyname('mnuedit').caption:= uc(ord(rcsMnuedit));
  with itembyname('mnuedit') do begin
   itembyname('mnucopy').caption:= uc(ord(rcsMnucopy));
   itembyname('mnucut').caption:= uc(ord(rcsMnucut));
   itembyname('mnupaste').caption:= uc(ord(rcsMnupaste));
   itembyname('mnudelete').caption:= uc(ord(rcsMnudelete));
   itembyname('mnuundelete').caption:= uc(ord(rcsMnuundelete));
   itembyname('mnutofront').caption:= uc(ord(rcsMnutofront));
   itembyname('mnutoback').caption:= uc(ord(rcsMnutoback));
  end;
  itembyname('mnurep').caption:= uc(ord(rcsMnureport));
  with itembyname('mnurep') do begin
   itembyname('mnureppreview').caption:= uc(ord(rcsMnupreview));
   itembyname('mnurepoptions').caption:= uc(ord(rcsMnuoptions));
  end;
  itembyname('mnupage').caption:= uc(ord(rcsMnupages));
  with itembyname('mnupage') do begin
   itembyname('mnupageadd').caption:= uc(ord(rcsMnuaddpages));
   itembyname('mnupagedel').caption:= uc(ord(rcsMnuremovepages));
  end;
  itembyname('mnulang').caption:= uc(ord(rcsMnulanguage));
  itembyname('mnuhelp').caption:= uc(ord(rcsMnuhelp));
  with itembyname('mnuhelp') do begin
   itembyname('mnuhelphelp').caption:= uc(ord(rcsMnuhelp));
   itembyname('mnuhelpabout').caption:= uc(ord(rcsMnuabout));
  end;
 end;
 tsplitter1.hint:= uc(ord(rcsDraginfo));
 cpage.hint:= uc(ord(rscSelectpageinfo));
 cunit.hint:= uc(ord(rcsSelectunitinfo));
 with ttoolbar1 do begin
  buttons[0].hint:= uc(ord(rcsNewreportinfo));
  buttons[1].hint:= uc(ord(rcsOpenreportinfo));
  buttons[2].hint:= uc(ord(rcsSavereportinfo));
  buttons[3].hint:= uc(ord(rcsSaveasreportinfo));
  buttons[4].hint:= uc(ord(rcsPreviewreportinfo));
  buttons[6].hint:= uc(ord(rcsAddpageinfo));
  buttons[7].hint:= uc(ord(rcsDelpageinfo));
 end;
 with ttoolbar2 do begin
  buttons[1].hint:= uc(ord(rcsShowgridinfo));
  buttons[2].hint:= uc(ord(rcsSnapinfo));
  buttons[3].hint:= uc(ord(rcsExitinfo));
 end;
 with tpopupmenu1.menu do begin
  itembyname('mnucopy').caption:= uc(ord(rcsMnucopy));
  itembyname('mnucut').caption:= uc(ord(rcsMnucut));
  itembyname('mnupaste').caption:= uc(ord(rcsMnupaste));
  itembyname('mnudelete').caption:= uc(ord(rcsMnudelete));
  itembyname('mnuundelete').caption:= uc(ord(rcsMnuundelete));
  itembyname('mnutofront').caption:= uc(ord(rcsMnutofront));
  itembyname('mnutoback').caption:= uc(ord(rcsMnutoback));
 end;
 with ttoolbar2 do begin
  buttons[4].hint:= uc(ord(rcshintcopy));
  buttons[5].hint:= uc(ord(rcshintcut));
  buttons[6].hint:= uc(ord(rcshintpaste));
  buttons[7].hint:= uc(ord(rcshintdelete));
  buttons[8].hint:= uc(ord(rcshintundelete));
  buttons[9].hint:= uc(ord(rcshinttofront));
  buttons[10].hint:= uc(ord(rcshinttoback));
 end;
end;

procedure trepazdesignfo.repazdesignfo_oncreate(const sender: TObject);
begin
 inherited;
 regpropeditor(typeinfo(msestring),TraTabulatorItem,'expression',texpressionpropeditor);
 regpropeditor(typeinfo(string),nil,'lookup_buffer',tlookupbufferpropeditor);
 regpropeditor(typeinfo(string),nil,'datasource',tdatasourcepropeditor);
 regpropeditor(typeinfo(TraTabulators),nil,'',treptabulatorseditor);
 regpropeditor(typeinfo(string),nil,'datafield',tdbfieldnamepropeditor);
 regpropeditor(typeinfo(string),nil,'DetailParams',tdbparamnamepropeditor);
 regpropeditor(typeinfo(string),nil,'Param',tdbparamnamepropeditor);
 regpropeditor(typeinfo(string),nil,'Tree_KeyField',tdbfieldnamepropeditor);
 regpropeditor(typeinfo(string),nil,'KeyField',tdbfieldnamepropeditor);
 regpropeditor(typeinfo(string),nil,'Tree_ParentField',tdbfieldnamepropeditor);
 regpropeditor(typeinfo(string),nil,'KeyFieldHeader',tdbfieldnamepropeditor);
 regpropeditor(typeinfo(string),TGroupItem,'groupfield',tdbfieldnamepropeditor);
 regpropeditor(typeinfo(msestring),TraTabulatorItem,'format',trepformatpropeditor);
 regpropeditor(typeinfo(integer),TraTabulatorItem,'Lookup_KeyFieldNo',
                    tlookupbufferkeyfieldnopropeditor);
 regpropeditor(typeinfo(integer),TraTabulatorItem,'Lookup_ValueFieldNo',
                    tlookupbufferfieldnopropeditor);
end;

procedure trepazdesignfo.copyexec(const sender: TObject);
begin
 cpaper.docopy(false);
end;

procedure trepazdesignfo.cutexec(const sender: TObject);
begin
 cpaper.docut;
end;

procedure trepazdesignfo.pasteexec(const sender: TObject);
begin
 cpaper.dopaste(true);
end;

procedure trepazdesignfo.deleteexec(const sender: TObject);
begin
 cpaper.dodelete;
end;

procedure trepazdesignfo.undeleteexec(const sender: TObject);
begin
 cpaper.doundelete;
end;

procedure trepazdesignfo.tofrontexec(const sender: TObject);
begin
 cpaper.dobringfront; 
end;

procedure trepazdesignfo.tobackexec(const sender: TObject);
begin
 cpaper.dosendback;
end;

procedure trepazdesignfo.langen(const sender: TObject);
begin
 setlangconsts('en');
 updatelanguage;
 application.invalidate;
end;

procedure trepazdesignfo.langid(const sender: TObject);
begin
 setlangconsts('id');
 updatelanguage;
end;

procedure trepazdesignfo.repazdesignfo_onclose(const sender: TObject);
begin
 report_onclose;
end;

procedure trepazdesignfo.repazdesignfo_onclosequery(const sender: tcustommseform;
               var amodalresult: modalresultty);
begin
 if self=nil then exit;
 if cpaper.modified then begin
  case askyesnocancel(uc(ord(rcsAskSave)),uc(ord(rcsCapConfirmation ))) of
  mr_yes: 
   begin
    reportsave(nil);
   end;
  mr_no:
   begin
    
   end;
  else
   begin
    amodalresult:= mr_none; //do not close the window
   end;
  end; 
 end;
end;

procedure trepazdesignfo.cpaper_onchange(const sender: TObject);
begin
 ttoolbar1.buttons[2].enabled:= true;
 ttoolbar1.buttons[3].enabled:= true;
end;

procedure trepazdesignfo.repazdesignfo_ondestroy(const sender: TObject);
var
 int1: integer;
begin
 for int1:= cpaper.widgetcount-1 downto 0 do begin
  //TraPage(cpaper.widgets[int1]).report:= nil;
  //cpaper.widgets[int1].free;
 end;
end;

function getdatasourcelist(arepaz: trepaz): msestringarty;
var
 int1: integer;
begin
 result:=nil;
 if arepaz.datasources<>nil then begin
  setlength(result,arepaz.datasources.count);
  for int1:= 0 to high(result) do begin
   result[int1]:= arepaz.datasources.datasource[int1].datasource.name;
  end;
 end;
end;

function getlookupbufferlist(arepaz: trepaz): msestringarty;
var
 int1: integer;
begin
 result:= nil;
 if arepaz.lookupbuffers<>nil then begin
  setlength(result,arepaz.lookupbuffers.count);
  for int1:= 0 to high(result) do begin
   result[int1]:= arepaz.lookupbuffers.lookupbuffer[int1].lookupbuffer.name;
  end;
 end;
end;

{ tdatasourcecomponenteditor }

function tdatasourcepropeditor.getvalues: msestringarty;
begin
 result:= getdatasourcelist(TraReportTemplate(component).reportpage.report);
end;

function tdatasourcepropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_valuelist, ps_sortlist,ps_volatile,ps_refresh,ps_refreshall];
end;

{ tlookupbuffercomponenteditor }

function tlookupbufferpropeditor.getvalues: msestringarty;
begin
 result:= getlookupbufferlist(TraReportTemplate(component).reportpage.report);
end;

function tlookupbufferpropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_valuelist, ps_sortlist,ps_volatile,ps_refresh,ps_refreshall];
end;

{ tdbfieldnamepropeditor }

function tdbfieldnamepropeditor.getdefaultstate: propertystatesty;
var
 //datasource1: tdatasource;
 obj1: tobject;
 ar1: stringarty;
 ar2: fieldtypesarty;
 int1,int2: integer;
begin
 result:= inherited getdefaultstate;
 if fremote <> nil then begin
  obj1:= tobject(tpropeditor1(fremote.getparenteditor).getpointervalue);
  if obj1 <> nil then begin
   getcorbainterface(obj1,typeinfo(idbeditinfo),fdbeditinfointf);
  end;
 end
 else begin
  if (high(fprops) = 0) then begin
   with fprops[0] do begin
    getcorbainterface(instance,typeinfo(idbeditinfo),fdbeditinfointf);
   end;
  end;
 end;
 if fdbeditinfointf <> nil then begin
  fdbeditinfointf.getfieldtypes(ar1,ar2);
  int2:= 0;
  for int1:= 0 to high(ar1) do begin
   if ar1[int1] = name then begin
    int2:= int1;
    break;
   end;
  end;
  //datasource1:= fdbeditinfointf.getdatasource(int2);
  result:= result + [ps_valuelist,ps_sortlist];
 end;
end;

function tdbfieldnamepropeditor.getvalues: msestringarty;
var
 propertynames: stringarty;
 fieldtypes: fieldtypesarty;
 ft: fieldtypesty;
 int1,int2: integer;
 ds: tdataset;
 dataso: tdatasource;
 
begin
 result:= nil;
 if (fdbeditinfointf <> nil) then begin
  int2:= 0;
  fdbeditinfointf.getfieldtypes(propertynames,fieldtypes);
  if high(propertynames) >= 0 then begin
   for int1:= 0 to high(propertynames) do begin
    if propertynames[int1] = fname then begin
     int2:= int1;
     break;
    end;
   end; 
  end;
  if int2 <= high(fieldtypes) then begin
   ft:= fieldtypes[int2];
  end
  else begin
   ft:= [];
  end;
  ds:= fdbeditinfointf.getdataset(int2);
  if ds <> nil then begin
   if ds.active or (ds.fields.count > 0) then begin
    for int1:= 0 to ds.fields.count -1 do begin
     with ds.fields[int1] do begin
      if ((ft = []) or (datatype = ftunknown) or (datatype in ft)) and
             (not fnocalc or (fieldkind <> fkcalculated)) then begin
       additem(result,msestring(fieldname));
      end;
     end;
    end;
   end
   else begin
    for int1:= 0 to ds.fielddefs.count -1 do begin
     with ds.fielddefs[int1] do begin
      if (ft = []) or (datatype = ftunknown) or (datatype in ft) then begin
       additem(result,msestring(name));
      end;
     end;
    end;
   end;
  end;
 end;
end;

{ tdbparamnamepropeditor }

function tdbparamnamepropeditor.getdefaultstate: propertystatesty;
var
 obj1: tobject;
begin
 result:= inherited getdefaultstate;
 if fremote <> nil then begin
  obj1:= tobject(tpropeditor1(fremote.getparenteditor).getpointervalue);
  if obj1 <> nil then begin
   getcorbainterface(obj1,typeinfo(idbparaminfo),fdbparaminfointf);
  end;
 end
 else begin
  if (high(fprops) = 0) then begin
   with fprops[0] do begin
    getcorbainterface(instance,typeinfo(idbparaminfo),fdbparaminfointf);
   end;
  end;
 end;
 if (fdbparaminfointf <> nil) and (fdbparaminfointf.getdestdataset <> nil) then begin
  result:= result + [ps_valuelist,ps_sortlist];
 end;
end;

function tdbparamnamepropeditor.getvalues: msestringarty;
var
 int1: integer;
begin
 with fdbparaminfointf.getdestdataset.params do begin
  for int1:= 0 to count - 1 do begin
   additem(result,msestring(items[int1].name));
  end;
 end;
end;

{ treptabulatoreditor }

function treptabulatoreditor.getvalue: msestring;
var
 mstr1: msestring;
begin
 with TraTabulatorItem(getpointervalue) do begin
  if datafield = '' then begin
   if expression='' then
    mstr1:= Text
   else
    mstr1:= expression;
  end
  else begin
   mstr1:= datafield;
   if (reallookupbuffer <> nil) and (reallookupbuffer is tdblookupbuffer) and 
    (lookup_valuefieldno >= 0) then begin
    with tdblookupbuffer(reallookupbuffer) do begin
     case lookup_valuetype of
      lk_text: begin
       if lookup_valuefieldno < reallookupbuffer.fieldcounttext then begin
        mstr1:= mstr1+'='+textfields[lookup_valuefieldno];
       end;
      end;
      lk_integer: begin
       if lookup_valuefieldno < reallookupbuffer.fieldcountinteger then begin
        mstr1:= mstr1+'='+integerfields[lookup_valuefieldno];
       end;
      end;
      lk_float,lk_date,lk_time,lk_datetime: begin
       if lookup_valuefieldno < reallookupbuffer.fieldcountfloat then begin
        mstr1:= mstr1+'='+floatfields[lookup_valuefieldno];
       end;
      end;
     end;
    end;
   end;
   if TraTabulatorItem(getpointervalue) is TraTabulatorItemSummary then begin
    with TraTabulatorItemSummary(getpointervalue) do begin
     if summarytype<>st_None then begin
      case summarytype of
       st_Sum: mstr1:= 'SUM('+mstr1+')';
       st_Count: mstr1:= 'COUNT('+mstr1+')';
       st_Average: mstr1:= 'AVG('+mstr1+')';
      end;
     end;
    end;
   end;
  end;
  result:= 'U='+formatfloat('0.0',position)+';'+formatfloat('0.0',width)+' C=' + 
    inttostr(RAW_PosInChar)+';'+inttostr(RAW_WidthInChar)+' ['+mstr1+']';
 end;
end;

{ treptabulatorseditor }

function treptabulatorseditor.geteditorclass: propeditorclassty;
begin
 result:= treptabulatoreditor;
end;

{ texpressionpropeditor }

function texpressionpropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate + [ps_isordprop,ps_dialog];
end;

procedure texpressionpropeditor.edit;
begin
 setvalue(decodemsestring((component as TraReportTemplate).expressiondialog(encodemsestring(getvalue))));
 //modified;
end;

function texpressionpropeditor.getvalue: msestring;
begin
 result:= getmsestringvalue(0);
end;

procedure texpressionpropeditor.setvalue(const value: msestring);
begin
 setmsestringvalue(value);
end;

{ trepformatpropeditor }

function trepformatpropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate;
 result:= result + [ps_valuelist];
end;

function trepformatpropeditor.getvalues: msestringarty;
begin
 setlength(result,25);
 result[0]:= '0'; 
 result[1]:= '0.00'; 
 result[2]:= '#.##'; 
 result[3]:= '#,##0.00'; 
 result[4]:= '#,##0.00;(#,##0.00)'; 
 result[5]:= '#,##0;(#,##0)'; 
 result[6]:= '#,##0.00;;Zero'; 
 result[7]:= '0.000E+00'; 
 result[8]:= '#.###E-0'; 
 result[9]:= 'c'; //shortdateformat + ? ? + shorttimeformat
 result[10]:= 'ddddd'; //shortdateformat
 result[11]:= 't'; //shorttimeformat
 result[12]:= 'tt'; //longtimeformat
 result[13]:= 'yyyy/mm/dd hh:nn:ss'; 
 result[14]:= 'yy/mm/dd hh:nn:ss'; 
 result[15]:= 'yyyy/mm/dd'; 
 result[16]:= 'yy/mm/dd'; 
 result[17]:= 'dd/mm/yyyy hh:n:ss'; 
 result[18]:= 'dd/mm/yy hh:nn:s'; 
 result[19]:= 'dd/mm/yyyy'; 
 result[20]:= 'dd/mm/yy'; 
 result[21]:= 'hh:nn:ss am/pm'; 
 result[22]:= 'hh:nn:ss a/p'; 
 result[23]:= 'h:n:s am/pm'; 
 result[24]:= 'h:n:s a/p'; 
end;

{ tlookupbufferfieldnopropeditor }

constructor tlookupbufferfieldnopropeditor.create(const adesigner: tcomponentdesigner;
     const acomponent: tcomponent;
         const aobjectinspector: iobjectinspector;
         const aprops: propinstancearty; atypeinfo: ptypeinfo);
begin
 getcorbainterface(aprops[0].instance,typeinfo(ilbfieldinfo),fintf);
 if fintf <> nil then begin
  flbdatakind:= fintf.getlbdatakind(aprops[0].propinfo^.name);
  flbkeykind:= fintf.getlbdatakind(aprops[0].propinfo^.name);
  {if fintf.getlb = nil then begin
   flbdatakind:= lbdk_none;
  end;}
 end;
 inherited;
end;

function tlookupbufferfieldnopropeditor.getdefaultstate: propertystatesty;
begin
 result:= inherited getdefaultstate;
 //if flbdatakind <> lbdk_none then begin
  result:= result + [ps_valuelist,ps_sortlist];
 //end;
end;

function tlookupbufferfieldnopropeditor.getnames: msestringarty;
var
 lb1: tcustomlookupbuffer;
 ar1: stringarty;
 int1: integer;
begin
 ar1:= nil;
 if fintf <> nil then begin
  lb1:= fintf.getlb;
  if lb1 <> nil then begin
   case flbdatakind of
    lk_Integer: begin
     ar1:= lb1.fieldnamesinteger;
    end;
    lk_Int64: begin
     ar1:= lb1.fieldnamesint64;
    end;
    lk_Float: begin
     ar1:= lb1.fieldnamesfloat;
    end;
    lk_Text: begin
     ar1:= lb1.fieldnamestext;
    end;
   end;
  end;
 end;
 setlength(result,length(ar1));
 for int1:= 0 to high(ar1) do begin
  result[int1]:= ar1[int1];
 end;
end;

function tlookupbufferfieldnopropeditor.getvalues: msestringarty;
begin
 result:= getnames;
end;

procedure tlookupbufferfieldnopropeditor.setvalue1(const value: msestring);
var
 ar1: msestringarty;
 int1: integer;
begin
 if value <> '' then begin
  ar1:= getnames;
  for int1:= 0 to high(ar1) do begin
   if value = ar1[int1] then begin
    setordvalue(int1);
    exit;
   end;
  end;
 end;
end;

procedure tlookupbufferfieldnopropeditor.setvalue(const value: msestring);
begin
 setvalue1(value);
 //inherited;
end;

function tlookupbufferfieldnopropeditor.getvalue1: msestring;
var
 ar1: msestringarty;
 int1: integer;
begin
 if fintf <> nil then begin
  int1:= getordvalue;
  ar1:= getnames;
  if (int1 >= 0) and (int1 <= high(ar1)) then begin
   result:= '<'+ar1[int1]+'>';
  end
  else begin
   result:= '<>';
  end;
 end else begin
  result:= '<>';
 end;
end;

function tlookupbufferfieldnopropeditor.getvalue: msestring;
begin
 result:= inherited getvalue;
 result:= result+getvalue1;
end;

function tlookupbufferkeyfieldnopropeditor.getnames: msestringarty;
var
 lb1: tcustomlookupbuffer;
 ar1: stringarty;
 int1,int2,int3: integer;
begin
 ar1:= nil;
 if fintf <> nil then begin
  lb1:= fintf.getlb;
  if lb1 <> nil then begin
   int3:=0;
   ar1:= lb1.fieldnamesinteger;
   int1:= length(ar1);
   if int1>0 then begin
    int3:= int3+int1;
    setlength(result,int3);
    for int2:=0 to length(ar1)-1 do begin
     result[int2]:= ar1[int2];
    end;
   end;
   ar1:= lb1.fieldnamesint64;
   int1:= length(ar1);
   if int1>0 then begin
    setlength(result,int3+int1);
    for int2:=0 to length(ar1)-1 do begin
     result[int3+int2]:= ar1[int2];
    end;
    int3:= int3+int1;
   end;
   ar1:= lb1.fieldnamesfloat;
   int1:= length(ar1);
   if int1>0 then begin
    setlength(result,int3+int1);
    for int2:=0 to length(ar1)-1 do begin
     result[int3+int2]:= ar1[int2];
    end;
    int3:= int3+int1;
   end;
   ar1:= lb1.fieldnamestext;
   int1:= length(ar1);
   if int1>0 then begin
    setlength(result,int3+int1);
    for int2:=0 to length(ar1)-1 do begin
     result[int3+int2]:= ar1[int2];
    end;
    int3:= int3+int1;
   end;
  end;
 end;
end;

function tlookupbufferkeyfieldnopropeditor.getvalue1: msestring;
var
 ar1: stringarty;
 int1: integer;
 lb1: tcustomlookupbuffer;
begin
 if fintf <> nil then begin
  lb1:= fintf.getlb;
  if lb1 <> nil then begin
   int1:= getordvalue;
   case flbkeykind of
    lk_Integer: begin
     ar1:= lb1.fieldnamesinteger;
     if (int1 >= 0) and (int1 <= high(ar1)) then begin
      result:= '<'+ar1[int1]+'>';
     end
    end;
    lk_Int64: begin
     ar1:= lb1.fieldnamesint64;
     if (int1 >= 0) and (int1 <= high(ar1)) then begin
      result:= '<'+ar1[int1]+'>';
     end
    end;
    lk_Float: begin
     ar1:= lb1.fieldnamesfloat;
     if (int1 >= 0) and (int1 <= high(ar1)) then begin
      result:= '<'+ar1[int1]+'>';
     end
    end;
    lk_Text: begin
     ar1:= lb1.fieldnamestext;
     if (int1 >= 0) and (int1 <= high(ar1)) then begin
      result:= '<'+ar1[int1]+'>';
     end
    end;
   end;
  end else begin
   result:= '<>';
  end;
 end else begin
  result:= '<>';
 end;
end;

procedure tlookupbufferkeyfieldnopropeditor.setvalue1(const value: msestring);
var
 ar1: stringarty;
 ar2: msestringarty;
 int1,int2,int3: integer;
 lb1: tcustomlookupbuffer;
begin
 if value <> '' then begin
  ar2:= getnames;
  for int2:= 0 to high(ar2) do begin
   if value = ar2[int2] then begin
    lb1:= fintf.getlb;
    int3:= 0;
    if lb1 <> nil then begin
     ar1:= lb1.fieldnamesinteger;
     int3:= length(ar1);
     if int2>int3 then begin
      ar1:= lb1.fieldnamesint64;
      int3:= int3+length(ar1);
      if int2>int3 then begin
       ar1:= lb1.fieldnamesfloat;
       int3:= int3+length(ar1);
       if int2>int3 then begin
        ar1:= lb1.fieldnamestext;
        int3:= int3+length(ar1);
        if int2<=int3 then begin
         int1:= int2;
        end;
       end else begin
        int1:= int2-int3;
       end;
      end else begin
       int1:= int2-int3;
      end;
     end else begin
      int1:= int2;
     end;
    end;
    setordvalue(int1);
    exit;
   end;
  end;
 end;
end;

initialization
 registeredcomponents.regcomponents('RepazComp',[TraSimpleReport,TraMasterDetailReport,TraMultiTableReport,TraGroupReport,TraTreeReport,TraChartReport,TraLetterReport,TraPage,TraLabelReport]); 
 registeredcomponents.regcomponenttabhints(['RepazComp'],['Repaz simple report','Master-detail report','Repaz multi table report','Repaz grouping report',
   'Repaz tree report','Repaz chart report','Repaz letter report','Repaz page','Label report']);
 registeredcomponents.setinvisiblecomponents('RepazComp',[TraPage]); 
end.
