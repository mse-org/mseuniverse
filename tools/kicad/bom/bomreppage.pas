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
unit bomreppage;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,basereppage,
 mdb,msebufdataset,msedb,mseifiglob,mselocaldataset,msereport,mserichstring,
 msesplitter,msestrings,listreppage,mainmodule;

type
 tbomreppa = class(tlistreppa)
   count: tmselongintfield;
   part: tmsestringfield;
   ref: tmsestringfield;
   ds: tlocaldataset;
   dso: tmsedatasource;
   header: trecordband;
   tbandgroup1: tbandgroup;
   data1: trecordband;
   data2: trecordband;
   data3: trecordband;
   enddummy: trecordband;
   procedure bandafterrendev(const sender: tcustomrecordband);
  public
   constructor create(const apage: tbompage);
 end;
implementation
uses
 bomreppage_mfm,bommodule;

{ tbomreppa }

constructor tbomreppa.create(const apage: tbompage);
var
 s1: msestring;
begin
 inherited create(apage);
 data2.visible:= apage.showreferences;
 s1:= 'PART';
 if apage.showreferences then begin
  s1:= s1+'/REF';
 end;
 if apage.showdistributors then begin
  s1:= s1+'/DISTRIBUTOR';
  bommo.compdistribqu.active:= true;
  header.tabs[2].value:= 'PART#';
 end;
 header.tabs[1].value:= s1;
end;

procedure tbomreppa.bandafterrendev(const sender: tcustomrecordband);
begin
 if bommo.compdistribqu.active then begin
  bommo.compdistribqu.refresh();
 end;
end;

end.
