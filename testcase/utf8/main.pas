unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,
 msestatfile,msestream,msestrings,sysutils,msedispwidgets,mserichstring,
 msegrids,msewidgetgrid,msegraphedits,msescrollbar,mseact;

type
 tmainfo = class(tmainform)
   tbutton1: tbutton;
   ed: tstringedit;
   di: tstringdisp;
   tintegeredit1: tintegeredit;
   hdi1: tintegerdisp;
   hdi2: tintegerdisp;
   hdi3: tintegerdisp;
   errdi: tstringdisp;
   h8di: tbytestringdisp;
   h16di: tintegerdisp;
   validisp: tstringdisp;
   storeedexe: tstringedit;
   storedi: tstringdisp;
   storedi2: tstringdisp;
   tstatfile1: tstatfile;
   thexstringedit1: thexstringedit;
   list: twidgetgrid;
   listed: tintegeredit;
   edtest: tstringedit;
   storeinvalided: tbooleanedit;
   storedihex: thexstringedit;
   storedihex1: thexstringedit;
   editdihex: thexstringedit;
   procedure exe(const sender: TObject);
   procedure setva(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure sethex(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
   procedure storeed(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure hexset(const sender: TObject; var avalue: AnsiString;
                   var accept: Boolean);
   procedure listdatent(const sender: TObject);
   procedure storeinvalidsetev(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
  private
   futfoptions: utfoptionsty;
   procedure dodisp();
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;

procedure tmainfo.exe(const sender: TObject);
var
 i1: int32;
 ucs4,ucs4b: ucs4string;
 str1: utf8string;
 mstr1: msestring;

begin
 errdi.value:= '';
 setlength(ucs4,2);
 for i1:= 0 to $10ffff do begin
  if ((i1 < $d800) or (i1 > $dfff)) and 
                             (i1 <> $fffe) and (i1 <> $ffff) then begin
   ucs4[0]:= i1;
   str1:= utf8encode(ucs4stringtounicodestring(ucs4));
   if not checkutf8(str1) and (i1 <> 0) then begin
    errdi.value:= '***check ERROR***';
    exit;
   end;    
   mstr1:= utf8tostring(pchar(str1),length(str1));
   ucs4b:= unicodestringtoucs4string(mstr1);
   if (length(ucs4b) <> 2) or (ucs4b[0] <> i1) then begin
    errdi.value:= '***utf8tostring ERROR***';
    exit;
   end;
   mstr1:= ucs4stringtounicodestring(ucs4);
   str1:= stringtoutf8(mstr1);
   ucs4b:= unicodestringtoucs4string(utf8decode(str1));
   if (length(ucs4b) <> 2) or (ucs4b[0] <> i1) then begin
    errdi.value:= '***stringtoutf8error ERROR***';
    exit;
   end;
  end;
 end;
 errdi.value:= 'OK';
end;

procedure tmainfo.setva(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
var
 str1: utf8string;
begin
 str1:= utf8encode(avalue);
 di.value:= utf8tostring(pchar(str1),length(str1));
end;

procedure tmainfo.dodisp();
begin
 if length(di.value) > 0 then begin
  hdi1.text:= '';
  hdi1.value:= ord(di.value[1]);
  hdi3.value:= hdi1.value
 end
 else begin
  hdi1.text:= ' ';
 end;
 if length(di.value) > 1 then begin
  hdi2.text:= '';
  hdi2.value:= ord(di.value[2]);
  hdi3.value:= ((card32(hdi1.value)-$d800) shl 10) +
                               (card32(hdi2.value)-$dc00)+ $10000;
 end
 else begin
  hdi2.text:= ' ';
 end;
end;

procedure tmainfo.sethex(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
var
 ucs4: ucs4string;
 str1: utf8string;
 mstr1: unicodestring;
begin
 setlength(ucs4,2);
 ucs4[0]:= avalue;
 str1:= utf8encode(ucs4stringtounicodestring(ucs4));
 if checkutf8(str1) then begin
  validisp.value:= 'valid';
 end
 else begin
  validisp.value:= 'invalid';
 end;
 di.value:= utf8tostring(pchar(str1),length(str1));
 dodisp();
 mstr1:= ucs4stringtounicodestring(ucs4);
 h8di.value:= stringtoutf8(mstr1);
 ucs4:= unicodestringtoucs4string(utf8decode(h8di.value));
 h16di.value:= ucs4[0];
end;

procedure tmainfo.storeed(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
var
 str1,str2: string;
begin
 str1:= stringtolatin1(avalue);
 storedi.value:= utf8tostringansi(str1,[uto_storeinvalid]);
 str2:= stringtoutf8ansi(storedi.value,[uto_storeinvalid]);
 storedi2.value:= latin1tostring(str2);
 storedihex.value:= str1;
 storedihex1.value:= str2;
end;

procedure tmainfo.hexset(const sender: TObject; var avalue: AnsiString;
               var accept: Boolean);
var
 ucs4: ucs4string;
begin
 di.value:= utf8tostringansi(avalue,futfoptions);
 dodisp();
 setlength(ucs4,2);
 ucs4[0]:= hdi3.value;
 di.value:= ucs4stringtounicodestring(ucs4);
end;

procedure tmainfo.listdatent(const sender: TObject);
var
 ar1: ucs4string;
 i1: int32;
begin
 setlength(ar1,list.rowcount+1);
 for i1:= 0 to list.datarowhigh do begin
  ar1[i1]:= listed[i1];
 end;
 edtest.value:= ucs4stringtounicodestring(ar1);
 editdihex.value:= stringtoutf8ansi(edtest.value,futfoptions);
end;

procedure tmainfo.storeinvalidsetev(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 if avalue then begin
  include(futfoptions,uto_storeinvalid);
 end
 else begin
  exclude(futfoptions,uto_storeinvalid);
 end;
end;

end.
