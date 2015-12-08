{ MSEide Copyright (c) 1999-2011 by Martin Schreiber

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

   Modified 2011 by Sri Wahono

   This component is used for Repaz components
   Feel free to participate with reports bug, create new 
   report template, etc with join with Repaz forum at : 
   http://www.msegui.org/repaz                
}

unit compdesignintf;

{$ifdef FPC}{$mode objfpc}{$h+}{$interfaces corba}{$endif}

interface
uses
 classes,mclasses,msegraphutils,mselist,sysutils,typinfo,msebitmap,
 msetypes,msestrings,msegraphics,msegui,mseglob,msearrayutils,
 mseclasses,msestat,msehash,mseobjecttext;

type

 componentinfoty = record
  name: string;
  instance: tcomponent;
 end;
 pcomponentinfoty = ^componentinfoty;

 componentnamety = record
  instance: tcomponent;
  dispname: string;
 end;
 componentnamearty = array of componentnamety;

 componentclassinfoty = record
  classtyp: tcomponentclass;
  icon: integer;
  page: integer;
 end;
 pcomponentclassinfoty = ^componentclassinfoty;

 comppagety = record
  caption: msestring;
  hint: msestring;
 end;
 comppagearty = array of comppagety;
 
 tcomponentclasslist = class(torderedrecordlist)
  private
   fselectedclass: tcomponentclass;
   fimagelist: timagelist;
   fpagenames: comppagearty;
   fpagecomporders: integerararty;
   function getpagecomporders(const index: integer): integerarty;
   procedure setpagecomporders(const index: integer;
      const Value: integerarty);
   procedure checkpageindex(const index: integer);
  protected
   function findpage(const pagename: msestring): integer;
   function addpage(const pagename: msestring): integer;
   function getcomparefunc: sortcomparemethodty; override;
   function componentcounts: integerarty;
   function compare(const l,r): integer;
  public
   constructor create;
   destructor destroy; override;
   function indexof(const value: tcomponentclass): integer;  //-1 if not found
   function add(const value: componentclassinfoty): integer;
           //-1 if allready registred
   function itempo(const index: integer): pcomponentclassinfoty;
   
   procedure regcomponents(const page: msestring;
                 const componentclasses: array of tcomponentclass);
   procedure setinvisiblecomponents(const page: msestring;
                 const componentclasses: array of tcomponentclass);
   procedure regcomponenttabhints(const pages: array of msestring;
                       const hints: array of msestring);
                       //pages are case sensitive, pages mustexist
   function pagehigh: integer;
   function pagenames: comppagearty;
   property pagecomporders[const index: integer]: integerarty
                  read getpagecomporders write setpagecomporders;
   procedure drawcomponenticon(const acomponent: tcomponent;
              const canvas: tcanvas; const dest: rectty);
   procedure updatestat(const filer: tstatfiler);
   property selectedclass: tcomponentclass read fselectedclass write fselectedclass;
   property imagelist: timagelist read fimagelist;
 //nil for unselect
 end;

 idesignerselections = interface(inullinterface)
  function add(const item: tcomponent): integer;
  function equals(const list: idesignerselections): boolean;
  function get(index: integer): tcomponent;
  function getcount: integer;
  function getarray: componentarty;
  property count: integer read getcount;
  property items[index: integer]: tcomponent read get; default;
 end;

 componenteditorstatety = (cs_canedit);
 componenteditorstatesty = set of componenteditorstatety;

 icomponentdesigner = interface(inullinterface)
  procedure edit;
  function state: componenteditorstatesty;
 end;

 selectedinfoty = record
  instance: tcomponent;
 end;
 pselectedinfoty = ^selectedinfoty;
 
 objinfoty = record
  owner: tcomponent;
  parent: twidget;
  objtext: string;
 end;
 objinfoarty = array of objinfoty;

 componentsdataty = record
  key: ptruint;
  data: componentinfoty;
 end;
 pcomponentsdataty = ^componentsdataty;

 tdesignerselections = class(trecordlist,idesignerselections)
  private
   fupdating: integer;
   factcomp: tcomponent;
   function Getitems(const index: integer): tcomponent;
   procedure Setitems(const index: integer; const Value: tcomponent);
   procedure dosetactcomp(component: tcomponent);
   procedure doadd(component: tcomponent);
  protected
   procedure dochanged; virtual;
   function getrecordsize: integer; virtual;
  public
   constructor create;
   procedure change; virtual;
   procedure beginupdate;
   procedure endupdate;
    // idesignerselections
   function Add(const Item: Tcomponent): Integer;
   function Equals(const List: IDesignerSelections): Boolean;
   function Get(Index: Integer): Tcomponent;
   function GetCount: Integer;
   function getarray: componentarty;

   function getobjinfoar: objinfoarty;   
   function itempo(const index: integer): pselectedinfoty;
   function indexof(const ainstance: tcomponent): integer;
   function remove(const ainstance: tcomponent): integer; virtual;
   procedure assign(const source: idesignerselections);
   property items[const index: integer]: tcomponent
              read Getitems write Setitems; default;
   function isembedded(const component: tcomponent): boolean;
                 //true if subchild of another selected component
 end;

 tcomponents = class(tptruinthashdatalist)
  protected
   //procedure freedata(var data); override;
   function find(const value: tobject): pcomponentinfoty;
   procedure swapcomponent(const old,new: tcomponent);
  public
   constructor create;
   destructor destroy; override;
   procedure add(comp: tcomponent);
   function next: pcomponentinfoty;
   function getcomponents: componentarty;
   function getlistnames: stringarty;
   function getdispnames: componentnamearty;
   function getcomponent(const aname: string): tcomponent;
   procedure namechanged(const acomponent: tcomponent; const newname: string);
 end;
  
