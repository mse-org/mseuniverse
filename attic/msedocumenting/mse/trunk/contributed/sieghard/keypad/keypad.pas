unit keypad;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
{$LONGSTRINGS OFF}


interface

uses
 Classes, SysUtils, msegui,mseclasses,mseforms,mseevent,msegraphics,msegraphutils,msemenus,
 mseglob,mseact,msesimplewidgets,msewidgets,msedispwidgets,msestrings,msetypes,
 dialogform;

type
 tKeyPadfo = class (tDialogfo)
   Eingabefeld: tgroupbox;
   Eingabe:     tstringdisp;
   tbutton1:    tbutton;
   tbutton2:    tbutton;
   tbutton3:    tbutton;
   tbutton4:    tbutton;
   tbutton5:    tbutton;
   tbutton6:    tbutton;
   tbutton7:    tbutton;
   tbutton8:    tbutton;
   tbutton9:    tbutton;
   tbutton0:    tbutton;
   ClearKey:    tbutton;
   EnterKey:    tbutton;
   DecimalKey:  tbutton;
   Abbruch:     tstockglyphbutton;
   DelKey:      tstockglyphbutton;

   procedure NewPad   (const sender: TObject); VIRTUAL; ABSTRACT;
   procedure PadKey   (const sender: TObject); VIRTUAL; ABSTRACT;
   procedure Clear    (const sender: TObject); VIRTUAL; ABSTRACT;
   procedure Delete   (const sender: TObject); VIRTUAL; ABSTRACT;
   procedure PointKey (const sender: TObject); VIRTUAL; ABSTRACT;
 end;


 tIntKeyPadfo = class (tKeyPadfo)
   procedure NewPad   (const sender: TObject); OVERRIDE;
   procedure PadKey   (const sender: TObject); OVERRIDE;
   procedure Clear    (const sender: TObject); OVERRIDE;
   procedure Delete   (const sender: TObject); OVERRIDE;

 Private
   intValue: integer;

 Published
   PROPERTY Value: integer READ intValue WRITE intValue;
 end;

 tFloatKeyPadfo = class (tKeyPadfo)
   procedure NewPad   (const sender: TObject); OVERRIDE;
   procedure PadKey   (const sender: TObject); OVERRIDE;
   procedure Clear    (const sender: TObject); OVERRIDE;
   procedure Delete   (const sender: TObject); OVERRIDE;
   procedure PointKey (const sender: TObject); OVERRIDE;

 Private
   pointpos: smallint;
   decimals,
   intValue: realty;

 Published
   PROPERTY Value: realty READ intValue WRITE intValue;
 end;


implementation

uses
 KeyPad_mfm;


procedure tIntKeyPadfo.NewPad (const sender: TObject);
 begin
   WITH DecimalKey DO BEGIN
     State:= State+ [as_invisible];
   END (* WITH DecimalKey *);
   EnterKey.Bounds_CY:= 93;
   Window.WindowPos:= wp_screencentered;
   Clear (Self);
 end;

procedure tIntKeyPadfo.PadKey (const sender: TObject);
 begin
   intValue:= 10* intValue+ tbutton (Sender).Tag;
   Eingabe.Value:= IntToStr (intValue);
 end;

procedure tIntKeyPadfo.Clear (const sender: TObject);
 begin
   intValue:= 0; Eingabe.Value:= '0';
 end;

procedure tIntKeyPadfo.Delete (const sender: TObject);
 begin
   intValue:= intValue DIV 10;
   Eingabe.Value:= IntToStr (intValue);
 end;


procedure tFloatKeyPadfo.NewPad (const sender: TObject);
 begin
   WITH DecimalKey DO BEGIN
     Caption:= DecimalSeparator;
     State:= State- [as_invisible];
     OnExecute:= @PointKey;
   END (* WITH DecimalKey *);
   EnterKey.Bounds_CY:= 61;
   Window.WindowPos:= wp_screencentered;
   Clear (Self);
 end;

procedure tFloatKeyPadfo.PointKey (const sender: TObject);
 begin
   IF decimals = 1.0 THEN decimals:= 0.1;
 end;

procedure tFloatKeyPadfo.PadKey (const sender: TObject);
 begin
   IF decimals < 1.0 THEN BEGIN
     intValue:= Round ((intValue+ tbutton (Sender).Tag* decimals)/decimals)* decimals;
     Inc (pointpos); decimals:= decimals* 0.1;
   END (* IF decimals < 1.0 *)
   ELSE intValue:= (10.0* intValue)+ tbutton (Sender).Tag;

   Eingabe.Value:= FloatToStrF (intValue, ffFixed, 0, pointpos);
 end;

procedure tFloatKeyPadfo.Clear (const sender: TObject);
 begin
   pointpos:= 0; decimals:= 1.0;
   intValue:= 0.0; Eingabe.Value:= '0';
 end;

procedure tFloatKeyPadfo.Delete (const sender: TObject);
 begin
   IF decimals <= 0.1 THEN BEGIN
     Dec (pointpos); decimals:= decimals* 10.0;
   END (* IF decimals <= 0.1 *);

   IF decimals < 1.0
     THEN intValue:= Int (intValue/(10.0* decimals))* 10.0* decimals
     ELSE intValue:= Int (intValue* 0.1);

   IF decimals > 0.1 THEN BEGIN
     pointpos:= 0; decimals:= 1.0;
   END (* IF decimals > 0.1 *);

   Eingabe.Value:= FloatToStrF (intValue, ffFixed, 0, pointpos);
 end;

end.
