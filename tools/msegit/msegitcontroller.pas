{ MSEgit Copyright (c) 2011-2012 by Martin Schreiber
   
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
unit msegitcontroller;
{$ifdef FPC}{$mode objfpc}{$h+}{$goto on}{$endif}
interface
uses
 msestrings,mseclasses,classes,msehash,mselistbrowser,msetypes,msedatanodes,
 msedate,msesys,msesystypes;
const
 defaultgitcommand = 'git';
 branchref = 'refs/heads/';
 tagref = 'refs/tags/';
 
 
type
 commitkindty = (ck_none,ck_stage,ck_unstage,ck_amend,ck_commit,ck_revert,
                 ck_remove,ck_modify);

 gitstatety = (gist_invalid,gist_unmodified,gist_modified,gist_added,
                gist_deleted,gist_renamed,gist_copied,gist_unmerged,
                gist_untracked,gist_ignored,
                gist_pushpending,gist_mergepending,gist_mergeconflictpending,
                gist_pushconflict);
 gitstatesty = set of gitstatety;

const
 cancommitstate = [gist_modified,gist_added,gist_deleted,gist_renamed];

type
 gitstatedataty = record
  statex: gitstatesty;
  statey: gitstatesty;
 end;
 pgitstatedataty = ^gitstatedataty;
 gitstateinfoty = record
  filename: filenamety;
  data: gitstatedataty;
 end;
 pgitstateinfoty = ^gitstateinfoty;
 gitstateinfoarty = array of gitstateinfoty;

 gitstateiteratorprocty = procedure(var aitem: gitstateinfoty) of object; 
 tgitstatecache = class(tmsestringhashdatalist)
  private
   freporoot: filenamety;
   fdirhash: tpointermsestringhashdatalist;
   ffiledir: msestring;
  public
   constructor create;
   destructor destroy; override;
   function getrepodir(const apath: filenamety): filenamety;
                //returns apath - reporoot
   function add(const aname: msestring): pgitstatedataty;
   function addunique(const akey: msestring): pgitstatedataty;
   function find(const aname: msestring): pgitstatedataty;
   function first: pgitstateinfoty;
   function next: pgitstateinfoty;
   procedure iterate(const include: array of gitstatedataty;
                   const aiterator: gitstateiteratorprocty); overload;
   procedure iterate(const adir: msestring;
                            const include: array of gitstatedataty;
                  const aiterator: gitstateiteratorprocty); overload;
   procedure iterate(const adir: msestring;
                  const include: array of gitstatedataty); overload;
   property reporoot: filenamety read freporoot write freporoot;
 end;

 addstatecallbackeventty = procedure(const astatus: gitstateinfoty) of object;

 gitfiledataty = record
  stateinfo: gitstateinfoty;
 end;
 pgitfiledataty = ^gitfiledataty;
 gitfileinfoty = record
  dirpath: filenamety; //key
  data: gitfiledataty;
 end;

 gitfileiteratorprocty = procedure(var aitem: gitfileinfoty) of object;
 
 tgitfilecache = class(tmsestringhashdatalist)
  private
   fdirpath: filenamety;
  protected
   procedure finalizeitem(var aitemdata); override;
  public
   constructor create;
   function add(const adirpath: filenamety): pgitfiledataty; overload;
   function add(var ainfo: gitfileinfoty): pgitfiledataty; overload;
   function add(const astatus: gitstateinfoty): pgitfiledataty; overload;
   procedure iterate(const akey: msestring;
                     const aiterator: gitfileiteratorprocty); overload;
 end;
 
 tgitfileitem = class(tlistedititem)
  private
  protected
   fgitstate: gitstatedataty;
  public
   constructor create; overload; virtual;
   constructor create(const aitem: gitstateinfoty;
                               const pathstart: integer); overload;
   procedure assign(const source: tlistitem); overload; override;
   property statex: gitstatesty read fgitstate.statex;
   property statey: gitstatesty read fgitstate.statey;
   property gitstate: gitstatedataty read fgitstate;
 end;
 pgitfileitem = ^tgitfileitem;
 gitfileitemclassty = class of tgitfileitem;
 gitfileitemarty = array of tgitfileitem;
 gitfileitematy = array[0..0] of tgitfileitem;
 pgitfileitematy = ^gitfileitematy;

 addfilecallbackeventty = procedure(var afile: gitfileinfoty) of object;
 
 refskindty = (refk_none,refk_localbranch,refk_remotebranch,refk_tag);
 refsinfoty = record
  name: msestring;
  commit: msestring;
  kind: refskindty;
 end;

 localbranchinfoty = record
  info: refsinfoty;
  active: boolean;
  hidden: boolean;
  nobranch: boolean;
  trackremote: msestring;
  trackbranch: msestring;
 end;
 plocalbranchinfoty = ^localbranchinfoty;
 localbranchinfoarty = array of localbranchinfoty;    

 remotebranchinfoty = record
  info: refsinfoty;
  linklocalbranch: boolean;
  hidden: boolean;
 end;
 premotebranchinfoty = ^remotebranchinfoty;
 remotebranchinfoarty = array of remotebranchinfoty;

 remoteinfoty = record
  name: msestring;
  fetchurl: msestring;
  pushurl: msestring;
  branches: remotebranchinfoarty;
  activebranch: msestring;
  hidden: boolean;
 end;
 premoteinfoty = ^remoteinfoty;
 remoteinfoarty = array of remoteinfoty;

 refinfoty = record
  commit: msestring;
  message: msestring;
  committer: msestring;
  commitdate: tdatetime; //utc
 end;
 prefinfoty = ^refinfoty;
 refinfoarty = array of refinfoty;
 prefinfoarty = ^refinfoarty;

 tagsinfoty = record
  ref: refsinfoty;
//  name: msestring;
  info: refinfoty;
 end; 
 ptagsinfoty = ^tagsinfoty;
 tagsinfoarty = array of tagsinfoty;
 
 stashinfoty = record
  name: msestring;
  message: msestring;
 end;
 stashinfoarty = array of stashinfoty;
     
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
   fversionchecked: boolean;
   fcanvarset: boolean;
   fhasaskpassvar: boolean;
   fhasdisplayvar: boolean;
   fcommandlinevars: string;
   procedure arraycallback(const astatus: gitstateinfoty);
   procedure cachecallback(const astatus: gitstateinfoty);
   procedure filearraycallback(var ainfo: gitfileinfoty);
   procedure filecachecallback(var ainfo: gitfileinfoty);
  protected
   function execcommand(const acommand: string;
                                const useshell: boolean): boolean;
   function commandresult1(const acommand: string; out adest: msestring): boolean;
   function status1(const callback: addstatecallbackeventty;
        const apath: filenamety; const aorigin: msestring): boolean;
   function lsfiles1(const apath: filenamety; const excludetracked: boolean;
            const includeuntracked: boolean; const includeignored: boolean;
                            const arecursive: boolean;
                            const astate: tgitstatecache;
                            const callback: addfilecallbackeventty): boolean;
   function canvarset: boolean;
   function decodecommit(const atext: msestring;
              const ainfo: prefinfoty; const alist: prefinfoarty): boolean;
                              //false if empty
  public
   constructor create(aowner: tcomponent); override;
   procedure resetversioncheck;
   function getconfig(const varname: string; out varvalue: msestring): boolean;
                  //false if unset
   function checkrefformat(const aref: msestring): boolean;
   function encodegitcommand(const acommand: string): string;
   function encodestring(const avalue: msestring): string;
   function encodestringparam(const avalue: msestring): string;
   function noemptystringparam(const avalue: msestring): string;
   function encodepathparam(const apath: filenamety;
                                  const relative: boolean): string;
   function encodepathparams(const apath: filenamearty;
                                  const relative: boolean): string;
   function encodedatetimeparam(const aparam: tdatetime): string;
   
   function status(const apath: filenamety; const aorigin: msestring;
                        out astatus: gitstateinfoarty): boolean; overload;
          //true if ok
   function status(const apath: filenamety; const aorigin: msestring;
             const afiles: tgitfilecache; //add added files, can be nil
                        out astatus: tgitstatecache): boolean; overload;
          //true if ok
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
   function cat(const source,dest: filenamety;
                const commit: msestring): boolean; overload;
   function cat(const dest: filenamety;
                const aindex: msestring): boolean; overload;
   function remoteshow(out adest: remoteinfoarty): boolean;
   function branchshow(out adest: localbranchinfoarty;
                       out activebranch,activecommit: msestring): boolean;
   function tagsshow(out adest: tagsinfoarty): boolean;
   function stashlist(out adest: stashinfoarty): boolean;
   function diff(const commits: msestringarty; const afile: filenamety;
                 const acontextn: integer = 3): msestringarty; overload;
   function diff(const a,b: msestring; const afile: filenamety;
                 const acontextn: integer = 3): msestringarty; overload;
   function diff(const b: msestring; const afile: filenamety;
                 const acontextn: integer = 3): msestringarty; overload;
                       //cached
   function getsha1(const arev: msestring): msestring;
   function getrefinfo(const arev: msestring;
                                 out ainfo: refinfoty): boolean;
   function issha1(const avalue: string; var asha1: string): boolean;
                                                               overload;
   function issha1(const avalue: string): boolean; overload;
   function revlist(out alist: refinfoarty; 
                const abranch: msestring; const apath: filenamety = '';
                const maxcount: integer = 0; const skip: integer = 0;
                const commitfilter: msestring = ''; 
                const commitdatemin: tdatetime = emptydatetime;
                const commitdatemax: tdatetime = emptydatetime;
                const committerfilter: msestring = ''; 
                const messagefilter: msestring = ''): boolean;
   procedure setprociddest(var adest: prochandlety); //sets threadvar   
  published
   property gitcommand: filenamety read fgitcommand write fgitcommand;
                  //'' -> 'git'
 end;
 
function checkgit(const adir: filenamety; out gitroot: filenamety): boolean;
//git log -z --name-only --format=format: origin/master..HEAD 

function checkcancommit(const astate: gitstatedataty): boolean;
function checkcanrevert(const astate: gitstatedataty): boolean;
function checkcanremove(const astate: gitstatedataty): boolean;
function gitfilepath(const apath: filenamety;
                                      const relative: boolean): filenamety;

implementation
uses
 msefileutils,mseprocess,msearrayutils,msesysintf,msesysutils,
 msestream,sysutils,mseformatstr,mseprocutils,mseapplication;

type
 thashdatalist1 = class(thashdatalist);

threadvar
 currentgitprocesspo: pprochandlety;
 
function gitfilepath(const apath: filenamety;
                                      const relative: boolean): filenamety;
begin
 result:= tosysfilepath(filepath('',apath,fk_default,relative));
//{$ifdef mswindows}
// if (result <> '') and (result[1] = '/') then begin
//  tosysfilepath1(result);
// end;
//{$endif}
end;

function checkcancommit(const astate: gitstatedataty): boolean;
begin
 with astate do begin
  result:= (statex * cancommitstate <> []) or (statey * cancommitstate <> []);
 end;
end;
  
function checkcanrevert(const astate: gitstatedataty): boolean;
begin
 with astate do begin
  result:= [gist_modified,gist_deleted] * statey <> [];
 end;
end;

function checkcanremove(const astate: gitstatedataty): boolean;
begin
 with astate do begin
  result:= statey * [gist_untracked,gist_ignored] = [];
 end;
end;
  
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
var
 mstr1: msestring;
begin
 inherited;
 fhasaskpassvar:= sys_getenv('SSH_ASKPASS',mstr1);
 fhasdisplayvar:= sys_getenv('DISPLAY',mstr1);
end;

function tgitcontroller.canvarset: boolean;
var
 str1,str2: string;
{$ifdef windows}
 mstr1,mstr2: msestring;
{$endif}
begin
 result:= fcanvarset;
 if not result and not fversionchecked then begin
  fversionchecked:= true;
  str2:= fgitcommand;
  if str2 = '' then begin
   str2:= defaultgitcommand;
  end;
  fcanvarset:= getprocessoutput(str2 +
    ' -c color.ui=false --version','',str1,-1,[pro_inactive]) = 0;
  result:= fcanvarset;
  if result then begin
   fcommandlinevars:= ' -c color.ui=false';
  {$ifdef mswindows}
   mstr1:= filedir(sys_getapplicationpath)+'msegitpw.exe';
   if findfile(mstr1) and not getconfig('core.askpass',mstr2) then begin
    str1:= encodepathparam(mstr1,true);
    fcommandlinevars:= fcommandlinevars+' -c core.askpass=' + str1;
    if not fhasaskpassvar then begin
     sys_setenv('SSH_ASKPASS',str1);
    end;
    if not fhasdisplayvar then begin
     sys_setenv('DISPLAY',':0');
    end;
   end;
  {$endif}
  end
  else begin
   fcommandlinevars:= ''; 
  end;
 end;
end;

function tgitcontroller.encodegitcommand(const acommand: string): string;
begin
 if fgitcommand = '' then begin
  result:= defaultgitcommand;
 end
 else begin
  result:= fgitcommand;
 end;
 if canvarset then begin
  result:= result + fcommandlinevars;
 end;
 result:= result + ' --no-pager '+ acommand;
end;

function tgitcontroller.encodepathparam(const apath: filenamety;
                                      const relative: boolean): string;
begin
 result:= quotefilename(gitfilepath(apath,relative));
end;

function tgitcontroller.encodepathparams(const apath: filenamearty;
               const relative: boolean): string;
var
 int1: integer;
begin
 result:= '';
 if high(apath) >= 0 then begin
  result:= '-- '+encodepathparam(apath[0],relative);
  for int1:= 1 to high(apath) do begin
   result:= result + ' ' + encodepathparam(apath[int1],relative);
  end;
 end;
end;

function tgitcontroller.encodestring(const avalue: msestring): string;
begin
 result:= stringtoutf8(avalue);
end;

function tgitcontroller.encodestringparam(const avalue: msestring): string;
begin
 result:= stringtoutf8(quoteescapedstring(avalue,'"'));
end;

function tgitcontroller.noemptystringparam(const avalue: msestring): string;
begin
 if avalue <> '' then begin
  result:= encodestringparam(avalue) + ' ';
 end
 else begin
  result:= '';
 end;
end;

function tgitcontroller.commandresult1(const acommand: string;
               out adest: msestring): boolean;
var
 str1: string;
 opt1: processoptionsty;
begin
 opt1:= [pro_inactive];
 if application.ismainthread then begin
  opt1:= [pro_waitcursor,pro_checkescape,pro_inactive,pro_processmessages];
 end;
 result:= getprocessoutput(currentgitprocesspo^,
          encodegitcommand(acommand),'',str1,ferrormessage,-1,opt1) = 0;
 adest:= utf8tostring(str1);
end;

function tgitcontroller.execcommand(const acommand: string;
                             const useshell: boolean): boolean;
var
 opt1: processoptionsty;
begin
 opt1:= [pro_waitcursor,pro_checkescape,pro_processmessages,pro_inactive];
 if useshell then begin
  include(opt1,pro_shell);
 end;
 result:= startprocessandwait(encodegitcommand(acommand),-1,opt1) = 0;
// result:= execwaitmse(encodegitcommand(acommand),[exo_inactive]) = 0;
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
   gist_invalid,gist_unmerged,gist_invalid,gist_invalid,
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
               const apath: filenamety; const aorigin: msestring): boolean;
