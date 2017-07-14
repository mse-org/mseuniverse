{ MSEkicad Copyright (c) 2016 by Martin Schreiber
   
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
unit kicadschemaparser;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseclasses,msestream,msetypes,msestrings;
 
type
 compfieldinfoty = record
  n: int32;
  text: msestring;
  name: msestring;
 end;
 pcompfieldinfoty = ^compfieldinfoty;
 compfieldarty = array of compfieldinfoty;
 
 compinfoty = record
  name: msestring;
  reference: msestring;
  n: int32;
  mm: int32;
  timestamp: msestring;
  fields: compfieldarty;
  duplicates: msestringarty; //AR entries from hierarchical sheets
 end;
 
 tkicadschemaparser = class;
 compeventty = procedure(const sender: tkicadschemaparser;
                                        var info: compinfoty) of object;
 
 tkicadschemaparser = class(tmsecomponent)
  private
   foncomp: compeventty;
  public
   procedure parse(const asource: ttextstream);
  published
   property oncomp: compeventty read foncomp write foncomp;
 end;
 
implementation
uses
 sysutils,mseformatstr,msearrayutils;
 
{ tkicadschemaparser }

procedure tkicadschemaparser.parse(const asource: ttextstream);
type
 sheetstatety = (ss_none,ss_unknown,ss_comp);
 
const
 firstentity = sheetstatety(ord(ss_unknown)+1);
 entitytokens: array[sheetstatety] of msestring = ('','',
         //ss_comp
          'Comp');
var
 entitytoken: msestring;

function findstringvalue(const items: msestringarty;
            const name: msestring; var value: msestring): boolean;
var
 p1,pe: pmsestring;
 i1,i2: int32;
begin
 result:= false;
 p1:= pointer(items);
 pe:= p1 + length(items);
 while p1 < pe do begin
  if pos(name,p1^) = 1 then begin
   i1:= length(name)+1;
   i2:= length(p1^);
   if (p1^[i1] = '"') and (i2 > i1) and (p1^[i2] = '"') then begin
    result:= true;
    value:= copy(p1^,i1+1,i2-i1-1);
   end;
   break;
  end;
  inc(p1);
 end;
end;

function isentityend(const atext: msestring): boolean;
begin
 result:= (atext <> '') and (atext[1] = '$') and 
      (trimright(copy(atext,2,bigint)) = 'End'+entitytoken);
end;

var
 s1,s2: msestring;
 eof1: boolean;
 state,st1: sheetstatety;
 entitystate: int32;
 po1: pmsechar;
 ar1: msestringarty;
 compinfo: compinfoty;
 i1: int32;
 fieldcount: int32;
 
begin
 state:= ss_none;
 repeat
  eof1:= not asource.readln(s1);
  if s1 <> '' then begin
   case state of
    ss_none: begin
     if s1[1] = '$' then begin
      entitytoken:= trimright(copy(s1,2,bigint));
      if entitytoken <> '' then begin
       po1:= pointer(entitytoken);
       while (po1^ <> ' ') and (po1^ <> #0) do begin
        inc(po1);
       end;
       setlength(entitytoken,po1-pmsechar(pointer(entitytoken)));
      end;
      state:= ss_unknown;
      for st1:= firstentity to high(entitytokens) do begin
       if entitytokens[st1] = entitytoken then begin
        state:= st1;
        entitystate:= 0;
        break;
       end;
      end;
     end;
    end;
    ss_unknown: begin
     if isentityend(s1) then begin
      state:= ss_none; //skip unknown entity
     end;
    end;
    ss_comp: begin
     if entitystate = 0 then begin
      with compinfo do begin
       name:= '';
       reference:= '';
       n:= 0;
       mm:= 0;
       timestamp:= '';
       fields:= nil;
       duplicates:= nil;
      end;
      fieldcount:= 0;
      inc(entitystate);
     end;
     if isentityend(s1) and assigned(foncomp) then begin
      setlength(compinfo.fields,fieldcount);
      if compinfo.duplicates <> nil then begin
       for i1:= 0 to high(compinfo.duplicates) do begin
        compinfo.reference:= compinfo.duplicates[i1];
        foncomp(self,compinfo);
       end;
      end
      else begin
       foncomp(self,compinfo);
      end;
      state:= ss_none;
     end
     else begin
      ar1:= splitstringquoted(s1,' ','"',true);
      i1:= high(ar1);
      if ar1[0] <> '' then begin
       case ar1[0][1] of
        'L': begin
         if i1 >= 1 then begin
          compinfo.name:= ar1[1];
          if i1 >= 2 then begin
           compinfo.reference:= ar1[2];
          end;
         end;
        end;
        'A': begin
         if ar1[0][2] = 'R' then begin
          if findstringvalue(ar1,'Ref=',s2) then begin
           additem(compinfo.duplicates,s2);
          end;
         end;
        end;
        'U': begin
         if i1 >= 1 then begin
          if not trystrtoint(ar1[1],compinfo.n) then begin
           compinfo.n:= 0;
          end;
          if i1 >= 2 then begin
           if not trystrtoint(ar1[2],compinfo.mm) then begin
            compinfo.mm:= 0;
           end;
           if i1 >= 3 then begin
            compinfo.timestamp:= ar1[3];
           end;
          end;
         end;
        end;
        'F': begin
         if (high(ar1) >= 1) and trystrtoint(ar1[1],i1) then begin
          additem(compinfo.fields,typeinfo(compinfo.fields),fieldcount);
          with compinfo.fields[fieldcount-1] do begin
           n:= i1;
           if high(ar1) >= 2 then begin
            text:= unquotestring(ar1[2],'"');
            if high(ar1) >= 11 then begin
             name:= mseuppercase(unquotestring(ar1[11],'"'));
            end
            else begin
             case i1 of
              0: name:= 'REFERENCE';
              1: name:= 'VALUE';
              2: name:= 'FOOTPRINT';
              3: name:= 'DATASHEET';
             end;
            end;
           end;
          end;
         end;
        end;
       end;
      end;
     end;
    end;
   end;
  end;
 until eof1;
end;

end.
