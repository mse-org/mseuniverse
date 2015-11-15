{ MSEgit Copyright (c) 2011-2014 by Martin Schreiber
   
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
}
unit diffform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 classes,mclasses,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,
 msegui,msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,
 msestatfile,msedataedits,mseedit,msegrids,mseifiglob,msestrings,msetypes,
 msewidgetgrid,mseeditglob,msetextedit,mainmodule,mseact,mseactions,dispform,
 msescrollbar,msetabs,msewidgets,sysutils,difftab,msethreadcomp,msesystypes,
 mseificomp,mseificompglob;

type
 refreshinfoty = record
   iscommits: boolean;
   cached: boolean;
   commits: msestringarty;
   path: msestring;
   a: msestring;
   b: msestring;
 end;
 
 tdifffo = class(tdispfo)
   tpopupmenu1: tpopupmenu;
   externaldiffact: taction;
   tabs: ttabwidget;
   refreshthread: tthreadcomp;
   findindiffact: taction;
   repeatfind: taction;
   procedure externaldiffexe(const sender: TObject);
   procedure popupupdateexe(const sender: tcustommenu); virtual;
   procedure refreshexe(const sender: tthreadcomp);
   procedure findupdate(const sender: tcustomaction);
   procedure findexe(const sender: TObject);
   procedure repeatfindexe(const sender: TObject);
   procedure terminateexe(const sender: tthreadcomp);
   procedure asyncexe(const sender: TObject; var atag: Integer);
  private
   procedure showdiff(const dest: tdifftabfo; const text: msestringarty);
   procedure cleartabs;
  protected
   fi: refreshinfoty;
   fcanexternaldiff: boolean;
   fgitproc: prochandlety;
   fdifftext: msestringarty;
   function currentpath: filenamety;
   procedure dorefresh; override;
   procedure doclear; override;
   function singlediff: boolean;
   procedure refresh1(const adir: tgitdirtreenode;
                                      const afile: tmsegitfileitem);
   procedure dorepoloaded; override;
  public
   constructor create(aowner: tcomponent); override;
   procedure refresh(const adir: tgitdirtreenode;
                                      const afile: tmsegitfileitem;
                  const commits: msestringarty); overload;
   procedure refresh(const adir: tgitdirtreenode;
                                      const afile: tmsegitfileitem;
          const oldcommit: msestring; const newcommit: msestring); overload;
   property iscommits: boolean read fi.iscommits write fi.iscommits;
 end;

implementation
uses
 diffform_mfm,mserichstring,msearrayutils,msefileutils,msegitcontroller,main,
 mseprocutils,msestream,finddialogform;
 
const
 chunkcolor = cl_dkmagenta;
 addcolor = $008000;
 removecolor = cl_dkred;
 
{ tdifffo }

constructor tdifffo.create(aowner: tcomponent);
begin
 fgitproc:= invalidprochandle;
 inherited create(aowner);
 tabs.add(itabpage(tdifftabfo.create(nil)));
end;

procedure tdifffo.cleartabs;
var
 int1: integer;
begin
 tabs.beginupdate;
 for int1:= tabs.count - 1 downto 1 do begin
  tabs[int1].free;
 end;
 if tabs.count > 0 then begin
  tdifftabfo(tabs[0]).grid.clear; //canceled otherwise
 end;
 tabs.endupdate;
end;

procedure tdifffo.doclear;
//var
// int1: integer;
begin
 fcanexternaldiff:= false;
 fi.path:= '';
 fi.a:= '';
 fi.b:= '';
 if not mainfo.refreshing then begin
  cleartabs;
 end;
// grid.clear;
end;

function tdifffo.currentpath: filenamety;
begin
 if fcanexternaldiff then begin
  result:= fi.path;
 end
 else begin
  result:= mainmo.repobase+tabs.activepageintf.gettabhint;
 end;
end;

procedure tdifffo.externaldiffexe(const sender: TObject);
begin
 with mainmo.git do begin
  if fi.cached then begin
   mainmo.execgitconsole('difftool -y --tool='+
               encodestringparam(mainmo.opt.difftool)+' '+
                       '--cached '+noemptystringparam(fi.b)+
          ' -- '+encodepathparam(currentpath,true));
  end
  else begin
   mainmo.execgitconsole('difftool -y --tool='+
               encodestringparam(mainmo.opt.difftool)+' '+
                        noemptystringparam(fi.a)+noemptystringparam(fi.b)+
          ' -- '+encodepathparam(currentpath,true));
  end;
 end;
