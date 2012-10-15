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
unit plotsform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedock,msescrollbar,
 msestatfile,msestream,msestrings,msetabs,msewidgets,sysutils,msetypes;

type
 tplotsfo = class(tdockform)
   tabs: ttabwidget;
   popupmen: tpopupmenu;
   procedure createexe(const sender: TObject);
   procedure newplotexe(const sender: TObject);
   procedure deleteplotexe(const sender: TObject);
   procedure popupupdateexe(const sender: tcustommenu);
  protected
   procedure createpage(const akind: integer);
   procedure updatetabnames;
  public
   procedure readstat(const areader: tstatreader);
   procedure writestat(const awriter: tstatwriter);
 end;
var
 plotsfo: tplotsfo;
implementation
uses
 plotsform_mfm,plotpage;
const
 plotssection = 'plots';
 kindtag = 'kind';
  
procedure tplotsfo.createexe(const sender: TObject);
begin
 createpage(-1);
end;

procedure tplotsfo.createpage(const akind: integer);
var
 fo1: tplotpagefo;
begin
 fo1:= tplotpagefo.create(self,akind);
 fo1.name:= '';
 tabs.add(itabpage(fo1));
 
end;

procedure tplotsfo.updatetabnames;
var
 int1,int2: integer;
 str1: string;
 ar1: chartnodearty;
begin
 for int1:= 0 to tabs.count-1 do begin
  tabs.items[int1].name:= '';
 end;
 for int1:= 0 to tabs.count-1 do begin
  with tplotpagefo(tabs.items[int1]) do begin
   str1:= 'p'+inttostr(int1);
   name:= str1;
   str1:= str1+'_';
   ar1:= chartnodes;
   for int2:= 0 to high(ar1) do begin
    with ar1[int2] do begin
     if haschart then begin
      chart.name:= str1+inttostr(int2);
     end;
    end;
   end;
   resetnameindex;
  end;
 end;
end;

procedure tplotsfo.readstat(const areader: tstatreader);
var
 ar1: integerarty;
 int1: integer;
begin
 tabs.clear;
 with areader do begin
  if findsection(plotssection) then begin
   ar1:= readarray(kindtag,integerarty(nil));
   for int1:= 0 to high(ar1) do begin
    createpage(ar1[int1]);
   end;
   updatetabnames;
  end;
 end;
 if tabs.count = 0 then begin
  createpage(-1);
 end;
end;

procedure tplotsfo.writestat(const awriter: tstatwriter);
var
 ar1: integerarty;
 int1: integer;
begin
 tabs.clearorder;
 updatetabnames;
 setlength(ar1,tabs.count);
 for int1:= 0 to high(ar1) do begin
  ar1[int1]:= tplotpagefo(tabs.items[int1]).kind;
 end;
 with awriter do begin
  setsection(plotssection);
  writearray(kindtag,ar1);
 end;  
end;

procedure tplotsfo.newplotexe(const sender: TObject);
begin
 createpage(-1);
end;

procedure tplotsfo.deleteplotexe(const sender: TObject);
begin
 tabs.activepage.release;
end;

procedure tplotsfo.popupupdateexe(const sender: tcustommenu);
begin
 sender.menu.itembyname('del').enabled:= tabs.activepageindex >= 0;
end;

end.
