unit uSTHevaluator;
// TODO 5 : Implement TNumStack (extended) and TOpStack (string) to avoid conversions
// TODO 5 : Implement functions with n Arguments
// TODO 5 : Implement lists of values (for functions)
{
 Author : Stefan M. Huber
 Version: 0.3.2
 Date   : 2005-11-27
 Update : 2007-05-25
 Purpose: arithmetic evaluator with variable capabilities, binary operators
          and unary functions. Extend Operators, Calc and TryFunction for
          further functionality.
          A semicolon (;) can separate formulas in one string
          variable assignments are possible (var=value).
          'ans' is the variable holding the last result
          the decimal separator depends on your operating system setup: . or ,
 Note   : Accuracy is of course limited. I am using lots of conversions between
          string respresentation and extended variables. So don't use it for
          risky calculations.
          
 BE SURE TO READ THE LICENCE INFORMATION BELOW!

 Usage: example
   with TSthEvaluator.Create do
     try
     OnVariable  := VariableHandler;   // write a handler for unknown variables
     AutoEval    := false;             // don't evaluate immediately when a
                                       // formula is set.
     Formula     := EditFormula.Text;  // assign a formula.
     EditResult.Text := ResultString;  // ResultString is a string
     variableExt := ResultExt;         // Result as extended variable
     finally
     Free;
     end;

 The OnVariable handler will be called for each unknown variable and can look
 like this one here:
   procedure Form1.VariableHandler(ASender: TSthEvaluator; AVariable: string);
   begin
     ASender.Variable[AVariableName] :=
       InputBox('Enter value for variable', AVariable, '0');
   end;

 The OnNumber handler will be called for each number. That way you can do
 something with those numbers. Maybe interpret them as binary. Internally,
 I handle all numbers as extended or strings (yet).
 That means that you have to do the conversion in either the OnNumber handler
 and the OnVariable handler.

 I allow the backslash character when going through the formula, because this
 enables you to react to different number systems and thus evaluate formulas
 like (binary + hex)
   \b11011 + \xFF

 Just write an OnNumber handler that checks if the first character in
 ANumberString is a backslash and do the conversions based on the second
 character.

 Examples of valid formulas:
   (1+2)*3
   1+2*3
   a=1; a*5
   1; ans*5       (same as before)
   a=2; a*b+c     (will trigger the Onvariable event for b and c)
   A=2; a+2       (note: variables are not case sensitive. This example only
                         treats 'A' as variable, when AllowVariablesWithCapitals
                         is set to true)

If you make corrections to the code, please be so kind and send a copy of
the modification to me.

 Licence:

  Copyright (c) and Urheberrecht 2006-2007, Stefan M. Huber

  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the "Software"),
  to deal in the Software without restriction, including without limitation
  the rights to use, copy, modify, merge, publish, distribute, sublicense,
  and/or sell copies of the Software, and to permit persons to whom the
  Software is furnished to do so, subject to the following conditions:

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESSED
  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  DEALINGS IN THE SOFTWARE.
}

interface

uses classes, sysutils;

