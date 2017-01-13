{ MSEkicad Copyright (c) 2016-2017 by Martin Schreiber
   
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
unit bommodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseapplication,mseclasses,msedatamodules,mdb,msebufdataset,
 msedb,mseifiglob,mselocaldataset;

type
 tbommo = class(tmsedatamodule)
   bomds: tlocaldataset;
   bomdso: tmsedatasource;
   count: tmselongintfield;
   part: tmsestringfield;
   ref: tmsestringfield;
   procedure afteropenev(DataSet: TDataSet);
 end;
var
 bommo: tbommo;
implementation
uses
 bommodule_mfm,mainmodule;
 
procedure tbommo.afteropenev(DataSet: TDataSet);
var
 index1: int32;
 recno1: int32;
begin
 with mainmo.compds do begin
  index1:= indexlocal.activeindex;
  recno1:= recno;
  try
  finally
   indexlocal.activeindex:= index1;
   recno:= recno1;
  end;
 end;
end;

end.
