{ MSEgit Copyright (c) 2012 by Martin Schreiber
   
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
unit filechecklistframe;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,filelistframe,
 msegraphedits,mseifiglob,msetypes,mainmodule,msestrings,msegitcontroller;

type
 checkalleventty = procedure(const sender: tobject;
                               const acheck: boolean) of object;

 tfilechecklistframefo = class(tfilelistframefo)
   selected: tbooleanedit;
   checkpopup: tpopupmenu;
   procedure uncheckallexe(const sender: TObject);
   procedure checkallexe(const sender: TObject);
  private
   foncheckall: checkalleventty;
  protected
   procedure docheckall(const acheck: boolean);
  public
   function selectedfiles(const aroot: tgitdirtreenode): filenamearty;
   function checkeditems: msegitfileitemarty;
   property oncheckall: checkalleventty read foncheckall write foncheckall;
 end;

var
 filechecklistframefo: tfilechecklistframefo;

implementation
uses
 filechecklistframe_mfm;

{ tfilechecklistframe }

function tfilechecklistframefo.selectedfiles(
                  const aroot: tgitdirtreenode): filenamearty; 
var
 int1,int2: integer;
 po1: pgitfileitem;
begin
 setlength(result,grid.rowcount);
 int2:= 0;
 po1:= fileitemed.itemlist.datapo;
 for int1:= 0 to high(result) do begin
  if selected[int1] then begin
   result[int2]:= mainmo.getpath(aroot,
                           po1[int1].caption);
   inc(int2);
  end;
 end;
 setlength(result,int2);
end;

function tfilechecklistframefo.checkeditems: msegitfileitemarty;
var
 int1,int2: integer;
 po1: pmsegitfileitem;
begin
 setlength(result,grid.rowcount);
 int2:= 0;
 po1:= fileitemed.itemlist.datapo;
 for int1:= 0 to high(result) do begin
  if selected[int1] then begin
   result[int2]:= po1[int1];
   inc(int2);
  end;
 end;
 setlength(result,int2);
end;

procedure tfilechecklistframefo.docheckall(const acheck: boolean);
begin
 selected.fillcol(acheck);
 if canevent(tmethod(foncheckall)) then begin
  foncheckall(self,acheck);
 end;
end;

procedure tfilechecklistframefo.uncheckallexe(const sender: TObject);
begin
 docheckall(false);
end;

procedure tfilechecklistframefo.checkallexe(const sender: TObject);
begin
 docheckall(true);
end;

end.