type
  EEvaluatorException = class(Exception);
  EEvaluatorUnknownVariableException = class(EEvaluatorException)
  private
    FVariableName: string;
  public
    constructor CreateWithVarname(const AMsg: string; AVarName: string);
    property VariableName: string read FVariableName;
  end;
  EEvaluatorInvalidTokenException = class(EEvaluatorException)
  private
    FPosition  : integer;
    FToken     : string;
  public
    constructor CreatePositionToken(const AMsg: string;
                                    const APosition: integer;
                                    const AToken: string);
    property Position: integer read FPosition;
    property Token: string read FToken;
  end;

  TOperator = string[5]; // binary operators and their max length

  TStack = array of String;
  ROperator = record
    aOperator   : TOperator;
    Precedence : integer;
  end;
  RConstant = record
    Name  : string;
    Value : extended;
  end;

  TSthEvaluator = class;

  TVariableEvent = procedure(ASender       : TSthEvaluator;
                             AVariableName : string) of Object;
  // fired when the evaluator encounters an unknown variable

  TNumberEvent = procedure(ASender         : TSthEvaluator;
                           ANumberString   : string;
                           var  ANumberExt : extended) of Object;
  // this event is triggered when the evaluator encounters a literal number.
  // eg: "log 100" will trigger for "100"

  TSthEvaluator = class
  protected
    function  DoEvaluate(var APos: integer; AFullEval: boolean = true): string; virtual;
    function  DoOnNumber(ANumberString: string; var ANumberExt: extended): boolean; virtual;
    procedure DoOnVariable(AVariableName: string); virtual;
  private
    FVariables   : TStringList;
    FOnVariable  : TVariableEvent;
    FOnNumber    : TNumberEvent;
    FAutoEval    : boolean;
    FFormula     : string;
    FResultString: string;
    FResultExt   : extended;
    FAbortCurrent : boolean; // ; encountered. Finish calculation
    fAllowEmptyAssignments: boolean;
    fAllowVariablesWithCapitals: boolean;

    function  Calc(AOp: TOperator; AArg1, AArg2: string): string;
    procedure ClearStack(var AStack: TStack);
    function  CompareOps(AOp1, AOp2: string): integer;
    function  GetConstant(AConstant: string): string;
    function  GetVariable(AVariable: string): string;
    function  GetVariableCount: integer;
    function  GetVariableNo(AIndex: integer): string;
    function  IsPossibleOperator(ACandidate: string): boolean;
    function  IsVariable(AToken: string): boolean;
    function  Peek(var AStack: TStack): string;
    function  PeekToken(APos: integer): string;
    function  Pop(var AStack: TStack): string;
    procedure Push(var AStack: TStack; AValue: string);
    function  ReadOperator(var APos: integer): string;
    function  ReadToken(var APos: integer): string;
    procedure SetFormula(const Value: string);
    procedure SetVariable(AVariable: string; const Value: string);
    function  StackEmpty(AStack: TStack): boolean;
    function  TryFunction(var AFunction: string; var APos: integer): boolean;
    procedure VariableReplacement(var AToken: string);
  public
    constructor Create;
    destructor Destroy; override;

    procedure ClearVariables; virtual;
    procedure Evaluate; virtual;  // call only when you set autoeval to false

    property AllowEmptyAssignments: boolean read fAllowEmptyAssignments write fAllowEmptyAssignments;
             // allows assignments to be empty (assigning 0). Thus "a=; b=a+1"
             // would assign 0 to a and 1 to b. This is useful, if you have
             // programmes that return values from somewhere and allow null values.
    property AllowVariablesWithCapitals : boolean read fAllowVariablesWithCapitals write fAllowVariablesWithCapitals;
             // enable this *only* when you don't plan to use number systems
             // with a basis > 10. Hex, for instance. Otherwise, the evaluator
             // cannot tell if A+A is a formula with variables or with numbers.
    property AutoEval: boolean read FAutoEval write FAutoEval;
             // evaluate when you set a formula
    property Formula: string read FFormula write SetFormula;
             // the string to be evaluated
    property ResultString: string read FResultString;
             // the result of an evaluation as a string
    property ResultExt: extended read FResultExt;
             // converted to an extended value, if possible
    property Variable[AVariable: string]: string read GetVariable write SetVariable;
             // assign or read variable values.
             // Set it to '' to undefine a variable
    property VariableNo[AIndex: integer]: string read GetVariableNo;
             // get name of variable number AIndex (useful for iterating
             // through the variables)
    property VariableCount: integer read GetVariableCount;
             // number of variables

    property OnNumber: TNumberEvent read FOnNumber write FOnNumber;
    property OnVariable: TVariableEvent read FOnVariable write FOnVariable;
             // the event that is triggered when an unknown variable is
             // encountered during evaluation
  end;

