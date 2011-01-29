{*********************************************************}
{           Type definition for TRepazEvaluator           }
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
unit repazevaluatortype;


interface

uses
 msestrings,sysutils,classes,db,variants,repazconsts,mseconsts;

const
 // parser datatypes for constants
 toeof         =      char(0);
 tosymbol      =      char(1);
 tkstring      =      char(2);
 tointeger     =      char(3);
 tofloat       =      char(4);
 tooperator    =      char(5);
 towstring     =      char(6);
 // max number of parameters in a function
 maxparams =  50;

type
 tevaltoken=(toteof,totsymbol,totstring,totinteger,totfloat,totoperator,
   totboolean,totdate,tottime,totdatetime);


 tevalnamedexception=class(exception)
  public
   errormessage:string;
   elementerror:string;
   constructor create(msg,element:string);
 end;
 tevalexception=class(tevalnamedexception)
  public
   errorline:integer;
   errorposition:integer;
   constructor create(msg,element:string;line,position:integer);
 end;

 rtypeidentificator = (rtypeidenfunction,rtypeidenvariable,rtypeidenconstant,rtypeidenreport);

 tevalidentifier=class(tcomponent)
  protected
   fparamcount:integer;
   procedure setevalvalue(avalue:variant);virtual;abstract;
   function getevalvalue:variant;virtual;abstract;
  public
   evaluator:tcomponent;
   rtype:rtypeidentificator;
   idenname:string;
   help:string;
   model:string;
   aparams:string;
   params:array[0..maxparams-1] of variant;
   constructor create(aowner:tcomponent);override;
   property paramcount:integer read fparamcount;
   property value:variant read getevalvalue write setevalvalue;
  end;

 tidenfunction=class(tevalidentifier)
  protected
   procedure setevalvalue(avalue:variant);override;
  public
   constructor create(aowner:tcomponent);override;
  end;

 tidenreport=class(tevalidentifier)
  protected
   procedure setevalvalue(avalue:variant);override;
  public
   constructor create(aowner:tcomponent);override;
  end;

 tidenvariable=class(tevalidentifier)
  protected
   fvalue:variant;
   procedure setevalvalue(avalue:variant);override;
   function getevalvalue:variant;override;
  public
   constructor create(aowner:tcomponent);override;
  end;

 tidenconstant=class(tevalidentifier)
 protected
  fvalue:variant;
  procedure setevalvalue(avalue:variant);override;
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenfield=class(tevalidentifier)
 private
  ffield:tfield;
 protected
  function getevalvalue:variant;override;
  procedure setevalvalue(avalue:variant);override;
 public
  constructor create(aowner:tcomponent);override;
  constructor createfield(aowner:tcomponent;nom:string);
  property field:tfield read ffield write ffield;
 end;

 tidentrue=class(tidenconstant)
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenfalse=class(tidenconstant)
 public
  constructor create(aowner:tcomponent);override;
 end;

// math operations
function sumtevalvalue(value1,value2:variant):variant;
function diftevalvalue(value1,value2:variant):variant;
function multtevalvalue(value1,value2:variant):variant;
function divtevalvalue(value1,value2:variant):variant;
function signtevalvalue(value:variant):variant;
// comp operations
function equaltevalvalue(value1,value2:variant):variant;
function equalequaltevalvalue(value1,value2:variant):variant;
function morethanequaltevalvalue(value1,value2:variant):variant;
function lessthanequaltevalvalue(value1,value2:variant):variant;
function morethantevalvalue(value1,value2:variant):variant;
function lessthantevalvalue(value1,value2:variant):variant;
function diferenttevalvalue(value1,value2:variant):variant;
function isnulltevalvalue(value:variant):boolean;

// logical operations
function logicalandtevalvalue(value1,value2:variant):variant;
function logicalortevalvalue(value1,value2:variant):variant;
function logicalnottevalvalue(value1:variant):variant;

// formatting operations
function tevalvaluetostring(value:variant):msestring;
function formattevalvalue(sformat:string;value:variant;userdef:boolean):string;

// date operation validation
procedure datetimevalidation(var value1,value2:variant);
function varisstring(avar:variant):boolean;
function varisnumber(avar:variant):boolean;
function varisinteger(avar:variant):boolean;
function varisboolean(avar:variant):boolean;
function roundfloat(num:double;redondeo:double):double;
function formatcurradv(mask:string;number:double):string;
function numbertotext(fnumber:currency):msestring;
function numbertotext_en(amount:currency):msestring;
function numbertotext_id(amount:currency):msestring;