end;

procedure tdifffo.showdiff(const dest: tdifftabfo; const text: msestringarty);
var
 int1: integer;
 po1: prichstringaty;
 chunkformat,addformat,removeformat: formatinfoarty;
begin
 setfontcolor1(chunkformat,0,bigint,chunkcolor);
 setfontcolor1(addformat,0,bigint,addcolor);
 setfontcolor1(removeformat,0,bigint,removecolor);
 with dest do begin
  grid.beginupdate;
  try
   ed.gridvalues:= text;
   po1:= ed.datalist.datapo;
   for int1:= 0 to ed.datalist.count-1 do begin
    with po1^[int1] do begin
     if text <> '' then begin
      case text[1] of
       '@': begin
        format:= chunkformat;
       end;
       '+': begin
        format:= addformat;
       end;
       '-': begin
        format:= removeformat;
       end;
      end;
     end;
    end;
   end;
  finally
   grid.endupdate;
  end;
 end;
end;

procedure tdifffo.dorefresh;
var
 int1: integer;
begin
 int1:= application.unlockall();
 try
  refreshthread.terminate;
  killprocess(fgitproc);
//  terminateprocess(fgitproc);
  refreshthread.run;
 finally
  application.relockall(int1);
 end;
end;

procedure tdifffo.refreshexe(const sender: tthreadcomp);
var
 ar1: msestringarty;
 fi1: refreshinfoty;
 diffcontextn1: integer;
begin
 mainmo.git.setprociddest(fgitproc);
 application.lock;
 fi1:= fi;
 diffcontextn1:= mainmo.opt.diffcontextn;
 mainfo.beginbackground;
 fdifftext:= nil;
 application.unlock;
 with fi1 do begin 
  if iscommits then begin
   ar1:= mainmo.git.diff(commits,path,diffcontextn1,
                charencodingty(mainmo.opt.diffencoding));
  end
  else begin
   if cached then begin
    ar1:= mainmo.git.diff(b,path,diffcontextn1,
                charencodingty(mainmo.opt.diffencoding),
                mainmo.opt.maxdiffsize*1000);
   end
   else begin
    ar1:= mainmo.git.diff(a,b,path,diffcontextn1,
                charencodingty(mainmo.opt.diffencoding),
                                       mainmo.opt.maxdiffsize*1000);
   end;
  end;
 end;
 if not sender.terminated then begin
  application.lock;
  fdifftext:= ar1;
  application.unlock();
 end;
end;

const
 difftag = 83267593;
 
procedure tdifffo.terminateexe(const sender: tthreadcomp);
begin
 asyncevent(difftag,[peo_first]);
end;

procedure tdifffo.asyncexe(const sender: TObject; var atag: Integer);

 function checkterminate(): boolean;
 begin
  result:= application.waitescaped();
  if result then begin
   tabs.clear;
  end;
 end; //checkterminate

var
 int1,int2,int3: integer;
 ar1: msestringarty;
 ar3: filenamearty;
 captions,hints: msestringarty;
 ar2: msestringararty;
 intar1: integerarty;
 mstr1: msestring;
 truncated: boolean;
