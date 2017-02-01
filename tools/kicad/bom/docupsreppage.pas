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
unit docupsreppage;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msereport,mserepps,
 basereppage,mainmodule;

type
 tdocupsreppa = class(tbasereppa)
   ps: treppsdisp;
  public
   constructor create(const apage: tdocupage);
 end;

implementation
uses
 docupsreppage_mfm;

{ tdocupsreppa }

constructor tdocupsreppa.create(const apage: tdocupage);
begin
 inherited create(nil);
 ps.scale:= apage.scale;
 ps.shifthorz:= apage.shifthorz;
 ps.shiftvert:= apage.shiftvert;
end;

end.
