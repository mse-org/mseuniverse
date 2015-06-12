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
 mseificomp,mseificompglob,mseifiglob,msebitmap,msevaluenodes;

type
 tmynode = class(ttreelistedititem,irecordfield)
  private
   fstrfield: msestring; //index 0
   fintfield: integer ;  //index 1
   frealfield: real;     //index 2
   procedure setstrfield(const avalue: msestring);
   procedure setintfield(const avalue: integer);
   procedure setrealfield(const avalue: real);
  protected
   function createsubnode: ttreelistitem; override;
    //irecordfield
   function getfieldtext(const fieldindex: integer): msestring;
   procedure setfieldtext(const fieldindex: integer; var avalue: msestring);
  public
   constructor create(const aowner: tcustomitemlist = nil;
              const aparent: ttreelistitem = nil); override;
   procedure dostatread(const reader: tstatreader); override;
   procedure dostatwrite(const writer: tstatwriter); override;
   function getvaluetext: msestring; override;
   property strfield: msestring read fstrfield write setstrfield;
   property intfield: integer read fintfield write setintfield;
   property realfield: real read frealfield write setrealfield;
 end;
 
 tmainfo = class(tmseform)
   grid: twidgetgrid;
   treeedit: ttreeitemedit;
   tstatfile1: tstatfile;
   recfielded: trecordfieldedit;
   ima: timagelist;
   stred: tstringedit;
   inted: tintegeredit;
   realed: trealedit;
   procedure initdata(const sender: TObject);
   procedure initform(const sender: TObject);
   procedure strfieldset(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure intfieldset(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
   procedure realfieldset(const sender: TObject; var avalue: realty;
                   var accept: Boolean);
  protected
   function currentnode(): tmynode;
 end;
 
var
 mainfo: tmainfo;
 
implementation
uses
 main_mfm,mseformatstr;
 
{ tmynode }

constructor tmynode.create(const aowner: tcustomitemlist = nil;
               const aparent: ttreelistitem = nil);
begin
 inherited;                                                //image base = -1
 state:= state + [ns_readonly];
 add(trecordfielditem.create(irecordfield(self),0,'String Field',true,1));
 add(trecordfielditem.create(irecordfield(self),1,'Integer Field',true,2));
 add(trecordfielditem.create(irecordfield(self),2,'Real Field',true,3));
end;

function tmynode.createsubnode: ttreelistitem;
begin
 result:= trecordfielditem.create(irecordfield(self),count,'',true);
end;

procedure tmynode.dostatread(const reader: tstatreader);
begin
 inherited;
 fstrfield:= reader.readstring('str',fstrfield);
 fintfield:= reader.readinteger('int',fintfield);
 frealfield:= reader.readreal('rea',frealfield,emptyreal);
end;

procedure tmynode.dostatwrite(const writer: tstatwriter);
begin
 inherited;
 writer.writestring('str',fstrfield);
 writer.writeinteger('int',fintfield);
 writer.writereal('rea',frealfield);
end;

procedure tmynode.setstrfield(const avalue: msestring);
begin
 fstrfield:= avalue;
 trecordfielditem(fitems[0]).valuechange();
end;

procedure tmynode.setintfield(const avalue: integer);
begin
 fintfield:= avalue;
 trecordfielditem(fitems[1]).valuechange();
end;

procedure tmynode.setrealfield(const avalue: real);
begin
 frealfield:= avalue;
 trecordfielditem(fitems[2]).valuechange();
end;

function tmynode.getfieldtext(const fieldindex: integer): msestring;
begin
 case fieldindex of
  0: begin
   result:= fstrfield;
  end;
  1: begin
   result:= inttostrmse(fintfield);
  end;
  2: begin
   result:= realtytostrmse(frealfield);
  end;
  else begin
   result:= '';
  end;
 end;
end;

procedure tmynode.setfieldtext(const fieldindex: integer;
                                                   var avalue: msestring);
begin
 case fieldindex of
  0: begin
   fstrfield:= avalue;
  end;
  1: begin
   fintfield:= strtointmse(avalue);
  end;
  2: begin
   frealfield:= strtorealty(avalue);
  end;
 end;
end;

function tmynode.getvaluetext: msestring;
begin
 result:= ''; //no caption copy in field edit
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
  end;
  with tmynode(treeedit[1]) do begin
   caption:= 'BBBBBBBBBB';
  end;
 end;
end;

function tmainfo.currentnode(): tmynode;
begin
 result:= nil;
 if treeedit.item is tmynode then begin
  result:= tmynode(treeedit.item);
 end
 else begin
  result:= tmynode(treeedit.item.parent);
 end;
end;

procedure tmainfo.strfieldset(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 currentnode.strfield:= avalue;
end;

procedure tmainfo.intfieldset(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
 currentnode.intfield:= avalue;
end;

procedure tmainfo.realfieldset(const sender: TObject; var avalue: realty;
               var accept: Boolean);
begin
 currentnode.realfield:= avalue;
end;

end.