var
 mstr1: msestring;
 po1,po2,po3: pmsechar;
 int1: integer;
 stat1: gitstateinfoty;

 procedure scan(const aflags: gitstatesty);
 begin
  po1:= pointer(mstr1);
  po3:= po1 + length(mstr1);
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
     filename:= psubstr(po1,po2);
     data.statex:= [];
     data.statey:= aflags;
    end;
    callback(stat1);
    po1:= po2+1;
   end;
  end;
 end;

var
 fna1: string;

begin
 fna1:= encodepathparam(apath,false);
 result:= commandresult1('status -z --porcelain '+fna1,mstr1);
 if result and (mstr1 <> '') then begin
  po1:= pointer(mstr1);
  po3:= po1 + length(mstr1);
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
     filename:= po1;
     if data.statex = [gist_renamed] then begin
      data.statex:= [gist_added];
      callback(stat1);
      data.statex:= [gist_deleted];
      po1:= po2+1; //next filename
      if po1 >= po3 then begin
       break;
      end;
      filename:= po1;
      po2:= po1+length(filename);
     end;
     callback(stat1);
    end;
    po1:= po2+1;
   end;
  end;
 end;
 if result and (aorigin <> '') then begin
  if commandresult1('log -z --name-only --format=format: '+aorigin+
                        '..HEAD '+fna1,mstr1) and (mstr1 <> '') then begin
   scan([gist_pushpending]);
  end;
  if commandresult1('log -z --name-only --format=format: '+
       'HEAD..'+aorigin+' '+fna1,mstr1) and (mstr1 <> '') then begin
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
           const aorigin: msestring; out astatus: gitstateinfoarty): boolean;
