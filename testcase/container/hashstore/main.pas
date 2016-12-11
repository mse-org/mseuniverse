unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$goto on}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,mseact,msedataedits,mseedit,mseificomp,mseificompglob,
 mseifiglob,msestatfile,msestream,msestrings,sysutils;

type
 tmainfo = class(tmainform)
   tbutton1: tbutton;
   counted: tintegeredit;
   tstatfile1: tstatfile;
   leveled: tintegeredit;
   tbutton2: tbutton;
   procedure runstoreev(const sender: TObject);
   procedure runtreeev(const sender: TObject);
  public
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,msehashstore,mselfsr,msehash;
 
type
 testdataty = record
  data: int32;
 end;
 testhashdataty = record
  header: elementhashdataty;
  data: testdataty;
 end;
 ptesthashdataty = ^testhashdataty;
 
 ttesthashstore = class(thashstore)
  protected
   function getrecordsize(): int32 override;
  public
//   constructor create();
   function add(const idents: identvecty;
                     out adata: ptesthashdataty): hashoffsetty;
   function find(const idents: identvecty): ptesthashdataty;
//   function dataoffs(const apo: ptestdataty): hashoffsetty;
   function datapo(const aoffs: hashoffsetty): ptesthashdataty;
 end;

procedure tmainfo.runstoreev(const sender: TObject);
const
 startvalue = $abcd1234;
var
 vec1: identvecty;
 c1,c2: card32;
 i1,i2: int32;
 store: ttesthashstore;
 p1: ptesthashdataty;
 o1,o2: hashoffsetty;
label
 errorlab;
begin
 writeln('**************');
 store:= ttesthashstore.create();
 c1:= startvalue;
 c2:= $ffffffff div leveled.value;
 for i1:= 0 to counted.value - 1 do begin
  vec1.high:= lfsr32(c1) div c2;
//  write('n:',i1,'h: ',vec1.high);
  for i2:= 0 to vec1.high do begin
   vec1.d[i2]:= lfsr32(c1);
//   write(' ',vec1.d[i2]);
  end;
//  writeln();
  if store.find(vec1) <> nil then begin
   writeln('*error1 found ',i1);
   goto errorlab;
  end;
  store.add(vec1,p1);
  p1^.data.data:= i1;
 end;
 writeln('** read');
 c1:= startvalue;
 for i1:= 0 to counted.value - 1 do begin
  vec1.high:= lfsr32(c1) div c2;
//  write('n:',i1,' h:',vec1.high);
  for i2:= 0 to vec1.high do begin
   vec1.d[i2]:= lfsr32(c1);
//   write(' ',vec1.d[i2]);
  end;
//  writeln();
  p1:= store.find(vec1);
  if p1 = nil then begin
   writeln('*error1 not found ',i1);
   goto errorlab;
  end
  else begin
   if p1^.data.data <> i1 then begin
    writeln('*error1 wrong data ',i1);
    goto errorlab;
   end;
  end;
 end;
 writeln('OK1 ',counted.value);
 store.clear();
 vec1.high:= 3;
 vec1.d[0]:= 1;
 vec1.d[1]:= 1;
 vec1.d[2]:= 2;
 for i1:= 0 to 5 do begin
  vec1.d[vec1.high]:= i1;
  if store.find(vec1) <> nil then begin
   writeln('*error2 found ',i1);
   goto errorlab;
  end;
  store.add(vec1,p1);
  p1^.data.data:= i1;
 end;
 for i1:= 0 to 5 do begin
  vec1.d[vec1.high]:= i1;
  p1:= store.find(vec1);
  if p1 = nil then begin
   writeln('*error2 not found ',i1);
   goto errorlab;
  end;
  if p1^.data.data <> i1 then begin
   writeln('*error2 wrong data ',i1);
   goto errorlab;
  end;
 end;
 writeln('OK2');
 for i1:= 0 to 5 do begin
  vec1.d[vec1.high]:= i1;
  vec1.d[vec1.high]:= i1;
  if store.find(vec1) = nil then begin
   writeln('*error3 not found ',i1);
   goto errorlab;
  end;
  if store.find(vec1)^.data.data <> i1 then begin
   writeln('*error3 wrong data ',i1);
   goto errorlab;
  end;
  store.delete(vec1);
  if store.find(vec1) <> nil then begin
   writeln('*error3 found ',i1);
   goto errorlab;
  end;
 end;
 if store.count <> 0 then begin
  writeln('*error3 count ',store.count);
  goto errorlab;
 end;
 writeln('OK3');
 store.clear();
 vec1.d[vec1.high]:= 123;
 o1:= store.add(vec1,p1);
 p1^.data.data:= 1;
 o2:= store.add(vec1,p1);
 p1^.data.data:= 2;
 if (store.datapo(o1)^.data.data <> 1) or 
           (store.datapo(o2)^.data.data <> 2) then begin
  writeln('*error4 wrong data');
  goto errorlab;
 end;
 writeln('OK4');
