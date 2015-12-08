{*********************************************************}
{                 Repaz Preview Components                }
{             Classes for preview Repaz Metadata          }
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

unit repazpreview;
{$ifdef FPC}{$mode objfpc}{$h+}{$interfaces corba}{$endif}

interface
uses
 classes,mclasses,msegui,msegraphutils,msegraphics,mseclasses,typinfo,
 msestrings,msewidgets,mseglob,msesimplewidgets,
 msedataedits,repazglob,repazchart,mseguiglob,
 mseeditglob;

type
 
 tpreview = class(tpaintbox)
  private
   fonpagereposition: notifyeventty;
   fonfileopened: notifyeventty;
   fpagecount: integer;
   fmetapages: tmetapages;
   factivepage,flastpage: integer;
   findhistory: msestringarty;
   tmpstring: tstringedit;
   zoomscale: real;
   origwidth: integer;
   origheight: integer;
   fpainting: boolean;
   //fthread: tmsethread;
   //fcanvas: tcanvas;
   procedure setmetapages(const avalue : tmetapages);
   procedure setactivepage(const avalue: integer);
  protected
   procedure clientmouseevent(var info: mouseeventinfoty); override;
   //function paintpage(thread: tmsethread): integer;
   procedure doonpaint(const acanvas: tcanvas); override;
   procedure showpage(apage: integer);
   function dofindtext(const apage: integer;
    const ainfo: findtextinfoty; var neverfound: boolean): boolean;
   procedure drawfocusedtext(ainfo:tabinfoty);
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   procedure savetofile(afilename: filenamety);
   procedure loadfromfile(const afilename: filenamety);
   procedure findtext;
   procedure zoom(const ascale: real); 
   property metapages: tmetapages read fmetapages write setmetapages;
  published
   property onpagereposition: notifyeventty read fonpagereposition write fonpagereposition;
   property onfileopened: notifyeventty read fonfileopened write fonfileopened;
   property pagecount: integer read fpagecount;
   property activepage: integer read factivepage write setactivepage;
   property optionswidget default defaultgroupboxoptionswidget;
 end;
 
implementation
uses
 msekeyboard,sysutils,
 mseactions,msestream,msesys,
 findtextdialogform;

{ tpreview }
  
constructor tpreview.create(aowner: tcomponent);
begin
 inherited;
 fpainting:= false;
 flastpage:= -1;
 createframe;
 if not (csdesigning in componentstate) then begin
  tmpstring:= tstringedit.create(self);
  tmpstring.createframe;
  tmpstring.createfont;
  tmpstring.visible:=false;
  tmpstring.readonly:= true;
  tmpstring.color:= cl_transparent;
  tmpstring.frame.colorclient:= cl_transparent;
  tmpstring.frame.levelo:= 0;
  tmpstring.frame.leveli:= 0;
  tmpstring.frame.framewidth:= 0;
  tmpstring.frame.framei_bottom:= 0;
  tmpstring.frame.framei_left:= 0;
  tmpstring.frame.framei_right:= 0;
  tmpstring.frame.framei_top:= 0;
  tmpstring.optionsskin:= [osk_noskin];
  tmpstring.optionswidget:= [ow_mousefocus];
  tmpstring.optionsedit:= [oe_readonly,oe_undoonesc,oe_exitoncursor,oe_autoselect,oe_autoselectonfirstclick,oe_hintclippedtext];
  insertwidget(tmpstring,makepoint(0,0));
 end;
 findhistory:= nil;
 frame.colorclient:=cl_white;
 frame.framewidth:=0;
 frame.colorframe:=cl_black;
 //fmetapages:= nil;
 zoomscale:= 1.0;
end;

destructor tpreview.destroy;
begin
 //clearmetapages(fmetapages);
 //fmetapages:= nil;
 freeandnil(tmpstring);
 findhistory:= nil;
 inherited;
 {if not (csdesigning in componentstate) then begin
  tmpstring.free;
 end;}
 {if fthread <> nil then begin
  fthread.terminate;
  application.waitforthread(fthread);
 end;
 fthread.free;}
end;

procedure tpreview.savetofile(afilename: filenamety);
var
 astream: tmsefilestream;
 binstream: tmemorystream;
 writer: twriter;
 pfmetapages: pmetapages;
 fmemsize: longint;
