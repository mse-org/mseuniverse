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
unit filelistframe;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedataedits,mseedit,
 msegrids,mseifiglob,msestrings,msetypes,msewidgetgrid,msegraphedits,
 msedatanodes,mselistbrowser,msestatfile;
type
 tfilelistframefo = class(tmseform)
   grid: twidgetgrid;
   originstate: tdataicon;
   filestate: tdataicon;
   fileitemed: titemedit;
   procedure updaterowvaluesexe(const sender: TObject; const aindex: Integer;
                   const aitem: tlistitem);
 end;
var
 filelistframefo: tfilelistframefo;
implementation
uses
 filelistframe_mfm,mainmodule;

procedure tfilelistframefo.updaterowvaluesexe(const sender: TObject;
               const aindex: Integer; const aitem: tlistitem);
begin
 with tmsegitfileitem(aitem) do begin
  filestate[aindex]:= imagenr;
  originstate[aindex]:= getoriginicon;
 end;
end;

end.