begin
 if atag <> difftag then begin
  exit;
 end;
 ar1:= fdifftext;
 fdifftext:= nil;
 application.beginwait();
 tabs.beginupdate();
 try
  if checkterminate() then begin
   exit;
  end;
  int2:= -1;
  if mainmo.opt.splitdiffs then begin
   int3:= 3+length(mainmo.repobase);
   with tabs do begin
    if activepageindex >= 0 then begin
     mstr1:= itemsintf[activepageindex].gettabhint;
    end
    else begin
     mstr1:= '';
    end;
   end;
   truncated:= (ar1 <> nil) and (ar1[high(ar1)] = trunctag);
   for int1:= 0 to high(ar1) do begin
    if checkterminate() then begin
     exit;
    end;
    if msestartsstr('diff ',ar1[int1]) then begin
     if int2 >= 0 then begin   
      additem(ar2,copy(ar1,int2,int1-int2));
     end;
     splitstringquoted(ar1[int1],ar3,msechar('"'),msechar(' '));
     additem(hints,msestring(copy(ar3[high(ar3)],int3,bigint)));
     additem(captions,filename(hints[high(hints)]));
     int2:= int1;
     if length(captions) >= mainmo.opt.maxdiffcount then begin
      truncated:= true;
      break;
     end;
    end;
   end;
   if int2 >= 0 then begin
    additem(ar2,copy(ar1,int2,bigint));
   end;
   sortarray(captions,sms_upi,intar1);
   orderarray(intar1,hints);
   orderarray(intar1,ar2);
   if truncated then begin
    additem(captions,'*truncated*');
    additem(hints,'');
    additem(ar2,nil);
   end;
  end
  else begin
   if ar1 <> nil then begin
    additem(ar2,ar1);
    setlength(captions,1);
    setlength(hints,1);
   end;
  end;
  if ar2 = nil then begin
   for int2:= tabs.count-1 downto 1 do begin
    tabs[int2].free;
   end;
   if tabs.count > 0 then begin
    tdifftabfo(tabs[0]).grid.clear;
    tabs.activepageindex:= 0;
   end;
  end
  else begin
   for int2:= tabs.count-1 downto length(ar2) do begin
    if checkterminate() then begin
     exit;
    end;
    tabs[int2].free;
   end;
   for int2:= tabs.count to high(ar2) do begin  
    if checkterminate() then begin
     exit;
    end;
    tabs.add(itabpage(tdifftabfo.create(nil)));
   end;
   for int1:= 0 to tabs.count - 1 do begin
    if checkterminate() then begin
     exit;
    end;
    with tdifftabfo(tabs[int1]) do begin
     caption:= captions[int1];
     tabhint:= hints[int1];
    end;
    showdiff(tdifftabfo(tabs[int1]),ar2[int1]);
   end;
   tabs.activepageindex:= 0;
   if (mstr1 <> '') and mainmo.opt.splitdiffs then begin
    for int1:= 0 to high(hints) do begin
     if hints[int1] = mstr1 then begin
      tabs.activepageindex:= int1;
      break;
     end;
    end;
   end;
  end;
 finally
  tabs.endupdate;  
  mainfo.endbackground();
  application.endwait();
 end;
end;

procedure tdifffo.refresh1(const adir: tgitdirtreenode;
                                      const afile: tmsegitfileitem);
begin
 fcanexternaldiff:= false;
 fi.cached:= false;
 fi.path:= '';
 if (adir <> nil) then begin
  fi.path:= adir.gitbasepath;
 end;
 if afile <> nil then begin
  fi.path:= fi.path+afile.caption;
  fcanexternaldiff:= true;
  if (fi.a = '') and (gist_unmodified in afile.statey) and 
              (gist_modified in afile.statex) then begin
   fi.cached:= true;
  end;
 end;
 inherited refresh;
end;

procedure tdifffo.refresh(const adir: tgitdirtreenode;
                                      const afile: tmsegitfileitem;
                   const oldcommit: msestring; const newcommit: msestring);
begin
 fi.a:= newcommit;
 fi.b:= oldcommit;
 fi.commits:= nil;
 fi.iscommits:= false;
 refresh1(adir,afile);
end;

procedure tdifffo.refresh(const adir: tgitdirtreenode;
                                      const afile: tmsegitfileitem;
                  const commits: msestringarty);
begin
 fi.a:= '';
 fi.b:= '';
 fi.commits:= commits;
 fi.iscommits:= true;
 refresh1(adir,afile);
end;

procedure tdifffo.popupupdateexe(const sender: tcustommenu);
begin
 externaldiffact.enabled:= singlediff and (mainmo.opt.difftool <> '');
end;

function tdifffo.singlediff: boolean;
begin
 result:=(fcanexternaldiff or 
        mainmo.opt.splitdiffs and (tabs.activepageintf <> nil) and 
                                   (tabs.activepageintf.getcaption <> ''))
end;

procedure tdifffo.dorepoloaded;
begin
 //do nothing, reload triggered by mainfo.objchanged
end;

procedure tdifffo.findupdate(const sender: tcustomaction);
begin
 sender.enabled:= (tabs.activepage <> nil) and 
                      (tdifftabfo(tabs.activepage).grid.rowcount > 0);
 repeatfind.enabled:= sender.enabled and (mainfo.findinfo.text <> '');
end;

procedure tdifffo.findexe(const sender: TObject);
begin
 if finddialogexecute(mainfo.findinfo) then begin
  tdifftabfo(tabs.activepage).find(mainfo.findinfo);
 end;
end;

procedure tdifffo.repeatfindexe(const sender: TObject);
begin
 tdifftabfo(tabs.activepage).find(mainfo.findinfo);
end;

end.
