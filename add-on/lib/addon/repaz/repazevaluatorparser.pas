{*********************************************************}
{        Parser expression unit for TRepazEvaluator       }
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
unit repazevaluatorparser;

interface

uses classes,sysutils,repazevaluatortype,repazconsts,mseconsts,msestrings;
type

  tmseevalparser = class(tobject)
  private
    fnewexpression:string;
    fstream: tstream;
    forigin: longint;
    fbuffer: array of byte;
    fbufptr: integer;
    fbufend: integer;
    fsourceptr: integer;
    fsourceend: integer;
    ftokenptr: integer;
    fstringptr: integer;
    fsourceline: integer;
    fsavechar: byte;
    ftoken: char;
    ffloattype: char;
    fwidestr: msestring;
    procedure readbuffer;
    procedure skipblanks;
    procedure setexpression(value:string);
  public
    constructor create;
    destructor destroy;override;
    procedure checktoken(t: char);
    procedure checktokensymbol(const s: string);
    procedure error(messageid:msestring);
    //procedure hextobinary(stream: tstream);
    function nexttoken: char;
    function sourcepos: longint;
    function tokencomponentident: string;
    function tokenfloat: double;
//    function tokenint: int64;
    function tokenint: integer;
    function tokenstring: string;
    function tokenwidestring: msestring;
    function tokensymbolis(const s: string): boolean;
    // ask for the next token
    function nexttokenis(value:string):boolean;
    property floattype: char read ffloattype;
    property sourceline: integer read fsourceline;
    property token: char read ftoken;
    property expression:string read fnewexpression write setexpression;
  end;

implementation

function sametext(const s1, s2: string): boolean;
begin
  result := comparetext(s1, s2) = 0;
end;

const
  parsebufsize = 4096;


const
  h2bconvert: array['0'..'f'] of smallint =
    ( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,-1,-1,-1,-1,-1,-1,
     -1,10,11,12,13,14,15,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
     -1,10,11,12,13,14,15);

function hextobin(const text: array of byte; textoffset: integer;
  buffer: array of byte; bufoffset: integer; count: integer): integer;
var
  i, c: integer;
begin
  c := 0;
  for i := 0 to count - 1 do
  begin
    if not (ansichar(text[textoffset + i * 2]) in [ansichar('0')..ansichar('f')]) or
       not (ansichar(text[textoffset + 1 + i * 2]) in [ansichar('0')..ansichar('f')]) then
      break;
    buffer[bufoffset + i] :=
      (h2bconvert[ansichar(text[textoffset + i * 2])] shl 4) or
       h2bconvert[ansichar(text[textoffset + 1 + i * 2])];
    inc(c);
  end;
  result := c;
end;

function alinestart(buffer: array of byte; bufpos: integer): integer;
begin
  while (bufpos > 0) and (buffer[bufpos] <> 10) do
    dec(bufpos);
  if buffer[bufpos] = 10 then
    inc(bufpos);
  result := bufpos;
end;


constructor tmseevalparser.create;
begin
  inherited create;
end;


procedure tmseevalparser.checktoken(t: char);
begin
  if token <> t then
    case t of
      tosymbol:
        error(uc(ord(rcsidentifierexpected)));
      tkstring:
        error(uc(ord(rcsstringexpected)));
      towstring:
        error(uc(ord(rcsstringexpected)));
      tointeger, tofloat:
        error(uc(ord(rcsnumberexpected)));
      tooperator:
        error(uc(ord(rcsoperatorexpected)));
    end;
end;

procedure tmseevalparser.error(messageid: msestring);
begin
  raise tevalexception.create(messageid,tokenstring,sourceline,sourcepos);
end;


procedure tmseevalparser.checktokensymbol(const s: string);
begin
  if not tokensymbolis(s) then
   raise tevalexception.create(format(uc(ord(rcsexpected)), [s]),'',sourceline,sourcepos);
end;


function tmseevalparser.nexttoken: char;
var
  i, j: integer;
  iswidestr: boolean;
  p, s: integer;
  achar:ansichar;
  operadors:string;
  operador:char;
