unit dialogform;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
{$LONGSTRINGS OFF}

interface

uses
 Classes, SysUtils, msegui,mseclasses,mseforms,mseevent,msegraphics,msegraphutils,
 msemenus,msesimplewidgets,msestrings,msetypes,msewidgets,msewindowwidget,
 mseglob,msegraphedits,msedataimage,msedock,msestat,msetimer;


type
 tDialogfo = class (tmseform)
   FUNCTION  Execute (const sender: TObject; CONST Msg: string = ''): boolean; VIRTUAL;
   FUNCTION  Execute (const sender: TObject; CONST X, Y: integer; CONST Msg: string = ''): boolean; VIRTUAL; OVERLOAD;
   PROCEDURE Dismiss (const sender: TObject); VIRTUAL;
 end;


 tTimedDialogfo = class (tDialogfo)
   Over: ttimer;

   FUNCTION  Execute   (const sender: TObject; CONST Msg: string = ''): boolean; OVERRIDE;
   PROCEDURE Retrigger (const sender: TObject); VIRTUAL;
   procedure AtEvent   (const sender: TObject; const aevent: tobjectevent);
   procedure AtMouse   (const sender: twidget; var info: mouseeventinfoty);
   procedure AtPaint   (const sender: twidget; const canvas: tcanvas);

   CONSTRUCTOR Create (aOwner: tComponent; TimeOut: longint); VIRTUAL; OVERLOAD;

 PRIVATE
   OutTime: longint;

 PUBLIC
   PROPERTY Interval: longint READ OutTime WRITE OutTime;
 end;


implementation


FUNCTION tDialogfo.Execute (const sender: TObject; CONST Msg: string): boolean;
 begin
   TRY
     Show (true);
     Result:= Window.ModalResult = mr_ok;
   EXCEPT
     ON Exception DO Result:= false;
   END (* TRY *);
 end;

FUNCTION tDialogfo.Execute (const sender: TObject; CONST X, Y: integer; CONST Msg: string): boolean;
 begin
   Bounds_X:= X; Bounds_Y:= Y;
   Result:= Execute (Sender, Msg);
 end;

PROCEDURE tDialogfo.Dismiss (const sender: TObject);
 begin
   Close (mr_windowclosed);
 end;


CONSTRUCTOR tTimedDialogfo.Create (aOwner: tComponent; TimeOut: longint);
 begin
   Create (aOwner);
   OutTime:= TimeOut;
 end;

FUNCTION tTimedDialogfo.Execute (const sender: TObject; CONST Msg: string): boolean;
 begin
   IF OutTime <> 0 THEN BEGIN
     IF NOT Assigned (Over) THEN Over:= ttimer.Create (Self);
     WITH Over DO BEGIN
       OnTimer:= @Dismiss; Interval:= OutTime; Enabled:= true;
     END (* WITH Over *);
     OnEvent:= @AtEvent; OnMouseEvent:= @AtMouse; OnBeforePaint:= @AtPaint;

     Result:= INHERITED;

     Over.Enabled:= false;
   END (* IF OutTime <> 0 *)
   ELSE Result:= INHERITED;
 end;

PROCEDURE tTimedDialogfo.Retrigger (const sender: TObject);
 begin
   Over.Interval:= OutTime;
 end;

procedure tTimedDialogfo.AtEvent (const sender: TObject; const aevent: tobjectevent);
 begin
   Retrigger (NIL);
 end;


procedure tTimedDialogfo.AtMouse (const sender: twidget; var info: mouseeventinfoty);
 begin
   Retrigger (NIL);
 end;


procedure tTimedDialogfo.AtPaint (const sender: twidget; const canvas: tcanvas);
 begin
   Retrigger (NIL);
 end;

end.
