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
 mseclasses,msestream,msestrings;
 
type
 compfieldinfoty = record
  n: int32;
  text: msestring;
  name: msestring;
 end;
 compfieldarty = array of compfieldinfoty;
 
 compinfoty = record
  name: msestring;
  reference: msestring;
  n: int32;
  mm: int32;
  timestamp: msestring;
  fields: compfieldarty;
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
 msetypes,sysutils,mseformatstr,msearrayutils;
 
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

function isentityend(const atext: msestring): boolean;
begin
 result:= (atext <> '') and (atext[1] = '$') and 
      (trimright(copy(atext,2,bigint)) = 'End'+entitytoken);
end;

var
 mstr1: msestring;
 eof1: boolean;
 state,s1: sheetstatety;
 entitystate: int32;
 po1: pmsechar;
 ar1: msestringarty;
 compinfo: compinfoty;
 i1: int32;
 fieldcount: int32;
 
begin
 state:= ss_none;
 repeat
  eof1:= not asource.readln(mstr1);
  if mstr1 <> '' then begin
   case state of
    ss_none: begin
     if mstr1[1] = '$' then begin
      entitytoken:= trimright(copy(mstr1,2,bigint));
      if entitytoken <> '' then begin
       po1:= pointer(entitytoken);
       while (po1^ <> ' ') and (po1^ <> #0) do begin
        inc(po1);
       end;
       setlength(entitytoken,po1-pmsechar(pointer(entitytoken)));
      end;
      state:= ss_unknown;
      for s1:= firstentity to high(entitytokens) do begin
       if entitytokens[s1] = entitytoken then begin
        state:= s1;
        entitystate:= 0;
        break;
       end;
      end;
     end;
    end;
    ss_unknown: begin
     if isentityend(mstr1) then begin
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
      end;
      fieldcount:= 0;
      inc(entitystate);
     end;
     if isentityend(mstr1) and assigned(foncomp) then begin
      setlength(compinfo.fields,fieldcount);
      foncomp(self,compinfo);
      state:= ss_none;
     end
     else begin
      ar1:= splitstringquoted(mstr1,' ','"',true);
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