begin
  skipblanks;
  p := fsourceptr;
  ftokenptr := p;
  case ansichar(fbuffer[p]) of
    // identifiers
    'A'..'Z', 'a'..'z','_':
      begin
        inc(p);
        while ansichar(fbuffer[p]) in ['A'..'Z', 'a'..'z','0'..'9','_','.'] do
          inc(p);
        result := tosymbol;
      end;
    // identifiers with blanks into brackets
    '[':
      begin
        inc(p);
        achar:=ansichar(fbuffer[p]);
        while ((achar<>ansichar(0)) and (achar<>']')) do
        begin
         inc(p);
         achar:=ansichar(fbuffer[p]);
        end;
        // finish?
        if achar<>']' then
         raise exception.create(format(uc(ord(rcsexpected)),[']']));
        inc(p);
        result := tosymbol;
      end;
    // operators
    '*','+','-','/','(',')',',','=','>','<',':',';':
      begin
       result:=tooperator;
       operador:=char(fbuffer[p]);
       inc(p);
       case char(fbuffer[p]) of
        '=':
         if operador in [':','!','<','>','='] then
          inc(p);
        '<':
         if operador='>' then
          inc(p);
        '>':
         if operador='<' then
          inc(p);
       end;
      end;
    // strings and chars
    '#', '''':
      begin
        iswidestr := false;
        j := 0;
        s := p;
        while true do
          case char(fbuffer[p]) of
            '#':
              begin
                inc(p);
                i := 0;
                while ansichar(fbuffer[p]) in ['0'..'9'] do
                begin
                  i := i * 10 + (fbuffer[p] - ord('0'));
                  inc(p);
                end;
                if (i > 127) then
                  iswidestr := true;
                inc(j);
              end;
            '''':
              begin
                inc(p);
                while true do
                begin
                  case ansichar(fbuffer[p]) of
                    #0, #10, #13:
                      error(uc(ord(rcsevalsyntax)));
                    '''':
                      begin
                        inc(p);
                        if char(fbuffer[p]) <> '''' then
                          break;
                      end;
                  end;
                  inc(j);
                  inc(p);
                end;
              end;
          else
            break;
          end;
        p := s;
        if iswidestr then
          setlength(fwidestr, j);
        j := 1;
        while true do
          case char(fbuffer[p]) of
            '#':
              begin
                inc(p);
                i := 0;
                while ansichar(fbuffer[p]) in ['0'..'9'] do
                begin
                  i := i * 10 + (fbuffer[p] - ord('0'));
                  inc(p);
                end;
                if iswidestr then
                begin
                  fwidestr[j] := widechar(smallint(i));
                  inc(j);
                end
                else
                begin
                  fbuffer[s] := i;
                  inc(s);
                end;
              end;
            '''':
              begin
                inc(p);
                while true do
                begin
                  case fbuffer[p] of
                    0, 10, 13:
                      error(uc(ord(rcsevalsyntax)));
                    ord(''''):
                      begin
                        inc(p);
                        if char(fbuffer[p]) <> '''' then
                          break;
                      end;
                  end;
                  if iswidestr then
                  begin
                    fwidestr[j] := widechar(fbuffer[p]);
                    inc(j);
                  end
                  else
                  begin
                    fbuffer[s] := fbuffer[p];
                    inc(s);
                  end;
                  inc(p);
                end;
              end;
          else
            break;
          end;
        fstringptr := s;
        if iswidestr then
          result := towstring
        else
          result := tkstring;
      end;
    // hex numbers
    '$':
      begin
        inc(p);
        while ansichar(fbuffer[p]) in ['0'..'9', 'A'..'F', 'a'..'f'] do
          inc(p);
        result := tointeger;
      end;
    // numbers
    '0'..'9':
      begin
        inc(p);
        while ansichar(fbuffer[p]) in ['0'..'9'] do
          inc(p);
        result := tointeger;
        while ansichar(fbuffer[p]) in ['0'..'9', '.', 'e', 'E'] do
        begin
          if ansichar(fbuffer[p])='.' then
          begin
           fbuffer[p]:=byte(decimalseparator);
          end;
          inc(p);
          result := tofloat;
        end;
        if (ansichar(fbuffer[p]) in ['c', 'C', 'd', 'D', 's', 'S', 'f', 'F']) then
        begin
          result := tofloat;
          ffloattype := char(fbuffer[p]);
          inc(p);
        end
        else
          ffloattype := #0;
      end;
  else
    result := char(fbuffer[p]);
    if result <> toeof then
    begin
     result:=tosymbol;
     inc(p);
    end;
  end;
  fsourceptr := p;
  ftoken := result;
  // symbols
  if ftoken=tosymbol then
  begin
   operadors:=lowercase(tokenstring);
   if ((operadors='or') or (operadors='not')
        or (operadors='and') or (operadors='iif')) then
   begin
    result:=tooperator;
    ftoken:=tooperator;
   end;
  end;
end;

procedure tmseevalparser.readbuffer;
var
  count: integer;
begin
  inc(forigin, fsourceptr);
  fbuffer[fsourceend] := fsavechar;
  count := fbufptr - fsourceptr;
  if count <> 0 then
  begin
   move(fbuffer[fsourceptr],fbuffer[0],count);
  end;
  fbufptr := count;
  inc(fbufptr, fstream.read(fbuffer[fbufptr], fbufend - fbufptr));
  fsourceptr := 0;
  fsourceend := fbufptr;
  if fsourceend = fbufend then
  begin
    fsourceend := alinestart(fbuffer, fsourceend - 2);
    if fsourceend = 0 then
      error(uc(ord(rcslinetoolong)));
  end;
  fsavechar := fbuffer[fsourceend];
  fbuffer[fsourceend] := 0;
end;

procedure tmseevalparser.skipblanks;
begin
  while true do
  begin
    case fbuffer[fsourceptr] of
      0:
        begin
          readbuffer;
          if fbuffer[fsourceptr] = 0 then
            exit;
          continue;
        end;
      10:
        inc(fsourceline);
      33..255:
        exit;
    end;
    inc(fsourceptr);
  end;
end;

function tmseevalparser.sourcepos: longint;
begin
  result := forigin + ftokenptr;
end;

function tmseevalparser.tokenfloat: double;
begin
  if ffloattype <> #0 then
    dec(fsourceptr);
  result := strtofloat(tokenstring);
  if ffloattype <> #0 then
    inc(fsourceptr);
end;

function tmseevalparser.tokenint: integer;
begin
  result := strtoint64(tokenstring);
end;

function tmseevalparser.tokenstring: string;
var
  l: integer;
begin
  if ftoken = tkstring then
    l := fstringptr - ftokenptr
  else
    l := fsourceptr - ftokenptr;
  setstring(result,pchar(@fbuffer[ftokenptr]),l);
  // brackets out
  if ftoken=tosymbol then
  begin
   if length(result)>0 then
   begin
    if result[1]='[' then
     if result[length(result)]=']' then
      result:=copy(result,2,length(result)-2);
   end;
  end;
end;

function tmseevalparser.tokenwidestring: msestring;
begin
  if ftoken = tkstring then
    result := tokenstring
  else
    result := fwidestr;
end;

function tmseevalparser.tokensymbolis(const s: string): boolean;
begin
  result := (token = tosymbol) and sametext(s, tokenstring);
end;

function tmseevalparser.tokencomponentident: string;
var
  p: integer;
begin
  checktoken(tosymbol);
  p := fsourceptr;
  while ansichar(fbuffer[p]) = '.' do
  begin
    inc(p);
    if not (ansichar(fbuffer[p]) in ['A'..'Z', 'a'..'z', '_']) then
      error(uc(ord(rcsidentifierexpected)));
    repeat
      inc(p)
    until not (ansichar(fbuffer[p]) in ['A'..'Z', 'a'..'z', '0'..'9', '_']);
  end;
  fsourceptr := p;
  result := tokenstring;
end;

function tmseevalparser.nexttokenis(value:string):boolean;
var newparser:tmseevalparser;
    apuntador:integer;
begin
  // a new parser must be create for checking the next token
  apuntador:=fsourceptr;
  newparser:=tmseevalparser.create;
  try
   newparser.expression:=copy(expression,apuntador+1,length(expression));
   result:=false;
   if newparser.token in [tosymbol,tooperator] then
    if newparser.tokenstring=value then
     result:=true;
  finally
   newparser.free;
  end;
end;

procedure tmseevalparser.setexpression(value:string);
begin
  if assigned(fstream) then
   fstream.free;
  fstream := tmemorystream.create;
  if length(value)>0 then
   fstream.write(value[1],length(value));
  fstream.seek(0,sofrombeginning);
  fnewexpression:=value;
  setlength(fbuffer, parsebufsize);
  fbuffer[0] := 0;
  fbufptr := 0;
  fbufend := parsebufsize;
  fsourceptr := 0;
  fsourceend := 0;
  ftokenptr := 0;
  fsourceline := 1;
  nexttoken;
end;

destructor tmseevalparser.destroy;
begin
 inherited destroy;
  if assigned(fstream) then
   fstream.free;
end;

end.
