unit keyboard;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
{$LONGSTRINGS OFF}


interface

uses
 msegui,mseact,mseclasses,mseforms,mseevent,msegraphics,msegraphutils,msemenus,
 mseglob,msesimplewidgets,msewidgets,msedispwidgets,msestrings,msetypes,SysUtils;


CONST
  SpecialKeys = 19;

type
 tKeyBoardfo = class (tmseform)
   Eingabefeld:  tgroupbox;

   tbuttonDach:  tbutton;
   tbutton1:     tbutton;
   tbutton2:     tbutton;
   tbutton3:     tbutton;
   tbutton4:     tbutton;
   tbutton5:     tbutton;
   tbutton6:     tbutton;
   tbutton7:     tbutton;
   tbutton8:     tbutton;
   tbutton9:     tbutton;
   tbutton0:     tbutton;
   tbuttonSS:    tbutton;
   tbuttonAigue: tbutton;

   TabKey:       tstockglyphbutton;
   tbuttonQ:     tbutton;
   tbuttonW:     tbutton;
   tbuttonE:     tbutton;
   tbuttonR:     tbutton;
   tbuttonT:     tbutton;
   tbuttonZ:     tbutton;
   tbuttonU:     tbutton;
   tbuttonI:     tbutton;
   tbuttonO:     tbutton;
   tbuttonP:     tbutton;
   tbuttonUe:    tbutton;
   tbuttonPlus:  tbutton;

   CapsLock:     tstockglyphbutton;
   CapsOn:       tstockglyphbutton;
   tbuttonA:     tbutton;
   tbuttonS:     tbutton;
   tbuttonD:     tbutton;
   tbuttonF:     tbutton;
   tbuttonG:     tbutton;
   tbuttonH:     tbutton;
   tbuttonJ:     tbutton;
   tbuttonK:     tbutton;
   tbuttonL:     tbutton;
   tbuttonOe:    tbutton;
   tbuttonAe:    tbutton;
   tbuttonSharp: tbutton;

   ShiftLeft:    tstockglyphbutton;
   tbuttonLess:  tbutton;
   tbuttonY:     tbutton;
   tbuttonX:     tbutton;
   tbuttonC:     tbutton;
   tbuttonV:     tbutton;
   tbuttonB:     tbutton;
   tbuttonN:     tbutton;
   tbuttonM:     tbutton;
   tbuttonKomma: tbutton;
   tbuttonPunkt: tbutton;
   tbuttonMinus: tbutton;
   ShiftRight:   tstockglyphbutton;

   SpaceKey:     tbutton;
   ClearKey:     tbutton;
   EnterKey:     tbutton;
   Abbruch:      tstockglyphbutton;
   DelKey:       tstockglyphbutton;

   Eingabetext:  tstringdisp;

   convex: tfacecomp;
   concave: tfacecomp;
   procedure PadKey   (const sender: TObject);
   procedure Clear    (const sender: TObject);
   procedure Delete   (const sender: TObject);
   procedure ShiftKey (const sender: TObject);
   procedure LockKey  (const sender: TObject);
   procedure NewBoard (const sender: TObject);
   FUNCTION  Execute  (const sender: TObject): boolean;
   FUNCTION  Execute  (const sender: TObject; CONST X, Y: integer): boolean; OVERLOAD;

 Private
   SpecialKey: ARRAY [1..SpecialKeys] OF tButton;
   shift,
   lock:       boolean;

   procedure ShiftKeys (shifted: boolean);
   procedure SetText   (Val: msestring);
   FUNCTION  GetText:  msestring;

 Published
   PROPERTY shifted: boolean READ shift WRITE ShiftKeys;
   PROPERTY Text: msestring READ GetText WRITE SetText;
 end;


implementation


uses
 KeyBoard_mfm;


CONST
  KeyShift: ARRAY [boolean, 1..SpecialKeys] OF msechar =
    (('1','2','3','4','5','6','7','8','9','0',#223,#180,'^','+','#','<',')','.','-'),
     ('!','"',#167,'$','%','&','/','(',')','=','?','`',#176,'*','''','>',';',':','_'));


procedure tKeyBoardfo.ShiftKeys (shifted: boolean);
 VAR
   i: integer;
   c: msechar;

 begin
   shift:= shifted;
   FOR i:= 1 TO SpecialKeys DO BEGIN
     c:= KeyShift [shifted, i];
     IF c <> '&'
       THEN SpecialKey [i].Caption:= c
       ELSE SpecialKey [i].Caption:= c+ c;
   END (* FOR i:= 1 TO SpecialKeys *);
 end;


procedure tKeyBoardfo.SetText (Val: msestring);
 begin
   Eingabetext.Value:= Val;
 end;


FUNCTION tKeyBoardfo.GetText: msestring;
 begin
   Result:= Eingabetext.Value;
 end;


procedure tKeyBoardfo.PadKey (const sender: TObject);
 VAR
   c: msechar;

 begin
   c:= tbutton (Sender).Caption [1];
   IF NOT (shift XOR lock)
     THEN
       CASE c OF
         #196: c:= #228;
         #214: c:= #246;
         #220: c:= #252;
         ELSE c:= widelowerCase (c)[1];
       END (* CASE c *);

   WITH Eingabetext DO Value:= Value+ c;
   shifted:= false;
 end;

procedure tKeyBoardfo.Clear (const sender: TObject);
 begin
   Eingabetext.Value:= '';
 end;

procedure tKeyBoardfo.Delete (const sender: TObject);
 begin
   WITH Eingabetext DO Value:= Copy (Value, 1, pred (Length (Value)));
 end;

procedure tKeyBoardfo.ShiftKey (const sender: TObject);
 begin
   shifted:= NOT shifted;
 end;

procedure tKeyBoardfo.LockKey (const sender: TObject);
 begin
   lock:= NOT lock;
   WITH CapsOn DO
     IF lock
       THEN state:= state- [as_invisible]
       ELSE state:= state+ [as_invisible];
 end;

procedure tKeyBoardfo.NewBoard (const sender: TObject);
 begin
   SpecialKey  [1]:= tbutton1;     SpecialKey  [2]:= tbutton2;
   SpecialKey  [3]:= tbutton3;     SpecialKey  [4]:= tbutton4;
   SpecialKey  [5]:= tbutton5;     SpecialKey  [6]:= tbutton6;
   SpecialKey  [7]:= tbutton7;     SpecialKey  [8]:= tbutton8;
   SpecialKey  [9]:= tbutton9;     SpecialKey [10]:= tbutton0;
   SpecialKey [11]:= tbuttonSS;    SpecialKey [12]:= tbuttonAigue;
   SpecialKey [13]:= tbuttonDach;  SpecialKey [14]:= tbuttonPlus;
   SpecialKey [15]:= tbuttonSharp; SpecialKey [16]:= tbuttonLess;
   SpecialKey [17]:= tbuttonKomma; SpecialKey [18]:= tbuttonPunkt;
   SpecialKey [19]:= tbuttonMinus; Eingabetext.Value:= '';
   Window.WindowPos:= wp_screencentered;
 end;

FUNCTION tKeyBoardfo.Execute (const sender: TObject): boolean;
 begin
   TRY
     Show (true);
     Result:= Window.ModalResult = mr_ok;
   EXCEPT
     ON Exception DO Result:= false;
   END (* TRY *);
 end;

FUNCTION tKeyBoardfo.Execute (const sender: TObject; CONST X, Y: integer): boolean;
 begin
   Bounds_X:= X; Bounds_Y:= Y;
   Result:= Execute (Sender);
 end;

end.
