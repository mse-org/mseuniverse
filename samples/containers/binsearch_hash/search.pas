program search;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef mswindows}{$apptype console}{$endif}
uses
 {$ifdef unix}cthreads,{$endif}
 msearrayutils,msehash,sysutils,msedate;

type
 keyty = record
  keyart: string;
  key: string;
 end;
 
 s_rec = record
  key: keyty; //first!
  Beschreibung: string;
  test: int32;
 end;
 ps_rec = ^s_rec;
 
 s_rechashty = record
  header: hashheaderty;
  data: s_rec;
 end;
 ps_rechashty = ^s_rechashty;
 
 thashlist = class(thashdatalist)
  protected
   function hashkey(const akey): hashvaluety override;
   function checkkey(const akey;
                  const aitem: phashdataty): boolean override;
   function getrecordsize(): int32 override;
   procedure inititem(const aitem: phashdataty) override;
   procedure finalizeitem(const aitem: phashdataty) override;
  public
   constructor create();
   procedure add(const aitem: s_rec);
   function find(const akey: keyty; out aitem: ps_rec): boolean;
                              //true if found
 end;


function comparesort(const l,r): int32;
begin
 result:= comparestr(s_rec(l).key.keyart,s_rec(r).key.keyart);
 if result = 0 then begin
  result:= comparestr(s_rec(l).key.key,s_rec(r).key.key);
 end;
end;

function comparefind(const l,r): int32;
begin
 result:= comparestr(keyty(l).keyart,s_rec(r).key.keyart);
 if result = 0 then begin
  result:= comparestr(keyty(l).key,s_rec(r).key.key);
 end;
end;


{ thashlist }

constructor thashlist.create();
begin
 fstate:= [hls_needsinit,hls_needsfinalize]; 
                        //because of dynamic strings in data record
 inherited;
end;

function thashlist.getrecordsize(): int32;
begin
 result:= sizeof(s_rechashty);
end;

procedure thashlist.inititem(const aitem: phashdataty);
begin
 initialize(ps_rechashty(aitem)^.data);
end;

procedure thashlist.finalizeitem(const aitem: phashdataty);
begin
 finalize(ps_rechashty(aitem)^.data);
end;

procedure thashlist.add(const aitem: s_rec);
begin
 ps_rechashty(internaladd(aitem))^.data:= aitem;
end;

function thashlist.find(const akey: keyty; out aitem: ps_rec): boolean;
begin
 aitem:= pointer(internalfind(akey)); //returns phashdataty
 result:= aitem <> nil;
 if result then begin
  aitem:= @ps_rechashty(aitem)^.data; //get s_rec address
 end;
end;

function thashlist.hashkey(const akey): hashvaluety;
begin
 with keyty(akey) do begin
  result:= stringhash(keyart) + stringhash(key);
 end;
end;

function thashlist.checkkey(const akey; const aitem: phashdataty): boolean;
begin
 with keyty(akey) do begin
  result:= (keyart = ps_rechashty(aitem)^.data.key.keyart) and
                                  (key = ps_rechashty(aitem)^.data.key.key);
 end;
end;

const
 itemcount = 1000000;
 loopcount = 10;
 ms = 24*60*60*1000;
var
 inputdata,binsearchdata: array of s_rec;
 i1,i2,i3: int32;
 t1: tdatetime;
 hashlist: thashlist;
 key: s_rec;
 p1: ps_rec;
 
begin
 setlength(inputdata,itemcount);
 for i1:= 0 to high(inputdata) do begin
  with inputdata[i1] do begin
   key.keyart:= inttostr(random(1000));
   key.key:= inttostr(random(100000000000))+'_'+inttostr(i1);
   test:= i1; //for correct item check
  end;
 end;
 setlength(binsearchdata,length(inputdata));
 for i1:= 0 to high(binsearchdata) do begin
  binsearchdata[i1]:= inputdata[i1]; //deep data copy
 end;
 t1:= nowutc();
 for i1:= 0 to loopcount-1 do begin
  sortarray(binsearchdata,sizeof(s_rec),@comparesort);
 end;
 t1:= nowutc() - t1;
 writeln('Binary search ',itemcount,' items');
 writeln('Sort time: ',floattostrf((t1/loopcount)*ms,fffixed,0,3),'ms');
 t1:= nowutc();
 for i1:= 0 to loopcount-1 do begin
  for i2:= 0 to high(inputdata) do begin
   if not findarrayitem(inputdata[i2].key,binsearchdata,sizeof(s_rec),
                                                  @comparefind,i3) then begin
    writeln('*** Item not found');
    exit;
   end;
   if binsearchdata[i3].test <> i2 then begin
    writeln('*** Wrong item found');
    exit;
   end;
  end;
 end;
 t1:= nowutc() - t1;
 writeln('Find time: ',floattostrf((t1/loopcount)*ms,fffixed,0,3),'ms');

 hashlist:= thashlist.create();
 try
  writeln();
  writeln('Hash search ',itemcount,' items');
  hashlist.capacity:= itemcount;
  t1:= nowutc();
  for i1:= 0 to high(inputdata) do begin
   hashlist.add(inputdata[i1]);
  end;
  t1:= nowutc() - t1;
  writeln('Load time: ',floattostrf((t1)*ms,fffixed,0,3),'ms');
  t1:= nowutc();
  for i1:= 0 to loopcount-1 do begin
   for i2:= 0 to high(inputdata) do begin
    if not hashlist.find(inputdata[i2].key,p1) then begin
     writeln('*** Item not found');
     exit;
    end;
    if p1^.test <> i2 then begin
     writeln('*** Wrong item found');
     exit;
    end;
   end;
  end;
  t1:= nowutc() - t1;
  writeln('Find time: ',floattostrf((t1/loopcount)*ms,fffixed,0,3),'ms');
 finally
  hashlist.destroy();
 end;
end.
