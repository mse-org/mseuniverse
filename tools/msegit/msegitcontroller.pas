{ MSEgit Copyright (c) 2011 by Martin Schreiber
   
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
//
// under construction
//
unit msegitcontroller;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msestrings,mseclasses,classes,msehash,mselistbrowser,msetypes;
const
 defaultgitcommand = 'git';
 
type
 gitstatety = (gist_invalid,gist_unmodified,gist_modified,gist_added,
                gist_deleted,gist_renamed,gist_copied,gist_updated,
                gist_untracked,gist_ignored,
                gist_pushpending,gist_mergepending,gist_pushconflict);
 gitstatesty = set of gitstatety;

 gitstatedataty = record
  statex: gitstatesty;
  statey: gitstatesty;
 end;
 pgitstatedataty = ^gitstatedataty;
 gitstateinfoty = record
  name: filenamety;
  data: gitstatedataty;
 end;
 pgitstateinfoty = ^gitstateinfoty;
 gitstateinfoarty = array of gitstateinfoty;
 
 tgitstatecache = class(tmsestringhashdatalist)
  private
   freporoot: filenamety;
  public
   constructor create;
   function getrepodir(const apath: filenamety): filenamety;
                //returns apath - reporoot
   function add(const aname: msestring): pgitstatedataty;
   function addunique(const akey: msestring): pgitstatedataty;
   function find(const aname: msestring): pgitstatedataty;
   function first: pgitstateinfoty;
   function next: pgitstateinfoty;
   property reporoot: filenamety read freporoot write freporoot;
 end;

 addstatecallbackeventty = procedure(const astatus: gitstateinfoty) of object;
{
 dirnamecachedataty = record
  dirname: filenamety;
 end;
 dirnamecacheinfoty = record
  key: integer;
  data: dirnamecachedataty;
 end;
 
 tdirnamecache = class(tintegerhashdatalist)
  protected
   procedure finalizeitem(var aitemdata); override;
  public
   constructor create;
   procedure add(const akey: integer; const aname: filenamety);
   function find(const akey: integer): msestring;
 end;
 }
 gitfiledataty = record
  filename: filenamety;
  statex,statey: gitstatesty;
 end;
 pgitfiledataty = ^gitfiledataty;
 gitfileinfoty = record
  dirpath: filenamety; //key
  data: gitfiledataty;
 end;

 gitfileiteratorprocty = procedure(var aitem: gitfileinfoty) of object;
 
 tgitfilecache = class(tmsestringhashdatalist)
  protected
   procedure finalizeitem(var aitemdata); override;
  public
   constructor create;
   function add(const adirpath: filenamety): pgitfiledataty;
   procedure iterate(const akey: msestring;
                     const aiterator: gitfileiteratorprocty); overload;
 end;
 
 tgitfileitem = class(tlistedititem)
  private
  protected
   fstatex: gitstatesty;
   fstatey: gitstatesty;
  public
   constructor create; virtual;
   property statex: gitstatesty read fstatex;
   property statey: gitstatesty read fstatey;
 end;
 gitfileitemclassty = class of tgitfileitem;
 gitfileitemarty = array of tgitfileitem;

 addfilecallbackeventty = procedure(var afile: gitfileinfoty) of object;

 remoteinfoty = record
  name: msestring;
  fetchurl: msestring;
  pushurl: msestring;
  active: boolean;
 end;
 remoteinfoarty = array of remoteinfoty;
   
 tgitcontroller = class(tmsecomponent)
  private
   fgitcommand: msestring;
   ferrormessage: string;
   fstatear: gitstateinfoarty;
   fvaluecount: integer;
   fstatecache: tgitstatecache;
   ffilear: gitfileitemarty;
   ffileitemclass: gitfileitemclassty;
   ffilecache: tgitfilecache;
   fdirlen: integer;
   fdirpath: filenamety;
   procedure arraycallback(const astatus: gitstateinfoty);
   procedure cachecallback(const astatus: gitstateinfoty);
   procedure filearraycallback(var astatus: gitfileinfoty);
   procedure filecachecallback(var astatus: gitfileinfoty);
  protected
   function commandresult(const acommand: string; out adest: string): boolean;
   function status1(const callback: addstatecallbackeventty;
                                  const apath: filenamety): boolean;
   function lsfiles1(const apath: filenamety; const excludetracked: boolean;
            const includeuntracked: boolean; const includeignored: boolean;
                            const arecursive: boolean;
                            const astate: tgitstatecache;
                            const callback: addfilecallbackeventty): boolean;
  public
   constructor create(aowner: tcomponent); override;
   function getgitcommand(const acommand: msestring): msestring;
   function status(const apath: filenamety;
                        out astatus: gitstateinfoarty): boolean; overload;
          //true if ok
   function status(const apath: filenamety;
                        out astatus: tgitstatecache): boolean; overload;
          //true if ok
   function getpathparam(const apath: filenamety;
                                  const relative: boolean): msestring;
   function lsfiles(const apath,repodir: filenamety;
               const excludetracked: boolean;
               const includeuntracked: boolean; const includeignored: boolean;
                    out afiles: filenamearty): boolean; overload;
          //true if ok
   function lsfiles(const apath: filenamety; 
               const excludetracked: boolean;
               const includeuntracked: boolean; const includeignored: boolean;
                    const astate: tgitstatecache;
                    const aitemclass: gitfileitemclassty;
                    out afiles: gitfileitemarty): boolean; overload;
          //true if ok
   function lsfiles(const apath: filenamety;
               const excludetracked: boolean;
               const includeuntracked: boolean; const includeignored: boolean;
                    const arecursive: boolean;
                    const astate: tgitstatecache;
                    const adest: tgitfilecache): boolean; overload;
   function remoteshow(out adest: remoteinfoarty): boolean;
  published
   property gitcommand: filenamety read fgitcommand write fgitcommand;
                  //'' -> 'git'
 end;
 
function checkgit(const adir: filenamety; out gitroot: filenamety): boolean;
//git log -z --name-only --format=format: origin/master..HEAD 
implementation
uses
 msefileutils,mseprocess,msearrayutils,msesysintf,msesystypes,msesysutils;
 
function checkgit(const adir: filenamety; out gitroot: filenamety): boolean;
var
 fna1,fna2: filenamety;
begin
 fna1:= filepath(adir);
 gitroot:= '';
 repeat
  result:= finddir(fna1+'/.git'); //todo: better check
  if result then begin
   gitroot:= fna1;
  end;
  fna2:= fna1;
  fna1:= filepath(fna1+'/..');
 until result or (fna1 = fna2);
 if result then begin
  gitroot:= filepath(gitroot,fk_dir);
 end;
end;

{ tgitcontroller }

constructor tgitcontroller.create(aowner: tcomponent);
begin
 inherited;
end;

function tgitcontroller.getgitcommand(const acommand: msestring): msestring;
begin
 if fgitcommand = '' then begin
  result:= defaultgitcommand;
 end
 else begin
  result:= fgitcommand;
 end;
 result:= result + ' ' + acommand;
end;

function tgitcontroller.getpathparam(const apath: filenamety;
                                      const relative: boolean): msestring;
begin
 result:= quotefilename(tosysfilepath(filepath(apath,'',fk_default,relative)));
end;

function tgitcontroller.commandresult(const acommand: string;
               out adest: string): boolean;
begin
 result:= getprocessoutput(getgitcommand(acommand),'',adest,ferrormessage) = 0;
end;

const
 statchars: array[0..127] of gitstatety =
  ( 
// #$00,        #$01,        #$02,        #$03,
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// #$04,        #$05,        #$06,        #$07,
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// #$08,        #$09,        #$0a,        #$0b,
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// #$0c,        #$0d,        #$0e,        #$0f,
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// #$10,        #$11,        #$12,        #$13,
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// #$14,        #$15,        #$16,        #$17,
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// #$18,        #$19,        #$1a,        #$1b,
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// #$1c,        #$1d,        #$1e,        #$1f,
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// ' ' ,           '!' ,        #$22,        #$23,
   gist_unmodified,gist_ignored,gist_invalid,gist_invalid,
// #$24,        #$25,        #$26,        #$27,
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// #$28,        #$29,        #$2a,        #$2b,
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// #$2c,        #$2d,        #$2e,        #$2f,
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// #$30,        #$31,        #$32,        #$33,
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// #$34,        #$35,        #$36,        #$37,
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// #$38,        #$39,        #$3a,        #$3b,
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// #$3c,        #$3d,        #$3e,        '?',
   gist_invalid,gist_invalid,gist_invalid,gist_untracked,
// #$40,        'A',        'B',          'C',
   gist_invalid,gist_added,gist_invalid,gist_copied,
// 'D',         'E',         'F',         'G',
   gist_deleted,gist_invalid,gist_invalid,gist_invalid,
// 'H',         'I',         'J',         'K',
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// 'L',         'M',         'N',         'O',
   gist_invalid,gist_modified,gist_invalid,gist_invalid,
// 'P',         'Q',         'R',         'S',
   gist_invalid,gist_invalid,gist_renamed,gist_invalid,
// 'T',         'U',         'V',         'W',
   gist_invalid,gist_updated,gist_invalid,gist_invalid,
// 'X',         'Y',         'Z',         #$5b,
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// #$5c,        #$5d,        #$5e,        #$5f,
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// #$60,        'a',        'b',          'c',
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// 'd',         'e',        'f',          'g',
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// 'h',         'i',         'j',         'k',
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// 'l',         'm',         'n',         'o',
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// 'p',         'q',         'r',         's',
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// 't',         'u',         'v',         'w',
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// 'x',         'x',         'z',          #$7b,
   gist_invalid,gist_invalid,gist_invalid,gist_invalid,
// #$7c,        #$7d,        #$7e,        #$7f,
   gist_invalid,gist_invalid,gist_invalid,gist_invalid
   );
   
function tgitcontroller.status1(const callback: addstatecallbackeventty;
               const apath: filenamety): boolean;
var
 fna1: filenamety;
 str1{,str2}: string;
 po1,po2,po3: pchar;
 int1: integer;
 stat1: gitstateinfoty;

 procedure scan(const aflags: gitstatesty);
 begin
  po1:= pointer(str1);
  po3:= po1 + length(str1);
  while po1 < po3 do begin
   if po1^ = c_return then begin
    inc(po1);
   end;
   if po1^ <> c_linefeed then begin
    break; //invalid
   end;
   inc(po1); //skip empy header
   while (po1 < po3) and (po1^ <> #0) do begin
    po2:= po1;
    while po2^ <> #0 do begin
     inc(po2);
    end;
    with stat1 do begin
     name:= psubstr(po1,po2);
     data.statex:= [];
     data.statey:= aflags;
    end;
    callback(stat1);
    po1:= po2+1;
   end;
  end;
 end;

begin
 fna1:= getpathparam(apath,false);
 result:= commandresult('status -z --porcelain '+fna1,str1);
 if result and (str1 <> '') then begin
  po1:= pointer(str1);
  po3:= po1 + length(str1);
  while po1 < po3 do begin
   po2:= po1;
   while po2^ <> #0 do begin
    inc(po2);
   end;
   int1:= po2-po1;
   if int1 > 3 then begin
    with stat1 do begin
     if po1^ > #$7f then begin
      data.statex:= [gist_invalid];
     end
     else begin
      data.statex:= [statchars[ord(po1^)]];
     end;
     inc(po1);
     if po1^ > #$7f then begin
      data.statey:= [gist_invalid];
     end
     else begin
      data.statey:= [statchars[ord(po1^)]];
     end;
     inc(po1,2);
     name:= po1;
     callback(stat1);
    end;
    po1:= po2+1;
   end;
  end;
 end;
 if result then begin
  if commandresult('log -z --name-only --format=format: '+
                        'origin/master..HEAD '+fna1,str1) and
                                                      (str1 <> '') then begin
   scan([gist_pushpending]);
  end;
  if commandresult('log -z --name-only --format=format: '+
                                'HEAD..origin/master '+fna1,str1) and
                                                      (str1 <> '') then begin
   scan([gist_mergepending]);
  end;
 end;
end;

procedure tgitcontroller.arraycallback(const astatus: gitstateinfoty);
begin
 if fvaluecount > high(fstatear) then begin
  setlength(fstatear,high(fstatear)*2+32);
 end;
 fstatear[fvaluecount]:= astatus;
 inc(fvaluecount);
end;

function tgitcontroller.status(const apath: filenamety;
                                      out astatus: gitstateinfoarty): boolean;
begin
 fstatear:= nil;
 fvaluecount:= 0;
 result:= status1(@arraycallback,apath);
 setlength(fstatear,fvaluecount);
 astatus:= fstatear;
 fstatear:= nil;
end;

procedure tgitcontroller.cachecallback(const astatus: gitstateinfoty);
begin
 with fstatecache.addunique(astatus.name)^ do begin
  statex:= statex + astatus.data.statex;
  statey:= statey + astatus.data.statey;
  if statey * [gist_pushpending,gist_mergepending] = 
                             [gist_pushpending,gist_mergepending] then begin
   include(statey,gist_pushconflict);
  end;
 end;
end;

function tgitcontroller.status(const apath: filenamety;
                                       out astatus: tgitstatecache): boolean;
begin
 fstatecache:= tgitstatecache.create;
 result:= status1(@cachecallback,apath);
 if not result then begin
  fstatecache.clear;
 end;
 astatus:= fstatecache;
 fstatecache:= nil;
end;

function tgitcontroller.lsfiles(const apath,repodir: filenamety;
               const excludetracked: boolean;
               const includeuntracked: boolean; const includeignored: boolean;
               out afiles: filenamearty): boolean;
var
 str1,str2,str3: string;
begin
 str2:= 'ls-files --full-name ';
 result:= commandresult(str2+getpathparam(apath,false),str1);
 if result and (includeuntracked or includeignored) then begin
  str2:= str2 + '--other --exclude='+
                              getpathparam(repodir+'*/',true)+' ';
  if not includeignored then begin
   str2:= str2 + '--exclude-standard ';
  end;
  result:= commandresult(str2+getpathparam(apath,false),str3);
  str1:= str1+str3;
 end;
 afiles:= breaklines(msestring(str1));
end;

function tgitcontroller.lsfiles1(const apath: filenamety;
            const excludetracked: boolean;
            const includeuntracked: boolean; const includeignored: boolean;
            const arecursive: boolean;
            const astate: tgitstatecache;
            const callback: addfilecallbackeventty): boolean;
var
 str1,str2: string;
 int1: integer;
 po1,po2: pchar;
 po3: pgitstatedataty;
 fna1: filenamety;
 repodir: filenamety;
 info1: gitfileinfoty;
begin
 repodir:= astate.getrepodir(apath);
 fdirlen:= length(repodir)+1;
 if not excludetracked then begin
  str2:= 'ls-tree --full-name --abbrev=1 ';
  if arecursive then begin
   str2:= str2 + '-r ';
  end;
  str2:= str2 + '-z HEAD ';
  result:= commandresult(str2+getpathparam(apath+'/',false),str1);
  if result and (str1 <> '') then begin
   po1:= pointer(str1);
   while true do begin
    po2:= po1;
    if po2^ = #0 then begin
     break; //end
    end;
    while (po2^ <> #0) and (po2^ <> ' ') do begin //skip mode
     inc(po2);
    end;
    if po2^ = #0 then begin
     break; //invalid
    end;
    inc(po2);
    case po2^ of
     #0: begin
      break; //invalid
     end;
     't': begin
       break; //tree
      end;
     'b': begin //file
     end;
     else begin
      break; //invalid
     end;
    end;
    while (po2^ <> #0) and (po2^ <> c_tab) do begin //skip type and object
     inc(po2);
    end;
    if po2^ = #0 then begin
     break; //invalid
    end;
    inc(po2);
    po1:= po2;
    while (po2^ <> #0) do begin //file path
     inc(po2);
    end;
    int1:= po2-po1;
    if int1 = 0 then begin
     break; //invalid
    end;
    with info1 do begin
     setlength(str2,int1);
     move(po1^,str2[1],int1);
     data.filename:= str2;
     po3:= astate.find(data.filename);
     if po3 <> nil then begin
      data.statex:= po3^.statex;
      data.statey:= po3^.statey;
     end
     else begin
      data.statex:= [];
      data.statey:= [];
     end;
     po1:= po1 + int1 + 1;
    end;
    callback(info1);
   end;
  end;
 end;
 if includeuntracked or includeignored then begin
  str2:= 'ls-files -z --other --full-name ';
  if not arecursive then begin
   str2:= str2 + '--exclude='+ getpathparam(repodir+'*/',true)+' ';
  end;
  if not includeignored then begin
   str2:= str2 + '--exclude-standard ';
  end;
  result:= commandresult(str2 + getpathparam(apath,true),str1);
  if str1 <> '' then begin
   info1.data.statex:= [];
   info1.data.statey:= [gist_untracked];
   po1:= pointer(str1);
   while true do begin
    po2:= po1;
    if po2^ = #0 then begin
     break; //end
    end;
    while po2^ <> #0 do begin
     inc(po2);
    end;
    str2:= psubstr(po1,po2);
    with info1 do begin
     data.filename:= str2;
     data.statey:= [gist_untracked];
    end;     
    callback(info1);
    po1:= po2+1;
   end;
  end;
 end;
end;

procedure tgitcontroller.filearraycallback(var astatus: gitfileinfoty);
var
 n1: tgitfileitem;
begin
 n1:= ffileitemclass.create;
 additem(pointerarty(ffilear),pointer(n1),fvaluecount);
 with astatus do begin
  n1.fcaption:= copy(data.filename,fdirlen,bigint);
  n1.fstatex:= data.statex;
  n1.fstatey:= data.statey;
 end;
end;

function tgitcontroller.lsfiles(const apath: filenamety;
               const excludetracked: boolean;
               const includeuntracked: boolean; const includeignored: boolean;
               const astate: tgitstatecache;
               const aitemclass: gitfileitemclassty;
               out afiles: gitfileitemarty): boolean;
begin
 fvaluecount:= 0;
 ffilear:= nil;
 ffileitemclass:= aitemclass;
 result:= lsfiles1(apath,excludetracked,includeuntracked,includeignored,
                                      false,astate,@filearraycallback);
 setlength(ffilear,fvaluecount);
 afiles:= ffilear;
 ffilear:= nil;
end;

procedure tgitcontroller.filecachecallback(var astatus: gitfileinfoty);
var
 dir,nam: msestring; 
begin
 with astatus do begin
  splitfilepath(data.filename,dir,nam);
  if dir = fdirpath then begin
   dir:= fdirpath; //reuse memory;
  end
  else begin
   fdirpath:= dir;
  end;
  data.filename:= nam;
  ffilecache.add(dir)^:= data;
 end;
end;

function tgitcontroller.lsfiles(const apath: filenamety;
               const excludetracked: boolean;
               const includeuntracked: boolean; const includeignored: boolean;
               const arecursive: boolean;
               const astate: tgitstatecache;
                              const adest: tgitfilecache): boolean;
begin
 ffilecache:= adest;
 result:= lsfiles1(apath,excludetracked,includeuntracked,includeignored,
                                         arecursive,astate,@filecachecallback);
end;

function tgitcontroller.remoteshow(out adest: remoteinfoarty): boolean;
var
 str1,str2: string;
 ar1,ar2: stringarty;
 int1,int2,int3: integer;
begin
 result:= commandresult('remote -v show',str1);
 if result then begin
  ar1:= breaklines(str1);
  setlength(adest,length(ar1));//max
  int2:= 0;
  str2:= '';
  for int1:= 0 to high(ar1) do begin
   ar2:= splitstring(ar1[int1],c_tab);
   if high(ar2) = 1 then begin
    if (str2 <> '') and (str2 <> ar2[0]) then begin
     inc(int2);
    end;
    str2:= ar2[0];
    with adest[int2] do begin
     name:= str2;
     int3:= length(ar2[1]);
     if (int3 > 8) and (copy(ar2[1],int3-7,bigint) = ' (fetch)') then begin
      fetchurl:= copy(ar2[1],1,int3-8);
     end;
     if (int3 > 7) and (copy(ar2[1],int3-6,bigint) = ' (push)') then begin
      pushurl:= copy(ar2[1],1,int3-7);
     end;
    end;     
   end;
  end;
  if str2 = '' then begin
   adest:= nil;
  end
  else begin
   setlength(adest,int2+1);
  end;
 end;
end;

{
function tgitcontroller.lsfiles(const apath: filenamety;
               const ainclude: gitstatesty; const aexclude: gitstatesty;
               const astate: tgitstatecache;
               const aitemclass: gitfileitemclassty;
               out afiles: gitfileitemarty): boolean;
var
 str1,str2: string;
 int1,int2: integer;
 n1: tgitfileitem;
 po1,po2: pchar;
 po3: pgitstatedataty;
 dirlen: integer;
 fna1: filenamety;
 wdbefore: filenamety;
begin
 afiles:= nil;
 wdbefore:= getcurrentdir;
 fna1:= astate.getrepodir(apath);
 result:= sys_setcurrentdir(apath) = sye_ok;
 if not result then begin
  ferrormessage:= getlasterrortext;
  exit;
 end;
 result:= getprocessoutput(getgitcommand('ls-files -z '+getpathparam(apath)),
                                                    '',str1,ferrormessage) = 0;
 setcurrentdir(wdbefore);
 if result and (str1 <> '') then begin
  int2:= 0;
  po1:= pointer(str1);
  while true do begin
   po2:= po1;
   if po2^ = #0 then begin
    break; //end
   end;
   while (po2^ <> #0) and (po2^ <> '/') do begin
    inc(po2);
   end;
   if po2^ = '/' then begin
    break; //subdir
   end;
   additem(pointerarty(afiles),pointer(aitemclass.create),int2);
   with afiles[int2-1] do begin
    int1:= po2-po1;
    setlength(str2,int1);
    move(po1^,str2[1],int1);
    fcaption:= str2;
    po3:= astate.find(fna1+fcaption);
    if po3 <> nil then begin
     fstatex:= po3^.statex;
     fstatey:= po3^.statey;
    end;  
    po1:= po1 + int1 + 1;
   end;
  end;
  setlength(afiles,int2);
 end;
end;
}
{ tgitstatecache }

constructor tgitstatecache.create;
begin
 inherited create(sizeof(gitstatedataty));
end;

function tgitstatecache.add(const aname: msestring): pgitstatedataty;
begin
 result:= inherited add(aname);
end;

function tgitstatecache.addunique(const akey: msestring): pgitstatedataty;
begin
 result:= inherited addunique(akey);
end;

function tgitstatecache.find(const aname: msestring): pgitstatedataty;
begin
 result:= inherited find(aname);
end;

function tgitstatecache.first: pgitstateinfoty;
begin
 result:= pointer(inherited first);
end;

function tgitstatecache.next: pgitstateinfoty;
begin
 result:= pointer(inherited next);
end;

function tgitstatecache.getrepodir(const apath: filenamety): filenamety;
begin
 result:= relativepath(apath,freporoot,fk_dir);
 if result = './' then begin
  result:= '';
 end;
end;

{ tgitfileitem }

constructor tgitfileitem.create;
begin
 inherited create(nil);
end;

{ tgitfilecache }

constructor tgitfilecache.create;
begin
 inherited create(sizeof(gitfiledataty));
end;

procedure tgitfilecache.finalizeitem(var aitemdata);
begin
 finalize(gitfileinfoty(aitemdata).data);
 inherited;
end;

function tgitfilecache.add(const adirpath: filenamety): pgitfiledataty;
begin
 result:= pgitfiledataty(inherited add(adirpath));
end;

procedure tgitfilecache.iterate(const akey: msestring;
               const aiterator: gitfileiteratorprocty);
begin
 inherited iterate(akey,msestringiteratorprocty(aiterator));
end;

end.