var
 defaultdecimals:integer;

implementation

// tevalnamedexception
constructor tevalnamedexception.create(msg,element:string);
begin
 errormessage:=msg;
 elementerror:=element;
 inherited create(errormessage);
end;

// tevalexception
constructor tevalexception.create(msg,element:string;line,position:integer);
begin
 inherited create(msg,element);
 errorline:=line;
 errorposition:=position;
 errormessage:=msg;
 elementerror:=element;
end;

// tevalidentifier
constructor tevalidentifier.create(aowner:tcomponent);
begin
 inherited create(aowner);
 help:=uc(ord(rcsnohelp));
 aparams:=uc(ord(rcsnoaparams));
 model:=uc(ord(rcsnomodel));
end;

// tidenfunction
constructor tidenfunction.create(aowner:tcomponent);
begin
 inherited create(aowner);
 rtype:=rtypeidenfunction;
end;

procedure tidenfunction.setevalvalue(avalue:variant);
begin
 raise tevalnamedexception.create(uc(ord(rcsassignfunc)),idenname);
end;

// tidenreport
constructor tidenreport.create(aowner:tcomponent);
begin
 inherited create(aowner);
 rtype:=rtypeidenreport;
end;

procedure tidenreport.setevalvalue(avalue:variant);
begin
 raise tevalnamedexception.create(uc(ord(rcsAssignReport)),idenname);
end;

// tidentrue
constructor tidentrue.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fvalue:=true;
 rtype:=rtypeidenconstant;
 help:=uc(ord(rcstruehelp));
 idenname:='true';
end;

// tidenfalse
constructor tidenfalse.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fvalue:=false;
 help:=uc(ord(rcsfalsehelp));
 idenname:='false';
end;

// tidenvariable
constructor tidenvariable.create(aowner:tcomponent);
begin
 inherited create(aowner);
 rtype:=rtypeidenvariable;
end;

function tidenvariable.getevalvalue:variant;
begin
 result:=fvalue;
end;

procedure tidenvariable.setevalvalue(avalue:variant);
begin
 fvalue:= avalue;
end;

// tidenconstant
constructor tidenconstant.create(aowner:tcomponent);
begin
 inherited create(aowner);
 rtype:=rtypeidenconstant;
end;

function tidenconstant.getevalvalue:variant;
begin
 result:=fvalue;
end;

procedure tidenconstant.setevalvalue(avalue:variant);
begin
 raise tevalnamedexception.create(uc(ord(rcsassignconst)),idenname);
end;

// tidenfield
constructor tidenfield.create(aowner:tcomponent);
begin
 inherited create(aowner);
end;

constructor tidenfield.createfield(aowner:tcomponent;nom:string);
begin
 inherited create(aowner);
 idenname:=nom;
 help:=uc(ord(rcsfieldhelp));
end;

procedure tidenfield.setevalvalue(avalue:variant);
begin
  raise tevalnamedexception.create(uc(ord(rcsassignfield)),idenname);
end;

function tidenfield.getevalvalue:variant;
begin
 if field=nil then begin
  result:=null;
  exit;
 end;
 result:=field.asvariant;
end;

// math functions
function sumtevalvalue(value1,value2:variant):variant;
var
 atype1,atype2:tvartype;
begin
 if varisnull(value1) then begin
  result:=value2;
 end else if varisnull(value2) then begin
  result:=value1;
 end else begin
  // bugfix suming msestring+string
  // the result should be by default a msestring
  // but it's a string
  atype1:=vartype(value1);
  atype2:=vartype(value2);
  if atype1=atype2 then begin
   result:=value1+value2;
  end else begin
   if atype1=varolestr then begin
    result:=value1+msestring(value2);
   end else if atype2=varolestr then begin
    result:=msestring(value1)+value2;
   end else begin
    result:=value1+value2;
   end;
  end;
 end;
end;

function diftevalvalue(value1,value2:variant):variant;
begin
 if value1=null then begin
  result:=-value2;
 end else begin
  if value2=null then begin
   result:=value1;
  end else begin
   result:=value1-value2;
  end;
 end;
end;

function multtevalvalue(value1,value2:variant):variant;
begin
 result:=value1*value2;
end;