errorlab:
 store.destroy();
end;

type
 testtreehashdataty = record
  header: treeelementhashdataty;
  data: testdataty;
 end;
 ptesttreehashdataty = ^testtreehashdataty;

 ttesthashtree = class(thashtree)
  protected
   function getrecordsize(): int32 override;
   procedure dump(const aitem: ptesttreehashdataty; const adata: pointer);
   procedure inititem(const aitem: phashdataty) override;
  public
//   constructor create();
   function add(const idents: identvecty;
                  out adata: ptesttreehashdataty): hashoffsetty reintroduce;
   function find(const idents: identvecty): ptesttreehashdataty reintroduce;
   function datapo(const aoffs: hashoffsetty): ptesttreehashdataty;
 end;

procedure tmainfo.runtreeev(const sender: TObject);
const
 startvalue = $abcd1234;
var
 vec1: identvecty;
 c1,c2: card32;
 i1,i2: int32;
 store: ttesthashtree;
 p1: ptesttreehashdataty;
 o1,o2: hashoffsetty;
 str1: string;
label
 errorlab;
begin
 writeln('**************');
 store:= ttesthashtree.create();
 c1:= startvalue;
 c2:= $ffffffff div leveled.value;
 for i1:= 0 to counted.value - 1 do begin
  vec1.high:= lfsr32(c1) div c2;
//  write('n:',i1,'h: ',vec1.high);
  for i2:= 0 to vec1.high do begin
   vec1.d[i2]:= lfsr32(c1);
//   write(' ',vec1.d[i2]);
  end;
//  writeln();
  if store.find(vec1) <> nil then begin
   writeln('*error1 found ',i1);
   goto errorlab;
  end;
  store.add(vec1,p1);
  p1^.data.data:= i1;
 end;
 writeln('** read');
 c1:= startvalue;
 for i1:= 0 to counted.value - 1 do begin
  vec1.high:= lfsr32(c1) div c2;
//  write('n:',i1,' h:',vec1.high);
  for i2:= 0 to vec1.high do begin
   vec1.d[i2]:= lfsr32(c1);
//   write(' ',vec1.d[i2]);
  end;