begin
 pfmetapages:= pmetapages(fmetapages);
 fmemsize:= memsize(pfmetapages);
 showmessage(inttostr(fmemsize));
 binstream:= tmemorystream.Create;
 astream:= tmsefilestream.create(afilename,fm_create);
 writer:= twriter.Create(binstream,fmemsize);
 writer.write(pfmetapages,fmemsize);
 writer.free;
 astream.copyfrom(binstream,fmemsize);
 astream.free;
 binstream.Free;
end;

procedure tpreview.loadfromfile(const afilename: filenamety);
begin
 //
end;

procedure tpreview.drawfocusedtext(ainfo:tabinfoty);
begin
  tmpstring.widgetrect:=makerect(ainfo.dest.x+1,ainfo.dest.y+1,ainfo.dest.cx,ainfo.dest.cy);
  tmpstring.font.color:= ainfo.fontcolor;
  tmpstring.font.height:= round(ainfo.fontsize*zoomscale);
  tmpstring.font.style:= ainfo.fontstyle;
  tmpstring.font.name:= ainfo.fontname;
  tmpstring.textflags:= ainfo.flags;
  tmpstring.textflagsactive:= ainfo.flags;
  tmpstring.value:= ainfo.text;
  tmpstring.readonly:= true;
  tmpstring.visible:= true;
  tmpstring.editor.selstart:=0;
  tmpstring.editor.sellength:=length(tmpstring.text);
  //tmpstring.activate;
end;

procedure tpreview.showpage(apage: integer);
begin
 factivepage:= apage;
 invalidate;
end;

function tpreview.dofindtext(const apage: integer;
 const ainfo: findtextinfoty; var neverfound: boolean): boolean;
var
 int1,int2: integer;
 found: boolean;
 fstart: integer; 
 tmprect: rectty;
 tabinfo:tabinfoty;
begin
 result:= true;
 if length(fmetapages[apage].tabobjects)>0 then begin
  for int1:=0 to length(fmetapages[apage].tabobjects)-1 do begin
   for int2:=0 to length(fmetapages[apage].tabobjects[int1].tabs)-1 do begin
    with fmetapages[apage].tabobjects[int1].tabs[int2] do begin
     fstart:=1;
     while fstart>0 do begin
      found:= false;
      fstart:= msestringsearch(ainfo.text,text,fstart,ainfo.options);
      if fstart>0 then begin
       found:= true;
       neverfound:= false;
       if factivepage<>apage then begin
        setactivepage(apage);              
       end;
       if zoomscale=1.0 then begin
        tmprect:= dest;
       end else begin
        tmprect.x:= round(dest.x * zoomscale);
        tmprect.y:= round(dest.y * zoomscale);
        tmprect.cx:= round(dest.cx * zoomscale);
        tmprect.cy:= round(dest.cy * zoomscale);
       end;
       tabinfo:= fmetapages[apage].tabobjects[int1].tabs[int2];
       tabinfo.dest:= tmprect;
       drawfocusedtext(tabinfo);
       if not askyesno('Find again?') then begin
        result:= false;
        exit;  
       end else begin
        inc(fstart,length(ainfo.text));
        if fstart>=length(text) then begin
         fstart:=0;
        end;
       end;
      end;
     end;
    end;
   end;
  end;
  if (found=false) and (apage=fpagecount-1) then begin
   if neverfound=true then begin
    showmessage('Text not found!');
    tmpstring.visible:= false;
   end else begin
    showmessage('Text not found again!');
   end;
   result:= true;
  end;
 end else begin
  showmessage('Text not found!');
  tmpstring.visible:= false;
  result:= true;
 end;
end;

procedure tpreview.findtext;
var
 info: findtextinfoty;
 int1: integer;
 neverfound: boolean;
begin
 neverfound:= true;
 info.options:=[so_caseinsensitive];
 info.allpage:= true;
 info.history:= findhistory;
 if findtextdialogexecute(info) then begin
  findhistory:= info.history;
  with info do begin
   if text<>'' then begin
    if allpage then begin
     for int1:=0 to fpagecount-1 do begin
      if not dofindtext(int1,info,neverfound) then break;
     end;
    end else begin
     dofindtext(factivepage,info,neverfound);
    end;
   end;
  end;
 end;
end;