const
  Constants : array[0..10] of RConstant = (
    (name: 'pi';         value: pi),                // []
    (name: 'euler';      value: 2.718281828459),    // []
    (name: 'planck';     value: 6.62607e-34),       // [Js]
    (name: 'dirac';      value: 6.62607e-34/(2*pi)),// [Js]
    (name: 'bolzmann';   value: 1.380658e-23),      // [eV/K]
    (name: 'earthaccel'; value: 9.80665),           // [m/sҝ
    (name: 'lightspeed'; value: 2.99792e8),         // [m/s]
    (name: 'grav';       value: 6.672e-11),         // [Nmүkg]
    (name: 'loschmidt';  value: 6.0221415e23),      // [parts/mol]
    (name: 'avogadro';   value: 6.0221415e23),      // [parts/mol] (=loschmidt)
    (name: 'theanswer';  value: 42)                 // tribute to Douglas Adams
  );
  Operators : array[0..6] of ROperator = (
    (aOperator : '+'; Precedence: 1),
    (aOperator : '-'; Precedence: 1),
    (aOperator : '*'; Precedence: 2),
    (aOperator : '/'; Precedence: 2),
    (aOperator : '^'; Precedence: 3),
    (aOperator : 'mod'; Precedence: 3),
    (aOperator : 'div'; Precedence: 3)
  );


implementation

uses math;

resourcestring
  ERR_PREMATURE_END      = 'Premature end of formula.';
  ERR_EMPTY_ASSIGNMENT   = 'Empty assignment found.';
  ERR_INVALID_TOKEN      = 'Invalid token found';
  ERR_VARIABLE_UNDEFINED = 'Variable undefined.';

{ TSthEvaluator }

function TSthEvaluator.Calc(AOp: TOperator; AArg1, AArg2: string): string;
// Try evaluating the operation AOp with the two arguments and return the
// result if one of the arguments is not numeric, try getting a variable of
// that name if that fails as well, raise an exception
var a1, a2: extended;
begin

  // OnNumber has already been called in DoEvaluate, so no need to call it here
  if IsVariable(AArg1) then VariableReplacement(AArg1);
  a1 := StrToFloat(AArg1);

  if IsVariable(AArg2) then VariableReplacement(AArg2);
  a2 := StrToFloat(AArg2);

  if AOp = '+' then Result := FloatToStr(a1 + a2)
  else if AOp = '-' then Result := FloatToStr(a1 - a2)
  else if AOp = '*' then Result := FloatToStr(a1 * a2)
  else if AOp = '/' then Result := FloatToStr(a1 / a2)
  else if AOp = '^' then Result := FloatToStr(Power(a1, a2))
  else if AOp = 'mod' then Result := FloatToStr(Trunc(a1) mod Trunc(a2))
  else if AOp = 'div' then Result := FloatToStr(Trunc(a1) div Trunc(a2))
end;

function TSthEvaluator.TryFunction(var AFunction: string;
                                   var APos: integer): boolean;
// returns true, if a function was passed as AFunction.
// the out value of AFunction is the result of the function

   function GetArg(var APos: integer): extended;
   // local function to get the argument of a function. This could probably be
   // handled more elegantly
  var arg_s : string;
      ext   : extended;
   begin
     if PeekToken(APos) = '('
       then begin
            ReadToken(APos);
            arg_s := DoEvaluate(APos)
            end
       else begin // only an argument, no term. As in "log 100 + log 100"
            arg_s := ReadToken(APos);
            if DoOnNumber(arg_s, ext) then arg_s := FloatToStr(ext);
            end;
     try
       Result := StrToFloat(arg_s);
     except
       VariableReplacement(arg_s);
       Result := StrToFloat(arg_s);
     end;
   end;

var inputvalue: string;