begin
 fstatear:= nil;
 fvaluecount:= 0;
 result:= status1({$ifdef FPC}@{$endif}arraycallback,apath,aorigin);
 setlength(fstatear,fvaluecount);
 astatus:= fstatear;
 fstatear:= nil;
end;

procedure tgitcontroller.cachecallback(const astatus: gitstateinfoty);
begin
 if (ffilecache <> nil) and (gist_added in astatus.data.statex) then begin
  ffilecache.add(astatus);
 end;
 with fstatecache.addunique(astatus.filename)^ do begin
  statex:= statex + astatus.data.statex;
  statey:= statey + astatus.data.statey;
  if statey * [gist_pushpending,gist_mergepending] = 
                             [gist_pushpending,gist_mergepending] then begin
   include(statey,gist_pushconflict);
  end;
  if statey * [gist_mergepending,gist_modified] = 
                            [gist_mergepending,gist_modified] then begin
   include(statey,gist_mergeconflictpending);
  end;
 end;
end;

function tgitcontroller.status(const apath: filenamety;
               const aorigin: msestring;
               const afiles: tgitfilecache; //add added files, can be nil
               out astatus: tgitstatecache): boolean;
begin
 fstatecache:= tgitstatecache.create;
 ffilecache:= afiles;
 result:= status1({$ifdef FPC}@{$endif}cachecallback,apath,aorigin);
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
 mstr1,mstr2: msestring;
 str2{,str3}: string;
