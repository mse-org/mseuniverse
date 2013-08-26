unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms, msestrings,msetypes,
 msegrids,msewidgetgrid,msestream,msewidgets,sysutils,msedispwidgets,
 mseeditglob,msesyntaxedit,msetextedit,msesimplewidgets,msebitmap,msefiledialog,
 mselistbrowser,msesys,msegraphedits,msetoolbar,mseact,mseactions,msedataedits,
 mseedit,msedragglob,msescrollbar,msestatfile,msetabs, utabeditorform;
 
 
type
 tmainfo = class(tmainform)
   ttoolbar2: ttoolbar;
//////////   
   ttabwidget1: ttabwidget;
   tbutton1: tbutton;
   procedure on_btnsi_execute(const sender: TObject);
   procedure charcount(aStroka : msestring);   
   procedure charcount1(aStroka : msestring);
//////////   
   procedure on_tab_change(const sender: TObject);
   procedure on_mainfrm_show(const sender: TObject);
 public
   FileNameParam : msestring; 
 end;
var
 mainfo: tmainfo;
 
 
implementation

uses
 main_mfm, msegridsglob, msekeyboard, ufrmcharinfo, Classes, udmaction;
 


/////////////// Need change (Same error) 
procedure tmainfo.charcount(aStroka : msestring);
var
  i, l, n, zz, zzz: Integer;
const
  WordDelim = ' !,.?:;%*"“”-+<>&$#~|=\/1234567890';  
begin
  l := 0;
  n := 0;
  zz := 0;
  zzz := 0;


  zzz := length(aStroka);

  For i := 1 to Length(aStroka) do begin
    If   aStroka[i] <> ' ' then zz := zz+1;
    if msePosEx(aStroka[i], WordDelim) = 0 then begin
      l := l + 1;
    end else begin
        If l <> 0 then begin
          l := 0;
          n := n + 1;
        end;
    end;
  end;

  With ufrmcharinfofo do begin
    tintegeredit2[0] := n;
    tintegeredit2[1] := zzz;    
    tintegeredit2[2] := zz;    
  end;
end;

procedure tmainfo.charcount1(aStroka : msestring);
var
  i, l, n, zz, zzz: Integer;
const
  WordDelim = ' !,.?:;%*"“”-+<>&$#~|=\/1234567890';  
begin
  l := 0;
  n := 0;
  zz := 0;
  zzz := 0;

  zzz := length(aStroka);
  For i := 1 to Length(aStroka) do begin
    If   aStroka[i] <> ' ' then zz := zz+1;
    if msePosEx(aStroka[i], WordDelim) = 0 then begin
      l := l + 1;
    end else begin
        If l <> 0 then begin
          l := 0;
          n := n + 1;
        end;
    end;
  end;
  With ufrmcharinfofo do begin
    tintegeredit1[0] := n;
    tintegeredit1[1] := zzz;    
    tintegeredit1[2] := zz;    
  end;
end;


procedure tmainfo.on_btnsi_execute(const sender: TObject);
var
  myList : TStrings;
  z : integer;
  stroka, selstroka : msestring;
begin
{  if Length(simpletext[0]) = 0 then exit;
  if not Assigned(ufrmcharinfofo) then
    application.createform(tufrmcharinfofo,ufrmcharinfofo)
    else ufrmcharinfofo.Activate; 

  for z := 0 to mygrid.rowcount -1 do begin
    stroka := stroka + simpletext[z] ;
  end;  
  if (simpletext.hasselection) and (length(simpletext.selectedtext) > 0) then charcount1(simpletext.selectedtext);
  charcount(stroka);  
}
end;

procedure tmainfo.on_tab_change(const sender: TObject);
begin
//
end;

procedure tmainfo.on_mainfrm_show(const sender: TObject);
begin

end;

end.
