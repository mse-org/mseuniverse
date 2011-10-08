unit RAWPrinter;

(************************************************************
  TRAWPrinter Component v.1.1 (Freeware Delphi Component)

  CREATION HISTORY
  ----------------
  - Originally created by:
    (C)2000. Przemyslaw Jankowski
    email: pjank@home.pl
    as TRAWPrinter v.1.0 on PJank palette
  - Modified and enhanced by:
    (C)2006. Bisma Jayadi
    email: bisma_j@yahoo.com
    as TRAWPrinter v.1.5 on BeeSoft palette
    Last updated: 27 March 2006
  - Modified for MSEide+MSEgui by :
    (c)2008. Sri Wahono

  WHAT'S NEW
  ----------
  - since v.1.5 (2006):
    - add methods to define custom ESC command for inherited class.
    - add formatted text printing (using simple HTML tag).
    - fixed ESC command list for Epson LX series.
  - since v.1.1 (2002):
    - fix methods and properties naming in order to
      make it easy to understand.
    - add some new properties for easier printer
      configuration.
    - add some new methods for general printer
      commands (Epson and IBM compatible).
    - introducing some events for easier program
      flow control.
    - importing TRAWPrinterException class from file
      RawPrinting.pas from the same author.
  - since v.1.0 (2000):
    - place printing process into window's spooling.
    - published methods and properties are compatible
      with standard TPrinter class.

  PRINTER COMPATIBILITY
  ---------------------
  This class is made based on Epson LX-300 printer and IBM
  9068A Passbook printer or the compatibles. Before using
  this class, make sure your printer is compatible with one
  of those printer. Applying this class onto another printer
  which is not compatible with one of those printer might
  produce some unexpected results or even hardware damages.
  See your printer user manual to know about the printer's
  compatibility issues.

  If you want to deploy this class so it can run on your
  printer, you must redefine the ESC command constants with
  the appropriate ESC command of your printer or enhance the
  class by define a new printer command type which based on
  your printer and add some codes for handling your printer
  command type in some methods.

 ************************************************************)

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

interface

uses
  Windows, SysUtils, Classes, WinSpool, msestrings, msewidgets;

const
  { special characters }
  SC_LINE_FEED       = #10;
  SC_FORM_FEED       = #12;
  SC_CARRIAGE_RETURN = #13;
  SC_LF_CR           = #10#13;
  SC_CR_LF           = #13#10;

  // ESC command index
  ESC_MAX           = 19;
  ESC_INIT          = 0;
  ESC_COURIER       = 1;
  ESC_ROMAN         = 2;
  ESC_NORMAL        = 3;
  ESC_CONDENSED     = 4;
  ESC_EXPANDED      = 5;
  ESC_DOUBLED       = 6;
  ESC_NOT_DOUBLED   = 7;
  ESC_BOLD          = 8;
  ESC_NOT_BOLD      = 9;
  ESC_ITALIC        = 10;
  ESC_NOT_ITALIC    = 11;
  ESC_UNDERLINE     = 12;
  ESC_NOT_UNDERLINE = 13;
  ESC_STRIKE        = 14;
  ESC_NOT_STRIKE    = 15;
  ESC_SUB           = 16;
  ESC_NOT_SUB       = 17;
  ESC_SUPER         = 18;
  ESC_NOT_SUPER     = 19;