procedure regcomponents(const page: msestring;
                          const componentclasses: array of tcomponentclass);
procedure regcomponenttabhints(const pages: array of msestring;
                       const hints: array of msestring);
                       //pages are case sensitive, pages mustexist
function registeredcomponents: tcomponentclasslist;

procedure setcomponentpos(const component: tcomponent; const pos: pointty);
function getcomponentpos(const component: tcomponent): pointty;

implementation
uses
 msestream,rtlconsts;
type

 {$ifdef FPC}
  TFilercracker = class(TObject)
  private
    FRoot: TComponent;
    FLookupRoot: TComponent;
  end;
  {$else}
  TFilercracker = class(TObject)
  private
    FStream: TStream;
    FBuffer: Pointer;
    FBufSize: Integer;
    FBufPos: Integer;
    FBufEnd: Integer;
    FRoot: TComponent;
    FLookupRoot: TComponent;
  end;
  {$endif}
 twriter1 = class(twriter);  

var
 aregisteredcomponents: tcomponentclasslist;

{$ifdef FPC}
var
 componentposreversed: boolean;
{$endif}

procedure setcomponentpos(const component: tcomponent; const pos: pointty);
var
 lo1: longint;
begin
 {$ifdef fpc} //fpbug
 if componentposreversed then begin
  longrec(lo1).hi:= pos.x;
  longrec(lo1).lo:= pos.y;
 end
 else begin
  longrec(lo1).lo:= pos.x;
  longrec(lo1).hi:= pos.y;
 end;
 {$else}
 longrec(lo1).lo:= pos.x;
 longrec(lo1).hi:= pos.y;
 {$endif}
 component.designinfo:= lo1;
end;

function getcomponentpos(const component: tcomponent): pointty;
begin
 {$ifdef fpc} //fpbug
 if componentposreversed then begin
  result.x:= smallint(longrec(component.designinfo).hi);
  result.y:= smallint(longrec(component.designinfo).lo);
 end
 else begin
  result.x:= smallint(longrec(component.designinfo).lo);
  result.y:= smallint(longrec(component.designinfo).hi);
 end;
 {$else}
 result.x:= smallint(longrec(component.designinfo).lo);
 result.y:= smallint(longrec(component.designinfo).hi);
 {$endif}
