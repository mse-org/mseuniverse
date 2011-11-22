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
unit filelistframe;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedataedits,mseedit,
 msegrids,mseifiglob,msestrings,msetypes,msewidgetgrid,msegraphedits,
 msedatanodes,mselistbrowser,msestatfile,mainmodule;
type
 tfilelistframefo = class(tmseform)
   grid: twidgetgrid;
   originstate: tdataicon;
   filestate: tdataicon;
   fileitemed: titemedit;
   procedure updaterowvaluesexe(const sender: TObject; const aindex: Integer;
                   const aitem: tlistitem);
  public
   function currentitem: tmsegitfileitem;
   function currentitems: msegitfileitemarty;
   function currentfile: filenamety;
   procedure setcurrentfile(const afile: filenamety);
 end;
var
 filelistframefo: tfilelistframefo;
implementation
uses
 filelistframe_mfm,msegitcontroller;

procedure tfilelistframefo.updaterowvaluesexe(const sender: TObject;
               const aindex: Integer; const aitem: tlistitem);
begin
 with tmsegitfileitem(aitem) do begin
  filestate[aindex]:= imagenr;
  originstate[aindex]:= getoriginicon;
 end;
end;

function tfilelistframefo.currentitem: tmsegitfileitem;
begin
 result:= tmsegitfileitem(fileitemed.item);
end;

function tfilelistframefo.currentfile: filenamety;
var
 n1: tmsegitfileitem;
begin
 result:= '';
 n1:= currentitem;
 if n1 <> nil then begin
  result:= n1.caption;
 end;
end;

procedure tfilelistframefo.setcurrentfile(const afile: filenamety);
var
 po1: pgitfileitematy;
 int1: integer;
begin
 po1:= fileitemed.itemlist.datapo;
 with grid do begin
  for int1:= rowhigh downto 0 do begin
   if po1^[int1].caption = afile then begin
    row:= int1;
    if not entered then begin
     datacols.clearselection;
    end; 
    exit;
   end;
  end;
  row:= invalidaxis;
 end;
end;

function tfilelistframefo.currentitems: msegitfileitemarty;
begin
 result:= msegitfileitemarty(fileitemed.selecteditems);
end;

end.