function divtevalvalue(value1,value2:variant):variant;
begin
 try
  if not varisempty(value1) and not varisempty(value2) then begin
   result:=value1/value2;
  end else begin
   result:= 0;
  end;
 except
 end;
end;

function signtevalvalue(value:variant):variant;
begin
 result:=-value;
end;

// formating functions
function tevalvaluetostring(value:variant):msestring;
begin
 if value=null then begin
  result:='';
  exit;
 end;
 case vartype(value) of
  vardate:
   result:=formatdatetime(shortdateformat,tdatetime(value));
  else
   result:=value;
 end;
end;

function formattevalvalue(sformat:string;value:variant;userdef:boolean):string;
var
 index:integer;
 general:boolean;
begin
 if varisnull(value) then
 begin
  result:='';
  exit;
 end;
 case vartype(value) of
  varsmallint..varinteger:
   begin
    if not userdef then begin
     general:=false;
     index:=pos('n',sformat);
     if index<>0 then
      general:=true
     else begin
      index:=pos('f',sformat);
      if index<>0 then
       general:=true
      else begin
       index:=pos('m',sformat);
       if index<>0 then
        general:=true
      end;
     end;
     if general then begin
      if pos('.',sformat)=0 then begin
       insert('.'+inttostr(defaultdecimals),sformat,index);
      end;
     end;
    end;
    if userdef then
     result:=sysutils.formatfloat(sformat,double(value))
    else begin
     index:=pos('d',sformat);
     if index<>0 then
      result:=format(sformat,[integer(value)])
     else
      result:=format(sformat,[double(value)]);
    end;
   end;
  varsingle,vardouble,varcurrency:
   begin
    if not userdef then begin
     general:=false;
     index:=pos('n',sformat);
     if index<>0 then
      general:=true
     else begin
      index:=pos('f',sformat);
      if index<>0 then
       general:=true
      else begin
       index:=pos('m',sformat);
       if index<>0 then begin
        general:=true;
       end;
      end;
     end;
     if (general) then begin
      if pos('.',sformat)=0 then begin
       insert('.'+inttostr(defaultdecimals),sformat,index);
      end;
     end;
    end;
    try
     if userdef then
      result:=sysutils.formatfloat(sformat,double(value))
     else
      result:=format(sformat,[double(value)]);
    except
     if double(value)<>integer(value) then
      raise;
     if userdef then
      result:=sysutils.formatfloat(sformat,double(value))
     else
      result:=format(sformat,[integer(value)]);
    end;
   end;
  varstring:
   if value='' then result:='' else
    result:=format(sformat,[string(value)]);
  varboolean:
   begin
    if userdef then
     result:=sformat
    else
    if boolean(value) then
     result:='true'
    else
     result:='false';
   end;
  vardate:
   begin
    if userdef then begin
     result:=formatdatetime(sformat,tdatetime(value));
    end else begin
     if (sformat='%xl') then begin
      if tdatetime(value)=0 then begin
       result:='';
       exit;
      end;
      if tdatetime(value)<1 then
        result:=formatdatetime(longtimeformat,tdatetime(value))
      else
       if tdatetime(value)-trunc(double(value))=0 then
        result:=formatdatetime(longdateformat,tdatetime(value))
       else
        result:=formatdatetime(longdateformat+' '+longtimeformat,tdatetime(value))
     end else begin
      if tdatetime(value)=0 then begin
       result:='';
       exit;
      end;
      if tdatetime(value)<1 then
        result:=formatdatetime(shorttimeformat,tdatetime(value))
      else
       if tdatetime(value)-trunc(double(value))=0 then
        result:=formatdatetime(shortdateformat,tdatetime(value))
       else
        result:=formatdatetime(shortdateformat+' '+shorttimeformat,tdatetime(value))
     end;
    end;
   end;
  else
   result:='';
 end;
end;

// logical functions

function isnulltevalvalue(value:variant):boolean;
begin
 case vartype(value) of
  varsmallint..vardouble:
   result:=(double(value)=0);
  varstring:
   result:=(string(value)='');
  varboolean:
   result:=not boolean(value);
  vardate:
   result:=(tdatetime(value)=0);
  else
   result:=varisnull(value);
 end;
end;

function logicalandtevalvalue(value1,value2:variant):variant;
begin
 result:=value1 and value2;
end;

function logicalortevalvalue(value1,value2:variant):variant;
begin
 result:=value1 or value2;
end;

function logicalnottevalvalue(value1:variant):variant;
begin
  result:=not value1;
end;

