
// Linux only because of low now() granularity on Windows!

unit main;
{$ifdef FPC}{$mode delphi}{$h+}{$endif}
interface
uses
 msegui,mseforms,mseguiglob,msewidgets,mseglob,msestat,msestatfile,
 msestrings,msetypes,msedispwidgets,msegrids,msegraphedits,msesimplewidgets,
 msedataedits;
 
type
 tmainfo = class(tmseform)
   grid: tstringgrid;
   tstatfile1: tstatfile;
   tbutton2: tbutton;
   sodi: trealdisp;
   sosumdi: trealdisp;
   sumdi: trealdisp;
   ndi: tintegerdisp;
   modeed: tenumtypeedit;
   di: trealdisp;
   tbutton1: tbutton;
   fpsodi: trealdisp;
   fpsosumdi: trealdisp;
   fpsumdi: trealdisp;
   fpdi: trealdisp;
   ned: tintegeredit;
   tbutton3: tbutton;
   pcharsumdi: trealdisp;
   sopcharsumdi: trealdisp;
   sopchardi: trealdisp;
   pchardi: trealdisp;
   procedure runexe(const sender: TObject);
   procedure initexe(const sender: tenumtypeedit);
   procedure resetexe(const sender: TObject);
   procedure datentexe(const sender: TObject);
   procedure copyexe(const sender: TObject);
  private
 end;

var
 mainfo: tmainfo;

implementation
uses
 main_mfm,msenoise,msearrayutils,msedate,fphashlistsort;

procedure tmainfo.runexe(const sender: TObject);
const
 strlen = $20;
var
 ti1: tdatetime;
 ar1: stringarty;
 ar2: msestringarty;
 ar3: array of string[strlen+1];
 ar4,ar5: tsortarray;
 int1,int2,int3: integer;
 po1: pchar;
 ch1: char;
 compfunc: tcomparefunc;
 arlen: integer;
begin
 arlen:= ned.value;
 setlength(ar1,arlen);
 for int1:= 0 to high(ar1) do begin
  int3:= mwcnoise and (strlen-1);
  setlength(ar1[int1],int3);
  po1:= pointer(ar1[int1]);
  for int2:= 0 to int3-1 do begin
   repeat
    ch1:= char(mwcnoise() and $7f);
   until (ch1 >= #32) and (ch1 < #127);
   po1[int2]:= ch1;
  end;
 end;
 setlength(ar3,arlen);
 setlength(ar4,arlen);
 for int1:= 0 to high(ar3) do begin
  ar3[int1]:= ar1[int1];
  ar3[int1][length(ar3[int1])+1]:= #0;
  ar4[int1]:= @ar3[int1];
 end;
 ar5:= copy(ar4);
 for int1:= 0 to high(ar5) do begin
  inc(pchar(pointer(ar5[int1])));
 end;
 ti1:= nowutc;                                        //MSEgui ansistring first
 sortarray(ar1,stringsortmodety(modeed.value));
 ti1:= (nowutc-ti1)*3600*24;
 di.value:= ti1;
 sumdi.value:= sumdi.value*ndi.value+ti1;
 ndi.value:= ndi.value+1;
 sumdi.value:= sumdi.value/ndi.value;

 ti1:= nowutc;                                        //MSEgui ansistring second
 sortarray(ar1,stringsortmodety(modeed.value));
 ti1:= (nowutc-ti1)*3600*24;
 sodi.value:= ti1;
 sosumdi.value:= sosumdi.value*(ndi.value-1)+ti1;
 sosumdi.value:= sosumdi.value/ndi.value;

 setlength(ar2,length(ar1));
 for int1:= 0 to high(ar1) do begin
  ar2[int1]:= ar1[int1];
 end;
 grid[0].datalist.asarray:= ar2;
                                                    
 ti1:= nowutc;                                        //MSEgui pchar first 
 sortarray(stringarty(ar5),stringsortmodety(modeed.value));
 ti1:= (nowutc-ti1)*3600*24;
 pchardi.value:= ti1;
 pcharsumdi.value:= pcharsumdi.value*(ndi.value-1)+ti1;
 pcharsumdi.value:= pcharsumdi.value/ndi.value;

 ti1:= nowutc;                                        //MSEgui pchar second
 sortarray(stringarty(ar5),stringsortmodety(modeed.value));
 ti1:= (nowutc-ti1)*3600*24;
 sopchardi.value:= ti1;
 sopcharsumdi.value:= sopcharsumdi.value*(ndi.value-1)+ti1;
 sopcharsumdi.value:= sopcharsumdi.value/ndi.value;

 setlength(ar2,length(ar1));
 for int1:= 0 to high(ar1) do begin
  ar2[int1]:= msestring(pchar(pointer(ar5[int1])));
 end;
 grid[1].datalist.asarray:= ar2;
 
 case stringsortmodety(modeed.value) of
  sms_upiascii: begin
   compfunc:= @CompareShortStringAnsiCharInSensitive;
  end;
  else begin
   compfunc:= @CompareShortStringAnsiCharSensitive;
  end;
 end;
 
 ti1:= nowutc;                                        //fp first
 quicksorthashlist(ar4,compfunc);
 ti1:= (nowutc-ti1)*3600*24;
 fpdi.value:= ti1;
 fpsumdi.value:= fpsumdi.value*(ndi.value-1)+ti1;
 fpsumdi.value:= fpsumdi.value/ndi.value;

 ti1:= nowutc;                                        //fp second
 quicksorthashlist(ar4,compfunc);
 ti1:= (nowutc-ti1)*3600*24;
 fpsodi.value:= ti1;
 fpsosumdi.value:= fpsosumdi.value*(ndi.value-1)+ti1;
 fpsosumdi.value:= fpsosumdi.value/ndi.value;

 setlength(ar2,length(ar4));
 for int1:= 0 to high(ar4) do begin
  ar2[int1]:= ar4[int1]^;
 end;
 grid[2].datalist.asarray:= ar2;
 copyexe(nil);
end;

procedure tmainfo.initexe(const sender: tenumtypeedit);
begin
 sender.typeinfopo:= typeinfo(stringsortmodety);
end;

procedure tmainfo.resetexe(const sender: TObject);
begin
 ndi.value:= 0;
 sumdi.value:= 0;
 sosumdi.value:= 0;
 pcharsumdi.value:= 0;
 sopcharsumdi.value:= 0;
 fpsumdi.value:= 0;
 fpsosumdi.value:= 0;
end;

procedure tmainfo.datentexe(const sender: TObject);
begin
 resetexe(nil);
end;

procedure tmainfo.copyexe(const sender: TObject);
begin
 copytoclipboard( 
'Mode: '+modeed.disptext+' Runs: '+ndi.disptext+lineend+
'           MSEgui first MSEgui second MSEgui first MSEgui second fp first    fp second'+lineend+
'           ansistring   ansistring    pchar        pchar         shortstring shortstring'+lineend+
'N: '+fitstring(ned.disptext,7,sp_right)+' '+
sumdi.disptext+'    '+sosumdi.disptext+'     '+pcharsumdi.disptext+'    '+sopcharsumdi.disptext+'     '+
fpsumdi.disptext+'   '+fpsosumdi.disptext);
 
end;

end.