begin
 str2:= 'ls-files --full-name ';
 result:= commandresult1(str2+encodepathparam(apath,false),mstr1);
 if result and (includeuntracked or includeignored) then begin
  str2:= str2 + '--other --exclude='+
                              encodepathparam(repodir+'*/',true)+' ';
  if not includeignored then begin
   str2:= str2 + '--exclude-standard ';
  end;
  result:= commandresult1(str2+encodepathparam(apath,false),mstr2);
  mstr1:= mstr1+mstr2;
 end;
 afiles:= breaklines(mstr1);
end;

function tgitcontroller.lsfiles1(const apath: filenamety;
            const excludetracked: boolean;
            const includeuntracked: boolean; const includeignored: boolean;
            const arecursive: boolean;
            const astate: tgitstatecache;
            const callback: addfilecallbackeventty): boolean;
var
 mstr1: msestring;
 str2: string;
 int1: integer;
 po1,po2: pmsechar;
 po3: pgitstatedataty;
// fna1: filenamety;
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
  result:= commandresult1(str2+encodepathparam(apath+'/',false),mstr1);
  if result and (mstr1 <> '') then begin
   po1:= pointer(mstr1);
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
     setlength(data.stateinfo.filename,int1);
     move(po1^,pointer(data.stateinfo.filename)^,int1*sizeof(msechar));
     po3:= astate.find(data.stateinfo.filename);
     if po3 <> nil then begin
      data.stateinfo.data.statex:= po3^.statex;
      data.stateinfo.data.statey:= po3^.statey;
     end
     else begin
      data.stateinfo.data.statex:= [];
      data.stateinfo.data.statey:= [];
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
   str2:= str2 + '--exclude='+ encodepathparam(repodir+'*/',true)+' ';
  end;
  if not includeignored then begin
   str2:= str2 + '--exclude-standard ';
  end;
  result:= commandresult1(str2 + encodepathparam(apath,true),mstr1);
  if mstr1 <> '' then begin
   info1.data.stateinfo.data.statex:= [];
   info1.data.stateinfo.data.statey:= [gist_untracked];
   po1:= pointer(mstr1);
   while true do begin
    po2:= po1;
    if po2^ = #0 then begin
     break; //end
    end;
    while po2^ <> #0 do begin
     inc(po2);
    end;
    with info1 do begin
     data.stateinfo.filename:= psubstr(po1,po2);
     data.stateinfo.data.statey:= [gist_untracked];
    end;     
    callback(info1);
    po1:= po2+1;
   end;
  end;
 end;
end;

procedure tgitcontroller.filearraycallback(var ainfo: gitfileinfoty);
var
 n1: tgitfileitem;
begin
 n1:= ffileitemclass.create;
{$ifdef FPC}
 additem(pointerarty(ffilear),pointer(n1),fvaluecount);
{$else}
 addpointeritem(pointerarty(ffilear),pointer(n1),fvaluecount);
{$endif}
 with ainfo do begin
  n1.fcaption:= copy(data.stateinfo.filename,fdirlen,bigint);
  n1.fgitstate:= data.stateinfo.data;
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
                   false,astate,{$ifdef FPC}@{$endif}filearraycallback);
 setlength(ffilear,fvaluecount);
 afiles:= ffilear;
 ffilear:= nil;
end;

procedure tgitcontroller.filecachecallback(var ainfo: gitfileinfoty);
begin
 ffilecache.add(ainfo);
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
                  arecursive,astate,{$ifdef FPC}@{$endif}filecachecallback);
end;

function tgitcontroller.cat(const source: filenamety; const dest: filenamety;
               const commit: msestring): boolean;
var
 str1: string;
begin
 str1:= 'cat-file blob ' + encodestringparam(commit+':'+source) +' >'+
                                         tosysfilepath(quotefilename(dest));
 result:= execcommand(str1,true);
end;

function tgitcontroller.cat(const dest: filenamety;
                 const aindex: msestring): boolean;
var
 str1: string;
begin
 str1:= 'cat-file blob ' + encodestringparam(aindex) +' >'+
                                         tosysfilepath(quotefilename(dest));
 result:= execcommand(str1,true);
end;

function tgitcontroller.remoteshow(out adest: remoteinfoarty): boolean;
var
 mstr1,mstr2{,mstr3}: msestring;
 ar1,ar2: msestringarty;
 int1,int2,int3: integer;
// str1: string;
// fna1: filenamety;
 po1,po2,po3,pend: pmsechar;
 remotename: msestring;
 destindex: integer;
label
 parseerror,nextline;
begin
 result:= commandresult1('remote -v show',mstr1);
 if result then begin
  ar1:= breaklines(mstr1);
  setlength(adest,length(ar1));//max
  int2:= 0;
  mstr2:= '';
  for int1:= 0 to high(ar1) do begin
   ar2:= splitstring(ar1[int1],c_tab);
   if high(ar2) = 1 then begin
    if (mstr2 <> '') and (mstr2 <> ar2[0]) then begin
     inc(int2);
    end;
    mstr2:= ar2[0];
    with adest[int2] do begin
     name:= mstr2;
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
  if mstr2 = '' then begin
   adest:= nil;
  end
  else begin
   setlength(adest,int2+1);
  end;
  if not commandresult1('branch -r -v --no-abbrev',mstr1) then begin
   goto parseerror;
  end;
  po1:= pmsechar(mstr1);
  pend:= po1 + length(mstr1);
  remotename:= '';
  while po1 < pend do begin
   mseskipspace(po1);
   if po1 >= pend then begin
    goto parseerror;
   end;
   po2:= msestrscan(po1,msechar('/'));
   po3:= msestrscan(po1,c_linefeed);
   if (po2 <> nil) and (po3 = nil) or (po3 > po2) then begin
    if not msestartsstr(pointer(remotename),po1) then begin //next repo
     remotename:= psubstr(po1,po2);
     destindex:= -1;
     for int1:= 0 to high(adest) do begin
      if adest[int1].name = remotename then begin
       destindex:= int1;
       break;
      end;
     end;
     if destindex < 0 then begin
      goto nextline;
     end;
    end;
    inc(po2);        //'remotes/<remote>/'
    po1:= msestrscan(po2,msechar(' ')); //'<branch>'
    if (po1 = nil) or (destindex < 0) then begin
     goto nextline;
    end;
    with adest[destindex] do begin
     setlength(branches,high(branches)+2);
     with branches[high(branches)].info do begin
      kind:= refk_remotebranch;
      name:= psubstr(po2,po1);
      mseskipspace(po1);
      if po1 >= pend then begin
       goto parseerror;
      end;
      if po1^ = '-' then begin //HEAD info
       setlength(branches,high(branches));
      end
      else begin
       po2:= msestrscan(po1,msechar(' ')); //'<sha1>'
       if po2 >= pend then begin
        goto parseerror;
       end;
       commit:= psubstr(po1,po2);
      end;
     end;
    end;
   end
   else begin
    po2:= po1;
   end;