end;

function registeredcomponents: tcomponentclasslist;
begin
 if aregisteredcomponents = nil then begin
  aregisteredcomponents:= tcomponentclasslist.create;
 end;
 result:= aregisteredcomponents;
end;

procedure regcomponents(const page: msestring;
                 const componentclasses: array of tcomponentclass);
begin
 registeredcomponents.regcomponents(page,componentclasses);
end;

procedure regcomponenttabhints(const pages: array of msestring;
                       const hints: array of msestring);
                       //pages are case sensitive, pages mustexist
begin
 registeredcomponents.regcomponenttabhints(pages,hints);
end;

{ tcomponentclasslist }

constructor tcomponentclasslist.create;
begin
 fimagelist:= timagelist.create(nil);
 fimagelist.size:= makesize(24,24);
 inherited create(sizeof(componentclassinfoty));
end;

destructor tcomponentclasslist.destroy;
begin
 fimagelist.Free;
 inherited;
end;

function tcomponentclasslist.add(const value: componentclassinfoty): integer;
begin
 if indexof(value.classtyp) < 0 then begin
  result:= inherited add(value);
 end
 else begin
  result:= -1;
 end;
end;

procedure tcomponentclasslist.regcomponents(const page: msestring;
                 const componentclasses: array of tcomponentclass);
var
 info: componentclassinfoty;
 int1: integer;
 bitmap: tbitmapcomp;
 class1: tclass;
 pagenr: integer;
begin
 pagenr:= addpage(page);
 bitmap:= tbitmapcomp.create(nil);
 try
  if fimagelist.count = 0 then begin
   bitmap.name:= 'TComponent';
   initmsecomponent1(bitmap,nil);
   bitmap.bitmap.automask;
   fimagelist.addimage(bitmap.bitmap);
  end;
  with info do begin
   for int1:= 0 to high(componentclasses) do begin               
    classtyp:= componentclasses[int1];
    page:= pagenr;
    icon:= 0;
    class1:= classtyp;
    while class1 <> nil do begin
     bitmap.name:= class1.classname;
     if initmsecomponent1(bitmap,nil) then begin
      bitmap.bitmap.automask;
      icon:= fimagelist.addimage(bitmap.bitmap);
      break;
     end;
     class1:= class1.ClassParent;
    end;
    mclasses.registerclass(info.classtyp);
    add(info);
   end;
  end;
 finally
  bitmap.Free;
 end;
end;

procedure tcomponentclasslist.setinvisiblecomponents(const page: msestring;
                 const componentclasses: array of tcomponentclass);
var
 int1: integer;
 class1: tcomponentclass;
 index1: integer;
begin
 try
  for int1:= 0 to high(componentclasses) do begin               
   class1:= componentclasses[int1];
   index1:= indexof(class1);
   //fimagelist.deleteimage(index1);
   delete(index1);
  end;
 finally
  //
 end;
end;

procedure tcomponentclasslist.regcomponenttabhints(
              const pages: array of msestring; const hints: array of msestring);
                       //pages are case sensitive, pages mustexist
var
 int1: integer;
 int2: integer;
begin
 for int1:= 0 to high(pages) do begin
  int2:= findpage(pages[int1]);
  if (int2 >= 0) then begin
   with fpagenames[int2] do begin
    if int1 <= high(hints) then begin
     hint:= hints[int1];
    end
    else begin
     hint:= '';
    end;
   end;
  end;
 end;
end;

function tcomponentclasslist.indexof(
  const value: tcomponentclass): integer;
begin
 result:= inherited indexof(value);
end;

function tcomponentclasslist.itempo(
  const index: integer): pcomponentclassinfoty;
begin
 result:= pcomponentclassinfoty(getitempo(index));
end;

function tcomponentclasslist.findpage(const pagename: msestring): integer;
var
 int1: integer;
begin
 result:= -1;
 for int1:= 0 to high(fpagenames) do begin
  if fpagenames[int1].caption = pagename then begin
   result:= int1;
   break;
  end;
 end;
