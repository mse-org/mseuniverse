{ MSEtoken Copyright (c) 2018 by Martin Schreiber
   
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
unit voucherreport;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msereport,mdb,mseifiglob,
 mserichstring,msesplitter,msedb,msedbdispwidgets;

type
 tvoucherre = class(treport)
   treportpage1: treportpage;
   trepvaluedisp1: trepvaluedisp;
   trepprintdatedisp1: trepprintdatedisp;
   trecordband1: trecordband;
   dataso: tmsedatasource;
   trecordband2: trecordband;
   trecordband3: trecordband;
   trecordband4: trecordband;
   trecordband5: trecordband;
   trecordband6: trecordband;
   tdbbarcode1: tdbbarcode;
   tdbintegerdisp1: tdbintegerdisp;
   trecordband7: trecordband;
   trecordband8: trecordband;
 end;
var
 voucherre: tvoucherre;
implementation
uses
 voucherreport_mfm;
end.