type
  // TRAWPrinter specific exception class
  ERAWPrinterException = class(Exception);
  ERAWPrinterError     = class(ERAWPrinterException);

  // TRAWPrinter specific custom data type
  TNewLineCode         = (nlLF, nlCR, nlLFCR, nlCRLF);
  TPrinterFontStyle    = (rfsBold, rfsItalic, rfsUnderline, rfsStrike, rfsSubScript, rfsSuperScript);
  TRAWPrinterCommand   = (rpcIBM, rpcEpson);
  TRAWPrinterMode      = (rpmText, rpmGraphic);
  TRAWPrinterStatus    = (rpsClosed, rpsOpened, rpsJobStarted, rpsPageStarted);
  TRAWPrinterFontName  = (rfnCourier, rfnRoman, rfnSanserif);
  TRAWPrinterFontPitch = (rfpNormal, rfpCondensed, rfpExpanded, rfpDoubled);
  TRAWPrinterFontStyle = set of TPrinterFontStyle;

  // TRAWPrinter class structure
  TRAWPrinter = class(TComponent)
  private
    fESCList      : array[0..ESC_MAX] of string;
    fPrnHandle    : DWord;
    fPrnName      : string;
    fPrnMode      : TRAWPrinterMode;
    fPrnStatus    : TRAWPrinterStatus;
    fPrnCommand   : TRAWPrinterCommand;
    fFontPitch    : TRAWPrinterFontPitch;
    fFontStyle    : TRAWPrinterFontStyle;
    fFontName     : TRAWPrinterFontName;
    fDocTitle     : string;
    fLeftMargin   : integer;
    fTopMargin    : integer;
    fPageWidth    : integer;
    fPageHeight   : integer;
    fEjectPaper   : boolean;
    fCurrentPage  : integer;
    fCurrentLine  : integer;
    fInitPrinter  : boolean;
    fNewLineCode  : TNewLineCode;

    fOnBeforePrint: TNotifyEvent;
    fOnAfterPrint : TNotifyEvent;
    fOnNewPage    : TNotifyEvent;

    procedure SetPrnMode(aPrintingMode: TRAWPrinterMode);
    procedure SetPrnCommand(aCommandType: TRAWPrinterCommand);
    procedure SetFontPitch(aFontPitch: TRAWPrinterFontPitch);
    procedure SetFontStyle(aFontStyle: TRAWPrinterFontStyle);
    procedure SetFontName(aFontName: TRAWPrinterFontName);
  protected  
    function  DecodeFormattedText(Text: string): string;
    procedure DefineEscapeCode(ESCCommand: integer; ESCString: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;

    // printer handling methods
    function  WriteToPrinter(const Buffer; Count: longint): DWord;
    function  SetToDefaultPrinter: boolean;

    // page handling methods
    function BeginDoc: boolean;
    function EndDoc: boolean;
    function Abort: boolean;
    function NewLine: boolean;
    function NewPage: boolean;

    // printing handling methods
    function  Write(const Text: string): boolean;
    function  WriteLn: boolean; overload;
    function  WriteLn(const Text: string): boolean; overload;
    procedure WriteList(const TextList: msestringarty; IsFormatted: boolean = false);
    procedure WriteColumn(Text: string; Width: integer; Alignment: TAlignment);

  published
    // printer and spooling configuration
    property PrinterName: string read fPrnName write fPrnName;
    property CommandType: TRAWPrinterCommand read fPrnCommand write SetPrnCommand;
    property PrintingMode: TRAWPrinterMode read fPrnMode write SetPrnMode;
    property DocumentTitle: string read fDocTitle write fDocTitle;
    property NewLineCode: TNewLineCode read fNewLineCode write fNewLineCode;
    property InitPrinterRequired: boolean read fInitPrinter write fInitPrinter default true;
    property EjectOnFinish: boolean read fEjectPaper write fEjectPaper default false;

    // font configuration
    property FontName: TRAWPrinterFontName read fFontName write SetFontName;
    property FontPitch: TRAWPrinterFontPitch read fFontPitch write SetFontPitch;
    property FontStyle: TRAWPrinterFontStyle read fFontStyle write SetFontStyle;

    // page configuration
    property TopMargin: integer read fTopMargin write fTopMargin;
    property LeftMargin: integer read fLeftMargin write fLeftMargin;
    property PageWidth: integer read fPageWidth write fPageWidth;
    property PageHeight: integer read fPageHeight write fPageHeight;

    // read only properties
    property CurrentPage: integer read fCurrentPage;

    // event properties
    property OnBeforePrint: TNotifyEvent read fOnBeforePrint write fOnBeforePrint;
    property OnAfterPrint: TNotifyEvent read fOnAfterPrint write fOnAfterPrint;
    property OnNewPage: TNotifyEvent read fOnNewPage write fOnNewPage;
  end;

{ published routines }
function AddSpace(Count: integer; Text: string; AsTail: boolean=false): string;
function FillText(Count: integer; TheChar: char): string;

implementation

uses
  StrUtils;

const
  // format tag code
  TAG_BEGIN     = '<';
  TAG_END       = '>';
  TAG_CLOSE     = '/';
  TAG_COURIER   = 'COURIER';
  TAG_ROMAN     = 'ROMAN';
  TAG_CONDENSED = 'SMALL';
  TAG_EXPANDED  = 'BIG';    
  TAG_DOUBLED   = 'DOUBLE'; 
  TAG_BOLD      = 'B';
  TAG_ITALIC    = 'I';
  TAG_UNDERLINE = 'U';
  TAG_STRIKE    = 'S';
  TAG_SUB       = 'SUB';
  TAG_SUPER     = 'SUPER';
  TAG_LEFT      = 'LEFT';
  TAG_RIGHT     = 'RIGHT';
  TAG_CENTER    = 'CENTER';

  { exception strings }
  errNoDefaultPrinter = 'No default printer found.';
  errPrinterError     = 'The printer "%s" is not available.';
  errPrintingError    = 'Error printing the document "%s".';

{ class utility methods }

// adding space before/after a string
function AddSpace(Count: integer; Text: string; AsTail: boolean=false): string;
var
  i: integer;
  s: string;
begin
  s := '';
  for i := 1 to Count do s := s + ' ';
  if AsTail then Result := Text + s
    else Result := s + Text;
end;

// fill string with a character
function FillText(Count: integer; TheChar: char): string;
var
  i: integer;
  s: string;
begin
  s := '';
  for i := 1 to Count do s := s + TheChar;
  Result := s;
end;

{ class creation methods }

constructor TRAWPrinter.Create(AOwner: TComponent);
begin
  inherited;

  fPrnName     := '';
  fPrnMode     := rpmText;
  fPrnStatus   := rpsClosed;
  fFontPitch   := rfpNormal;
  fFontStyle   := [];
  fFontName    := rfnCourier;
  fDocTitle    := 'RAW Printing';
  fNewLineCode := nlLFCR;

  SetPrnCommand(rpcEpson);

  { ----
    Note:
    These are all in reguler courier condensed font unit.
    I use it as margin unit since it's the smallest font available.
  }
  fLeftMargin  := 0;
  fTopMargin   := 0;
  fPageWidth   := 98;
  fPageHeight  := 68;
  fCurrentPage := 1;
  fCurrentLine := 0;
end;

destructor TRAWPrinter.Destroy;
begin
  if (fPrnStatus > rpsClosed) then Abort;
  inherited;
end;

{ printing process methods }

// interpret formatted text
function  TRAWPrinter.DecodeFormattedText(Text: string): string;

  function _replace(aWholeText, aOldText, aNewText: string): string;
  begin
    Result := StringReplace(aWholeText, aOldText, aNewText, [rfReplaceAll, rfIgnoreCase]);
  end;
  
var
  p: integer;
begin
  // decode Courier
  Text := _replace(Text, TAG_BEGIN+TAG_COURIER+TAG_END, fESCList[ESC_COURIER]);
  Text := _replace(Text, TAG_BEGIN+TAG_CLOSE+TAG_COURIER+TAG_END, fESCList[ESC_NORMAL]);
  // decode Roman
  Text := _replace(Text, TAG_BEGIN+TAG_ROMAN+TAG_END, fESCList[ESC_ROMAN]);
  Text := _replace(Text, TAG_BEGIN+TAG_CLOSE+TAG_ROMAN+TAG_END, fESCList[ESC_NORMAL]);
  // decode condensed
  Text := _replace(Text, TAG_BEGIN+TAG_CONDENSED+TAG_END, fESCList[ESC_CONDENSED]);
  Text := _replace(Text, TAG_BEGIN+TAG_CLOSE+TAG_CONDENSED+TAG_END, fESCList[ESC_NORMAL]);
  // decode expanded
  Text := _replace(Text, TAG_BEGIN+TAG_EXPANDED+TAG_END, fESCList[ESC_EXPANDED]);
  Text := _replace(Text, TAG_BEGIN+TAG_CLOSE+TAG_EXPANDED+TAG_END, fESCList[ESC_NORMAL]);
  // decode doubled
  Text := _replace(Text, TAG_BEGIN+TAG_DOUBLED+TAG_END, fESCList[ESC_DOUBLED]);
  Text := _replace(Text, TAG_BEGIN+TAG_CLOSE+TAG_DOUBLED+TAG_END, fESCList[ESC_NOT_DOUBLED]);
  // decode bold
  Text := _replace(Text, TAG_BEGIN+TAG_BOLD+TAG_END, fESCList[ESC_BOLD]);
  Text := _replace(Text, TAG_BEGIN+TAG_CLOSE+TAG_BOLD+TAG_END, fESCList[ESC_NOT_BOLD]);
  // decode italic
  Text := _replace(Text, TAG_BEGIN+TAG_ITALIC+TAG_END, fESCList[ESC_ITALIC]);
  Text := _replace(Text, TAG_BEGIN+TAG_CLOSE+TAG_ITALIC+TAG_END, fESCList[ESC_NOT_ITALIC]);
  // decode underline
  Text := _replace(Text, TAG_BEGIN+TAG_UNDERLINE+TAG_END, fESCList[ESC_UNDERLINE]);
  Text := _replace(Text, TAG_BEGIN+TAG_CLOSE+TAG_UNDERLINE+TAG_END, fESCList[ESC_NOT_UNDERLINE]);
  // decode strike
  Text := _replace(Text, TAG_BEGIN+TAG_STRIKE+TAG_END, fESCList[ESC_STRIKE]);
  Text := _replace(Text, TAG_BEGIN+TAG_CLOSE+TAG_STRIKE+TAG_END, fESCList[ESC_NOT_STRIKE]);
  // decode sub
  Text := _replace(Text, TAG_BEGIN+TAG_SUB+TAG_END, fESCList[ESC_SUB]);
  Text := _replace(Text, TAG_BEGIN+TAG_CLOSE+TAG_SUB+TAG_END, fESCList[ESC_NOT_SUB]);
  // decode super
  Text := _replace(Text, TAG_BEGIN+TAG_SUPER+TAG_END, fESCList[ESC_SUPER]);
  Text := _replace(Text, TAG_BEGIN+TAG_CLOSE+TAG_SUPER+TAG_END, fESCList[ESC_NOT_SUPER]);
  // decode left
  Text := _replace(Text, TAG_BEGIN+TAG_LEFT+TAG_END, '');
  Text := _replace(Text, TAG_BEGIN+TAG_CLOSE+TAG_LEFT+TAG_END, '');
  // decode right
  p := Pos(UpperCase(TAG_BEGIN+TAG_RIGHT+TAG_END), Text);
  if p = 0 then p := Pos(LowerCase(TAG_BEGIN+TAG_RIGHT+TAG_END), Text);
  Text := _replace(Text, TAG_BEGIN+TAG_RIGHT+TAG_END, '');
  Text := _replace(Text, TAG_BEGIN+TAG_CLOSE+TAG_RIGHT+TAG_END, '');
  if p > 0 then Text := AddSpace(fPageWidth-Length(Text), Text);
  // decode center
  p := Pos(UpperCase(TAG_BEGIN+TAG_CENTER+TAG_END), Text);
  if p = 0 then p := Pos(LowerCase(TAG_BEGIN+TAG_CENTER+TAG_END), Text);
  Text := _replace(Text, TAG_BEGIN+TAG_CENTER+TAG_END, '');
  Text := _replace(Text, TAG_BEGIN+TAG_CLOSE+TAG_CENTER+TAG_END, '');
  if p > 0 then Text := AddSpace((fPageWidth-Length(Text)) div 2, Text);

  Result := Text;
end;

// redefine ESC command string
procedure TRAWPrinter.DefineEscapeCode(ESCCommand: integer; ESCString: string);
begin
  if ESCCommand > ESC_MAX then Exit;
  fESCList[ESCCommand] := ESCString;
end;

function TRAWPrinter.SetToDefaultPrinter: boolean;
var
  str: array[0..79] of char;

  // formatting output string
  function FetchStr(Text: string): string;
  var
    i: integer;
  begin
    Text := TrimLeft(Text);
    i := Pos(',',Text);
    if i = 0 then Result := Text
      else Result := Copy(Text, 1, i-1);
  end;

begin
  // get printer device profile
  GetProfileString('windows', 'device', '', str, SizeOf(str)-1);
  fPrnName := FetchStr(str);
  Result := (fPrnName <> '');

  // exception on no default printer found
  if not Result then
    raise ERAWPrinterError.Create(errNoDefaultPrinter);
end;

function TRAWPrinter.BeginDoc: boolean;
var
  i: integer;
  tmpdata: string;
  DocInfo: TDocInfo1;
  saveFontName: TRAWPrinterFontName;
  saveFontPitch: TRAWPrinterFontPitch;
  saveFontStyle: TRAWPrinterFontStyle;
begin
  // reset page and line pos
  fCurrentPage  := 1;
  fCurrentLine  := 0;

  // open printer
  if (fPrnStatus = rpsClosed) then
  begin
    if (fPrnName = '') then SetToDefaultPrinter;
    if OpenPrinter(PChar(fPrnName), fPrnHandle, nil) then fPrnStatus := rpsOpened
      else raise ERAWPrinterError.Create(Format(errPrinterError, [fPrnName]));
  end;

  // start new job
  if (fPrnStatus = rpsOpened) then
  begin
    with DocInfo do
    begin
      pDocName := PChar(fDocTitle);
      pOutputFile := nil;
      pDatatype := 'RAW';
    end;
    if (StartDocPrinter(fPrnHandle, 1, @DocInfo) <> 0) then fPrnStatus := rpsJobStarted
      else raise ERAWPrinterError.Create(Format(errPrintingError, [fDocTitle]));
  end;

  // start new page
  if (fPrnStatus = rpsJobStarted) then
    if StartPagePrinter(fPrnHandle) then fPrnStatus := rpsPageStarted
      else raise ERAWPrinterError.Create(Format(errPrintingError, [fDocTitle]));

  // raise OnBeforePrint event
  if Assigned(fOnBeforePrint) then fOnBeforePrint(self);

  // page margin setting
  if fPrnStatus = rpsPageStarted then
  begin
    // initialize printer (if required)
    if fInitPrinter then
    begin
      tmpdata := fESCList[ESC_INIT];
      WriteToPrinter(tmpdata,Length(tmpdata));
    end;

    // save selected font
    saveFontName := fFontName;
    saveFontPitch := fFontPitch;
    saveFontStyle := fFontStyle;

    // set font for margin
    SetFontName(rfnCourier);
    SetFontPitch(rfpCondensed);
    SetFontStyle([]);

    // set top margin
    for i := 1 to fTopMargin do
    begin
      case fNewLineCode of
        nlLF: tmpdata := SC_LINE_FEED;
        nlCR: tmpdata := SC_CARRIAGE_RETURN;
        nlLFCR: tmpdata := SC_LF_CR;
        nlCRLF: tmpdata := SC_CR_LF;
      end;
      WriteToPrinter(tmpdata,Length(tmpdata));
    end;

    // set left margin
    tmpdata := AddSpace(fLeftMargin,'');
    WriteToPrinter(tmpdata,Length(tmpdata));

    // set selected font
    SetFontName(saveFontName);
    SetFontPitch(saveFontPitch);
    SetFontStyle(saveFontStyle);
  end;

  Result := (fPrnStatus = rpsPageStarted);
end;

function TRAWPrinter.EndDoc: boolean;
var
  tmpdata: string;
begin
  // eject paper
  if fEjectPaper and (fCurrentLine <> fPageHeight) then
  begin
    tmpdata := SC_FORM_FEED;
    WriteToPrinter(tmpdata,Length(tmpdata));
  end;

  // end printing process
  if (fPrnStatus = rpsPageStarted) then
    if EndPagePrinter(fPrnHandle) then fPrnStatus:= rpsJobStarted
      else raise ERAWPrinterError.Create(Format(errPrintingError, [fDocTitle]));
  if (fPrnStatus = rpsJobStarted) then
    if EndDocPrinter(fPrnHandle) then fPrnStatus := rpsOpened
      else raise ERAWPrinterError.Create(Format(errPrintingError, [fDocTitle]));
  if (fPrnStatus = rpsOpened) then
    if ClosePrinter(fPrnHandle) then fPrnStatus := rpsClosed
      else raise ERAWPrinterError.Create(Format(errPrintingError, [fPrnName]));

  Result := (fPrnStatus = rpsClosed);

  // raise OnAfterPrint event
  if Assigned(fOnAfterPrint) then fOnAfterPrint(self);
end;

function TRAWPrinter.Abort: boolean;
begin
  // end printing process while printing
  if (fPrnStatus > rpsOpened) then
    if AbortPrinter(fPrnHandle) then fPrnStatus := rpsOpened
      else raise ERAWPrinterError.Create(Format(errPrintingError, [fPrnName]));

  // end printing process while not printing
  if (fPrnStatus = rpsOpened) then
    if ClosePrinter(fPrnHandle) then fPrnStatus := rpsClosed
      else raise ERAWPrinterError.Create(Format(errPrintingError, [fPrnName]));

  Result:= (fPrnStatus = rpsClosed);
end;

function TRAWPrinter.WriteToPrinter(const Buffer; Count: integer): DWord;
begin
  // write directly to printer device
  { ----
    Note:
    This method is also able to send Escape command sequences directly,
    so you're no longer need to call Win32 API complicated Escape() function.
  }
  Result := 0;
  if (fPrnStatus = rpsPageStarted) then
    WritePrinter(fPrnHandle, Pointer(Buffer), Count, Result);
end;

function TRAWPrinter.Write(const Text: string): boolean;
var
  saveFontName: TRAWPrinterFontName;
  saveFontPitch: TRAWPrinterFontPitch;
  saveFontStyle: TRAWPrinterFontStyle;
  success: boolean;
  tmpdata: string;
  i,p: integer;
begin
  // write to printer device
  success := (WriteToPrinter(Text,Length(Text)) <> 0);

  // page handling
  if success then
  begin
    // new line
    case fNewLineCode of
      nlLF: p := Pos(SC_LF_CR,Text);
      nlCR: p := Pos(SC_CARRIAGE_RETURN,Text);
      nlLFCR: p := Pos(SC_LF_CR,Text);
      nlCRLF: p := Pos(SC_CR_LF,Text);
    end;

    if (p <> 0) then
    begin
      // update page line
      fCurrentLine := fCurrentLine+1;

      // save selected font
      saveFontName := fFontName;
      saveFontPitch := fFontPitch;
      saveFontStyle := fFontStyle;

      // set font for margin
      SetFontName(rfnCourier);
      SetFontPitch(rfpCondensed);
      SetFontStyle([]);

      // set left margin
      tmpdata := AddSpace(fLeftMargin,'');
      WriteToPrinter(tmpdata,Length(tmpdata));

      // set selected font
      SetFontName(saveFontName);
      SetFontPitch(saveFontPitch);
      SetFontStyle(saveFontStyle);
    end;

    // new page
    if fCurrentLine >= fPageHeight then
    begin
      // eject paper
      case fNewLineCode of
        nlLF: tmpdata := SC_LINE_FEED+SC_FORM_FEED;
        nlCR: tmpdata := SC_CARRIAGE_RETURN+SC_FORM_FEED;
        nlLFCR: tmpdata := SC_LF_CR+SC_FORM_FEED;
        nlCRLF: tmpdata := SC_CR_LF+SC_FORM_FEED;
      end;
      WriteToPrinter(tmpdata,Length(tmpdata));

      // end page printing
      if EndPagePrinter(fPrnHandle) then fPrnStatus:= rpsJobStarted
        else raise ERAWPrinterError.Create(Format(errPrintingError, [fDocTitle]));

      // update page number
      fCurrentPage := fCurrentPage+1;
      fCurrentLine := 0;
      
      // raise OnNewPage event
      if Assigned(fOnNewPage) then fOnNewPage(self);

      // start new page printing
      if StartPagePrinter(fPrnHandle) then fPrnStatus := rpsPageStarted
        else raise ERAWPrinterError.Create(Format(errPrintingError, [fDocTitle]));

      // save selected font
      saveFontName := fFontName;
      saveFontPitch := fFontPitch;
      saveFontStyle := fFontStyle;

      // set font for margin
      SetFontName(rfnCourier);
      SetFontPitch(rfpCondensed);
      SetFontStyle([]);

      // set top margin
      for i := 1 to fTopMargin do
      begin
        case fNewLineCode of
          nlLF: tmpdata := SC_LINE_FEED;
          nlCR: tmpdata := SC_CARRIAGE_RETURN;
          nlLFCR: tmpdata := SC_LF_CR;
          nlCRLF: tmpdata := SC_CR_LF;
        end;
        WriteToPrinter(tmpdata,Length(tmpdata));
      end;

      // set selected font
      SetFontName(saveFontName);
      SetFontPitch(saveFontPitch);
      SetFontStyle(saveFontStyle);
    end;
  end;

  Result := success;
end;

function TRAWPrinter.WriteLn: boolean;
begin
  Result := NewLine;
end;

function TRAWPrinter.WriteLn(const Text: string): boolean;
begin
  case fNewLineCode of
    nlLF: Result := Write(Text+SC_LINE_FEED);
    nlCR: Result := Write(Text+SC_CARRIAGE_RETURN);
    nlLFCR: Result := Write(Text+SC_LF_CR);
    nlCRLF: Result := Write(Text+SC_CR_LF);
  end;
end;

procedure TRAWPrinter.WriteList(const TextList: msestringarty; IsFormatted: boolean = false);
var
  i: integer;
begin
  // write a string array content at once
  for i := 0 to length(TextList)-1 do 
    if IsFormatted then
      WriteLn(DecodeFormattedText(TextList[i]))
    else
      WriteLn(TextList[i]);
end;

procedure TRAWPrinter.WriteColumn(Text: string; Width: integer; Alignment: TAlignment);
var
  left,right: integer;
  fStyle: TRAWPrinterFontStyle;
begin
  // cut text if exceed width
  if Length(Text) >= Width then 
    Text := Copy(Text,1,Width-1);

  // count left space
  case Alignment of
    taRightJustify: left := Width - Length(Text);
    taCenter      : left := (Width div 2) - (Length(Text) div 2);
    else            left := 0;
  end;
  if left < 0 then left := 0;
  // count right space
  right := Width - (left+Length(Text));

  // save font style
  fStyle := fFontStyle;
  // write aligned text
  SetFontStyle([]);
  Write(AddSpace(left,''));
  SetFontStyle(fStyle);
  Write(Text);
  SetFontStyle([]);
  Write(AddSpace(right,''));
  // set font style
  SetFontStyle(fStyle);
end;

function TRAWPrinter.NewLine: boolean;
begin
  // write new line code
  case fNewLineCode of
    nlLF: Result := Write(SC_LINE_FEED);
    nlCR: Result := Write(SC_CARRIAGE_RETURN);
    nlLFCR: Result := Write(SC_LF_CR);
    nlCRLF: Result := Write(SC_CR_LF);
  end;
end;

function TRAWPrinter.NewPage: boolean;
begin
  Result := Write(SC_FORM_FEED);
end;

{ printer configuration methods }

procedure TRAWPrinter.SetFontName(aFontName: TRAWPrinterFontName);
begin
  fFontName := aFontName;

  // apply font typeface selection
  case fFontName of
    rfnCourier: Write(fESCList[ESC_COURIER]);
    rfnRoman  : Write(fESCList[ESC_ROMAN]);
  end;

  // appropriate font pitch
  SetFontPitch(fFontPitch);
end;

procedure TRAWPrinter.SetFontPitch(aFontPitch: TRAWPrinterFontPitch);
begin
  // toggle double width status
  Write(fESCList[ESC_NOT_DOUBLED]);

  fFontPitch := aFontPitch;

  // apply font pitch selection
  case fFontPitch of
    rfpNormal: 
    begin
      Write(fESCList[ESC_NORMAL]);
      //fPageWidth := 98;
    end;
    rfpCondensed: 
    begin
      Write(fESCList[ESC_CONDENSED]);
      //fPageWidth := 140;
    end;
    rfpExpanded: 
    begin
      Write(fESCList[ESC_EXPANDED]);
      //fPageWidth := 82;
    end;
    rfpDoubled: 
    begin
      Write(fESCList[ESC_DOUBLED]);
      //fPageWidth := 41;
    end;
  end;
end;

procedure TRAWPrinter.SetFontStyle(aFontStyle: TRAWPrinterFontStyle);
begin
  fFontStyle := aFontStyle;

  if rfsBold in fFontStyle then Write(fESCList[ESC_BOLD]) else Write(fESCList[ESC_NOT_BOLD]);
  if rfsItalic in fFontStyle then Write(fESCList[ESC_ITALIC]) else Write(fESCList[ESC_NOT_ITALIC]);
  if rfsUnderline in fFontStyle then Write(fESCList[ESC_UNDERLINE]) else Write(fESCList[ESC_NOT_UNDERLINE]);
  if rfsStrike in fFontStyle then Write(fESCList[ESC_STRIKE]) else Write(fESCList[ESC_NOT_STRIKE]);
  if rfsSubScript in fFontStyle then Write(fESCList[ESC_SUB]) else Write(fESCList[ESC_NOT_SUB]);
  if rfsSuperScript in fFontStyle then Write(fESCList[ESC_SUPER]) else Write(fESCList[ESC_NOT_SUPER]);
end;

procedure TRAWPrinter.SetPrnCommand(aCommandType: TRAWPrinterCommand);
begin
  fPrnCommand := aCommandType;
  
  case fPrnCommand of
    // Epson's ESC command list, taken from Epson LX-300 User Manual
    rpcEpson: 
    begin
      fESCList[ESC_INIT]          := #27'@';
      fESCList[ESC_COURIER]       := #27'x0';
      fESCList[ESC_ROMAN]         := #27'x1';
      fESCList[ESC_NORMAL]        := #18#27'M';
      fESCList[ESC_CONDENSED]     := #15;
      fESCList[ESC_EXPANDED]      := #27'P';
      fESCList[ESC_DOUBLED]       := #27'W1';
      fESCList[ESC_NOT_DOUBLED]   := #27'W0';
      fESCList[ESC_BOLD]          := #27'E';
      fESCList[ESC_NOT_BOLD]      := #27'F';
      fESCList[ESC_ITALIC]        := #27'4';
      fESCList[ESC_NOT_ITALIC]    := #27'5';
      fESCList[ESC_UNDERLINE]     := #27'-1';
      fESCList[ESC_NOT_UNDERLINE] := #27'-0';
      fESCList[ESC_STRIKE]        := #27'G';        
      fESCList[ESC_NOT_STRIKE]    := #27'H';        
      fESCList[ESC_SUB]           := #27'S1';
      fESCList[ESC_NOT_SUB]       := #27'T';
      fESCList[ESC_SUPER]         := #27'S0';
      fESCList[ESC_NOT_SUPER]     := #27'T';
    end;
    
    // IBM's ESC command list, taken from: IBM 9068A Passbook Printer Programming Guide
    // Note: Printer must be set to Proprinter emulation mode 
    rpcIBM:
    begin
      fESCList[ESC_INIT]          := '';
      fESCList[ESC_COURIER]       := #27#73#8;
      fESCList[ESC_ROMAN]         := #27#73#10;
      fESCList[ESC_NORMAL]        := #27#58;
      fESCList[ESC_CONDENSED]     := #27#15;
      fESCList[ESC_EXPANDED]      := #27#18;
      fESCList[ESC_DOUBLED]       := #27'W1';
      fESCList[ESC_NOT_DOUBLED]   := #27'W0';
      fESCList[ESC_BOLD]          := #27'E';
      fESCList[ESC_NOT_BOLD]      := #27'F';
      fESCList[ESC_ITALIC]        := #27'G';
      fESCList[ESC_NOT_ITALIC]    := #27'H';
      fESCList[ESC_UNDERLINE]     := #27'-1';
      fESCList[ESC_NOT_UNDERLINE] := #27'-0';
      fESCList[ESC_STRIKE]        := #27'_1';        
      fESCList[ESC_NOT_STRIKE]    := #27'_0';        
      fESCList[ESC_SUB]           := '';
      fESCList[ESC_NOT_SUB]       := '';
      fESCList[ESC_SUPER]         := '';
      fESCList[ESC_NOT_SUPER]     := '';
    end;
  end;
end;

procedure TRAWPrinter.SetPrnMode(aPrintingMode: TRAWPrinterMode);
begin
  { ----
    Note:
    RAW mode not just able to print in text mode (character unit),
    it also able to print in graphic mode (pixel unit). This method
    should enables pixel printing on RAW mode by sending printing
    mode selection into the printer device.

    By enabling graphic mode, this class should be enhanced to handle
    pixel printing, e.g.:
    - DrawImage() with TImage parameter which to be drawn.
    - DrawShape() with TShape parameter which to be drawn.

    Until this version, I do not develop the graphic mode yet.

    But, it'd nice if there is someone would do it. :)
    Don't forget to send the enhancement of this class to me
    and the original class author (see file header).
  }

  //fPrnMode := aPrintingMode;
  fPrnMode := rpmText;
end;

end.

