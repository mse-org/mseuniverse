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
 msestrings,mseclasses,classes;
const
 defaultgitcommand = 'git';
 
type
 gitstatety = (gist_invalid,gist_unmodified,gist_modified,gist_added,
                gist_deleted,gist_renamed,gist_copied,gist_updated,
                gist_untracked,gist_ignored);
 gitstatesty = set of gitstatety;
 gitstateinfoty = record
  name: filenamety;
  statex: gitstatety;
  statey: gitstatety;
 end;
 pgitstateinfoty = ^gitstateinfoty;
 gitstateinfoarty = array of gitstateinfoty;
 
 tgitcontroller = class(tmsecomponent)
  private
   fgitcommand: msestring;
   ferrormessage: string;
  protected
   function getgitcommand(const acommand: msestring): msestring;
  public
   constructor create(aowner: tcomponent); override;
   function status(out astatus: gitstateinfoarty;
                               const apath: filenamety = ''): boolean;
   function getpathparam(const apath: filenamety): msestring;
  published
   property gitcommand: filenamety read fgitcommand write fgitcommand;
                  //'' -> 'git'
 end;
 
function checkgit(const adir: filenamety; out gitroot: filenamety): boolean;

implementation
uses
 msefileutils,mseprocess,msearrayutils;
 
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

function tgitcontroller.getpathparam(const apath: filenamety): msestring;
begin
 result:= quotefilename(tosysfilepath(apath));
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
   
function tgitcontroller.status(out astatus: gitstateinfoarty;
               const apath: filenamety = ''): boolean;
var
 str1: string;
 po1,po2,po3: pchar;
 int1,int2: integer;
begin
 astatus:= nil;
 result:= getprocessoutput(getgitcommand('status -z --porcelain '+
                                  getpathparam(apath)),'',str1,ferrormessage) = 0;
 if result and (str1 <> '') then begin
  po1:= pointer(str1);
  po3:= po1 + length(str1);
  int2:= 0;
  while po1 < po3 do begin
   po2:= po1;
   while po2^ <> #0 do begin
    inc(po2);
   end;
   int1:= po2-po1;
   if int1 > 3 then begin
    if int2 >= high(astatus) then begin
     setlength(astatus,length(astatus)*2+32);
    end;
    with astatus[int2] do begin
     if po1^ > #$7f then begin
      statex:= gist_invalid;
     end
     else begin
      statex:= statchars[ord(po1^)];
     end;
     inc(po1);
     if po1^ > #$7f then begin
      statey:= gist_invalid;
     end
     else begin
      statey:= statchars[ord(po1^)];
     end;
     inc(po1,2);
     name:= po1;
    end;
    po1:= po2+1;
   end;
   inc(int2);
  end;
  setlength(astatus,int2);
 end;
end;

end.