nextline:
   po1:= po3;
   if po1 = nil then begin
    po1:= pend;
   end
   else begin
    inc(po1);
   end;
  end;
  result:= true;
  exit;
    
parseerror:
 result:= false;
 adest:= nil;
{
  for int1:= 0 to high(adest) do begin
   with adest[int1] do begin
    fna1:= '.git/refs/remotes/'+name;
    ar2:= searchfilenames('',fna1);
    setlength(branches,length(ar2)); //max
    int3:= 0;
    for int2:= 0 to high(ar2) do begin
     if tryreadfiledatastring(fna1+'/'+ar2[int2],str1) and
                                      issha1(str1,str1) then begin
      with branches[int3] do begin
       info.name:= ar2[int2];
       info.commit:= str1;
      end;
      inc(int3);
     end;
    end;
    setlength(branches,int3);
   end;
  end;
 }
 end;
end;

function tgitcontroller.tagsshow(out adest: tagsinfoarty): boolean;
var
 mstr1: msestring;
 ar1: msestringarty;
 int1: integer;
begin
 adest:= nil;
 result:= commandresult1('tag',mstr1);
 if result then begin
  ar1:= breaklines(mstr1);
  if high(ar1) > 0 then begin
   setlength(adest,high(ar1)); //there is an empty last line
   for int1:= 0 to high(adest) do begin
    with adest[int1] do begin
     ref.kind:= refk_tag;
     ref.name:= ar1[int1];
     getrefinfo(tagref+ref.name,info);
     ref.commit:= info.commit;
    end;
   end;
  end;
 end;
end;

function tgitcontroller.branchshow(out adest: localbranchinfoarty;
                           out activebranch,activecommit: msestring): boolean;
var
 mstr1: msestring;
 ar1: msestringarty;
 int1: integer;
 po1,po2,po3: pmsechar;
begin
 adest:= nil;
 activebranch:= '';
 activecommit:= '';
 result:= commandresult1('branch -vv --no-abbrev',mstr1); 
 if result then begin
  ar1:= breaklines(mstr1);
  if ar1 <> nil then begin
   if ar1[high(ar1)] = '' then begin
    setlength(ar1,high(ar1));
   end;
   setlength(adest,length(ar1));
   for int1:= 0 to high(ar1) do begin
    if length(ar1[int1]) < 2 then begin
     result:= false;
     adest:= nil;
     exit;
    end;
    with adest[int1] do begin
     po1:= pmsechar(pointer(ar1[int1]))+2;
     info.name:= nextword(po1);
     info.kind:= refk_localbranch;
     if (info.name <> '') and (info.name[1] = '(') then begin
      po2:= po1;
      po1:= msestrscan(po1,msechar(')'));
      if po1 <> '' then begin
       inc(po1);
      end;
      info.name:= info.name+psubstr(po2,po1);
      nobranch:= true;
     end;
     info.commit:= nextword(po1);
     if ar1[int1][1] = '*' then begin
      active:= true;
      activebranch:= info.name;
      activecommit:= info.commit;
     end;
     po1:= msestrscan(po1,msechar('['));
     if po1 <> nil then begin
      inc(po1);
      po2:= msestrscan(po1,msechar(':'));
      po3:= msestrscan(po1,msechar(']'));
      if (po2 = nil) or (po3 < po2) then begin
       po2:= po3;
      end;
      if po2 <> nil then begin
       po3:= msestrscan(po1,msechar('/'));
       if po3 <> nil then begin
        trackremote:= stringsegment(po1,po3);
        po1:= po3+1;
       end;
       trackbranch:= stringsegment(po1,po2);
      end;
     end;
    end;    
   end;
  end;
 end;
end;

function tgitcontroller.diff(const a,b: msestring; const afile: filenamety;
                                  const acontextn: integer = 3): msestringarty;
var
 mstr1: msestring;
begin
 result:= nil;
 if commandresult1('diff --unified='+inttostr(acontextn)+' '+
                       noemptystringparam(a)+noemptystringparam(b)+
                       ' -- '+encodepathparam(afile,true),mstr1) then begin
  result:= breaklines(mstr1);
 end;
end;

function tgitcontroller.diff(const b: msestring; const afile: filenamety;
                 const acontextn: integer = 3): msestringarty;
                       //cached
var
 mstr1: msestring;
begin
 result:= nil;
 if commandresult1('diff --unified='+inttostr(acontextn)+' '+
                       '--cached '+noemptystringparam(b)+
                       ' -- '+encodepathparam(afile,true),mstr1) then begin
  result:= breaklines(mstr1);
 end;
end;

function tgitcontroller.diff(const commits: msestringarty; const afile: filenamety;
                 const acontextn: integer = 3): msestringarty;
var
 mstr1: msestring;
 int1: integer;
 str1: string;
begin
 result:= nil;
 if commits <> nil then begin
  str1:= 'log -n'+inttostr(length(commits))+' --unified='+inttostr(acontextn)+
            ' --full-index -p --pretty=format:';
  for int1:= 0 to high(commits) do begin
   str1:= str1 + ' '+encodestringparam(commits[int1]);
  end;
  str1:= str1 + ' -- '+encodepathparam(afile,true);
  if commandresult1(str1,mstr1) then begin
   result:= breaklines(mstr1);
  end;
 end;
end;

