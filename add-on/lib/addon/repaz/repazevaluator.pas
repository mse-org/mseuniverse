{*********************************************************}
{                   TRepazEvaluator                       }
{*********************************************************}
{            Copyright (c) 2011 Sri Wahono                }
{*********************************************************}
{ License Agreement:                                      }
{ This library is distributed in the hope that it will be }
{ useful, but WITHOUT ANY WARRANTY; without even the      }
{ implied warranty of MERCHANTABILITY or FITNESS FOR      }
{ A PARTICULAR PURPOSE.  See the GNU Lesser General       }
{ Public License for more details.                        }
{                                                         }
{ The source code of the Repaz libraries and packages are }
{ distributed under the Library GNU General Public        }
{ License with the following  modification:               }
{ As a special exception, the copyright holders of this   }
{ library give you permission to link this library with   }
{ independent modules to produce an executable,           }
{ regardless of the license terms of these independent    }
{ modules, and to copy and distribute the resulting       }
{ executable under terms of your choice, provided that    }
{ you also meet, for each linked independent module,      }
{ the terms and conditions of the license of that module. }
{ An independent module is a module which is not derived  }
{ from or based on this library.                          }
{                                                         }
{ Feel free to participate with reports bug, create new   }
{ report template, etc with join with Repaz forum  :      }
{                                                         }
{                http://www.msegui.org/repaz              }
{                                                         }
{*********************************************************}
unit repazevaluator;

interface

uses
  sysutils,classes,db,repazevaluatortype,msestrings,
  sysconst,repazevaluatorparser,variants,repazdatasources,repazconsts,
  mseconsts,msesysutils;

type
 trepazcustomevaluator=class(tcomponent)
 private
  evalfunctions:tstringlist;
  ferror:string;
  fposerror:longint;
  flineerror:word;
  repazevalparser:tmseevalparser;
  fexpression:msestring;
  fevalresult:variant;
  fidentifiers:tstringlist;
  fpartial:variant;
  fchecking:boolean;
  fwithreport,fwitherror: boolean;
  procedure setexpression(value:msestring);
  procedure variables(var value:variant);
  procedure separator(var value:variant);
  procedure logicalor(var value:variant);
  procedure logicaland(var value:variant);
  procedure comparations(var value:variant);
  procedure sum_dif(var value:variant);
  procedure mul_div(var value:variant);
  procedure dosign(var value:variant);
  procedure executeiif(var value:variant);
  procedure parentesis(var value:variant);
  procedure operand(var value:variant);
  function evaluateexpression:variant;
  function searchwithoutdot(name1:shortstring):tevalidentifier;
  function getevalresultstring:msestring;
  procedure addidentifiers;
  procedure freeevalfunctions;
  procedure initevalfunctions;
  procedure fillfunctions;
 protected
  procedure notification(acomponent:tcomponent;operation:toperation);override;
 public
  fevaldatasource:trepazdatasources;
  evaluating:boolean;
  constructor create(aowner:tcomponent);override;
  constructor createfromreport(aowner:tcomponent);
  constructor createwithoutiden(aowner:tcomponent;addidens:boolean);
  destructor destroy;override;
  procedure addvariable(name1:string;objecte:tevalidentifier);
  procedure addiden(name1:string;objecte:tevalidentifier);
  function newvariable(name1:string;valueini:variant;ahelp:string=''):tidenvariable;
  procedure setvariable(varname:string; varvalue:variant);
  function searchidentifier(name1:shortstring):tevalidentifier;
  procedure evaluate;
  function evaluatetext(text:msestring):variant;
  procedure checksyntax;
  property expression:msestring read fexpression write setexpression;
  property evalresult:variant read fevalresult;
  property identifiers:tstringlist read fidentifiers
   write fidentifiers;
  property checking:boolean read fchecking;
  property error:string read ferror;
  property poserror:longint read fposerror;
  property lineerror:word read flineerror;
  property evalresultstring:msestring read getevalresultstring;
  property datasource:trepazdatasources read fevaldatasource write fevaldatasource;
  property withreport: boolean read fwithreport write fwithreport default false;
  property witherrorreport: boolean read fwitherror write fwitherror default false;
 end;

 trepazevaluator = class(trepazcustomevaluator)
  published
   property datasource;
   property evalresult;
   property expression;
   property withreport;
  end;

var
 aholidays : array of tdatetime;
 adiscountdays : array of tdatetime;
 
function evaluateexpression(aexpression:msestring):variant;
procedure addholiday(adate: tdatetime);
procedure removeholiday(adate: tdatetime);
procedure adddiscountday(adate: tdatetime);
procedure removediscountday(adate: tdatetime);

implementation

uses repazevaluatorfunc,repazclasses,dateutils;

{ trepazcustomevaluator }

constructor trepazcustomevaluator.createwithoutiden(aowner:tcomponent;addidens:boolean);
begin
 inherited create(aowner);
 evaluating:=false;
 fexpression:='';
 repazevalparser:=tmseevalparser.create;
 fidentifiers:=tstringlist.create;
 if addidens then begin
  addidentifiers;
 end;
end;

constructor trepazcustomevaluator.create(aowner:tcomponent);
begin
 inherited create(aowner);
 initevalfunctions;
 evaluating:=false;
 fwitherror:= true;
 fexpression:='';
 repazevalparser:=tmseevalparser.create;
 fidentifiers:=tstringlist.create;
 addidentifiers;
 fwithreport:= false;
end;

constructor trepazcustomevaluator.createfromreport(aowner:tcomponent);
begin
 inherited create(aowner);
 fwithreport:= true;
 initevalfunctions;
 evaluating:=false;
 fwitherror:= false;
 fexpression:='';
 repazevalparser:=tmseevalparser.create;
 fidentifiers:=tstringlist.create;
 addidentifiers;
end;

procedure trepazcustomevaluator.fillfunctions;
var
 iden:tevalidentifier;
begin
 if evalfunctions.count>0 then exit;
 iden:=tidentrue.create(self);
 evalfunctions.addobject('True',iden);
 iden:=tidenfalse.create(self);
 evalfunctions.addobject('False',iden);

 // datetime constants
 iden:=tidentoday.create(self);
 evalfunctions.addobject('Today',iden);
 iden:=tidentime.create(self);
 evalfunctions.addobject('Time',iden);
 iden:=tidennow.create(self);
 evalfunctions.addobject('Now',iden);

 // null constant
 iden:=tidennull.create(self);
 evalfunctions.addobject('Null',iden);

 // functions
 iden:=tidensinus.create(self);
 evalfunctions.addobject('SIN',iden);
 iden:=tidenmax.create(self);
 evalfunctions.addobject('MAX',iden);
 iden:=tidenmin.create(self);
 evalfunctions.addobject('MIN',iden);
 iden:=tidenfloattodatetime.create(self);
 evalfunctions.addobject('FloatToDateTime',iden);
 iden:=tidenstringtotime.create(self);
 evalfunctions.addobject('StringToTime',iden);
 iden:=tidenstringtodatetime.create(self);
 evalfunctions.addobject('StringToDateTime',iden);
 iden:=tidentimetostring.create(self);
 evalfunctions.addobject('TimeToString',iden);
 iden:=tidendatetimetostring.create(self);
 evalfunctions.addobject('DateTimeToString',iden);
 iden:=tidendayofweek.create(self);
 evalfunctions.addobject('DayOfWeek',iden);
 iden:=tidenround.create(self);
 evalfunctions.addobject('Round',iden);
 iden:=tidenroundtointeger.create(self);
 evalfunctions.addobject('RoundToInteger',iden);
 iden:=tidenint.create(self);
 evalfunctions.addobject('Int',iden);
 iden:=tidenabs.create(self);
 evalfunctions.addobject('ABS',iden);
 iden:=tidencomparevalue.create(self);
 evalfunctions.addobject('CompareValue',iden);
 iden:=tidensqrt.create(self);
 evalfunctions.addobject('SQRT',iden);
 iden:=tidenisinteger.create(self);
 evalfunctions.addobject('IsInteger',iden);
 iden:=tidenisnumeric.create(self);
 evalfunctions.addobject('IsNumeric',iden);
 iden:=tidenisvaliddatetime.create(self);
 evalfunctions.addobject('IsValidDateTime',iden);
 iden:=tidencheckexpression.create(self);
 evalfunctions.addobject('CheckExpression',iden);
 iden := tidenstringtobin.create(self);
 evalfunctions.addobject('StringToBin', iden);

 iden:=tidenstr.create(self);
 evalfunctions.addobject('Str',iden);
 iden:=tidenval.create(self);
 evalfunctions.addobject('Val',iden);
 iden:=tidenleft.create(self);
 evalfunctions.addobject('Left',iden);
 iden:=tidenlength.create(self);
 evalfunctions.addobject('Length',iden);
 iden:=tidentrim.create(self);
 evalfunctions.addobject('Trim',iden);
 iden:=tidenpos.create(self);
 evalfunctions.addobject('Pos',iden);
 iden:=tidenmodul.create(self);
 evalfunctions.addobject('Mod',iden);
 iden:=tidendivide.create(self);
 evalfunctions.addobject('Div',iden);
 iden:=tidenmonthname.create(self);
 evalfunctions.addobject('MonthName',iden);
 iden:=tidenmonth.create(self);
 evalfunctions.addobject('Month',iden);
 iden:=tidenyear.create(self);
 evalfunctions.addobject('Year',iden);
 iden:=tidenday.create(self);
 evalfunctions.addobject('Day',iden);
 iden:=tidenright.create(self);
 evalfunctions.addobject('Right',iden);
 iden:=tidensubstr.create(self);
 evalfunctions.addobject('SubStr',iden);
 iden:=tidenformatstr.create(self);
 evalfunctions.addobject('FormatStr',iden);
 iden:=tidenformatnum.create(self);
 evalfunctions.addobject('FormatNum',iden);
 iden:=tidenuppercase.create(self);
 evalfunctions.addobject('UpperCase',iden);
 iden:=tidenlowercase.create(self);
 evalfunctions.addobject('LowerCase',iden);
 iden:=tidenevaltext.create(self);
 evalfunctions.addobject('EvalText',iden);
 iden:=tidennumtotext.create(self);
 evalfunctions.addobject('NumToText',iden);
 iden:=tidenreplacestr.create(self);
 evalfunctions.addobject('ReplaceStr',iden);
 iden:=tidenfieldwithkey.create(self);
 evalfunctions.addobject('FieldWithKey',iden);
 iden:=tidensumfield.create(self);
 evalfunctions.addobject('SumField',iden);
 iden:=tidenisholiday.create(self);
 evalfunctions.addobject('IsHoliday',iden);
 iden:=tidenisdiscountday.create(self);
 evalfunctions.addobject('IsDiscountday',iden);
 if fwithreport then begin
  iden:=tidenpagenumber.create(self);
  evalfunctions.addobject('PageNumber',iden);
  iden:=tidenreportheader.create(self);
  evalfunctions.addobject('ReportHeader',iden); 
  iden:=tidenreportfooter.create(self);
  evalfunctions.addobject('ReportFooter',iden); 
  iden:=tidenpageheader.create(self);
  evalfunctions.addobject('PageHeader',iden); 
  iden:=tidenpagefooter.create(self);
  evalfunctions.addobject('PageFooter',iden); 
  iden:=tidencontentheader.create(self);
  evalfunctions.addobject('ContentHeader',iden); 
  iden:=tidencontentfooter.create(self);
  evalfunctions.addobject('ContentFooter',iden); 
  iden:=tidentableheader.create(self);
  evalfunctions.addobject('TableHeader',iden); 
  iden:=tidentablefooter.create(self);
  evalfunctions.addobject('TableFooter',iden); 
  iden:=tidencontentdata.create(self);
  evalfunctions.addobject('ContentData',iden); 
  iden:=tidengroupheader.create(self);
  evalfunctions.addobject('GroupHeader',iden); 
  iden:=tidengroupfooter.create(self);
  evalfunctions.addobject('GroupFooter',iden); 
  iden:=tidengroupdata.create(self);
  evalfunctions.addobject('GroupData',iden); 
  iden:=tidenrecordnumber.create(self);
  evalfunctions.addobject('RecordNumber',iden); 
  iden:=tidenmasternumber.create(self);
  evalfunctions.addobject('MasterNumber',iden); 
  iden:=tidendatanumber.create(self);
  evalfunctions.addobject('DataNumber',iden); 
  iden:=tidengroupnumber.create(self);
  evalfunctions.addobject('GroupNumber',iden); 
  iden:=tidenheadertreekey.create(self);
  evalfunctions.addobject('HeaderTreeKey',iden); 
  iden:=tidenfootertreekey.create(self);
  evalfunctions.addobject('FooterTreeKey',iden); 
  iden:=tidentreefootervalue.create(self);
  evalfunctions.addobject('TreeFooterValue',iden); 
  iden:=tidentreefootervalue2.create(self);
  evalfunctions.addobject('TreeFooterValue2',iden); 
  iden:=tidenlettervalue.create(self);
  evalfunctions.addobject('LetterValue',iden); 
 end;
end;

// adds the identifiers that are on cache
procedure trepazcustomevaluator.addidentifiers;
var
 i:integer;
begin
 fillfunctions;
 for i:=0 to evalfunctions.count-1 do begin
  fidentifiers.addobject(evalfunctions.strings[i],evalfunctions.objects[i]);
 end;
end;

destructor trepazcustomevaluator.destroy;
begin
 if repazevalparser<>nil then begin
  repazevalparser.free;
 end;
 fidentifiers.free;
 freeevalfunctions;
 inherited destroy;
end;

procedure trepazcustomevaluator.setexpression(value:msestring);
begin
 if evaluating then begin
  if fwitherror then begin
   raise exception.create(uc(ord(rcssetexpression)));
  end;
  exit;
 end;
 fexpression:=value;
end;

// to evaluate a text we must create another evaluator
function trepazcustomevaluator.evaluatetext(text:msestring):variant;
var
 eval:trepazcustomevaluator;
 oldiden:tstringlist;
begin
 oldiden:=nil;
 if evaluating then begin
  eval:=trepazcustomevaluator.createwithoutiden(self,false);
  try
   oldiden:=eval.identifiers;
   eval.identifiers:=identifiers;
   eval.datasource:=fevaldatasource;
   eval.expression:=text;
   eval.evaluate;
   result:=eval.evalresult;
  finally
   eval.identifiers:=oldiden;
   eval.free;
  end;
 end else begin
  expression:=text;
  evaluate;
  result:=evalresult;
 end;
end;

// checking for syntax
procedure trepazcustomevaluator.checksyntax;
begin
 repazevalparser.expression:=fexpression;
 if repazevalparser.tokenstring='' then begin
  fevalresult:=true;
  exit;
 end;
 fchecking:=true;
 try
  evaluateexpression;
  fevalresult:=true;
 except
  fevalresult:=false;
  if fwitherror then begin
   raise;
  end;
 end;
end;

procedure trepazcustomevaluator.evaluate;
begin
 repazevalparser.expression:=fexpression;
 fchecking:=false;
 if ((repazevalparser.tokenstring='') and (not (repazevalparser.token in [tkstring,towstring]))) then begin
  fevalresult:=true;
  exit;
 end;
 try
  fevalresult:=evaluateexpression;
 except
  if fwitherror then begin
   raise;
  end;
 end;
end;

function trepazcustomevaluator.evaluateexpression:variant;
begin
 fpartial:=varnull;
 try
  evaluating:=true;
  try
   // call the recursive tree to evaluate the expression
   separator(fpartial);
  finally
   evaluating:=false;
  end;
 except
  // we can assign error information here
  on e:ezerodivide do
   begin
    if fwitherror then begin
     ferror:=uc(ord(rcsdivisiozero));
     flineerror:=repazevalparser.sourceline;
     fposerror:=repazevalparser.sourcepos;
     //raise tevalexception.create(ferror,
     //  repazevalparser.tokenstring,flineerror,fposerror);
     raise exception.create(ferror+
       lineend+'token: '+repazevalparser.tokenstring+lineend+
       'line: '+inttostr(flineerror)+lineend+
       'position: '+inttostr(fposerror)+lineend+
       'expression: '+fexpression);
    end;
   end;
  on e:tevalnamedexception do
   begin
    if fwitherror then begin
     ferror:=e.errormessage;
     flineerror:=repazevalparser.sourceline;
     fposerror:=repazevalparser.sourcepos;
     //raise tevalexception.create(ferror+' '''+e.elementerror+'''',
     //    repazevalparser.tokenstring,flineerror,fposerror)
     raise exception.create(ferror+' '''+e.elementerror+''''+lineend+
       'token: '+repazevalparser.tokenstring+lineend+
       'line: '+inttostr(flineerror)+lineend+
       'position: '+inttostr(fposerror)+lineend+
       'expression: '+fexpression);
   end;
   end;
  on eparsererror do
   begin
    if fwitherror then begin
     ferror:=uc(ord(rcsevalsyntax));
     flineerror:=repazevalparser.sourceline;
     fposerror:=repazevalparser.sourcepos;
     //raise tevalexception.create(ferror,
     //   repazevalparser.tokenstring,flineerror,fposerror);
     raise exception.create(ferror+lineend+
       'token: '+repazevalparser.tokenstring+lineend+
       'line: '+inttostr(flineerror)+lineend+
       'position: '+inttostr(fposerror)+lineend+
       'expression: '+fexpression);
    end;
   end;
  on e:tevalexception do
   begin
    if fwitherror then begin
     ferror:=e.errormessage;
     flineerror:=e.errorline;
     fposerror:=e.errorposition;
     raise exception.create(ferror+lineend+
       'line: '+inttostr(flineerror)+lineend+
       'position: '+inttostr(fposerror)+lineend+
       'expression: '+fexpression);
     //raise;
    end;
   end;
  on e:evarianterror do
   begin
    if fwitherror then begin
     if e.message=sinvalidcast then
     begin
      ferror:=uc(ord(rcsevaltype));
      flineerror:=repazevalparser.sourceline;
      fposerror:=repazevalparser.sourcepos;
      //raise tevalexception.create(ferror,
      //    repazevalparser.tokenstring,flineerror,fposerror);
      raise exception.create(ferror+lineend+
       'token: '+repazevalparser.tokenstring+lineend+
       'line: '+inttostr(flineerror)+lineend+
       'position: '+inttostr(fposerror)+lineend+
       'expression: '+fexpression);
     end
     else
      if e.message=sinvalidvarop then
      begin
       ferror:=uc(ord(rcsinvalidoperation));
       flineerror:=repazevalparser.sourceline;
       fposerror:=repazevalparser.sourcepos;
       //raise tevalexception.create(ferror,
       //   repazevalparser.tokenstring,flineerror,fposerror);
       raise exception.create(ferror+lineend+
       'token: '+repazevalparser.tokenstring+lineend+
       'line: '+inttostr(flineerror)+lineend+
       'position: '+inttostr(fposerror)+lineend+
       'expression: '+fexpression);
      end;
    end;
   end;
  else begin
   if fwitherror then begin
    ferror:=uc(ord(rcsevalsyntax));
    flineerror:=repazevalparser.sourceline;
    fposerror:=repazevalparser.sourcepos;
    //raise;
    raise exception.create(ferror+lineend+
      'token: '+repazevalparser.tokenstring+lineend+
      'line: '+inttostr(flineerror)+lineend+
      'position: '+inttostr(fposerror)+lineend+
      'expression: '+fexpression);
   end;
  end;
 end;

 {if repazevalparser.token<>toeof then begin
  ferror:=uc(ord(rcsevalsyntax));
  flineerror:=repazevalparser.sourceline;
  fposerror:=repazevalparser.sourcepos;
  if fwitherror then begin
   //raise tevalexception.create(uc(ord(rcsevalsyntax))+repazevalparser.tokenstring,
   //     repazevalparser.tokenstring,repazevalparser.sourceline,repazevalparser.sourcepos);
   raise exception.create(uc(ord(rcsevalsyntax))+lineend+
      'token: '+repazevalparser.tokenstring+lineend+
      'line: '+inttostr(flineerror)+lineend+
      'position: '+inttostr(fposerror)+lineend+
      'expression: '+fexpression);
  end;    
 end;}
 result:=fpartial;
end;

procedure trepazcustomevaluator.variables(var value:variant);
var
 iden:tevalidentifier;
begin
 if repazevalparser.token=tosymbol then begin
  // exists this identifier?
  iden:=searchidentifier(repazevalparser.tokenstring);
  if iden=nil then begin
   if fwitherror then begin
    raise tevalexception.create(uc(ord(rcsevaldesciden))+':'+
         repazevalparser.tokenstring,repazevalparser.tokenstring,
        repazevalparser.sourceline,repazevalparser.sourcepos);
   end;
   exit;
  end else begin
   iden.evaluator:=self;
   // is a variable?
   if iden.rtype=rtypeidenvariable then begin
    {// is a := , so we must assign
    if repazevalparser.nexttokenis(':=') then
    begin
     repazevalparser.nexttoken;
     // the :=
     repazevalparser.nexttoken;
     // look for the value
     variables(value);
     // if syntax checking not touch the variable
     if (not fchecking) then
      (iden as tidenvariable).value:=value;
     if ((repazevalparser.token=tooperator) and (repazevalparser.tokenstring[1]=';')) then
      separator(value);
    end
    else
     // not a := we must continue
     logicalor(value);}
     value:= (iden as tidenvariable).value;
     logicalor(value);
   end else begin
    // look for it
    logicalor(value);
   end;
  end
 end
 else
 begin
   // look for it
  logicalor(value);
 end;
end;

{**************************************************************************}

procedure trepazcustomevaluator.logicalor(var value:variant);
var
 operador:string[3];
 auxiliar,auxiliar2:variant;
begin
 // first precedes the and operator
 logicaland(value);

 if repazevalparser.token=tooperator then begin
  operador:=lowercase(repazevalparser.tokenstring);
  while (operador='or') do begin
   auxiliar2:=value;
   repazevalparser.nexttoken;
   logicaland(auxiliar);
   // compatible types?
   if (not fchecking) then begin
    value:=logicalortevalvalue(auxiliar2,auxiliar);
   end;
   if repazevalparser.token<>tooperator then
    exit
   else
    operador:=lowercase(repazevalparser.tokenstring);
  end;
 end;
end;

procedure trepazcustomevaluator.logicaland(var value:variant);
var
 operador:string[3];
 auxiliar,auxiliar2:variant;
begin
 comparations(value);       

 if repazevalparser.token=tooperator then begin
  operador:=lowercase(repazevalparser.tokenstring);
  while (operador='and') do begin
   repazevalparser.nexttoken;
   auxiliar2:=value;
   comparations(auxiliar);
   // compatible types?
   if (not fchecking) then
    value:=logicalandtevalvalue(auxiliar2,auxiliar);
   if repazevalparser.token<>tooperator then
    exit
   else
    operador:=lowercase(repazevalparser.tokenstring);
  end;
 end;
end;

procedure trepazcustomevaluator.separator(var value:variant);
begin
 if ((repazevalparser.token=tooperator) and (repazevalparser.tokenstring[1]=';')) then
 begin
  while ((repazevalparser.token=tooperator) and (repazevalparser.tokenstring[1]=';')) do
  begin
   repazevalparser.nexttoken;
   if (repazevalparser.token<>toeof) then
    variables(value);
  end
 end
 else
 begin
  variables(value);
  while ((repazevalparser.token=tooperator) and (repazevalparser.tokenstring[1]=';')) do
  begin
   repazevalparser.nexttoken;
   if (repazevalparser.token<>toeof) then
    variables(value);
  end
 end;
end;

procedure trepazcustomevaluator.comparations(var value:variant);
var
operation:string[3];
auxiliar,auxiliar2:variant;
begin
 sum_dif(value);
 while repazevalparser.token=tooperator do begin
  operation:=repazevalparser.tokenstring;
  if operation='=' then begin
   repazevalparser.nexttoken;
   auxiliar2:=value;
   sum_dif(auxiliar);
   if (not fchecking) then value:=equaltevalvalue(auxiliar2,auxiliar);
  end else if ((operation='<>') or (operation='><')) then begin
   repazevalparser.nexttoken;
   auxiliar2:=value;
   sum_dif(auxiliar);
   if (not fchecking) then value:=diferenttevalvalue(auxiliar2,auxiliar);
  end else if operation='>=' then begin
   repazevalparser.nexttoken;
   auxiliar2:=value;
   sum_dif(auxiliar);
   if (not fchecking) then value:=morethanequaltevalvalue(auxiliar2,auxiliar);
  end else if operation='<=' then begin
   repazevalparser.nexttoken;
   auxiliar2:=value;
   sum_dif(auxiliar);
   if (not fchecking) then value:=lessthanequaltevalvalue(auxiliar2,auxiliar);
  end else if operation='>' then begin
   repazevalparser.nexttoken;
   auxiliar2:=value;
   sum_dif(auxiliar);
   if (not fchecking) then value:=morethantevalvalue(auxiliar2,auxiliar);
  end else if operation='<' then begin
   repazevalparser.nexttoken;
   auxiliar2:=value;
   sum_dif(auxiliar);
   if (not fchecking) then value:=lessthantevalvalue(auxiliar2,auxiliar);
  end else if operation='==' then begin
   repazevalparser.nexttoken;
   auxiliar2:=value;
   sum_dif(auxiliar);
   if (not fchecking) then value:=equalequaltevalvalue(auxiliar2,auxiliar);
  end else if operation=':=' then begin
   if fwitherror then begin
    raise tevalexception.create(uc(ord(rcsevaldescidenleft))+':'+
          repazevalparser.tokenstring,repazevalparser.tokenstring,
         repazevalparser.sourceline,repazevalparser.sourcepos);
   end;
  end else
    exit;
 end;
end;

procedure trepazcustomevaluator.sum_dif(var value:variant);
var operador:string[3];
    auxiliar,auxiliar2:variant;
begin
 mul_div(value);

 if repazevalparser.token=tooperator then
 begin
  operador:=lowercase(repazevalparser.tokenstring);
  while ((operador='+') or (operador='-')) do
  begin
   repazevalparser.nexttoken;
   auxiliar2:=value;
   mul_div(auxiliar);

   // compatible types?
   if (not fchecking) then
   case operador[1] of
    '+':value:=sumtevalvalue(auxiliar2,auxiliar);
    '-':value:=diftevalvalue(auxiliar2,auxiliar);
   end;
   if repazevalparser.token<>tooperator then
    exit
   else
    operador:=lowercase(repazevalparser.tokenstring);
  end;
 end;
end;

procedure trepazcustomevaluator.mul_div(var value:variant);
var operador:string[4];
    auxiliar,auxiliar2:variant;
begin
 dosign(value);

 if repazevalparser.token=tooperator then
 begin
  operador:=lowercase(repazevalparser.tokenstring);
  while ((operador='*') or (operador='/')) do
  begin
   repazevalparser.nexttoken;
   auxiliar2:=value;
   dosign(auxiliar);
   if (not fchecking) then
   case operador[1] of
    '*':value:=multtevalvalue(auxiliar2,auxiliar);
    '/':value:=divtevalvalue(auxiliar2,auxiliar);
   end;
   if repazevalparser.token<>tooperator then
      exit
   else
    operador:=lowercase(repazevalparser.tokenstring);
  end;
 end;
end;

// the sign is same precedence than functions
procedure trepazcustomevaluator.dosign(var value:variant);
var operador:string[4];
    iden:tevalidentifier;
    i:integer;
begin
 iden:=nil;
 operador:='';
 if repazevalparser.token=tooperator then begin
  operador:=lowercase(repazevalparser.tokenstring);
  if ((operador='+') or (operador='-')
       or (operador='not') or (operador='iif')) then begin
   repazevalparser.nexttoken;
  end;
 end else if repazevalparser.token=tosymbol then begin
  iden:=searchidentifier(repazevalparser.tokenstring);
  if iden=nil then begin
   if fwitherror then begin
    raise tevalexception.create(uc(ord(rcsevaldesciden))+
       repazevalparser.tokenstring,repazevalparser.tokenstring,
      repazevalparser.sourceline,repazevalparser.sourcepos);
   end;
   exit;
  end;
  if (iden.rtype=rtypeidenfunction) or (iden.rtype=rtypeidenreport) then begin
   iden.evaluator:=self;
   // ok is a function assign params
   if iden.paramcount>0 then begin
    repazevalparser.nexttoken;
    if fwitherror then begin
     if repazevalparser.token<>tooperator then
        raise tevalexception.create(uc(ord(rcsevalparent))+' ('+
        repazevalparser.tokenstring,' ( '+repazevalparser.tokenstring,repazevalparser.sourceline,
        repazevalparser.sourcepos);
     if repazevalparser.tokenstring<>'(' then
        raise tevalexception.create(uc(ord(rcsevalparent))+
        repazevalparser.tokenstring,'('+repazevalparser.tokenstring,repazevalparser.sourceline,
        repazevalparser.sourcepos);
    end;
   end;
   for i:=0 to iden.paramcount-1 do begin
    // next param
    repazevalparser.nexttoken;
    // look for the value
    separator(iden.params[i]);
    // param separator is ','
    if iden.paramcount>i+1 then begin
     if fwitherror then begin
      if repazevalparser.token<>tooperator then
       raise tevalexception.create(uc(ord(rcsevalsyntax))+
       repazevalparser.tokenstring,repazevalparser.tokenstring,repazevalparser.sourceline,
       repazevalparser.sourcepos);
      if repazevalparser.tokenstring[1]<>',' then
       raise tevalexception.create(uc(ord(rcsevalsyntax))+
       repazevalparser.tokenstring,repazevalparser.tokenstring,repazevalparser.sourceline,
       repazevalparser.sourcepos);
     end;
    end;
   end;
   // now the close ) expected
   if iden.paramcount>0 then begin
    if fwitherror then begin
     if repazevalparser.token<>tooperator then
        raise tevalexception.create(uc(ord(rcsevalparent))+' )'+
        repazevalparser.tokenstring,' ) '+repazevalparser.tokenstring,repazevalparser.sourceline,
        repazevalparser.sourcepos);
     if repazevalparser.tokenstring<>')' then
        raise tevalexception.create(uc(ord(rcsevalparent))+' )'+
        repazevalparser.tokenstring,' ) '+repazevalparser.tokenstring,repazevalparser.sourceline,
        repazevalparser.sourcepos);
    end;
    repazevalparser.nexttoken;
   end;
  end
  else
   // if not a function must be an operator
   iden:=nil;
 end;
 if iden=nil then
 begin
  if operador='iif' then
     executeiif(value)
  else
   parentesis(value)
 end
 else
  if iden.paramcount=0 then
   repazevalparser.nexttoken;

 // if it's a funcion execute it (if not syntax check)
 if iden<>nil then
 begin
  if not fchecking then
   value:=iden.value;
 end
 else
 begin
  if operador='-' then
     if (not fchecking) then
      value:=signtevalvalue(value)
     else
     begin
     end
  else
   if operador='not' then
     if (not fchecking) then
      value:=logicalnottevalvalue(value);
 end;
end;

procedure trepazcustomevaluator.operand(var value:variant);
var
    iden:tevalidentifier;
begin
 case repazevalparser.token of
  tosymbol:
   begin
    // obtaining the value of an identifier
    iden:=searchidentifier(repazevalparser.tokenstring);
    if iden=nil then
    begin
     if fwitherror then begin
      raise tevalexception.create(uc(ord(rcsevaldesciden))+
         repazevalparser.tokenstring,repazevalparser.tokenstring,
        repazevalparser.sourceline,repazevalparser.sourcepos);
     end;
    end;
    iden.evaluator:=self;
    value:=iden.value;
    repazevalparser.nexttoken;
   end;
  tkstring:
   begin
    value:=repazevalparser.tokenstring;
    repazevalparser.nexttoken;
   end;
  towstring:
   begin
    value:=repazevalparser.tokenwidestring;
    repazevalparser.nexttoken;
   end;
  tointeger:
   begin
    value:=repazevalparser.tokenint;
    repazevalparser.nexttoken;
   end;
  tofloat:
   begin
    value:=repazevalparser.tokenfloat;
    repazevalparser.nexttoken;
   end;
  else begin
   if fwitherror then begin
    raise tevalexception.create(uc(ord(rcsevalsyntax))+
         repazevalparser.tokenstring,repazevalparser.tokenstring,
        repazevalparser.sourceline,repazevalparser.sourcepos);
   end;
  end;
 end;
end;

procedure trepazcustomevaluator.parentesis(var value:variant);
var operation:char;
begin
 if repazevalparser.token=tooperator then
 begin
  operation:=repazevalparser.tokenstring[1];
  if operation='(' then
  begin
   repazevalparser.nexttoken;
   // look into the parentesis
   separator(value);
   if fwitherror then begin
    if (repazevalparser.token<>tooperator) then
     raise tevalexception.create(uc(ord(rcsevalparent)),'',
         repazevalparser.sourceline,repazevalparser.sourcepos);
    operation:=repazevalparser.tokenstring[1];
    if (operation<>')') then
       raise tevalexception.create(uc(ord(rcsevalparent)),'',
         repazevalparser.sourceline,repazevalparser.sourcepos);
   end;
   repazevalparser.nexttoken;
  end
  else
   operand(value);
 end
 else
   operand(value);
end;

procedure trepazcustomevaluator.executeiif(var value:variant);
var
 auxiliar:variant;
 anticfchecking:boolean;
begin
 // must be a parentesis
 if fwitherror then begin
  if repazevalparser.token<>tooperator then
    raise tevalexception.create(uc(ord(rcsevalparent)),'(',
       repazevalparser.sourceline,repazevalparser.sourcepos);
  if repazevalparser.tokenstring<>'(' then
    raise tevalexception.create(uc(ord(rcsevalparent)),'(',
       repazevalparser.sourceline,repazevalparser.sourcepos);
 end;
 // decision term
 repazevalparser.nexttoken;
 separator(value);
 // null means false
 if varisnull(value) then
  value:=false;
 // not boolean error
 if fwitherror then begin
  if ((vartype(value)<>varboolean) and (not fchecking)) then
    raise tevalexception.create(uc(ord(rcsevaltype)),'iif',
       repazevalparser.sourceline,repazevalparser.sourcepos);
  // next tokens
  if repazevalparser.token<>tooperator then
    raise tevalexception.create(uc(ord(rcsevalsyntax)),'iif',
       repazevalparser.sourceline,repazevalparser.sourcepos);
  if repazevalparser.tokenstring<>',' then
    raise tevalexception.create(uc(ord(rcsevalsyntax)),'iif',
       repazevalparser.sourceline,repazevalparser.sourcepos);
 end;
 repazevalparser.nexttoken;
 // if yes and not checking syntax
 if not fchecking then
 begin
  if boolean(value) then
  begin
   separator(value);
   // skip the second term
   if fwitherror then begin
    if repazevalparser.token<>tooperator then
      raise tevalexception.create(uc(ord(rcsevalsyntax)),'iif',
         repazevalparser.sourceline,repazevalparser.sourcepos);
    if repazevalparser.tokenstring<>',' then
      raise tevalexception.create(uc(ord(rcsevalsyntax)),'iif',
         repazevalparser.sourceline,repazevalparser.sourcepos);
   end;
   repazevalparser.nexttoken;

   anticfchecking:=fchecking;
   fchecking:=true;
   separator(auxiliar);
   fchecking:=anticfchecking;
  end
  else
  begin
   anticfchecking:=fchecking;
   fchecking:=true;
   separator(auxiliar);

   if fwitherror then begin
    if repazevalparser.token<>tooperator then
      raise tevalexception.create(uc(ord(rcsevalsyntax)),'iif',
         repazevalparser.sourceline,repazevalparser.sourcepos);
    if repazevalparser.tokenstring<>',' then
      raise tevalexception.create(uc(ord(rcsevalsyntax)),'iif',
         repazevalparser.sourceline,repazevalparser.sourcepos);
   end;
   repazevalparser.nexttoken;

   fchecking:=anticfchecking;
   separator(value);
  end;
 end
 else
 // syntax checking
 begin
  // skip the params
  separator(value);
  if fwitherror then begin
   if repazevalparser.token<>tooperator then
     raise tevalexception.create(uc(ord(rcsevalsyntax)),'iif',
        repazevalparser.sourceline,repazevalparser.sourcepos);
   if repazevalparser.tokenstring<>',' then
     raise tevalexception.create(uc(ord(rcsevalsyntax)),'iif',
        repazevalparser.sourceline,repazevalparser.sourcepos);
  end;
  repazevalparser.nexttoken;
  separator(auxiliar);
 end;
 // must be a ) now
 if fwitherror then begin
  if repazevalparser.token<>tooperator then
    raise tevalexception.create(uc(ord(rcsevalparent)),')',
       repazevalparser.sourceline,repazevalparser.sourcepos);
  if repazevalparser.tokenstring<>')' then
    raise tevalexception.create(uc(ord(rcsevalparent)),')',
       repazevalparser.sourceline,repazevalparser.sourcepos);
 end;
 repazevalparser.nexttoken;
end;

procedure trepazcustomevaluator.addvariable(name1:string;objecte:tevalidentifier);
begin
 objecte.idenname:=name1;
 fidentifiers.addobject('v.'+name1,objecte);
end;

procedure trepazcustomevaluator.addiden(name1:string;objecte:tevalidentifier);
begin
 identifiers.addobject(name1,objecte);
end;

function trepazcustomevaluator.searchwithoutdot(name1:shortstring):tevalidentifier;
var
 index:integer;
begin
  result:=nil;
  index:=fidentifiers.indexof(name1);
  if index>=0 then
   result:=fidentifiers.objects[index] as tevalidentifier;
  if assigned(result) then
   exit;
  // memory variable?
  index:=fidentifiers.indexof('v.'+name1);
  if index>=0 then
   result:=fidentifiers.objects[index] as tevalidentifier;
  if assigned(result) then
   exit;
  // may be a field ?
  if fevaldatasource<>nil then
   result:=fevaldatasource.searchfield(name1);
end;

function trepazcustomevaluator.searchidentifier(name1:shortstring):tevalidentifier;
var
 pospunt:byte;
 primer,sensepunt:string;
 index:integer;
begin
 name1:=ansilowercase(name1);
 result:=nil;
 // have a point ?
 pospunt:=pos('.',name1);
 if pospunt=0 then begin
  result:=searchwithoutdot(name1);
  exit;
 end;
 primer:=copy(name1,0,pospunt-1);
  // memory variable ?
 if primer='v' then begin
  index:=fidentifiers.indexof(name1);
  if index>=0 then
   result:=fidentifiers.objects[index] as tevalidentifier;
  exit;
 end;
 sensepunt:=copy(name1,pospunt+1,ord(name1[0])-pospunt);
 if fevaldatasource<>nil then begin
  result:=fevaldatasource.searchfieldwithdataset(primer,sensepunt);
 end;
end;

function trepazcustomevaluator.getevalresultstring:msestring;
begin
 result:=tevalvaluetostring(evalresult);
end;

procedure trepazcustomevaluator.notification(acomponent:tcomponent;operation:toperation);
begin
 inherited notification(acomponent,operation);
 if operation=opremove then
 begin
  if acomponent=fevaldatasource then
   datasource:=nil;
 end;
end;


function trepazcustomevaluator.newvariable(name1:string;valueini:variant;ahelp:string=''):tidenvariable;
var
 iden: tidenvariable;
 var1: tevalidentifier;
begin
 var1:= searchidentifier('v.'+name1);
 if var1=nil then begin
  iden:=tidenvariable.create(self);
  iden.value:= valueini;
  iden.help:= ahelp;
  iden.evaluator:=self;
  addvariable(name1,iden);
  result:=iden;
 end else begin
  // error variable redeclared
  //raise exception.create(uc(ord(rcsvariabledefined))+name1);
  tidenvariable(var1).value:= valueini;
 end;
end;

procedure trepazcustomevaluator.setvariable(varname:string; varvalue:variant);
var
 index: integer;
begin
 index:=fidentifiers.indexof('v.'+varname);
 if index>=0 then begin
  (fidentifiers.objects[index] as tevalidentifier).value:= varvalue;
 end else begin
  if fwitherror then begin
   raise exception.create(varname+' not found!');  
  end;
 end;
end;

procedure trepazcustomevaluator.freeevalfunctions;
var
 i:integer;
begin
 if assigned(evalfunctions) then
 begin
  for i:=0 to evalfunctions.count-1 do
  begin
   evalfunctions.objects[i].free;
  end;
 end;
 evalfunctions.free;
end;

procedure trepazcustomevaluator.initevalfunctions;
begin
 evalfunctions:=tstringlist.create;
 evalfunctions.sorted:=true;
 evalfunctions.duplicates:=duperror;
end;

procedure addholiday(adate: tdatetime);
var
 int1: integer;
 bo1: boolean;
begin
 bo1:= false;
 for int1:=0 to high(aholidays) do begin
  if dateof(adate)=dateof(aholidays[int1]) then begin
   bo1:= true;
   break;
  end;
 end;
 if not bo1 then begin
  setlength(aholidays,length(aholidays)+1);
  aholidays[high(aholidays)]:= adate;
 end;
end;

procedure removeholiday(adate: tdatetime);
var
 int1,int2: integer;
begin
 for int1:=0 to high(aholidays) do begin
  if dateof(adate)=dateof(aholidays[int1]) then begin
   if int1<high(aholidays) then begin
    for int2:= int1+1 to high(aholidays) do begin
     aholidays[int2-1]:= aholidays[int2];
    end;
    setlength(aholidays,length(aholidays)+1);
    break;
   end;
  end;
 end;
end;

procedure adddiscountday(adate: tdatetime);
var
 int1: integer;
 bo1: boolean;
begin
 bo1:= false;
 for int1:=0 to high(adiscountdays) do begin
  if dateof(adate)=dateof(adiscountdays[int1]) then begin
   bo1:= true;
   break;
  end;
 end;
 if not bo1 then begin
  setlength(adiscountdays,length(adiscountdays)+1);
  adiscountdays[high(adiscountdays)]:= adate;
 end;
end;

procedure removediscountday(adate: tdatetime);
var
 int1,int2: integer;
begin
 for int1:=0 to high(adiscountdays) do begin
  if dateof(adate)=dateof(adiscountdays[int1]) then begin
   if int1<high(adiscountdays) then begin
    for int2:= int1+1 to high(adiscountdays) do begin
     adiscountdays[int2-1]:= adiscountdays[int2];
    end;
    setlength(adiscountdays,length(adiscountdays)+1);
    break;
   end;
  end;
 end;
end;

function evaluateexpression(aexpression:msestring):variant;
var
 aeval:trepazevaluator;
begin
 aeval:=trepazevaluator.create(nil);
 try
  aeval.expression:=aexpression;
  aeval.evaluate;
  result:=aeval.evalresult;
 finally
  aeval.free;
 end;
end;

initialization

finalization

end.