//  writeln();
  p1:= store.find(vec1);
  if p1 = nil then begin
   writeln('*error1 not found ',i1);
   goto errorlab;
  end
  else begin
   if p1^.data.data <> i1 then begin
    writeln('*error1 wrong data ',i1);
    goto errorlab;
   end;
  end;
 end;
 writeln('OK1 ',counted.value);
 store.clear();
 vec1.high:= 3;
 vec1.d[0]:= 1;
 vec1.d[1]:= 1;
 vec1.d[2]:= 2;
 for i1:= 0 to 5 do begin
  vec1.d[vec1.high]:= i1;
  if store.find(vec1) <> nil then begin
   writeln('*error2 found ',i1);
   goto errorlab;
  end;
  store.add(vec1,p1);
  p1^.data.data:= i1;
 end;
 for i1:= 0 to 5 do begin
  vec1.d[vec1.high]:= i1;
  p1:= store.find(vec1);
  if p1 = nil then begin
   writeln('*error2 not found ',i1);
   goto errorlab;
  end;
  if p1^.data.data <> i1 then begin
   writeln('*error2 wrong data ',i1);
   goto errorlab;
  end;
 end;
 writeln('OK2');
 for i1:= 0 to 5 do begin
  vec1.d[vec1.high]:= i1;
  if store.find(vec1) = nil then begin
   writeln('*error3 not found ',i1);
   goto errorlab;
  end;
  store.delete(vec1);
  if store.find(vec1) <> nil then begin
   writeln('*error3 found ',i1);
   goto errorlab;
  end;
 end;
 if store.count <> 0 then begin
  writeln('*error3 count ',store.count);
  goto errorlab;
 end;
 writeln('OK3');
 store.clear();
 vec1.d[vec1.high]:= 123;
 o1:= store.add(vec1,p1);
 p1^.data.data:= 1;
 o2:= store.add(vec1,p1);
 p1^.data.data:= 2;
 if (store.datapo(o1)^.data.data <> 1) or 
           (store.datapo(o2)^.data.data <> 2) then begin
  writeln('*error4 wrong data');
  goto errorlab;
 end;
 writeln('OK4');
 writeln('root');
 str1:= ' ';
 store.iteratechildren(store.root(o1),
                  treehashelementiteratorprocty(@store.dump),@str1);
errorlab:
 store.destroy();
end;

{ ttesthashstore }
{
constructor ttesthashstore.create();
begin
 inherited create(sizeof(testdataty));
end;
}
function ttesthashstore.getrecordsize(): int32;
begin
 result:= sizeof(testhashdataty);
end;

function ttesthashstore.add(const idents: identvecty;
                        out adata: ptesthashdataty): hashoffsetty;
begin
 result:= inherited add(idents,pelementhashdataty(adata));
end;

function ttesthashstore.find(const idents: identvecty): ptesthashdataty;
begin
 result:= ptesthashdataty(inherited find(idents)); 
end;
{
function ttesthashstore.dataoffs(const apo: ptestdataty): hashoffsetty;
begin
 result:= getdataoffs(apo);
end;
}
function ttesthashstore.datapo(const aoffs: hashoffsetty): ptesthashdataty;
begin
 result:= ptesthashdataty(inherited datapo(aoffs));
end;

{ ttesthashtree }
{
constructor ttesthashtree.create();
begin
 inherited create(sizeof(testdataty));
end;
}
function ttesthashtree.getrecordsize(): int32;
begin
 result:= sizeof(testtreehashdataty);
end;

procedure ttesthashtree.dump(const aitem: ptesttreehashdataty;
               const adata: pointer);
begin
 writeln(pstring(adata)^,aitem^.data.data,
             ' l:',aitem^.header.data.header.element.parentlevel,
             ' r:',aitem^.header.data.header.element.refcount,
             ' c:',aitem^.header.data.header.children);

 pstring(adata)^:= pstring(adata)^+' ';
 iteratechildren(ptreeelementhashdataty(aitem),
                         treehashelementiteratorprocty(@dump),adata);
 setlength(pstring(adata)^,length(pstring(adata)^)-1);
end;

procedure ttesthashtree.inititem(const aitem: phashdataty);
begin
 inherited;
 ptesttreehashdataty(aitem)^.data.data:= -123;
end;
{
constructor ttesthashtree.create();
begin
end;
}
function ttesthashtree.add(const idents: identvecty;
                           out adata: ptesttreehashdataty): hashoffsetty;
begin
 result:= inherited add(idents,ptreeelementhashdataty(adata));
end;

function ttesthashtree.find(const idents: identvecty): ptesttreehashdataty;
begin
 result:= ptesttreehashdataty(inherited find(idents));
end;
{
function ttesthashtree.dataoffs(const apo: ptestdataty): hashoffsetty;
begin
 result:= getdataoffs(apo);
end;
}
function ttesthashtree.datapo(const aoffs: hashoffsetty): ptesttreehashdataty;
begin
 result:= ptesttreehashdataty(inherited datapo(aoffs));
end;

end.