function tgitcontroller.issha1(const avalue: string;
                                              var asha1: string): boolean;
var
// int1: integer;
 po1,po2: pchar;
begin
 result:= length(avalue) >= 40;
 if result then begin
  po1:= pointer(avalue);
  po2:= po1+length(avalue)-1;
  while (po1 <= po2) and (po1^ in [' ',c_tab]) do begin
   inc(po1);         //remove leading whitespace
  end;
  while (po2 >= po1) and ((po2^ in [' ',c_tab,c_return,c_linefeed])) do begin
   dec(po2);         //remove trailing whitespace
  end;
  inc(po2);
  result:= po2-po1 = 40;
  if result then begin
   asha1:= psubstr(po1,po2);
  end;
  po1:= pointer(asha1);
  while ((po1^ >= '0') and (po1^ <= '9') or  
         (po1^ >= 'a') and (po1^ <= 'f')) do begin
   inc(po1);
  end;
  result:= po1^ = #0;
 end;
end;

function tgitcontroller.issha1(const avalue: string): boolean;
var
 str1: string;
begin
 result:= issha1(avalue,str1);
end;

type
 recordkindty = (rk_none,rk_commit,rk_committer,rk_message);
 recdefty = record
  name: msestring;
 end;

const
 rk_first = rk_commit;
 rk_last = high(recordkindty);
 
 recdef: array[recordkindty] of recdefty =
         (     
          (name: ''),             //rk_none
          (name: 'commit'),       //rk_commit
          (name: 'committer'),    //rk_committer
          (name: '   ')           //rk_message
         );
         
function tgitcontroller.decodecommit(const atext: msestring;
                   const ainfo: prefinfoty; const alist: prefinfoarty): boolean;
                                             //false if empty

 function recordkind(const start,stop: pmsechar): recordkindty;
 var
  k1: recordkindty;
  po1: pmsechar;
  int1,int2: integer;
 begin
  result:= rk_none;
  int1:= stop-start;
  if int1 > 0 then begin
   for k1:= rk_first to rk_last do begin
    if length(recdef[k1].name) = int1 then begin
     result:= k1;
     po1:= pointer(recdef[k1].name);
     for int2:= 0 to int1-1 do begin
      if po1[int2] <> start[int2] then begin
       result:= rk_none;
       break;
      end;
     end;
     if result <> rk_none then begin
      break;
     end;
    end;
   end;
  end;
 end; //recordkind
 
var
 po1: pmsechar;
 
 procedure revfind(const start: pmsechar; const achar: msechar;
                                                 out found: pmsechar);
 var
  po2: pmsechar;
 begin
  found:= nil;
  po2:= start-1;
  while (po2 > po1) and (po2^ <> achar) do begin
   dec(po2);
  end;
  if (po2 >= po1) and (po2^ = achar) then begin
   found:= po2;
  end;
 end; //revfind;
 
var
 po2,po3,po4,po5: pmsechar;
 k1: recordkindty;
 lwo1: longword;
 int1: integer;
 pinfo1: prefinfoty;
