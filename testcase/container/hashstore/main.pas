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
   procedure runev(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,msehashstore,mselfsr;
 
type
 testdataty = record
  data: int32;
 end;
 ptestdataty = ^testdataty;
 
 ttesthashstore = class(thashstore)
  public
   constructor create();
   function add(const idents: identvecty): ptestdataty;
   function find(const idents: identvecty): ptestdataty;
 end;
 
procedure tmainfo.runev(const sender: TObject);
const
 startvalue = $abcd1234;
var
 vec1: identvecty;
 c1,c2: card32;
 i1,i2: int32;
 store: ttesthashstore;
 p1: ptestdataty;
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
  with store.add(vec1)^ do begin
   data:= i1;
  end;
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
   if p1^.data <> i1 then begin
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
  with store.add(vec1)^ do begin
   data:= i1;
  end;
 end;
 for i1:= 0 to 5 do begin
  vec1.d[vec1.high]:= i1;
  p1:= store.find(vec1);
  if p1 = nil then begin
   writeln('*error2 not found ',i1);
   goto errorlab;
  end;
  if p1^.data <> i1 then begin
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
errorlab:
 store.destroy();
end;

{ ttesthashstore }

constructor ttesthashstore.create();
begin
 inherited create(sizeof(testdataty));
end;

function ttesthashstore.add(const idents: identvecty): ptestdataty;
begin
 result:= ptestdataty(inherited add(idents));
end;

function ttesthashstore.find(const idents: identvecty): ptestdataty;
begin
 result:= ptestdataty(inherited find(idents)); 
end;

end.
