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
 msedb,mseifiglob,mselocaldataset,msestrings;

type
 tbommo = class(tmsedatamodule)
   bomds: tlocaldataset;
   bomdso: tmsedatasource;
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
 val,val1,val2,desc: msestring;
 valbefore,val1before,val2before,descbefore: msestring;
 reflist: msestring;
 count1: int32;

 procedure addcomp();
 begin
  if count1 > 0 then begin
   setlength(reflist,length(reflist)-1); //remove trailing space
   bomds.appendrecord([count1,descbefore,reflist]);
  end;
  valbefore:= val;
  val1before:= val1;
  val2before:= val2;
  descbefore:= desc;
  count1:= 0;
  reflist:= '';
 end;//addcomp

begin
 with mainmo.compds do begin
  index1:= indexlocal.activeindex;
  recno1:= recno;
  try
   bomds.resetindex;
   indexlocal.indexbyname('comp').active:= true;
   disablecontrols();
   valbefore:= '';
   val1before:= '';
   val2before:= '';
   descbefore:= '';
   reflist:= '';
   count1:= 0;
   first();
   while not eof do begin
    val:= mseuppercase(mainmo.c_value.asmsestring);
    val1:= mseuppercase(mainmo.c_value1.asmsestring);
    val2:= mseuppercase(mainmo.c_value2.asmsestring);
    desc:= mainmo.c_description.asmsestring;
    if (val <> valbefore) or (val1 <> val1before) or 
                        (val2 <> val2before) or (desc <> descbefore) then begin
     addcomp();
    end;
    reflist:= reflist + mainmo.c_ref.asmsestring + ' ';
    inc(count1);
    next();
   end;
   addcomp();
   bomds.indexlocal[0].active:= true;
   bomds.first();
  finally
   indexlocal.activeindex:= index1;
   recno:= recno1;
  end;
 end;
end;

end.