begin
  inputvalue := AFunction;
  if AFunction = 'abs' then AFunction := FloatToStr(Abs(GetArg(APos)))
  else if AFunction = 'arccos' then AFunction := FloatToStr(arccos(GetArg(APos)))
  else if AFunction = 'arccosh' then AFunction := FloatToStr(arccosh(GetArg(APos)))
  else if AFunction = 'arcsin' then AFunction := FloatToStr(arcsin(GetArg(APos)))
  else if AFunction = 'arcsinh' then AFunction := FloatToStr(arcsinh(GetArg(APos)))
  else if AFunction = 'arctanh' then AFunction := FloatToStr(arctanh(GetArg(APos)))
  else if AFunction = 'ceil' then AFunction := FloatToStr(ceil(GetArg(APos)))
  else if AFunction = 'cos' then AFunction := FloatToStr(cos(GetArg(APos)))
  else if AFunction = 'cosh' then AFunction := FloatToStr(cosh(GetArg(APos)))
  else if AFunction = 'cotan' then AFunction := FloatToStr(cotan(GetArg(APos)))
  else if AFunction = 'deg' then AFunction := FloatToStr(RadToDeg(GetArg(APos)))
  else if AFunction = 'exp' then AFunction := FloatToStr(exp(GetArg(APos)))
  else if AFunction = 'floor' then AFunction := FloatToStr(floor(GetArg(APos)))
  else if AFunction = 'frac' then AFunction := FloatToStr(Frac(GetArg(APos)))
  else if AFunction = 'ld' then AFunction := FloatToStr(log2(GetArg(APos)))
  else if AFunction = 'log' then AFunction := FloatToStr(log10(GetArg(APos)))
  else if AFunction = 'log10' then AFunction := FloatToStr(log10(GetArg(APos)))
  else if AFunction = 'log2' then AFunction := FloatToStr(log2(GetArg(APos)))
  else if AFunction = 'ln' then AFunction := FloatToStr(ln(GetArg(APos)))
  else if AFunction = 'rad' then AFunction := FloatToStr(DegToRad(GetArg(APos)))
  else if AFunction = 'random' then AFunction := FloatToStr(Random(Trunc(GetArg(APos))))
  else if AFunction = 'round' then AFunction := FloatToStr(round(GetArg(APos)))
  else if AFunction = 'sin' then AFunction := FloatToStr(sin(GetArg(APos)))
  else if AFunction = 'sinh' then AFunction := FloatToStr(sinh(GetArg(APos)))
  else if AFunction = 'sqrt' then AFunction := FloatToStr(sqrt(GetArg(APos)))
  else if AFunction = 'tan' then AFunction := FloatToStr(tan(GetArg(APos)))
  else if AFunction = 'tanh' then AFunction := FloatToStr(tanh(GetArg(APos)))
  else if AFunction = 'trunc' then AFunction := FloatToStr(Trunc(GetArg(APos)))
  ;
  Result := AFunction <> inputvalue;
end;

procedure TSthEvaluator.ClearStack(var AStack: TStack);
begin
  SetLength(AStack, 0);
end;

procedure TSthEvaluator.ClearVariables;
begin
  FVariables.Clear;
end;

function TSthEvaluator.CompareOps(AOp1, AOp2: string): integer;
// precedence(AOp1) > precedence(AOp2) => >0
// precedence(AOp1) = precedence(AOp2) => =0
// precedence(AOp1) < precedence(AOp2) => <0
// the calling function must ensure that both operators can be found in the
// Operators array
var p1, p2: integer;  // precedence values
    i     : integer;
begin
  p1 := -1;
  p2 := -1;
  i := Low(Operators);
  while (i <= High(Operators)) and ((p1 < 0) or (p2 < 0)) do
    begin
    if Operators[i].aOperator = AOp1 then p1 := Operators[i].Precedence;
    if Operators[i].aOperator = AOp2 then p2 := Operators[i].Precedence;
    inc(i);
    end;
  Result := p1-p2;
end;

constructor TSthEvaluator.Create;
begin
  fAllowVariablesWithCapitals := false;
  fAllowEmptyAssignments := false;
  FAutoEval   := true;
  FResultString := '';
  FResultExt    := 0.0;
  FVariables  := TStringList.Create;