procedure tpreview.zoom(const ascale: real);
begin
 if zoomscale<>ascale then begin
  zoomscale:= ascale;
  size:= makesize(round(origwidth*zoomscale),
    round(origheight*zoomscale));
 end;
 tmpstring.visible:= false;
end;

{function tpreview.paintpage(thread: tmsethread): integer;
begin
 result:= 0;
 printmetapages(fcanvas,fmetapages,factivepage,zoomscale);
end;}

procedure tpreview.doonpaint(const acanvas: tcanvas);
begin
 inherited;
 if (fmetapages<>nil) and (factivepage>=0) then begin
  if not fpainting then begin
   try
    fpainting:= true;
    application.lock;
    if (size.cx<>round(fmetapages[factivepage].pagewidth*zoomscale)) and 
      (size.cy<>round(fmetapages[factivepage].pageheight*zoomscale)) then begin
     size:= makesize(round(fmetapages[factivepage].pagewidth*zoomscale),
       round(fmetapages[factivepage].pageheight*zoomscale));
    end;
    //fcanvas:= acanvas;
    //fthread:= tmsethread.create({$ifdef FPC}@{$endif}paintpage);
    printmetapages(acanvas,fmetapages,factivepage,zoomscale);
    flastpage:= factivepage;
   finally
    fpainting:= false;
    application.unlock;
   end;
  end;
 end;
end;

procedure tpreview.clientmouseevent(var info: mouseeventinfoty);
var
 int1,int2: integer;
 tmprect: rectty;
 ainfo:tabinfoty;
begin
 inherited;
 if csdesigning in componentstate then exit;
 if high(fmetapages)<0 then exit;
 if factivepage<0 then exit;
 with info do begin
  if isdblclick(info) then begin
   if fmetapages[factivepage].chartobjects<>nil then begin
    if zoomscale=1.0 then begin
     tmprect:= fmetapages[factivepage].chartrect;
    end else begin
     tmprect.x:= round(fmetapages[factivepage].chartrect.x * zoomscale);
     tmprect.y:= round(fmetapages[factivepage].chartrect.y * zoomscale);
     tmprect.cx:= round(fmetapages[factivepage].chartrect.cx * zoomscale);
     tmprect.cy:= round(fmetapages[factivepage].chartrect.cy * zoomscale);
    end;
    if pointinrect(pos,tmprect) then begin
     int1:= ord(fmetapages[factivepage].chartobjects.charttype);
     if int1+1<=maxcharttype then inc(int1) else int1:=0;
     fmetapages[factivepage].chartobjects.charttype:= chartty(int1);
     invalidate;
     exit;
    end;
   end;
  end;
  if isclick(info) then begin
   for int1:=0 to high(fmetapages[factivepage].tabobjects) do begin
    with fmetapages[factivepage].tabobjects[int1] do begin
     for int2:=0 to high(tabs) do begin
      if zoomscale=1.0 then begin
       tmprect:= tabs[int2].dest;
      end else begin
       tmprect.x:= round(tabs[int2].dest.x * zoomscale);
       tmprect.y:= round(tabs[int2].dest.y * zoomscale);
       tmprect.cx:= round(tabs[int2].dest.cx * zoomscale);
       tmprect.cy:= round(tabs[int2].dest.cy * zoomscale);
      end;
      if pointinrect(pos,tmprect) then begin
       ainfo:= tabs[int2];
       ainfo.dest:= tmprect;
       drawfocusedtext(ainfo);
       exit;
      end;
     end;
    end;
   end;
  end;
 end;
end;

procedure tpreview.setmetapages(const avalue : tmetapages);
begin
 fmetapages:= avalue;
 fpagecount:= length(avalue);
 if fpagecount>0 then begin
  origwidth:= avalue[0].pagewidth;
  origheight:= avalue[0].pageheight;
 end else begin
  origwidth:= width;
  origheight:= height;
 end;
 if canevent(tmethod(fonfileopened)) then begin
  fonfileopened(self);
 end;
 if fpagecount>0 then begin
  showpage(0);
 end;
end;

procedure tpreview.setactivepage(const avalue: integer);
begin
 if avalue<>factivepage then begin
  factivepage:= avalue;
  tmpstring.visible:= false;
  showpage(avalue);
  if canevent(tmethod(fonpagereposition)) then begin
   fonpagereposition(self);
  end;
 end;
end;

end.
