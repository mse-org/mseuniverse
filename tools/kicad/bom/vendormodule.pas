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
//
// under construction
//
unit vendormodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseapplication,mseclasses,msedatamodules,mdb,msebufdataset,
 msedatabase,msedb,mseifiglob,msesqldb,msestrings,msqldb,sysutils;

type
 tvendormo = class(tmsedatamodule)
   distributorqu: tmsesqlquery;
   d_ident: tmsestringfield;
   d_name: tmsestringfield;
   d_pk: tmselargeintfield;
   distributordso: tmsedatasource;
   manufacturerqu: tmsesqlquery;
   m_ident: tmsestringfield;
   m_name: tmsestringfield;
   m_pk: tmselargeintfield;
   manufacturerdso: tmsedatasource;
   procedure distributordeletecheckev(DataSet: TDataSet);
   procedure maufaturerdeletecheckev(DataSet: TDataSet);
 end;
var
 vendormo: tvendormo;
implementation
uses
 vendormodule_mfm,mainmodule;
 
procedure tvendormo.distributordeletecheckev(DataSet: TDataSet);
begin
 with mainmo do begin
  deletecheck(d_pk,[sc_distributor,k_distributor]);
 end;
end;

procedure tvendormo.maufaturerdeletecheckev(DataSet: TDataSet);
begin
 with mainmo do begin
  deletecheck(m_pk,[sc_manufacturer,k_manufacturer]);
 end;
end;

end.
