{ MSEide+MSEgui demo Copyright (c) 2008 by Martin Schreiber
   
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
 msestrings,msetypes,msewidgetgrid,msedatanodes,mselistbrowser,msestatfile;

type
 tmainfo = class(tmseform)
   grid: twidgetgrid;
   treeedit: ttreeitemedit;
   stredit: tstringedit;
   intedit: tintegeredit;
   procedure initdata(const sender: TObject);
   procedure updaterowvalues(const sender: TObject; const aindex: Integer;
                   const aitem: tlistitem);
   procedure strsetvalue(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure intsetvalue(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
 end;
 
 tmynode = class(ttreelistedititem)
  private
   fint: integer;
   fstr: msestring;
  public
   property int: integer read fint write fint;
   property str: msestring read fstr write fstr;
 end;
 
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
 
{ tmainfo }

procedure tmainfo.initdata(const sender: TObject);
var
 node1: tmynode;
begin

 node1:= tmynode.create;  //first root node
 with node1 do begin
  caption:= 'A';
  str:= mselowercase(caption);
  int:= parentindex;  
  with tmynode(add(tmynode)) do begin
   caption:= 'AA';  
   str:= mselowercase(caption);
   int:= parentindex;
  end;  
  with tmynode(add(tmynode)) do begin
   caption:= 'AB';
   str:= mselowercase(caption);
   int:= parentindex;
   with tmynode(add(tmynode)) do begin
    caption:= 'ABA';
    str:= mselowercase(caption);
    int:= parentindex;
   end;
  end;
  with tmynode(add(tmynode)) do begin
   caption:= 'AC';
   str:= mselowercase(caption);
   int:= parentindex;
  end;
  with tmynode(add(tmynode)) do begin
   caption:= 'AD';
   str:= mselowercase(caption);
   int:= parentindex;
  end;
 end;
 treeedit.itemlist.add(node1); //itemlist owns the item
 
 node1:= tmynode.create;  //second root node
 with node1 do begin
  caption:= 'B';
  str:= mselowercase(caption);
  int:= parentindex;  
  with tmynode(add(tmynode)) do begin
   caption:= 'BA';
   str:= mselowercase(caption);
   int:= parentindex;
  end;  
  with tmynode(add(tmynode)) do begin
   caption:= 'BC';
   str:= mselowercase(caption);
   int:= parentindex;
  end;
  with tmynode(add(tmynode)) do begin
   caption:= 'BD';
   str:= mselowercase(caption);
   int:= parentindex;
  end;
  with tmynode(add(tmynode)) do begin
   caption:= 'BE';
   str:= mselowercase(caption);
   int:= parentindex; 
  end;
  add(5,tmynode);
  items[4].caption:= 'BF';
  items[5].caption:= 'BG';
  with tmynode(items[6]) do begin
   caption:= 'BH';
   add(5,tmynode);
   items[0].caption:= 'BHA';
   items[1].caption:= 'BHB';
   items[2].caption:= 'BHC';
   items[3].caption:= 'BHD';
   items[4].caption:= 'BHE';
  end;
  items[7].caption:= 'BI';
  items[8].caption:= 'BJ';
 end;
 treeedit.itemlist.add(node1); //itemlist owns the item
end;

procedure tmainfo.updaterowvalues(const sender: TObject; const aindex: Integer;
               const aitem: tlistitem);
begin
 with tmynode(aitem) do begin
  stredit[aindex]:= str;
  intedit[aindex]:= int;
 end;
end;

procedure tmainfo.strsetvalue(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 with tmynode(treeedit.item) do begin
  str:= avalue;
 end;
end;

procedure tmainfo.intsetvalue(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
 with tmynode(treeedit.item) do begin
  int:= avalue;
 end;
end;

end.