end;

function tcomponentclasslist.addpage(const pagename: msestring): integer;
begin
 result:= findpage(pagename);
 if result < 0 then begin
  setlength(fpagenames,length(fpagenames) + 1);
  setlength(fpagecomporders,length(fpagenames));
  result:= high(fpagenames);
  fpagenames[result].caption:= pagename;
 end;
end;

function tcomponentclasslist.pagenames: comppagearty;
begin
 result:= fpagenames;
end;

function tcomponentclasslist.pagehigh: integer;
begin
 result:= high(fpagenames);
end;

procedure tcomponentclasslist.drawcomponenticon(const acomponent: tcomponent;
                                    const canvas: tcanvas; const dest: rectty);
var
 int1: integer;
begin
 int1:= indexof(tcomponentclass(acomponent.classtype));
 if int1 >= 0 then begin
  fimagelist.paint(canvas,itempo(int1)^.icon,dest);
 end;
end;

function tcomponentclasslist.componentcounts: integerarty;
var
 int1: integer;
begin
 setlength(result,length(fpagenames));
 for int1:= 0 to count - 1 do begin
  with itempo(int1)^ do begin
   if page <= high(result) then begin
    inc(result[page]);
   end;
  end;
 end;
end;

procedure tcomponentclasslist.updatestat(const filer: tstatfiler);
var
 int1,int2: integer;
 ar1,ar2,ar3: integerarty;
begin
 ar1:= nil; //compiler warning
 ar2:= nil; //compiler warning
 filer.setsection('componentpalette');
 if filer.iswriter then begin
  for int1:= 0 to high(fpagecomporders) do begin
   tstatwriter(filer).writearray('order'+inttostr(int1),fpagecomporders[int1]);
  end;
 end
 else begin
  ar2:= componentcounts;
  for int1:= 0 to high(fpagecomporders) do begin
   ar1:= tstatreader(filer).readarray('order'+inttostr(int1),integerarty(nil));
   if ar1 <> nil then begin
    if length(ar1) <> ar2[int1] then begin
     ar1:= nil; //invalid
    end
    else begin
     ar3:= copy(ar1);
     sortarray(ar3);
     for int2:= 0 to high(ar3) do begin
      if ar3[int2] <> int2 then begin
       ar1:= nil; //invalid
       break;
      end;
     end;
    end;
   end;
   fpagecomporders[int1]:= ar1;
  end;
 end;
 filer.endlist;
end;

function tcomponentclasslist.compare(const l,r): integer;
begin
 result:= integer(componentclassinfoty(l).classtyp) -
              integer(componentclassinfoty(r).classtyp);
end;

function tcomponentclasslist.getcomparefunc: sortcomparemethodty;
begin
 result:= {$ifdef FPC}@{$endif}compare;
end;

procedure tcomponentclasslist.checkpageindex(const index: integer);
begin
 if (index < 0) or (index > high(fpagecomporders)) then begin
  tlist.Error(SListIndexError, Index);
 end;
end;

function tcomponentclasslist.getpagecomporders(
  const index: integer): integerarty;
begin
 checkpageindex(index);
 result:= fpagecomporders[index];
end;

procedure tcomponentclasslist.setpagecomporders(const index: integer;
  const Value: integerarty);
begin
 checkpageindex(index);
 fpagecomporders[index]:= value;
end;

{ tdesignerselections }

constructor tdesignerselections.create;
begin
 inherited create(getrecordsize);
end;

function tdesignerselections.itempo(const index: integer): pselectedinfoty;
begin
 result:= pselectedinfoty(getitempo(index));
end;

procedure tdesignerselections.assign(const source: idesignerselections);
var
 int1: integer;
begin
 clear;
 count:= source.Count;
 for int1:= 0 to source.count - 1 do begin
  itempo(int1)^.instance:= source.Items[int1];
 end;
 change;
end;

