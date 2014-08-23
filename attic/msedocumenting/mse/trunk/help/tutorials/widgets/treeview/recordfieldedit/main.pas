{ MSEide+MSEgui demo Copyright (c) 2008-2014 by Martin Schreiber
   
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
unit main;

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msedataedits,mseedit,msegrids,
 msestrings,msetypes,msewidgetgrid,msedatanodes,mselistbrowser,msestatfile,
 mseificomp,mseificompglob,mseifiglob;

type
 tmainfo = class(tmseform)
   grid: twidgetgrid;
   treeedit: ttreeitemedit;
   tstatfile1: tstatfile;
   recfielded: trecordfieldedit;
   procedure initdata(const sender: TObject);
   procedure initform(const sender: TObject);
 end;
 
 tmynode = class(ttreelistedititem)
  private
   fstr: msestring;
  protected
  public
   function getvaluetext: msestring; override;
   procedure setvaluetext(var avalue: msestring); override;
   procedure dostatread(const reader: tstatreader); override;
   procedure dostatwrite(const writer: tstatwriter); override;
   property str: msestring read fstr write fstr;
 end;
 
var
 mainfo: tmainfo;
 
implementation
uses
 main_mfm;
 
{ tmynode }

procedure tmynode.dostatread(const reader: tstatreader);
begin
 inherited;
 str:= reader.readstring('str',str);
end;

procedure tmynode.dostatwrite(const writer: tstatwriter);
begin
 inherited;
 writer.writestring('str',str);
end;

function tmynode.getvaluetext: msestring;
begin
 result:= fstr;
end;

procedure tmynode.setvaluetext(var avalue: msestring);
begin
 fstr:= avalue;
end;

{ tmainfo }

procedure tmainfo.initform(const sender: TObject);
begin
 treeedit.itemlist.itemclass:= tmynode; 
end;

procedure tmainfo.initdata(const sender: TObject);
begin
 if grid.rowcount = 0 then begin //not loaded by statfile
  grid.rowcount:= 2; //root nodes
  with tmynode(treeedit[0]) do begin
   caption:= 'AAAAA';
   add(3,tmynode);
   items[0].caption:= 'A0';
   items[1].caption:= 'A1';
   items[2].caption:= 'A2';
  end;
  with tmynode(treeedit[1]) do begin
   caption:= 'BBBBBBBBBB';
   add(5,tmynode);
   items[0].caption:= 'BB0';
   items[1].caption:= 'B1';
   with tmynode(items[1]) do begin
    add(5,tmynode);
    items[0].caption:= 'B1a';
    items[1].caption:= 'B1b';
    items[2].caption:= 'B1c';
    items[3].caption:= 'B1d';
    items[4].caption:= 'B1e';
   end;
   items[2].caption:= 'BBBBBB2';
   items[3].caption:= 'B3';
   items[4].caption:= 'B4';
  end;
 end;
end;

end.