end;

destructor TSthEvaluator.Destroy;
begin
  FVariables.Free;
  inherited;
end;

function TSthEvaluator.DoEvaluate(var APos: integer; AFullEval: boolean = true): string;
// the recursive function that does the actual evaluation, starting with
// APos in the formula string
// AFullEval tells the function to parse complete terms. If this is false, the
// function was called to evaluate the argument of a unary function without
// parentheses. eg: log 100 + log 100 should be treated as log(100) + log(100)
var token, op : string;
    opstack, numstack : TStack;
    a1, a2    : string;
    ext       : extended;
    bWasFunctionResult : boolean;
begin
  Result := '';
  ClearStack(opstack);
  ClearStack(numstack);

  while not FAbortCurrent and (APos <= Length(FFormula)) do
    // if no operator is found, the routine exits as well.
    // No explicit check for closing brackets is performed.
    begin
    token  := ReadToken(APos);

    bWasFunctionResult := TryFunction(token, APos);

    if token = '(' then
      begin
      token := DoEvaluate(APos);
//      inc(APos);   THIS IS BUGGY. WHY DID I INCLUDE IT IN THE FIRST PLACE?
      op    := ReadOperator(APos);
      end
    else
      begin
      op     := ReadOperator(APos);
      end;

    if not bWasFunctionResult then
      if DoOnNumber(token, ext) then
        begin
        token := FloatToStr(ext);
        end;
    Push(numstack, token);

    if (op = '') or (op = ')') or (op = ';') then
      begin
      if op = ';' then FAbortCurrent := true;
      BREAK;
      end
    else
      begin
      if (Peek(opstack) = '') or (CompareOps(Peek(opstack), op) < 0) then
        // We had no or an operation with lower precedence on the stack, wait
        // with evaluating the expression
        begin
        if op <> '' then Push(opstack, op);
        end
      else
        // we possibly have a number of equally preceding operations on the
        // stack or the current operation has lower precedence: Calculate
        begin
        while (not StackEmpty(opstack)) and
              (CompareOps(Peek(opstack), op) >= 0)
        do
          begin
          a2 := Pop(numstack); // to avoid ambiguities in compiler evaluation
          a1 := Pop(numstack);
          Push(numstack, Calc(Pop(opstack), a1, a2));
          end;
        Push(opstack, op);
        end;
      end
    end;

  // There might still be unevaluated expressions.
  while not StackEmpty(opstack) do
    begin
    try
      a2 := Pop(numstack);
      a1 := Pop(numstack);
    except
      raise EEvaluatorException.Create(ERR_PREMATURE_END);
    end;
    Push(numstack, Calc(Pop(opstack), a1, a2));
    end;

    try
    Result := pop(numstack);
      // This is the last result of the current subroutine and it could be
      // a variable (non numeric). This is the case, when the formula consists
      // of a variable only.
    except
    raise EEvaluatorException.Create(ERR_PREMATURE_END);
    end;

    if IsVariable(Result) then VariableReplacement(Result);
      try
      FResultExt := StrToFloat(Result);
      except
      on E: Exception do raise EEvaluatorException.Create(E.Message);
      end;

end;

procedure TSthEvaluator.DoOnVariable(AVariableName: string);
begin
  if Assigned(FOnVariable) then
    FOnVariable(self, AVariableName)
  else
    raise EEvaluatorUnknownVariableException.CreateWithVarname(
      ERR_VARIABLE_UNDEFINED, AVariableName
    );
end;

procedure TSthEvaluator.Evaluate;
var p, p1 : integer;
    token, op : string; // possible variable assignment
    varstr    : string; // string replacement of a variable token
    teststr   : string;