function tdesignerselections.getarray: componentarty;
begin
 if fcount > 0 then begin
  setlength(result,fcount);
  move(datapo^,pointer(result)^,fcount*sizeof(pointer));
 end
 else begin
  result:= nil;
 end;
end;

function tdesignerselections.Add(const Item: Tcomponent): Integer;
var
 info: selectedinfoty;
begin
 result:= indexof(item);
 if result < 0 then begin
  fillchar(info,sizeof(info),0);
  info.instance:= item;
  result:= inherited add(info);
  change;
 end;
end;

function tdesignerselections.Equals(const List: IDesignerSelections): Boolean;
var
 int1: integer;
begin
 result:= false;
 if list.Count = count then begin
  for int1:= 0 to count-1 do begin
   if list.Items[int1] <> itempo(int1)^.instance then begin
    exit;
   end;
  end;
 end;
 result:= true;
end;

function tdesignerselections.Get(Index: Integer): Tcomponent;
begin
 result:= itempo(index)^.instance;
end;

function tdesignerselections.GetCount: Integer;
begin
 result:= count;
end;

function tdesignerselections.indexof(const ainstance: tcomponent): integer;
var
 int1: integer;
begin
 result:= -1;
 for int1:= 0 to count-1 do begin
  if itempo(int1)^.instance = ainstance then begin
   result:= int1;
   break;
  end;
 end;
end;

function tdesignerselections.remove(const ainstance: tcomponent): integer;
begin
 result:= indexof(ainstance);
 if result >= 0 then begin
  delete(result);
  change;
 end;
end;

procedure tdesignerselections.dochanged;
begin
 //dummy
end;

function tdesignerselections.getrecordsize: integer;
begin
 result:= sizeof(selectedinfoty);
end;

function tdesignerselections.Getitems(const index: integer): tcomponent;
begin
 result:= itempo(index)^.instance;
end;

procedure tdesignerselections.Setitems(const index: integer;
  const Value: tcomponent);
begin
 itempo(index)^.instance:= value;
end;

procedure tdesignerselections.beginupdate;
begin
 inc(fupdating);
end;

procedure tdesignerselections.change;
begin
 if fupdating = 0 then begin
  dochanged;
 end;
end;

procedure tdesignerselections.endupdate;
begin
 dec(fupdating);
 if fupdating = 0 then begin
  dochanged;
 end;
end;

function tdesignerselections.isembedded(const component: tcomponent): boolean;
                 //true if subchild of another selected component
var
 comp1: tcomponent;
begin
 result:= false;
 comp1:= component.getparentcomponent;
 while comp1 <> nil do begin
  if (indexof(comp1) >= 0) then begin
   result:= true;
   break;  //stored bay parent
  end;
  comp1:= comp1.getparentcomponent;
 end;
end;

function tdesignerselections.getobjinfoar: objinfoarty;
var
 int1: integer;   
 co1: tcomponent;
 binstream: tmemorystream;
 textstream: ttextstream;
 writer: twriter;
begin
 result:= nil;
 for int1:= 0 to count - 1 do begin
  co1:= items[int1];
  if not isembedded(co1) then begin
   setlength(result,high(result)+2);
   with result[high(result)] do begin
    owner:= co1.owner;
    if co1 is twidget then begin
     parent:= twidget(co1).parentwidget;
    end
    else begin
     parent:= nil;
    end;
    binstream:= tmemorystream.create;
    writer:= twriter.create(binstream,4096);
    textstream:= ttextstream.create;
    try
     writer.root:= co1.owner;
     {$ifndef FPC}
     writer.writesignature;
     {$endif}
     writer.writecomponent(co1);
     freeandnil(writer);
     binstream.position:= 0;
     objectbinarytotextmse(binstream,textstream);
     textstream.position:= 0;
     objtext:= textstream.readdatastring;
    finally
     writer.free;
     binstream.free;
     textstream.free;
    end;   
   end;
  end;
 end; 
end;

procedure tdesignerselections.doadd(component: tcomponent);
begin
 add(component);
end;

procedure tdesignerselections.dosetactcomp(component: tcomponent);
begin
 factcomp:= component;