function equaltevalvalue(value1,value2:variant):variant;
begin
 datetimevalidation(value1,value2);
 result:=(value1=value2);
end;

function morethanequaltevalvalue(value1,value2:variant):variant;
begin
 datetimevalidation(value1,value2);
 result:=value1>=value2;
end;

function lessthanequaltevalvalue(value1,value2:variant):variant;
begin
 datetimevalidation(value1,value2);
 result:=(value1<=value2);
end;

function morethantevalvalue(value1,value2:variant):variant;
begin
 datetimevalidation(value1,value2);
 result:=(value1>value2);
end;

function lessthantevalvalue(value1,value2:variant):variant;
begin
 datetimevalidation(value1,value2);
 result:=(value1<value2);
end;

function diferenttevalvalue(value1,value2:variant):variant;
begin
 datetimevalidation(value1,value2);
 result:=(value1<>value2);
end;

function equalequaltevalvalue(value1,value2:variant):variant;
begin
 datetimevalidation(value1,value2);
 result:=(value1=value2);
end;

// date time validation
procedure datetimevalidation(var value1,value2:variant);
begin
 if vartype(value1)=vardate then begin
  if vartype(value2)<>vardate then
   if value2<>null then begin
    value2:=varastype(value2,vardate);
   end;
 end;
 if vartype(value2)=vardate then begin
  if vartype(value1)<>vardate then
   if value1<>null then begin
    value1:=varastype(value1,vardate);
   end;
 end;
end;

function varisstring(avar:variant):boolean;
begin
 result:=false;
 if ((vartype(avar)=varstring) or (vartype(avar)=varolestr)) then
  result:=true;
end;

function varisnumber(avar:variant):boolean;
begin
 result:=(vartype(avar) in [varsmallint,varinteger,varsingle,vardouble,varcurrency,
  varshortint,varbyte,varword,varlongword,varint64]);
end;

function varisinteger(avar:variant):boolean;
begin
 result:=(vartype(avar) in [varsmallint,varinteger,varshortint,varbyte,varword,varlongword,varint64]);
end;

function varisboolean(avar:variant):boolean;
begin
 result:=(vartype(avar) in [varboolean]);
end;

function roundfloat(num:double;redondeo:double):double;
var
 provanum,provaredon,quocient:currency;
 intnum,intredon:comp;
 reste:integer;
 signenum,escala:integer;
begin
 if ((redondeo=0) or (num=0)) then begin
  result:=num;
  exit;
 end;
 if redondeo<0.0001 then begin
  redondeo:=0.0001;
 end;

 // original number
 signenum:=1;
 if num<0 then
  signenum:=-1;
 // has decimal?
 provanum:=abs(num);
 provaredon:=abs(redondeo);
 escala:=1;
 while (frac(provanum)<>0) do begin
  provanum:=provanum*10;
  provaredon:=provaredon*10;
  escala:=escala*10;
 end;
 while (frac(provaredon)<>0) do begin
  provanum:=provanum*10;
  provaredon:=provaredon*10;
  escala:=escala*10;
 end;
 // integers
 intnum:=trunc(provanum);
 intredon:=trunc(provaredon);
// intnum:=int(provanum);
// intredon:=int(provaredon);
 // mod
 quocient:=intnum/intredon;
 reste:=round(intnum-intredon*int(quocient));
 if (reste<(intredon/2)) then
  intnum:=intnum-reste
 else
  intnum:=intnum-reste+intredon;
 result:=intnum/escala*signenum;
end;

function formatcurradv(mask:string;number:double):string;
var
 decseparator:boolean;
 hiddendecseparator:boolean;
 decimalplacesvariable:boolean;
 index:integer;
 leftfillchar:char;
 astring:string;
 intstring,decstring:string;
 decchar:char;
 thchar:char;
 leftmask:string;
 rightmask:string;
 i:integer;
 allzeros:boolean;
 isnegative:boolean;
