unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msedataedits,mseedit,msegrids,
 msestrings,msetypes,msewidgetgrid,msesimplewidgets,msewidgets,msegraphedits,
 msesplitter,msedispwidgets, uSTHevaluator;
(***********************************************************************
  simple calculator for Delphi programs
  by Martin Austermeier CIS 100116,3455
  Version 1.1 - 10.10.95:
    * corrected embarassing subtract bug
    * "overflow" error display
    * deleted some unnecessary code
  --------------------------------------------------------------

  This is not a component; just include it with "USES
 Calc,msedispwidgets".

  Sorry, I don't have the time to write mucho documentation.
  Only a few items:
    * you might want to change the Form's Caption.

    * the calculator is designed to show results with two decimal places.
      Look at SetResult (PRECISION, DECIMAL_PLACES) if you want to change this.

    * there are only the basic functions.
      Not even a "percent" button.. ;-)
      If you integrate new buttons, you should set their "Tag" property,
      and process them like in CalcButtonClick()

    * I invoke the calculator as a modal form (see ShowCalculator).
      You'd have to write a Close mechanism if you want to use it as
      a non-modal window.

    * a typical call would look like
        var myNumber : Double;
        begin
          myNumber := 123.45;
          if Calc.Showcalculator(myNumber) then [myNumber has changed];
        end;
*********************************************************************
	* 13/06/2008
	* adapted to freepascal msegui/mseide by Domingo Alvarez Duarte
*)
type
  TCalcStatus = (CS_FIRST, CS_VALID, { the rest is error stati }
                 CS_ERROR, CS_OVERFLOW);
                 
 tmainfo = class(tmseform)
   appMainMenu: tmainmenu;
   tlayouter1: tlayouter;
   btn7: tbutton;
   btn4: tbutton;
   btn1: tbutton;
   btn0: tbutton;
   btn8: tbutton;
   btn5: tbutton;
   btn2: tbutton;
   btnSign: tbutton;
   tbutton9: tbutton;
   tbutton10: tbutton;
   tbutton11: tbutton;
   btnDot: tbutton;
   btnDiv: tbutton;
   btnTimes: tbutton;
   btnMinus: tbutton;
   btnPlus: tbutton;
   btnclear: tbutton;
   btnSqrt: tbutton;
   btnPercent: tbutton;
   ButtonEq: tbutton;
   tbutton21: tbutton;
   resultDisplay: trealedit;
   procedure doFinish(const sender: TObject);
   
    procedure CalcButtonClick(const sender: TObject);
    procedure OkBtnClick(const sender: TObject);
    procedure clearBtnClick(const sender: TObject);
    procedure signBtnClick(const sender: TObject);
    procedure sqrtBtnClick(const sender: TObject);
    procedure percentBtnClick(const sender: TObject);
    procedure FormCreate(const sender: TObject);
    procedure FormKeyPress(const sender: TObject; var Key: Char);
   procedure execKeyDown(const sender: twidget; var info: keyeventinfoty);
   procedure doEval(const sender: tdataedit; const quiet: Boolean;
                   var accept: Boolean);
  private
    { Private-Deklarationen }
    fResult : Double;
    fDisplayText : String[30];
    fStatus : TCalcStatus;
    foperand : Double;
    foperator : Char;

    procedure SetResult(r : Double);
    function GetResult : Double;
    procedure SetStatus(stat : TCalcStatus);
    procedure SetDisplayText(s : String);
    function GetDisplayText : String;
    property Status : TCalcStatus read fStatus write SetStatus;
    property DisplayText : String read GetDisplayText write SetDisplayText;

  public
    { Public-Deklarationen }
    property CalcResult : Double read GetResult write SetResult;

    procedure Clear;
 end;
 
 function ShowCalculator(var number : Double) : Boolean;
{ display modal (inital result=number); return "number", if TRUE }

var
 mainfo: tmainfo;
implementation
uses
 main_mfm, sysutils;
 
//$A7BBD1
 
procedure tmainfo.doFinish(const sender: TObject);
begin
	close;
end;

function ShowCalculator(var number : Double) : Boolean;
begin
  if not Assigned(mainfo) then application.CreateForm(tmainfo,mainfo);
  try
    mainfo.CalcResult := number;
    if (mainfo.Show(True) = MR_OK) then
      number := mainfo.CalcResult;
  finally
    freeandnil(mainfo);
  end;
end;


procedure tmainfo.SetResult(r : Double);
const
  PRECISION = 15;
  DECIMAL_PLACES = 2;
begin
  fResult := r;
  DisplayText := FloatToStrF(fResult, ffFixed, PRECISION, DECIMAL_PLACES);
end;


function tmainfo.GetResult : Double;
begin
  result := StrToFloat(DisplayText);
end;


procedure tmainfo.SetStatus(stat : TCalcStatus);
begin
  fStatus := stat;
  if (fStatus >= CS_ERROR) then
    //MessageBeep(MB_ICONSTOP);
    ShowMessage('Error !');
end;