begin
 result:= false;
 if atext <> '' then begin
  po1:= pointer(atext);
  pinfo1:= nil;
  int1:= 0;
  while po1^ <> #0 do begin
   po2:= po1;
   while (po2^ <> ' ') and (po2^ <> c_linefeed) and (po2^ <> #0) do begin
    inc(po2);
   end;
   if po1^ = ' ' then begin
    while po2^ = ' ' do begin
     inc(po2);
    end;
    dec(po2);
   end;
   po3:= po2;
   while (po3^ <> c_linefeed) and (po3^ <> #0) do begin
    inc(po3);
   end;
   k1:= recordkind(po1,po2);
   if k1 = rk_commit then begin
    result:= true; 
    if alist <> nil then begin
     if int1 > high(alist^) then begin
      setlength(alist^,high(alist^)*2+256);
     end;
     pinfo1:= @alist^[int1];
    end
    else begin
     if pinfo1 <> nil then begin
      exit;
     end;
     pinfo1:= ainfo;
    end;
    inc(int1);
    pinfo1^.commit:= psubstr(po2+1,po3);
   end
   else begin
    if pinfo1 <> nil then begin
     case k1 of
      rk_committer: begin
       revfind(po3,' ',po4);
       revfind(po4,' ',po5);
       if po5 <> nil then begin
        if trystrtointmse(psubstr(po5+1,po4),lwo1) then begin
         pinfo1^.commitdate:= unixtodatetime(lwo1);
         pinfo1^.committer:= psubstr(po2+1,po5);
        end;
       end;
      end;
      rk_message: begin
       if pinfo1^.message <> '' then begin
        pinfo1^.message:= pinfo1^.message + lineend + psubstr(po2+1,po3);
       end
       else begin
        pinfo1^.message:= pinfo1^.message + psubstr(po2+1,po3);
       end;
      end;
     end;
    end;
   end;
   if po3^ <> #0 then begin
    inc(po3);
   end;
   po1:= po3;
  end;
  if alist <> nil then begin
   setlength(alist^,int1);
  end;
 end;
end;

function tgitcontroller.revlist(out alist: refinfoarty; 
               const abranch: msestring; const apath: filenamety = '';
               const maxcount: integer = 0; const skip: integer = 0;
               const commitfilter: msestring = ''; 
               const commitdatemin: tdatetime = emptydatetime;
               const commitdatemax: tdatetime = emptydatetime;
               const committerfilter: msestring = ''; 
               const messagefilter: msestring = ''): boolean;

var
 mstr1: msestring;
 str1: string;
 
begin
 alist:= nil;
 str1:= 'rev-list --pretty=raw ';
 if commitdatemin <> emptydatetime then begin
  str1:= str1 + '--since='+encodedatetimeparam(commitdatemin)+' ';
 end;
 if commitdatemax <> emptydatetime then begin
  str1:= str1 + '--until='+encodedatetimeparam(commitdatemax)+' ';
 end;
 if committerfilter <> '' then begin
  str1:= str1 + '--committer='+encodestringparam(committerfilter)+' ';
 end;
 if messagefilter <> '' then begin
  str1:= str1 + '--grep='+encodestringparam(messagefilter)+' ';
 end;
 if maxcount > 0 then begin
  str1:= str1 + '--max-count='+inttostr(maxcount)+' ';
 end;
 if skip > 0 then begin
  str1:= str1+'--skip='+inttostr(skip)+' ';
 end;
 if commitfilter <> '' then begin
  str1:= str1 + encodestringparam(commitfilter);
 end
 else begin
  if abranch = '' then begin
   str1:= str1 + 'HEAD ';
  end
  else begin
   str1:= str1 + abranch + ' ';
  end;
 end;
 if apath <> '' then begin
  str1:= str1 + '-- '+encodepathparam(apath,true);
 end;
 result:= commandresult1(str1,mstr1);
 if result then begin
  decodecommit(mstr1,nil,@alist);
 end;
end;

(*
function tgitcontroller.revlist(out alist: refinfoarty; 
               const abranch: msestring; const apath: filenamety = '';
               const maxcount: integer = 0; const skip: integer = 0): boolean;
               
 function recordkind(const start,stop: pmsechar): recordkindty;
 var
  k1: recordkindty;
  po1: pmsechar;
  int1,int2: integer;
 begin
  result:= rk_none;
  int1:= stop-start;
  if int1 > 0 then begin
   for k1:= rk_first to rk_last do begin
    if length(recdef[k1].name) = int1 then begin
     result:= k1;
     po1:= pointer(recdef[k1].name);
     for int2:= 0 to int1-1 do begin
      if po1[int2] <> start[int2] then begin
       result:= rk_none;
       break;
      end;
     end;
     if result <> rk_none then begin
      break;
     end;
    end;
   end;
  end;
 end; //recordkind

var
 po1: pmsechar;
 
 procedure revfind(const start: pmsechar; const achar: msechar;
                                                 out found: pmsechar);
 var
  po2: pmsechar;
 begin
  found:= nil;
  po2:= start-1;
  while (po2 > po1) and (po2^ <> achar) do begin
   dec(po2);
  end;
  if (po2 >= po1) and (po2^ = achar) then begin
   found:= po2;
  end;
 end; //revfind;
 
var
 str1: string;
 mstr1: msestring;
 po2,po3,po4,po5: pmsechar;
 int1: integer;
 pinfo1: prefinfoty;
 k1: recordkindty;
 lwo1: longword;
 
begin
 alist:= nil;
 str1:= 'rev-list --pretty=raw ';
 if maxcount > 0 then begin
  str1:= str1 + '--max-count='+inttostr(maxcount)+' ';
 end;
 if skip > 0 then begin
  str1:= str1+'--skip='+inttostr(skip)+' ';
 end;
 if abranch = '' then begin
  str1:= str1 + 'HEAD ';
 end
 else begin
  str1:= str1 + abranch + ' ';
 end;
 if apath <> '' then begin
  str1:= str1 + '-- '+encodepathparam(apath,true);
 end;
 result:= commandresult1(str1,mstr1);
 if result then begin
  pinfo1:= nil;
  po1:= pmsechar(mstr1);
  int1:= 0;
  while po1^ <> #0 do begin
   po2:= po1;
   while (po2^ <> ' ') and (po2^ <> c_linefeed) and (po2^ <> #0) do begin
    inc(po2);
   end;
   if po1^ = ' ' then begin
    while po2^ = ' ' do begin
     inc(po2);
    end;
    dec(po2);
   end;
   po3:= po2;
   while (po3^ <> c_linefeed) and (po3^ <> #0) do begin
    inc(po3);
   end;
   k1:= recordkind(po1,po2);
   if k1 = rk_commit then begin
    if int1 > high(alist) then begin
     setlength(alist,high(alist)*2+256);
    end;
    pinfo1:= @alist[int1];
    inc(int1);
    pinfo1^.commit:= psubstr(po2+1,po3);
   end
   else begin
    if pinfo1 <> nil then begin
     case k1 of
      rk_committer: begin
       revfind(po3,' ',po4);
       revfind(po4,' ',po5);
       if po5 <> nil then begin
        if trystrtointmse(psubstr(po5+1,po4),lwo1) then begin
         pinfo1^.commitdate:= unixtodatetime(lwo1);
         pinfo1^.committer:= psubstr(po2+1,po5);
        end;
       end;
      end;
      rk_message: begin
       if pinfo1^.message <> '' then begin
        pinfo1^.message:= pinfo1^.message + lineend + psubstr(po2+1,po3);
       end
       else begin
        pinfo1^.message:= pinfo1^.message + psubstr(po2+1,po3);
       end;
      end;
     end;
    end;
   end;
   if po3^ <> #0 then begin
    inc(po3);
   end;
   po1:= po3;
  end;
  setlength(alist,int1);
 end;
end;
*)

function tgitcontroller.stashlist(out adest: stashinfoarty): boolean;
var
 po1,po2: pmsechar;
 
 procedure decodeline;
 var
  po3,po4: pmsechar;
 begin
  po3:= po1;
  while (po3^ <> ':') and (po3 < po2) do begin
   inc(po3);
  end;
  inc(po3); //space
  if po3 < po2 then begin
   setlength(adest,high(adest)+2);
   with adest[high(adest)] do begin
    name:= psubstr(po1,po3-1);
    po4:= po2;
    if (po4 > po3) and (po4^ = c_return) then begin
     dec(po4);
    end;
    message:= psubstr(po3,po4);
   end;
  end;
  po1:= po2+1;
 end; //decodeline
 
var
 mstr1: msestring;
begin
 adest:= nil;
 result:= commandresult1('stash list',mstr1);
 if mstr1 <> '' then begin
  po1:= pointer(mstr1);
  po2:= po1;
  while po2^ <> #0 do begin
   if po2^ = c_linefeed then begin
    decodeline;
   end;
   inc(po2);
  end;
  decodeline;
 end;
end;

function tgitcontroller.getsha1(const arev: msestring): msestring;
begin
 commandresult1('show --format=format:"%H" -s '+encodestringparam(arev),result);
 trimright1(result); //remove line end
end;

function tgitcontroller.getrefinfo(const arev: msestring;
                                 out ainfo: refinfoty): boolean;
var
 mstr1: msestring;
begin
 ainfo.commitdate:= emptydatetime;
 result:= commandresult1('show --format=raw -s '+
             encodestringparam(arev),mstr1);
 if result then begin
  result:= decodecommit(mstr1,@ainfo,nil);
 end;
end;

procedure tgitcontroller.resetversioncheck;
begin
 fversionchecked:= false;
 fcanvarset:= false;
end;

function tgitcontroller.checkrefformat(const aref: msestring): boolean;
begin
 result:= execcommand('check-ref-format '+encodestringparam('refs/'+aref),false);
end;

procedure tgitcontroller.setprociddest(var adest: prochandlety);
begin
 currentgitprocesspo:= @adest;
end;

function tgitcontroller.encodedatetimeparam(const aparam: tdatetime): string;
begin
 result:= datetimetostring(aparam,'II');
end;

function tgitcontroller.getconfig(const varname: string;
               out varvalue: msestring): boolean;
begin
 varvalue:= '';
 result:= commandresult1('config '+varname,varvalue) and (varvalue <> '');
 if result and (varvalue[length(varvalue)] = c_linefeed) then begin
  setlength(varvalue,length(varvalue)-1);
  if (varvalue <> '') and (varvalue[length(varvalue)] = c_return) then begin
   setlength(varvalue,length(varvalue)-1);
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
 wdbefore:= msegetcurrentdir;
 fna1:= astate.getrepodir(apath);
 result:= sys_setcurrentdir(apath) = sye_ok;
 if not result then begin
  ferrormessage:= getlasterrortext;
  exit;
 end;
 result:= getprocessoutput(getgitcommand('ls-files -z '+getpathparam(apath)),
                                                    '',str1,ferrormessage) = 0;
 msesetcurrentdir(wdbefore);
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
 fdirhash:= tpointermsestringhashdatalist.create;
end;

destructor tgitstatecache.destroy;
begin
 fdirhash.free;
 inherited;
end;

function tgitstatecache.add(const aname: msestring): pgitstatedataty;
var
 mstr1: msestring;
begin
 result:= inherited add(aname);
 mstr1:= filedir(aname);
 if mstr1 = ffiledir then begin
  mstr1:= ffiledir; //reuse memory
 end;
 ffiledir:= mstr1;
 fdirhash.add(mstr1,
         pointer(ptruint(pchar(result)-pchar(data)-sizeof(msestringdataty))));
         //pgitstateinfoty
end;

function tgitstatecache.addunique(const akey: msestring): pgitstatedataty;
begin
 result:= find(akey);
 if result = nil then begin
  result:= add(akey);
 end;
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

procedure tgitstatecache.iterate(const include: array of gitstatedataty;
                                      const aiterator: gitstateiteratorprocty);
var
 po1: pgitstateinfoty;
 puint1: ptruint;
 int1: integer;
begin
 if count > 0 then begin
  puint1:= assignedroot;
  while puint1 <> 0 do begin
   po1:= pgitstateinfoty(pchar(data) + puint1 + sizeof(hashheaderty));
   for int1:= 0 to high(include) do begin
    with include[int1] do begin
     if (po1^.data.statex*statex = statex) and 
                             (po1^.data.statey*statey = statey) then begin
      aiterator(po1^);
      break;
     end;
    end;
   end;
   inc(puint1,phashdataty(pchar(po1)-sizeof(hashheaderty))^.header.nextlist);
  end;  
 end;
end;

procedure tgitstatecache.iterate(const adir: msestring;
               const include: array of gitstatedataty;
               const aiterator: gitstateiteratorprocty);
var
 ha1: hashvaluety;
 po1: ppointermsestringhashdataty;
 po2: pgitstateinfoty;
 dirhashdata: pchar;
 int1: integer;
begin
{$warnings off}
 po1:= ppointermsestringhashdataty(thashdatalist1(fdirhash).internalfind(adir));
{$warnings on}
 if po1 <> nil then begin
{$warnings off}
  dirhashdata:= thashdatalist1(fdirhash).data;
{$warnings on}
  ha1:= hashkey(adir);
  while true do begin
   if (po1^.header.hash = ha1) and checkkey(adir,po1^.data) then begin
    po2:= pointer(pchar(data) + ptruint(po1^.data.data));
    for int1:= 0 to high(include) do begin
     with include[int1] do begin
      if (po2^.data.statex*statex = statex) and 
                            (po2^.data.statey*statey = statey) then begin
       aiterator(po2^);
       break;
      end;
     end;
    end;
   end;
   if po1^.header.nexthash = 0 then begin
    break;
   end;
   po1:= ppointermsestringhashdataty(phashdataty(dirhashdata + 
                                             po1^.header.nexthash));
  end;
 end;
end;

procedure tgitstatecache.iterate(const adir: msestring;
               const include: array of gitstatedataty);
begin
end;

{ tgitfileitem }

constructor tgitfileitem.create;
begin
 inherited create(nil);
end;

procedure tgitfileitem.assign(const source: tlistitem);
begin
 inherited;
 if source is tgitfileitem then begin
  with tgitfileitem(source) do begin
   self.fgitstate:= fgitstate;
  end;
 end;
end;

constructor tgitfileitem.create(const aitem: gitstateinfoty;
                                                  const pathstart: integer);
begin
 create;
 fcaption:= copy(aitem.filename,pathstart,bigint);
 fgitstate:= aitem.data;
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

function tgitfilecache.add(var ainfo: gitfileinfoty): pgitfiledataty;
var
 dir,nam: msestring; 
begin
 with ainfo do begin
  splitfilepath(data.stateinfo.filename,dir,nam);
  if dir = fdirpath then begin
   dir:= fdirpath; //reuse memory;
  end
  else begin
   fdirpath:= dir;
  end;
  data.stateinfo.filename:= nam;
  result:= add(dir);
  result^:= data;
 end;
end;

function tgitfilecache.add(const astatus: gitstateinfoty): pgitfiledataty;

var
 dir,nam: msestring; 
begin
 splitfilepath(astatus.filename,dir,nam);
 if dir = fdirpath then begin
  dir:= fdirpath; //reuse memory;
 end
 else begin
  fdirpath:= dir;
 end;
 result:= add(dir);
 with result^.stateinfo do begin
  filename:= nam;
  data:= astatus.data;
 end;
end;

end.