begin
 isnegative:=number<0;
 if (isnegative) then
  number:=-number;

 decseparator:=true;
 hiddendecseparator:=false;
 leftfillchar:='0';
 rightmask:='';
 decimalplacesvariable:=true;
 decchar:=decimalseparator;
 if decchar=chr(0) then
  decchar:='.';
 thchar:=thousandseparator;
 // decimal separator options
 index:=pos('.',mask);
 if index<1 then begin
  index:=pos(':',mask);
  if index>=0 then
   hiddendecseparator:=true;
 end;
 if index>0 then begin
  if index<length(mask) then begin
   if mask[index+1]='0' then
    decimalplacesvariable:=false;
  end
  else
   decseparator:=false;
 end
 else
  decseparator:=false;
 if not decseparator then
  decimalplacesvariable:=false;
 // right mask
 if index>0 then
  rightmask:=copy(mask,index+1,length(mask));
 // left mask option
 if index=0 then
  index:=length(mask);
 leftmask:='';
 while index>0 do begin
  if mask[index] in ['#',',','0'] then
   leftmask:=leftmask+mask[index];
  dec(index);
 end;

 // fill char options
 index:=pos('l',mask);
 if index>0 then begin
  if index<length(mask) then
   leftfillchar:=mask[index+1];
 end;
 // thousand  char
 index:=pos('t',mask);
 if index>0 then begin
  if index<length(mask) then
   thchar:=mask[index+1];
 end;
 index:=pos('d',mask);
 if index>0 then begin
  if index<length(mask) then
   decchar:=mask[index+1];
 end;

 // now formats the number
 intstring:='';
 decstring:='';
 astring:='##.';
 if decimalplacesvariable then
  astring:=astring+'#'
 else
  astring:=astring+rightmask;
 astring:=formatfloat(astring,number);
 index:=pos(decimalseparator,astring);
 if index>=0 then begin
  decstring:=copy(astring,index+1,length(astring));
  intstring:=copy(astring,1,index-1);
 end;
 // convert the number integer number
 i:=1;
 index:=length(intstring);
 astring:='';
 allzeros:=true;
 while index>0 do begin
  // negative case
  if intstring[index]='-' then begin
   astring:=intstring[index]+astring;
   break;
  end;
  while i<=length(leftmask) do begin
   if leftmask[i]=',' then begin
    astring:=thchar+astring;
    inc(i)
   end else begin
    if leftmask[i]='#' then
     allzeros:=false;
    inc(i);
    break;
   end;
  end;
  astring:=intstring[index]+astring;
  dec(index);
 end;
 if not decseparator then
  inc(i);
 // now fills if all 0
 while (allzeros and (i<=length(leftmask))) do begin
  if leftmask[i]='#' then
   allzeros:=false
  else
   astring:=leftfillchar+astring;
  inc(i);
 end;

 if hiddendecseparator then
  result:=astring+decstring
 else begin
  if (decseparator and (length(decstring)>0)) then
   result:=astring+decchar+decstring
  else
   result:=astring;
 end;
 if (isnegative) then
  result:='-'+result;
end;

function numbertotext(fnumber:currency):msestring;
var
 xx: string;
begin
 xx:= getcurrentlangconstsname;
 if xx='en' then begin
  result:= numbertotext_en(fnumber);
 end else if xx='id' then begin
  result:= numbertotext_id(fnumber);
 end;
end;

function numbertotext_en(amount:currency):msestring;
var
 num : longint;
 fracture : integer;
 
 function num2str(num: longint): string;
 const
  hundred = 100;
  thousand = 1000;
  million = 1000000;
  billion = 1000000000;
 begin
  if num >= billion then begin
   if (num mod billion) = 0 then begin
    num2str := num2str(num div billion) + ' Billion';
   end else begin
    num2str := num2str(num div billion) + ' Billion ' +
               num2str(num mod billion);
   end;
  end else if num >= million then begin
   if (num mod million) = 0 then begin
    num2str := num2str(num div million) + ' Million';
   end else begin
    num2str := num2str(num div million) + ' Million ' +
               num2str(num mod million);
   end;
  end else begin
   if num >= thousand then begin
    if (num mod thousand) = 0 then begin
     num2str := num2str(num div thousand) + ' Thousand';
    end else begin
     num2str := num2str(num div thousand) + ' Thousand ' +
                num2str(num mod thousand);
    end;
   end else begin
    if num >= hundred then begin
     if (num mod hundred) = 0 then begin
      num2str := num2str(num div hundred) + ' Hundred';
     end else begin
      num2str := num2str(num div  hundred) + ' Hundred ' +
                 num2str(num mod hundred);
     end;
    end else begin
     case (num div 10) of
      6,7,9:
       if (num mod 10) = 0 then
        num2str := num2str(num div 10) + 'ty'
       else
        num2str := num2str(num div 10) + 'ty-' +
                   num2str(num mod 10);
      8:
       if num = 80 then
        num2str := 'Eighty'
       else
        num2str := 'Eighty-' + num2str(num mod 10);
      5:
       if num = 50 then
        num2str := 'Fifty'
       else
        num2str := 'Fifty-' + num2str(num mod 10);
      4:
       if num = 40 then
        num2str := 'Forty'
       else
        num2str := 'Forty-' + num2str(num mod 10);
      3:
       if num = 30 then
        num2str := 'Thirty'
       else
        num2str := 'Thirty-' + num2str(num mod 10);
      2:
       if num = 20 then
        num2str := 'Twenty'
       else
        num2str := 'Twenty-' + num2str(num mod 10);
      0,1:
       case num of
        0: num2str := 'Zero';
        1: num2str := 'One';
        2: num2str := 'Two';
        3: num2str := 'Three';
        4: num2str := 'Four';
        5: num2str := 'Five';
        6: num2str := 'Six';
        7: num2str := 'Seven';
        8: num2str := 'Eight';
        9: num2str := 'Nine';
        10: num2str := 'Ten';
        11: num2str := 'Eleven';
        12: num2str := 'Twelve';
        13: num2str := 'Thirteen';
        14: num2str := 'Fourteen';
        15: num2str := 'Fifteen';
        16: num2str := 'Sixteen';
        17: num2str := 'Seventeen';
        18: num2str := 'Eightteen';
        19: num2str := 'Nineteen'
       end;
     end;
    end;
   end;
  end;
 end;