begin
  FResultString := '';
  FResultExt    := 0.0;
  p := 1;
  while p <= Length(FFormula) do
    begin
    p1 := p;

    // Check for assignment operator, which may occur only at the beginning
    token := ReadToken(p1); // will hold the possible variable name
    while (p1 <= Length(FFormula)) and (FFormula[p1] = ' ') do inc(p1);
    if (p1 <= Length(FFormula)) then op := FFormula[p1];

    FAbortCurrent := false;
    if op = '=' then
      begin
      op := '';
      p := p1+1;
      teststr := PeekToken(p);
      if (teststr = '') then
        begin
        varstr := GetVariable(token);
        if (varstr = '') and (not fAllowEmptyAssignments)
          then raise EEvaluatorInvalidTokenException.CreatePositionToken(
                     ERR_EMPTY_ASSIGNMENT, p, FFormula[p])
          else begin
               if varstr = '' then varstr := '0';
               Variable[token] := varstr;
               inc(p);
               end;
        end;

      if teststr <> '' then
        begin
        FResultString := DoEvaluate(p);
        Variable[token] := FResultString
        end;
      end
    else
      begin
      FResultString := DoEvaluate(p);
      Variable['ans'] := FResultString;
      end;
    end;
  try
    FResultExt := StrToFloat(FResultString);
  except
    on E: Exception do raise EEvaluatorException.Create(E.Message);
  end;
end;

function TSthEvaluator.GetVariable(AVariable: string): string;
begin
  Result := FVariables.Values[AVariable];
  if Result = '' then Result := GetConstant(AVariable);
  if Result = '' then
    begin
    DoOnVariable(AVariable);
    Result := FVariables.Values[AVariable];
    end;
end;

function TSthEvaluator.GetVariableCount: integer;
begin
  Result := FVariables.Count;
end;

function TSthEvaluator.GetVariableNo(AIndex: integer): string;
begin
  Result := FVariables.Names[AIndex];
end;

function TSthEvaluator.IsPossibleOperator(ACandidate: string): boolean;
// as an operator can consist of more than one character, I have to check, if
// the ACandidate can still become a valid operator
var i, len : integer;
begin
  Result := (ACandidate = ';') or (ACandidate = ')') or (ACandidate = '=');
  if Result then EXIT; // We have a separating or finishing condition

  len := Length(ACandidate);
  i := Low(Operators);
  while (i <= High(Operators)) and not Result do
    begin
    if Length(Operators[i].aOperator) >= len then
      begin
      Result := Copy(Operators[i].aOperator, 1, len) = ACandidate;
      end;
    inc(i);
    end;
end;

function TSthEvaluator.Peek(var AStack: TStack): string;
var len: integer;
begin
  Result := '';
  len := Length(AStack);
  if len > 0 then
    Result := AStack[len-1];
end;

function TSthEvaluator.Pop(var AStack: TStack): string;
begin
  Result := AStack[Length(AStack)-1];
  SetLength(AStack, Length(AStack)-1);
end;

procedure TSthEvaluator.Push(var AStack: TStack; AValue: string);
var len: integer;
begin
  len := Length(AStack);
  SetLength(AStack, len + 1);
  AStack[len] := AValue;
end;

function TSthEvaluator.ReadOperator(var APos: integer): string;
var startpos : integer;
begin
  while (APos <= Length(FFormula)) and (FFormula[APos] = ' ') do inc(APos);
  startpos := APos;

  while (APos <= Length(FFormula)) and
        IsPossibleOperator(Copy(FFormula, startpos, APos-startpos+1))
  do
    begin
    inc(APos);
    end;

  Result := Copy(FFormula, startpos, APos - startpos);
end;

function TSthEvaluator.ReadToken(var APos: integer): string;
// a token is anything but an operator: function, variable, number
var startpos     : integer;
    minus        : boolean;