procedure tmainfo.SetDisplayText(s : String);
const
  MAX_LEN = 17;  { max# digits in display }
begin
  if (Length(s) <= MAX_LEN) then
    resultDisplay.Text := s
  else begin
    Status := CS_OVERFLOW;
  end;
end;


function tmainfo.GetDisplayText : String;
begin
  result := resultDisplay.Text;
end;


procedure tmainfo.FormCreate(const sender: TObject);
begin
  Clear;
  btnSign.caption := ucs4tostring($00b1);
  btnSqrt.caption := ucs4tostring($221a);
end;


procedure tmainfo.Clear;
begin
  Status := CS_FIRST;
  DisplayText := '0';
  foperand := 0;
  foperator := #0;
  resultDisplay.value := 0;
end;


procedure tmainfo.CalcButtonClick(const sender: TObject);
var
  k : Char;
begin
  if (Sender is TButton) then begin
    ButtonEq.SetFocus;  { default button }
    k := Char(TButton(Sender).caption[1]);
    FormKeyPress(Sender, k);
  end;
end;


procedure tmainfo.OkBtnClick(const sender: TObject);
var
  k : Char;
begin
  k := '=';
  FormKeyPress(self, k);  { simulate "=" to get result }
end;

procedure tmainfo.clearBtnClick(const sender: TObject);
var
  k : Char;
begin
  k := 'C';
  FormKeyPress(self, k);  { simulate "c" to clear }
end;

procedure tmainfo.signBtnClick(const sender: TObject);
var
  k : Char;
begin
  k := '#';
  FormKeyPress(self, k);  { simulate "#" to change sign }
end;

procedure tmainfo.sqrtBtnClick(const sender: TObject);
var
  k : Char;
begin
  k := 'S';
  FormKeyPress(self, k);  { simulate "S" to calculate sqrt }
  k := '=';
  FormKeyPress(self, k);  { simulate "=" to calculate sqrt result }
end;

procedure tmainfo.percentBtnClick(const sender: TObject);
var
  k : Char;
begin
  k := 'P';
  FormKeyPress(self, k);  { simulate "P" to calculate percentage }
  k := '=';
  FormKeyPress(self, k);  { simulate "=" to calculate percentage result }
end;

procedure tmainfo.FormKeyPress(const sender: TObject; var Key: Char);
const
  KEY_SIGN = '#';
  KEY_CLEAR = 'C';
  KEY_DECIMAL = '.';

  ERR_TXT = 'Error';
  OFL_TXT = 'Overflow';

var
  k : Char;
begin
  k := UpCase(key);

  if (k = decimalSeparator) then
    k := KEY_DECIMAL;

  if (Status < CS_ERROR)
  or (k = KEY_CLEAR) then
  case k of
    '0'..'9': begin
      if (Status = CS_FIRST) or (DisplayText = '0') then
        DisplayText := '';
      Status := CS_VALID;
      DisplayText := DisplayText + k;
    end;

    #8 : begin
      if (Length(DisplayText) > 0) then begin
        DisplayText := Copy(DisplayText, 1, Length(DisplayText)-1);
        if (Length(DisplayText) = 0) then
          DisplayText := '0';
        Status := CS_VALID;
      end;
    end;

    KEY_DECIMAL: begin
      if (system.Pos(decimalSeparator, DisplayText) = 0) then
        DisplayText := DisplayText + decimalSeparator;
      Status := CS_VALID;
    end;

    '+', '-', '/', '*', '=', 'S', 'P' : begin
      case foperator of
        '+': begin
          CalcResult := foperand + CalcResult;
        end;

        '-': begin
          CalcResult := foperand - CalcResult;
        end;

        '*': begin
          CalcResult := foperand * CalcResult;
        end;

        'S': begin
          CalcResult := sqrt(foperand);
        end;

        'P': begin
          CalcResult := (foperand/100.0);
        end;

        '/': begin
          if (CalcResult = 0) then
            Status := CS_ERROR
          else
            CalcResult :=  foperand / CalcResult;
        end;

      end;

      if (Status <> CS_ERROR) then begin
        Status := CS_FIRST;
        foperand := CalcResult;
        foperator := k;
      end;
    end;

    KEY_SIGN: begin
      CalcResult := -CalcResult;
    end;

    KEY_CLEAR: begin
      Clear;
    end;

  end;

  case Status of  { in case of error.. }
    CS_ERROR : DisplayText := ERR_TXT;
    CS_OVERFLOW : DisplayText := OFL_TXT;
  end;
end;

procedure tmainfo.execKeyDown(const sender: twidget; var info: keyeventinfoty);
var
	key : char;
begin
	key := char(info.key);
	FormKeyPress(sender, key);
end;

procedure tmainfo.doEval(const sender: tdataedit; const quiet: Boolean;
               var accept: Boolean);
begin
	with TSthEvaluator.Create do
     try
     	Formula := resultDisplay.Text;  // assign a formula.
     	resultDisplay.Text := ResultString;  // ResultString is a string
     finally
     	Free;
   	end;
end;


end.