end;

{ tcomponents }

constructor tcomponents.create;
begin
 inherited create(sizeof(componentinfoty));
 fstate:= fstate + [hls_needsnull,hls_needsfinalize];
end;

destructor tcomponents.destroy;
begin
 inherited;
end;

{procedure tcomponents.freedata(var data);
begin
 with componentinfoty(data) do begin
  name:= '';
 end;
end;}

procedure tcomponents.add(comp: tcomponent);
var
 po1: pcomponentinfoty;
begin
 {$ifdef FPC} {$checkpointer off} {$endif}
 po1:= inherited add(ptruint(comp));
 {$ifdef FPC} {$checkpointer default} {$endif}
 with po1^ do begin
  instance:= comp;
  name:= comp.Name;
 end;
end;

function tcomponents.find(const value: tobject): pcomponentinfoty;
begin
 result:= pcomponentinfoty(inherited find(ptruint(value)));
end;

procedure tcomponents.swapcomponent(const old,new: tcomponent);
var
 po1: pcomponentinfoty;
begin
 po1:= find(old);
 if po1 <> nil then begin
  po1^.instance:= new;
 end;
end;

function tcomponents.getcomponents: componentarty;
var
 int1: integer;
begin
 setlength(result,count);
 for int1:= 0 to count - 1 do begin
  result[int1]:= pcomponentsdataty(next)^.data.instance;
 end;
end;

function tcomponents.next: pcomponentinfoty;
begin
 result:= @pcomponentsdataty(inherited next)^.data;
end;

function tcomponents.getcomponent(const aname: string): tcomponent;
var
 int1: integer;
 po1: pcomponentinfoty;
 str1: string;

begin
 result:= nil;
 str1:= uppercase(aname);
 if aname <> '' then begin
  for int1:= 0 to count - 1 do begin
   po1:= next;
   if uppercase(po1^.name) = str1 then begin
    result:= po1^.instance;
    break;
   end;
  end;
 end;
end;

procedure tcomponents.namechanged(const acomponent: tcomponent;
                                            const newname: string);
var
 po1: pcomponentinfoty;
begin
 po1:= find(acomponent);
 if po1 <> nil then begin
  po1^.name:= newname;
 end;
end;

function comparecomponentname(const l,r): integer;
begin
 result:= comparetext(componentnamety(l).dispname,componentnamety(r).dispname);
end;

function tcomponents.getdispnames: componentnamearty;
var
 int1: integer;
begin
 setlength(result,count);
 for int1:= 0 to count - 1 do begin
  with result[int1] do begin
   instance:= next^.instance;
   dispname:= instance.name;
  end;
 end;
 sortarray(result,sizeof(componentnamety),
                                 {$ifdef FPC}@{$endif}comparecomponentname);
end;

function tcomponents.getlistnames: stringarty;
var
 int1: integer;
begin
 setlength(result,count);
 for int1:= 0 to count - 1 do begin
  result[int1]:= next^.instance.name;
 end;
end;

{$ifdef FPC}
procedure checkreversedcomponentpos;
var
 comp1: tcomponent;
 writer1: twriter;
 reader1: treader;
 stream1: tmemorystream;
 int1: integer;
 str1: string;
begin
 comp1:= tcomponent.create(nil);
 comp1.designinfo:= 1;
 stream1:= tmemorystream.create;
 writer1:= twriter.create(stream1,256);
 twriter1(writer1).writeproperties(comp1);
 writer1.free;
 stream1.position:= 0;
 reader1:= treader.create(stream1,256);
 str1:= reader1.driver.beginproperty;
 int1:= reader1.readinteger;
 componentposreversed:= (int1 = 1) xor (str1 = 'left');
 reader1.free;
 stream1.free;
 comp1.free;
end;
{$endif}

initialization
 {$ifdef FPC}
 checkreversedcomponentpos;
 {$endif}
 aregisteredcomponents:= tcomponentclasslist.create;
finalization
 freeandnil(aregisteredcomponents);
end.