begin
  while (APos <= Length(FFormula)) and (FFormula[APos] = ' ') do
    inc(APos);
  startpos := APos;

  if FFormula[APos] = '(' then
    begin
    Result := '(';
    inc(APos);
    EXIT;
    end;

  minus := false;
  if FFormula[startpos] = '-' then
    begin
    minus := true;
    inc(APos);
    end;
  while (APos <= Length(FFormula)) and
        (FFormula[APos] in ['0'..'9', 'a'..'z', 'A'..'Z', ',', '.', '\'])
//        and (not IsOperatorChar(FFormula[APos]))
  do
    begin
// POSSIBLY STUPID IDEA: Take dot and comma and replace it
    if (FFormula[APos] in ['.', ',']) then FFormula[APos] := DecimalSeparator;

    inc(APos);
    end;
  Result := Copy(FFormula, startpos, APos - startpos);
  if (Result = '') or (minus and (Result = '-')) then
    begin
    if APos <= Length(FFormula)
      then Raise EEvaluatorInvalidTokenException.CreatePositionToken(
                   ERR_INVALID_TOKEN, startpos, FFormula[APos]
                 )
      else Raise EEvaluatorInvalidTokenException.CreatePositionToken(
                   ERR_INVALID_TOKEN, startpos, ''
                 );
    end
end;

procedure TSthEvaluator.SetFormula(const Value: string);
begin
  FFormula := Trim(Value);
  if AutoEval then Evaluate;
end;

procedure TSthEvaluator.SetVariable(AVariable: string; const Value: string);
begin
  FVariables.Values[AVariable] := Trim(Value);
end;

function TSthEvaluator.StackEmpty(AStack: TStack): boolean;
begin
  Result := Length(AStack) = 0;
end;

procedure TSthEvaluator.VariableReplacement(var AToken: string);
var v : string;
begin
  if AToken = '' then EXIT;
  
  v := GetVariable(AToken);
  if (v='') and (AToken = 'pi') then AToken := FloatToStr(Pi);
  if v <> '' then AToken := v;
end;

function TSthEvaluator.GetConstant(AConstant: string): string;
var i : integer;
begin
  i := Low(Constants);
  Result := '';
  while (i <= High(Constants)) and (Result = '') do
    begin
    if Constants[i].Name = AConstant then
      Result := FloatToStr(Constants[i].Value);
    inc(i);
    end;
end;

{ EEvaluatorUnknownVariableException }

constructor EEvaluatorUnknownVariableException.CreateWithVarname(
              const AMsg: string;
              AVarName: string);
begin
  inherited Create(AMsg);
  FVariableName := AVarName;
end;

{ EEvaluatorInvalidTokenException }

constructor EEvaluatorInvalidTokenException.CreatePositionToken(
  const AMsg: string; const APosition: integer; const AToken: string);
begin
  inherited Create(AMsg);
  FPosition := APosition;
  FToken    := AToken;
end;

function TSthEvaluator.DoOnNumber(ANumberString: string; var ANumberExt: extended): boolean;
begin
  Result := Assigned(FOnNumber) and not IsVariable(ANumberString);
  if Result then FOnNumber(self, ANumberString, ANumberExt);
end;

function TSthEvaluator.IsVariable(AToken: string): boolean;
// By default, a variable MUST consist of lower case letters and digits only
// and MUST start with a lowercase letter. Be careful when using the property
// AllowVariablesWithCapitals. This will blow up calculations in other number
// systems, as it cannot be determined, wheter A+A is a formula with variables
// or with numbers.
var i : integer;
    allowedChars : set of char;
begin
  Result := false;
  if Length(AToken) < 1 then EXIT;

  if fAllowVariablesWithCapitals
    then allowedChars := ['A'..'Z', 'a'..'z']
    else allowedChars := ['a'..'z'];

  if not (AToken[1] in allowedChars) then EXIT;

  allowedChars := allowedChars + ['0' .. '9'];

  for i := 2 to Length(AToken) do
    if not (AToken[1] in allowedChars) then EXIT;

  Result := true;
end;

function TSthEvaluator.PeekToken(APos: integer): string;
begin
  try
  Result := ReadToken(APos);
  except
  Result := '';
  end;
end;

end.

