unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msesplitter,msesimplewidgets,
 msewidgets,msedataedits,mseedit,msestrings,msetypes,msegrids;

type
 tmainfo = class(tmseform)
   tgroupbox1: tgroupbox;
   b8: tbutton;
   b9: tbutton;
   b7: tbutton;
   b4: tbutton;
   b5: tbutton;
   b6: tbutton;
   b1: tbutton;
   b2: tbutton;
   b3: tbutton;
   b0: tbutton;
   b000: tbutton;
   bperiod: tbutton;
   bplus: tbutton;
   bminus: tbutton;
   bmultiply: tbutton;
   bdiv: tbutton;
   tbutton17: tbutton;
   bpercent: tbutton;
   tbutton19: tbutton;
   bequal: tbutton;
   tbutton21: tbutton;
   tbutton22: tbutton;
   tbutton23: tbutton;
   tbutton24: tbutton;
   tgroupbox2: tgroupbox;
   ldisplay: tlabel;
   paper: tstringgrid;
   procedure donumber(const sender: TObject);
   procedure dototal(const sender: TObject);
   procedure setdefaults(const sender: TObject);
   procedure doclear(const sender: TObject);
   procedure dooperation(const sender: TObject);
   procedure dochangesign(const sender: TObject);
   procedure doreset(const sender: TObject);
   procedure doclearpaper(const sender: TObject);
   procedure dopercent(const sender: TObject);
   procedure doterminate(const sender: TObject);
   procedure dosqrt(const sender: TObject);
   procedure dokey(const sender: twidget; var info: keyeventinfoty);
 private
   tmpbuf : string;
   operation : string;
   decimals : integer;
   number1, total : currency;
   error : boolean;
   procedure updatedisplay(number : currency);
   procedure finishoperation;
   procedure printoperation(number : currency; op : string);
   procedure displayerror;
   function cround(number : currency; digits: integer) : currency;
   
 end;
var
 mainfo: tmainfo;
const
 maxdigits = 15;
 errormsg = '*** ERROR ***';
implementation
uses
 main_mfm, sysutils, math, msekeyboard, msesys;
procedure tmainfo.donumber(const sender: TObject);
var
 tmp : string;
begin
 try
  tmp := tmpbuf + tbutton(sender).caption;
  tmp := leftstr(tmp, maxdigits);
  number1 := strtofloat(tmp);
  number1 := cround(number1, 2);
  tmpbuf := tmp;
  updatedisplay(number1);
 except
  // wrong number
 end;
end;

procedure tmainfo.dototal(const sender: TObject);
var
 s : string;
begin
 dooperation(bperiod);
 if error then begin
  doreset(nil); 
  ldisplay.caption := errormsg;
 end else begin
  paper.appendrow('------------------------');
  s := FloatToStrf(total,ffNumber,maxdigits,decimals);
  fmtstr(s, '%s %22s', ['=', s]);
  paper.appendrow(s);
  paper.appendrow;
  paper.frame.sbvert.value:= 1;
  finishoperation;
  operation := '';
  s := ldisplay.caption;
  doreset(nil);
  ldisplay.caption := s;
 end;
end;

procedure tmainfo.updatedisplay(number : currency);
var
 s : string;
begin
 s := FloatToStrf(number,ffNumber,maxdigits,decimals);
 ldisplay.caption := s;
end;

procedure tmainfo.setdefaults(const sender: TObject);
begin
 doreset(nil);
 tbutton19.caption := #8730; // sqrt simbol
 bperiod.caption:= defaultformatsettingsmse.decimalseparator;
end;

function tmainfo.cround(number: currency; digits: integer): currency;
var
 d, i : integer;
begin
 d := 1;
 for i := 1 to digits do begin
  d := d * 10;
 end;
 result := round(number*d)/d;
end;

procedure tmainfo.doclear(const sender: TObject);
begin
 tmpbuf := '';
 number1 := 0.0;
 updatedisplay(total);
end;

procedure tmainfo.dooperation(const sender: TObject);
var
 op : string;
begin
 op := tbutton(sender).caption;
 try
 printoperation(number1, operation);
  if operation = ' ' then
  begin
   total := number1;
  end else if operation = '+' then
  begin
   total += number1;
  end else if operation = '-' then
  begin
   total -= number1;
  end else if operation = 'x' then
  begin
   total *= number1;
  end else if operation = '/' then
  begin
   total /= number1;
  end;
  finishoperation;
  operation := op;
 except
  doreset(nil);
  displayerror;
 end;
end;

procedure tmainfo.dochangesign(const sender: TObject);
begin
 number1 := -number1;
 tmpbuf := floattostr(number1);
 updatedisplay(number1);
end;

procedure tmainfo.finishoperation;
begin
 number1 := 0;
 tmpbuf := '';
 updatedisplay(total);
end;

procedure tmainfo.doreset(const sender: TObject);
begin
 number1 := 0.0;
 total := 0;
 decimals := 2;
 updatedisplay(number1);
 operation := ' ';
 tmpbuf := '';
 error := false;
end;

procedure tmainfo.doclearpaper(const sender: TObject);
begin
 paper.rowcount := 0;
end;

procedure tmainfo.dopercent(const sender: TObject);
begin
 number1 /= 100.0;
 number1 := cround(number1, 2);
 tmpbuf := floattostr(number1);
 updatedisplay(number1);
end;

procedure tmainfo.doterminate(const sender: TObject);
begin
 application.terminated := true;
end;

procedure tmainfo.printoperation(number: currency; op: string);
var
 s, s1 : string;
begin
 s1 := FloatToStrf(number,ffNumber,maxdigits,decimals);
 fmtstr(s, '%s %22s', [op, s1]);
 paper.appendrow(s);
 paper.frame.sbvert.value:= 1;
end;

procedure tmainfo.dosqrt(const sender: TObject);
begin
 try
  number1 := sqrt(number1);
  number1 := cround(number1, 2);
  tmpbuf := floattostr(number1);
  updatedisplay(number1);
 except
  doreset(nil);
  displayerror;
 end;
end;

procedure tmainfo.displayerror;
begin
  ldisplay.caption := errormsg;
  paper.appendrow(errormsg);
  paper.appendrow;
  paper.frame.sbvert.value:= 1;
end;

procedure tmainfo.dokey(const sender: twidget; var info: keyeventinfoty);
begin
 case info.key of
  key_Period : donumber(bperiod);
  key_comma : donumber(bperiod);
  key_0  : donumber(b0);
  key_1  : donumber(b1);
  key_2  : donumber(b2);
  key_3  : donumber(b3);
  key_4  : donumber(b4);
  key_5  : donumber(b5);
  key_6  : donumber(b6);
  key_7  : donumber(b7);
  key_8  : donumber(b8);
  key_9  : donumber(b9);
  key_o  : donumber(b000);
  key_minus    : dooperation(bminus);
  key_plus     : dooperation(bplus);
  key_x        : dooperation(bmultiply);
  key_multiply : dooperation(bmultiply);
  key_asterisk : dooperation(bmultiply);
  key_slash    : dooperation(bdiv);
  key_Enter    : dototal(bequal);
  key_Return   : dototal(bequal);
  key_equal    : dototal(bequal);
  key_percent  : dopercent(bpercent);
  key_c        : doclear(nil); // CE
  key_Escape   : doreset(nil); // AC
  key_A        : doreset(nil); // AC
 end;
end;

end.