begin
 num:= trunc(abs(amount));
 fracture:= round(1000*frac(abs(amount)));
 result := num2str(num);
 if fracture > 0 then begin
  result := result + ' and '+inttostr(fracture) + '/1000';
 end;
end;

function numbertotext_id(amount:currency):msestring;
var
 num : longint;
 fracture : integer;
 
 function num2str(num: longint): string;
 const
  hundred = 100;
  thousand = 1000;
  million = 1000000;
  billion = 1000000000;
 begin
  if num >= billion then begin
   if (num mod billion) = 0 then begin
    num2str := num2str(num div billion) + ' Milyar';
   end else begin
    num2str := num2str(num div billion) + ' Milyar ' +
               num2str(num mod billion);
   end;
  end else if num >= million then begin
   if (num mod million) = 0 then begin
    num2str := num2str(num div million) + ' Juta';
   end else begin
    num2str := num2str(num div million) + ' Juta ' +
               num2str(num mod million);
   end;
  end else begin
   if num >= thousand then begin
    if (num mod thousand) = 0 then begin
     num2str := num2str(num div thousand) + ' Ribu';
    end else begin
     num2str := num2str(num div thousand) + ' Ribu ' +
                num2str(num mod thousand);
    end;
   end else begin
    if num >= hundred then begin
     if (num mod hundred) = 0 then begin
      num2str := num2str(num div hundred) + ' Ratus';
     end else begin
      num2str := num2str(num div  hundred) + ' Ratus ' +
                 num2str(num mod hundred);
     end;
    end else begin
     case (num div 10) of
      2..9:
       if (num mod 10) = 0 then begin
        num2str := num2str(num div 10) + ' Puluh';
       end else begin
        num2str := num2str(num div 10) + ' Puluh ' +
                   num2str(num mod 10);
       end;
      0,1:
       case num of
        0: num2str := 'Nol';
        1: num2str := 'Satu';
        2: num2str := 'Dua';
        3: num2str := 'Tiga';
        4: num2str := 'Empat';
        5: num2str := 'Lima';
        6: num2str := 'Enam';
        7: num2str := 'Tujuh';
        8: num2str := 'Delapan';
        9: num2str := 'Sembilan';
        10: num2str := 'Sepuluh';
        11: num2str := 'Sebelas';
        12: num2str := 'Duabelas';
        13: num2str := 'Tigabelas';
        14: num2str := 'Empatbelas';
        15: num2str := 'Limabelas';
        16: num2str := 'Enambelas';
        17: num2str := 'Tujuhbelas';
        18: num2str := 'Delapanbelas';
        19: num2str := 'Sembilanbelas'
       end;
     end;
    end;
   end;
  end;
 end;
begin
 num:= trunc(abs(amount));
 fracture:= round(10*frac(abs(amount)));
 result := num2str(num);
 if fracture > 0 then begin
  result := result + ' Koma '+num2str(fracture);
 end;
end;

initialization

defaultdecimals:=2;

end.
