{*********************************************************}
{            Functions unit for TRepazEvaluator           }
{            Originally concept is taken from             }
{           ReportMan source code, written by :           }
{                     Toni Martir                         }
{*********************************************************}
{            Copyright (c) 2008 Sri Wahono                }
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
unit repazevaluatorfunc;

interface

uses
 sysutils,classes,repazconsts,mseconsts,dateutils,msestrings,msesysutils,
 {$ifdef mswindows}windows,{$endif}variants,repazevaluatortype,repazclasses;

type

 { functions }
 tidenuppercase=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenlowercase=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidensinus=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenmax=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenmin=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;


 tidenfloattodatetime=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenstringtotime=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenstringtodatetime=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidentimetostring=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidendatetimetostring=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidendayofweek=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenround=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenroundtointeger=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenabs=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidencomparevalue=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenint=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenval=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenstr=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidentrim=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenleft=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenlength=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenisinteger=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenisnumeric=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenisvaliddatetime=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidencheckexpression=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenpos=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenmodul=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidendivide=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidensqrt=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenmonth=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenevaltext=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenmonthname=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenyear=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenday=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenright=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;


 tidenstringtobin=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidensubstr=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenformatstr=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenformatnum=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidennumtotext=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenreplacestr=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenfieldwithkey=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidensumfield=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenisdiscountday=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenisholiday=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { report header }
 
 tidenreportheader=class(tidenreport)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { report footer }
 
 tidenreportfooter=class(tidenreport)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;
 
 { page header }
 
 tidenpageheader=class(tidenreport)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { page footer }
 
 tidenpagefooter=class(tidenreport)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { content header }
 
 tidencontentheader=class(tidenreport)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { content footer }
 
 tidencontentfooter=class(tidenreport)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { table header }
 
 tidentableheader=class(tidenreport)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { table footer }
 
 tidentablefooter=class(tidenreport)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;
 
 { content data }
 
 tidencontentdata=class(tidenreport)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { group header }
 
 tidengroupheader=class(tidenreport)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { group footer }
 
 tidengroupfooter=class(tidenreport)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;
 
 { group data }
 
 tidengroupdata=class(tidenreport)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { page number }
 
 tidenpagenumber=class(tidenreport)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { header tree key }
 
 tidenheadertreekey=class(tidenreport)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { footer tree key }
 
 tidenfootertreekey=class(tidenreport)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { treefootervalue }
 
 tidentreefootervalue=class(tidenreport)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { treefootervalue2 }
 
 tidentreefootervalue2=class(tidenreport)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { lettervalue }
 
 tidenlettervalue=class(tidenreport)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { record number }
 
 tidenrecordnumber=class(tidenreport)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { master number }
 
 tidenmasternumber=class(tidenreport)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { data number }
 
 tidendatanumber=class(tidenreport)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { group number }
 
 tidengroupnumber=class(tidenreport)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { constants }

 tidentoday=class(tidenconstant)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidentime=class(tidenconstant)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidennow=class(tidenconstant)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidennull=class(tidenconstant)
 protected
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

implementation

uses repazevaluator,math;

function varisstring(avar:variant):boolean;
begin
 result:=false;
 if ((vartype(avar)=varstring) or (vartype(avar)=varolestr)) then
  result:=true;
end;

constructor tidenuppercase.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='UpperCase';
 help:=uc(ord(rcsuppercase));
 model:='UpperCase(Strings:string):string';
 aparams:=uc(ord(rcspuppercase));
end;

function tidenuppercase.getevalvalue:variant;
begin
 if params[0]=null then
 begin
  result:='';
  exit;
 end;
 if not varisstring(params[0]) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 result:=mseuppercase(params[0]);
end;

function tidenlowercase.getevalvalue:variant;
begin
 if params[0]=null then
 begin
  result:='';
  exit;
 end;
 if not varisstring(params[0]) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
  result:=mselowercase(params[0]);
end;

constructor tidenlowercase.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='LowerCase';
 help:=uc(ord(rcslowercase));
 model:='LowerCase(Strings:string):string';
 aparams:=uc(ord(rcsplowercase));
end;

constructor tidenfloattodatetime.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='FloatToDateTime';
 help:=uc(ord(rcsfloattodatetime));
 model:='FloatToDateTime(Number:double):tdatetime';
 aparams:=uc(ord(rcspfloattodatetime));
end;

function tidenfloattodatetime.getevalvalue:variant;
begin
 if varisnumber(params[0]) then
  result:=tdatetime(params[0])
 else
  if vartype(params[0])=vardate then
    result:=tdatetime(params[0])
  else
  if varisnull(params[0]) then
  begin
   result:=null;
  end
  else
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
end;

constructor tidenstringtotime.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='StringToTime';
 help:=uc(ord(rcsstringtotime));
 model:='StringToTime(Strings:string):tdatetime';
 aparams:=uc(ord(rcspstringtotime));
end;

function tidenstringtotime.getevalvalue:variant;
begin
 if varisstring(params[0]) then
  result:=strtotime(params[0])
 else
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),
   idenname);
end;

constructor tidenstringtodatetime.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='StringToDateTime';
 help:= uc(ord(rcsstringtodatetime));
 model:='StringToDateTime(Strings:string):tdatetime';
 aparams:=uc(ord(rcspstringtodatetime));
end;

function tidenstringtodatetime.getevalvalue:variant;
begin
 if varisstring(params[0]) then
  result:=strtodatetime(params[0])
 else
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
end;

constructor tidentimetostring.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=2;
 idenname:='TimeToString';
 help:=uc(ord(rcstimetostring));
 model:='TimeToString(mask:string, Date:tdatetime):string';
 aparams:=uc(ord(rcsptimetostring));
end;

function tidentimetostring.getevalvalue:variant;
begin
 if vartype(params[1])=vardate then begin
  if ( not (varisstring(params[0]))) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
    idenname);
  if not varisnull(params[1]) then begin
   if params[0]='' then params[0]:='hh:nn:ss';
    result:=formatdatetime(params[0],params[1]);
  end else begin
   result:='';
  end;
 end else begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),
   idenname);
 end;
end;

constructor tidendatetimetostring.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=2;
 idenname:='DateTimeToString';
 help:= uc(ord(rcsdatetimetostring));
 model:='DateTimeToString(mask:string, Date:tdatetime):string';
 aparams:=uc(ord(rcspdatetimetostring));
end;

function tidendatetimetostring.getevalvalue:variant;
begin
 if vartype(params[1])=vardate then begin
  if ( not (varisstring(params[0]))) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
    idenname);
  if not varisnull(params[1]) then begin
   if params[0]='' then params[0]:='dd/mm/yyyy';
   result:=formatdatetime(params[0],params[1]);
  end else begin
   result:='';
  end;
 end else begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),
    idenname);
 end;
end;

constructor tidendayofweek.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='DayOfWeek';
 help:= uc(ord(rcsdayofweek));
 model:='DayOfWeek(Date:tdatetime):integer';
 aparams:=uc(ord(rcspdayofweek));
end;

function tidendayofweek.getevalvalue:variant;
begin
 if vartype(params[0])=vardate then begin
  if not varisnull(params[0]) then begin
   result:=dayoftheweek(params[0]);
  end else begin
   result:=0;
  end;
 end else begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),
    idenname);
 end;
end;

constructor tidensinus.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='SIN';
 help:=uc(ord(rcssin));
 model:='SIN(Angular:double):double';
 aparams:=uc(ord(rcspsin));
end;

function tidensinus.getevalvalue:variant;
begin
 if varisnumber(params[0]) then
  result:=sin(double(params[0]))
 else
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
end;

constructor tidenmax.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=2;
 idenname:='MAX';
 help:=uc(ord(rcsmax));
 model:='MAX(Number1:double,Number2:double):double';
end;

function tidenmax.getevalvalue:variant;
begin
 if varisnumber(params[0]) then begin
  if varisnumber(params[1]) then
   result:=max(double(params[0]),double(params[1]))
  else
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 end else
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
end;

constructor tidenmin.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=2;
 idenname:='MIN';
 help:=uc(ord(rcsmin));
 model:='MIN(Number1:double,Number2:double):double';
end;

function tidenmin.getevalvalue:variant;
begin
 if varisnumber(params[0]) then begin
  if varisnumber(params[1]) then
   result:=min(double(params[0]),double(params[1]))
  else
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 end else
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
end;

constructor tidenround.create(aowner:tcomponent);
begin
 inherited create(aowner);
 idenname:='Round';
 fparamcount:=2;
 help:=uc(ord(rcsround));
 model:='Round(Number:double,Rounded:double):double';
 aparams:=uc(ord(rcspround));
end;

function tidenround.getevalvalue:variant;
begin
 if (not varisnumber(params[0])) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 if (not varisnumber(params[1])) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 result:=roundfloat(double(params[0]),double(params[1]));
end;

constructor tidenroundtointeger.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='RoundToInteger';
 help:=uc(ord(rcsround));
 model:='RoundToInteger(Number:double):integer';
 aparams:='';
end;

function tidenroundtointeger.getevalvalue:variant;
begin
 if (not varisnumber(params[0])) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 result:=round(double(params[0]));
end;

constructor tidenabs.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='ABS';
 help:=uc(ord(rcsabs));
 model:='ABS(Number:double):double';
 aparams:=uc(ord(rcspabs));
end;

function tidenabs.getevalvalue:variant;
begin
 if (not varisnumber(params[0])) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 result:=abs(double(params[0]));
end;

constructor tidencomparevalue.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=3;
 idenname:='CompareValue';
 help:=uc(ord(rcscomparevalue));
 model:='Compare(Number1,Number2,Epsilon:double):integer';
 aparams:=uc(ord(rcspcomparevalue));
end;

function comparevalue(p1,p2,epsilon:double):integer;
var
 dif:double;
begin
 dif:=abs(p1-p2);
 epsilon:=abs(epsilon);
 if dif<epsilon then
 begin
  result:=0;
  exit;
 end;
 if p1<p2 then
  result:=-1
 else
  result:=1;
end;

function tidencomparevalue.getevalvalue:variant;
begin
 if (not varisnumber(params[0])) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 if (not varisnumber(params[1])) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 if (not varisnumber(params[2])) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 result:=integer(comparevalue(double(params[0]),double(params[1]),double(params[2])));
end;

constructor tidenint.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='Int';
 help:=uc(ord(rcsint));
 model:='Int(Number:double):integer';
 aparams:=uc(ord(rcspint));
end;

function tidenint.getevalvalue:variant;
begin
 if (not (vartype(params[0]) in [varsmallint..vardate,varvariant])) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 case vartype(params[0]) of
  varsmallint..vardate:
   begin
    result:=integer(trunc(int(double(params[0]))));
   end;
  varvariant:
   begin
    result:=integer(trunc(int(double(params[0]))));
   end;
  else
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
  end;

end;

constructor tidenstr.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='Str';
 help:=uc(ord(rcsstr));
 model:='Str(Number:variant):string';
 aparams:=uc(ord(rcspstr));
end;

function tidenstr.getevalvalue:variant;
begin
 if varisnull(params[0]) then
  result:=''
 else
  result:=string(params[0]);
end;

constructor tidenval.create(aowner:tcomponent);
begin
 fparamcount:=1;
 idenname:='Val';
 help:=uc(ord(rcsval));
 model:='Val(Strings:string):double';
 aparams:=uc(ord(rcspval));
end;

function tidenval.getevalvalue:variant;
begin
 try
  if varisstring(params[0]) then begin
   if params[0]=''+chr(0) then begin
    result:=0;
    exit;
   end;
   result:=strtofloat(params[0]);
  end else begin
   result:=double(params[0]);
  end;
 except
   raise tevalnamedexception.create(uc(ord(rcsconverterror)),
         idenname);
 end;
end;

constructor tidentrim.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='Trim';
 help:=uc(ord(rcstrim));
 model:='Trim(Strings:string):string';
 aparams:=uc(ord(rcsptrim));
end;

function tidentrim.getevalvalue:variant;
begin
 if params[0]=null then begin
  result:='';
  exit;
 end;
 if not varisstring(params[0]) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 result:=trim(string(params[0]));
end;

constructor tidenleft.create(aowner:tcomponent);
begin
 inherited create(aowner);
 idenname:= 'Left';
 fparamcount:=2;
 help:=uc(ord(rcsleft));
 model:='Left(Strings:string,Count:integer):string';
 aparams:=uc(ord(rcspleft));
end;

function tidenleft.getevalvalue:variant;
begin
 if not varisstring(params[0]) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 if  not (varisinteger(params[1])) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 if  (integer(params[1])<1) then
  result:=''
 else
  result:=copy(string(params[0]),1,
              integer(params[1]));
end;

constructor tidenlength.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='Length';
 help:=uc(ord(rcslength));
 model:='Length(Strings:string):integer';
 aparams:=uc(ord(rcsplength));
end;

function tidenlength.getevalvalue:variant;
begin
 if varisnull(params[0]) then
 begin
  result:=0;
  exit;
 end;
 if not varisstring(params[0]) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 result:=length(string(params[0]));
end;

constructor tidenisinteger.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='IsInteger';
 help:=uc(ord(rcsisinteger));
 model:='IsInteger(Strings:string):boolean';
end;

function tidenisinteger.getevalvalue:variant;
begin
 if varisnull(params[0]) then begin
  result:=false;
  exit;
 end;
 if not varisstring(params[0]) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 result:=true;
 try
  strtoint(params[0]);
 except
  result:=false;
 end;
end;

constructor tidenisnumeric.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;

 help:=uc(ord(rcsisnumeric));
 model:='IsNumeric(Strings:string):boolean';
end;

function tidenisnumeric.getevalvalue:variant;
begin
 if varisnull(params[0]) then begin
  result:=false;
  exit;
 end;
 if not varisstring(params[0]) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 result:=true;
 try
  strtofloat(params[0]);
 except
  result:=false;
 end;
end;

constructor tidenisvaliddatetime.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='IsValidDateTime';

 model:='IsValidDateTime(Strings:string):boolean';
end;

function tidenisvaliddatetime.getevalvalue:variant;
begin
 if varisnull(params[0]) then begin
  result:=false;
  exit;
 end;
 if not varisstring(params[0]) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 result:=true;
 try
  strtodatetime(params[0]);
 except
  result:=false;
 end;
end;

constructor tidencheckexpression.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=2;
 idenname:='CheckExpression';
 model:='CheckExpression(expression,message:string):boolean';
end;

function tidencheckexpression.getevalvalue:variant;
begin
 if not varisstring(params[0]) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 if not varisstring(params[1]) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 result:=trepazevaluator(evaluator).evaluatetext(params[0]);
 if varisboolean(params[0]) then
  result:=params[0];
 if (not result) then
  raise exception.create(params[1]);
end;

constructor tidenpos.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=2;
 idenname:='Pos';
 help:=uc(ord(rcspos));
 model:='Pos(SubString:string,Strings:string):integer';
 aparams:=uc(ord(rcsppos));
end;

function tidenpos.getevalvalue:variant;
begin
 if params[0]=null then begin
  result:=0;
  exit;
 end;
 if not varisstring(params[0]) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 if not varisstring(params[1]) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 result:=pos(string(params[0]),string(params[1]));
end;

constructor tidensqrt.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='SQRT';
 help:=uc(ord(rcssqrt));
 model:='SQRT(Number:double):double';
 aparams:=uc(ord(rcspsqrt));
end;

function tidensqrt.getevalvalue:variant;
begin
 if varisnumber(params[0]) then
  result:=sqrt(double(params[0]))
 else
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
end;

constructor tidenmodul.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=2;
 idenname:='MOD';
 help:=uc(ord(rcsmod));
 model:='MOD(Number1:integer,Number2:integer):integer';
 aparams:=uc(ord(rcspmod));
end;

function tidenmodul.getevalvalue:variant;
begin
 if not varisnumber(params[0]) then
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),
       idenname);
 if not varisnumber(params[1]) then
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),
       idenname);
 result:=integer(params[0]) mod integer(params[1]);
end;

constructor tidendivide.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=2;
 idenname:='DIV';
 help:=uc(ord(rcsdiv));
 model:='DIV(Number1:integer,Number2:integer):integer';
 aparams:=uc(ord(rcspdiv));
end;

function tidendivide.getevalvalue:variant;
begin
 if not varisnumber(params[0]) then
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),
       idenname);
 if not varisnumber(params[1]) then
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),
       idenname);
 result:=integer(params[0]) div integer(params[1]);
end;

constructor tidentoday.create(aowner:tcomponent);
begin
 inherited create(aowner);
 help:=uc(ord(rcstoday));
 model:='Today'+':date';
end;

function tidentoday.getevalvalue:variant;
begin
 result:=date;
end;

constructor tidentime.create(aowner:tcomponent);
begin
 inherited create(aowner);
 idenname:='Time';
 help:=uc(ord(rcstimeh));
 model:='Time'+':time';
end;

function tidentime.getevalvalue:variant;
begin
 result:=timeof(now);
end;

constructor tidennull.create(aowner:tcomponent);
begin
 inherited create(aowner);
 idenname:='Null';
 help:=uc(ord(rcsnull));
 model:='Null';
end;

function tidennull.getevalvalue:variant;
begin
 result:=null;
end;

constructor tidennow.create(aowner:tcomponent);
begin
 inherited create(aowner);
 idenname:='Now';
 help:=uc(ord(rcsnow));
 model:='Now'+':datetime';
end;

function tidennow.getevalvalue:variant;
begin
 result:=now;
end;

{ tidenpagenumber }

constructor tidenpagenumber.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=0;
 aparams:='';
 idenname:='PageNumber';
 help:=uc(ord(rcspagenumber));
 model:='PageNumber : integer';
end;

function tidenpagenumber.getevalvalue:variant;
begin
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).pagenum;
 end else begin
  result:= null;
 end;
end;

{ tidenheadertreekey }

constructor tidenheadertreekey.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=0;
 aparams:='';
 idenname:='HeaderTreeKey';
 help:=uc(ord(rcsheadertreekey));
 model:='HeaderTreeKey : variant';
end;

function tidenheadertreekey.getevalvalue:variant;
begin
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).headertreekey;
 end else begin
  result:= null;
 end;
end;

{ tidenfootertreekey }

constructor tidenfootertreekey.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=0;
 aparams:='';
 idenname:='FooterTreeKey';
 help:=uc(ord(rcsfootertreekey));
 model:='FooterTreeKey : variant';
end;

function tidenfootertreekey.getevalvalue:variant;
begin
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).footertreekey;
 end else begin
  result:= null;
 end;
end;

{ tidentreefootervalue }

constructor tidentreefootervalue.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=3;
 aparams:=uc(ord(rcsptreefootervalue));
 idenname:='TreeFooterValue';
 help:=uc(ord(rcstreefootervalue));
 model:='TreeFooterValue(IndexRow:Integer, IndexCol:Integer, IndexTree:Integer): variant';
end;

function tidentreefootervalue.getevalvalue:variant;
begin
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).treefootervalue(integer(params[0]),integer(params[1]),integer(params[2]));
 end else begin
  result:= null;
 end;
end;

{ tidentreefootervalue2 }

constructor tidentreefootervalue2.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=2;
 aparams:=uc(ord(rcsptreefootervalue2));
 idenname:='TreeFooterValue2';
 help:=uc(ord(rcstreefootervalue2));
 model:='TreeFooterValue2(IndexCol:Integer, IndexTree:Integer): variant';
end;

function tidentreefootervalue2.getevalvalue:variant;
begin
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).treefootervalue2(integer(params[0]),integer(params[1]));
 end else begin
  result:= null;
 end;
end;

{ tidenlettervalue }

constructor tidenlettervalue.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=2;
 aparams:=uc(ord(rcsplettervalue));
 idenname:='LetterValue';
 help:=uc(ord(rcslettervalue));
 model:='LetterValue(IndexRow:Integer, IndexCol:Integer): variant';
end;

function tidenlettervalue.getevalvalue:variant;
begin
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).lettervalue(integer(params[0]),integer(params[1]));
 end else begin
  result:= null;
 end;
end;

{ tidenrecordnumber }

constructor tidenrecordnumber.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=0;
 aparams:='';
 idenname:='RecordNumber';
 help:=uc(ord(rcsrecordnumber));
 model:='RecordNumber : integer';
end;

function tidenrecordnumber.getevalvalue:variant;
begin
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).recordnumber;
 end else begin
  result:= null;
 end;
end;

{ tidenmasternumber }

constructor tidenmasternumber.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=0;
 aparams:='';
 idenname:='MasterNumber';
 help:=uc(ord(rcsmasternumber));
 model:='MasterNumber : integer';
end;

function tidenmasternumber.getevalvalue:variant;
begin
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).masternumber;
 end else begin
  result:= null;
 end;
end;

{ tidendatanumber }

constructor tidendatanumber.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=0;
 aparams:='';
 idenname:='DataNumber';
 help:=uc(ord(rcsdatanumber));
 model:='DataNumber : integer';
end;

function tidendatanumber.getevalvalue:variant;
begin
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).datanumber;
 end else begin
  result:= null;
 end;
end;

{ tidengroupnumber }

constructor tidengroupnumber.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 aparams:=uc(ord(rcspgroupnumber));;
 idenname:='GroupNumber';
 help:=uc(ord(rcsgroupnumber));
 model:='GroupNumber(Index:integer) : integer';
end;

function tidengroupnumber.getevalvalue:variant;
begin
 if not (varisinteger(params[0])) then begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 end;
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).groupnumber(integer(params[0]));
 end else begin
  result:= null;
 end;
end;

{ tidenreportheader }

constructor tidenreportheader.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=2;
 aparams:=uc(ord(rcspreportheader));
 idenname:='ReportHeader';
 help:=uc(ord(rcsreportheader));
 model:='ReportHeader(RowIndex:integer, ColIndex:integer):variant';
end;

function tidenreportheader.getevalvalue:variant;
begin
 if not (varisinteger(params[0])) then begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 end;
 if not (varisinteger(params[1])) then begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 end;
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).reportheadervalue(
   integer(params[0]),integer(params[1]));
 end else begin
  result:= null;
 end;
end;

{ tidenreportfooter }

constructor tidenreportfooter.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=2;
 aparams:=uc(ord(rcspreportfooter));
 idenname:='ReportFooter';
 help:=uc(ord(rcsreportfooter));
 model:='ReportFooter(RowIndex:integer, ColIndex:integer):variant';
end;

function tidenreportfooter.getevalvalue:variant;
begin
 if not (varisinteger(params[0])) then begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 end;
 if not (varisinteger(params[1])) then begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 end;
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).reportfootervalue(
   integer(params[0]),integer(params[1]));
 end else begin
  result:= null;
 end;
end;

{ tidenpageheader }

constructor tidenpageheader.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=2;
 aparams:=uc(ord(rcsppageheader));
 idenname:='PageHeader';
 help:=uc(ord(rcspageheader));
 model:='PageHeader(RowIndex:integer, ColIndex:integer):variant';
end;

function tidenpageheader.getevalvalue:variant;
begin
 if not (varisinteger(params[0])) then begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 end;
 if not (varisinteger(params[1])) then begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 end;
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).pageheadervalue(
   integer(params[0]),integer(params[1]));
 end else begin
  result:= null;
 end;
end;

{ tidenpagefooter }

constructor tidenpagefooter.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=2;
 aparams:=uc(ord(rcsppagefooter));
 idenname:='PageFooter';
 help:=uc(ord(rcspagefooter));
 model:='PageFooter(RowIndex:integer, ColIndex:integer):variant';
end;

function tidenpagefooter.getevalvalue:variant;
begin
 if not (varisinteger(params[0])) then begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 end;
 if not (varisinteger(params[1])) then begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 end;
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).pagefootervalue(
   integer(params[0]),integer(params[1]));
 end else begin
  result:= null;
 end;
end;


{ tidencontentheader }

constructor tidencontentheader.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 aparams:=uc(ord(rcspcontentheader));
 idenname:='ContentHeader';
 help:=uc(ord(rcscontentheader));
 model:='ContentHeader(ColIndex:integer):variant';
end;

function tidencontentheader.getevalvalue:variant;
begin
 if not (varisinteger(params[0])) then begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 end;
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).contentheadervalue(integer(params[0]));
 end else begin
  result:= null;
 end;
end;

{ tidencontentfooter }

constructor tidencontentfooter.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 aparams:=uc(ord(rcspcontentfooter));
 idenname:='ContentFooter';
 help:=uc(ord(rcscontentfooter));
 model:='ContentFooter(ColIndex:integer):variant';
end;

function tidencontentfooter.getevalvalue:variant;
begin
 if not (varisinteger(params[0])) then begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 end;
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).contentfootervalue(integer(params[0]));
 end else begin
  result:= null;
 end;
end;

{ tidentableheader }

constructor tidentableheader.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=3;
 aparams:=uc(ord(rcsptableheader));
 idenname:='TableHeader';
 help:=uc(ord(rcstableheader));
 model:='TableHeader(TableIndex:integer, RowIndex:integer, ColIndex:integer):variant';
end;

function tidentableheader.getevalvalue:variant;
begin
 if not (varisinteger(params[0])) then begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 end;
 if not (varisinteger(params[1])) then begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 end;
 if not (varisinteger(params[2])) then begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 end;
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).tableheadervalue(integer(params[0]),integer(params[1]),integer(params[2]));
 end else begin
  result:= null;
 end;
end;

{ tidentablefooter }

constructor tidentablefooter.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=3;
 aparams:=uc(ord(rcsptablefooter));
 idenname:='TableFooter';
 help:=uc(ord(rcstablefooter));
 model:='TableFooter(TableIndex:integer, RowIndex:integer, ColIndex:integer):variant';
end;

function tidentablefooter.getevalvalue:variant;
begin
 if not (varisinteger(params[0])) then begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 end;
 if not (varisinteger(params[1])) then begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 end;
 if not (varisinteger(params[2])) then begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 end;
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).tablefootervalue(integer(params[0]),integer(params[1]),integer(params[2]));
 end else begin
  result:= null;
 end;
end;

{ tidencontentdata }

constructor tidencontentdata.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 aparams:=uc(ord(rcspcontentdata));
 idenname:='ContentData';
 help:=uc(ord(rcscontentdata));
 model:='ContentData(ColIndex:integer):variant';
end;

function tidencontentdata.getevalvalue:variant;
begin
 if not (varisinteger(params[0])) then begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 end;
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).contentdatavalue(integer(params[0]));
 end else begin
  result:= null;
 end;
end;

{ tidengroupheader }

constructor tidengroupheader.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=2;
 aparams:=uc(ord(rcspgroupheader));
 idenname:='GroupHeader';
 help:=uc(ord(rcsgroupheader));
 model:='GroupHeader(RowIndex:integer, ColIndex:integer):variant';
end;

function tidengroupheader.getevalvalue:variant;
begin
 if not (varisinteger(params[0])) then begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 end;
 if not (varisinteger(params[1])) then begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 end;
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).groupheadervalue(integer(params[0]),integer(params[1]));
 end else begin
  result:= null;
 end;
end;

{ tidengroupfooter }

constructor tidengroupfooter.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=2;
 aparams:=uc(ord(rcspgroupfooter));
 idenname:='GroupFooter';
 help:=uc(ord(rcsgroupfooter));
 model:='GroupFooter(RowIndex:integer, ColIndex:integer):variant';
end;

function tidengroupfooter.getevalvalue:variant;
begin
 if not (varisinteger(params[0])) then begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 end;
 if not (varisinteger(params[1])) then begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 end;
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).groupfootervalue(integer(params[0]),integer(params[1]));
 end else begin
  result:= null;
 end;
end;

{ tidengroupdata }

constructor tidengroupdata.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 aparams:=uc(ord(rcspgroupdata));
 idenname:='GroupData';
 help:=uc(ord(rcsgroupdata));
 model:='GroupData(ColIndex:integer):variant';
end;

function tidengroupdata.getevalvalue:variant;
begin
 if not (varisinteger(params[0])) then begin
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 end;
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).groupdatavalue(integer(params[0]));
 end else begin
  result:= null;
 end;
end;

constructor tidenmonthname.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='MonthName';
 help:=uc(ord(rcsmonthname));
 model:='MonthName(Date:datetime):string';
 aparams:=uc(ord(rcspmonthname));
end;

function tidenmonthname.getevalvalue:variant;
var any,mes,dia:word;
begin
 if varisnumber(params[0]) then begin
  mes:=integer(params[0]);
  if (not (mes in [1..12])) then
   result:=''
  else
   result:=longmonthnames[mes];
 end else
 if vartype(params[0])=vardate then begin
  decodedate(tdatetime(params[0]),any,mes,dia);
  result:=longmonthnames[mes];
 end else
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
end;

constructor tidenevaltext.create(aowner:tcomponent);
begin
 fparamcount:=1;
 idenname:='EvalText';
 help:=uc(ord(rcsevaltext));
 model:='EvalText(Expression:string):variant';
 aparams:=uc(ord(rcspevaltext));
end;

function tidenevaltext.getevalvalue:variant;
var avaluador:trepazcustomevaluator;
begin
 if not varisstring(params[0]) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 // evalue
 avaluador:=(evaluator as trepazcustomevaluator);
 result:=avaluador.evaluatetext(params[0]);
end;

constructor tidenmonth.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='Month';
 help:=uc(ord(rcsmonth));
 model:='Month(Date:datetime):integer';
 aparams:=uc(ord(rcspmonth));
end;


function tidenmonth.getevalvalue:variant;
var any,mes,dia:word;
begin
 case vartype(params[0]) of
  vardate:
   begin
    decodedate(tdatetime(params[0]),any,mes,dia);
    result:=mes;
   end;
  else
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 end;
end;

constructor tidenyear.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='Year';
 help:=uc(ord(rcsyear));
 model:='Year(Date:datetime):integer';
 aparams:=uc(ord(rcspyear));
end;

function tidenyear.getevalvalue:variant;
var any,mes,dia:word;
begin
 case vartype(params[0]) of
  vardate:
   begin
    decodedate(tdatetime(params[0]),any,mes,dia);
    result:=any;
   end;
  else
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 end;
end;

constructor tidenday.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='Day';
 help:=uc(ord(rcsday));
 model:='Day(Date:datetime):integer';
 aparams:=uc(ord(rcspday));
end;

function tidenday.getevalvalue:variant;
var any,mes,dia:word;
begin
 if ((vartype(params[0])=vardate) or (varisnumber(params[0]))) then
 begin
  decodedate(tdatetime(params[0]),any,mes,dia);
  result:=integer(dia);
 end
 else
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
end;

{ tidenright }

constructor tidenright.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=2;
 idenname:='Right';
 help:=uc(ord(rcsright));
 model:='Right(Strings:string,Count:integer):string';
 aparams:=uc(ord(rcspright));
end;


function tidenright.getevalvalue:variant;
begin
 if not varisstring(params[0]) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 if ( not (varisinteger(params[1]))) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 if  (integer(params[1])<1) then
  result:=''
 else
  result:=copy(string(params[0]),
              length(string(params[0]))+1-integer(params[1]),
              integer(params[1]));
end;


constructor tidensubstr.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=3;
 idenname:='SubStr';
 help:=uc(ord(rcssubstr));
 model:='SubStr(Strings:string,Start:integer,Length:integer):string';
 aparams:=uc(ord(rcspsubstr));
end;


function tidensubstr.getevalvalue:variant;
begin
 if not varisstring(params[0]) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 if ( not (varisinteger(params[1]))) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 if integer(params[1])<1 then
 begin
  result:='';
  exit;
 end;
 if ( not (varisinteger(params[2]))) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 if integer(params[2])<1 then
 begin
  result:='';
  exit;
 end;
 result:=copy(string(params[0]),
              integer(params[1]),
              integer(params[2]));
end;

constructor tidenformatstr.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=2;
 idenname:='FormatStr';
 help:=uc(ord(rcsformatstr));
 model:='FormatStr(format:string,Value:variant):string';
 aparams:=uc(ord(rcspformatstr));
end;


function tidenformatstr.getevalvalue:variant;
var
 avalue:variant;
begin
 if not varisstring(params[0]) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);

 avalue:=params[1];
 if avalue=null then
 begin
  result:='';
  exit;
 end;
 case vartype(avalue) of
  varsmallint,varinteger,varsingle,vardouble,varword,varbyte,varcurrency:
   begin
    result:=formatfloat(params[0],double(avalue));
   end;
  vardate,272:
   begin
    result:=formatdatetime(params[0],vartodatetime(value));
   end;
  varboolean:
   begin
    if boolean(value) then
     result:='true'
    else
     result:='false';
   end;
  else
  begin
   result:=vartostr(value);
  end;
 end;
end;

constructor tidenformatnum.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=2;
 idenname:='FormatNum';
 model:='FormatNum(mask:string,Number:double):string';
 aparams:=uc(ord(rcspformatnum));
end;

function tidenformatnum.getevalvalue:variant;
begin
 if varisnull(params[1]) then
  params[1]:=0.0;
 if not (varisnumber(params[1]))then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 if ( not (varisstring(params[0]))) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 result:=formatcurradv(params[0],params[1]);
end;

constructor tidennumtotext.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='NumToText';
 help:=uc(ord(rcsnumtotext));
 model:='NumToText(Number:double):string';
 aparams:=uc(ord(rcspnumtotext));
end;

function tidennumtotext.getevalvalue:variant;
begin
 if not (varisnumber(params[0])) then
  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 if params[0]=null then
  result:= ''
 else
  result:=numbertotext(params[0]);
end;

constructor tidenreplacestr.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=3;
 idenname:='ReplaceStr';
 help:=uc(ord(rcsreplacestr));
 model:='ReplaceStr(Strings:string, OldPattern:string, NewPattern:string;): string';
 aparams:=uc(ord(rcspreplacestr));
end;

function tidenreplacestr.getevalvalue:variant;
begin
 if (not varisstring(params[0]))
  or (not varisstring(params[1]))
  or (not varisstring(params[2])) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 result:=stringreplace(string(params[0]),string(params[1]),string(params[2]),
  [rfreplaceall, rfignorecase]);
end;

{ tidenfieldwithkey }

constructor tidenfieldwithkey.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=3;
 idenname:='FieldWithKey';
 help:=uc(ord(rcsfieldwithkey));
 model:='FieldWithKey(KeyField:string, KeyValue:variant, ValueField:string): variant';
 aparams:=uc(ord(rcspfieldwithkey));
end;

function tidenfieldwithkey.getevalvalue:variant;
var
 pos1,pos2: integer;
 adataset,afield,adataset2,afield2: string;
begin
 if (not varisstring(params[0]))
  or (not varisstring(params[2])) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 pos1:=pos('.',params[0]);
 adataset:=copy(params[0],0,pos1-1);
 afield:=copy(params[0],pos1+1,length(params[0])-pos1);
 pos2:=pos('.',params[2]);
 adataset2:=copy(params[2],0,pos2-1);
 afield2:=copy(params[2],pos2+1,length(params[2])-pos2);
 result:= trepazevaluator(owner).datasource.searchfieldwithkey(adataset,afield,[params[1]],afield2);
end;

{ tidensumfield }

constructor tidensumfield.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='sumfield';
 help:=uc(ord(rcssumfield));
 model:='sumfield(FieldName:string): variant';
 aparams:=uc(ord(rcspsumfield));
end;

function tidensumfield.getevalvalue:variant;
var
 pos1,pos2: integer;
 adataset,afield: string;
begin
 if (not varisstring(params[0])) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 pos1:=pos('.',params[0]);
 adataset:=copy(params[0],0,pos1-1);
 afield:=copy(params[0],pos1+1,length(params[0])-pos1);
 result:= trepazevaluator(owner).datasource.sumfield(adataset,afield);
end;

{ tidenisdiscountday }

constructor tidenisdiscountday.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=2;
 idenname:='IsDiscountday';
 help:=uc(ord(rcsisdiscountday));
 model:='IsDiscountday(ADate:tdatetime, IncludeSunday:boolean): boolean';
 aparams:=uc(ord(rcspisdiscountday));
end;

function tidenisdiscountday.getevalvalue:variant;
var
 bo1: boolean;
 adate: tdatetime;
 int1: integer;
begin
 //if (not varisnull(params[0])) then
 //  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 if (not varisboolean(params[1])) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 bo1:= boolean(params[1]);
 result:= false;
 try
  adate:= tdatetime(params[0]);
 except
  exit;
 end;
 try
  if bo1 then begin
   result:= dayofweek(adate) = 1;
   if result then exit;
  end;
  for int1:=0 to high(adiscountdays) do begin
   if dateof(adate)=dateof(adiscountdays[int1]) then begin
    result:= true;
    break;
   end;
  end;
 except
  raise;
 end;
end;

{ tidenisholiday }

constructor tidenisholiday.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=2;
 idenname:='IsHoliday';
 help:=uc(ord(rcsisholiday));
 model:='IsHoliday(ADate:tdatetime, IncludeSunday:boolean): boolean';
 aparams:=uc(ord(rcspisholiday));
end;

function tidenisholiday.getevalvalue:variant;
var
 bo1: boolean;
 adate: tdatetime;
 int1: integer;
begin
 //if (not varisnull(params[0])) then
 //  raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 if (not varisboolean(params[1])) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 bo1:= boolean(params[1]);
 adate:= tdatetime(params[0]);
 result:= false;
 if bo1 then begin
  result:= dayofweek(adate) = 1;
  if result then exit;
 end;
 for int1:=0 to high(aholidays) do begin
  if dateof(adate)=dateof(aholidays[int1]) then begin
   result:= true;
   break;
  end;
 end;
end;

constructor tidenstringtobin.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='StringToBin';
 help:=uc(ord(rcsdecode64));
 model:='StringToBin(Strings:string):binary';
 aparams:='';
end;


function tidenstringtobin.getevalvalue:variant;
var
 astring:string;
 p:pointer;
begin
 if not varisstring(params[0]) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),
         idenname);
 astring:=string(params[0]);
 if length(astring)>0 then begin
  result:=vararraycreate([0,length(astring)-1],varbyte);
  p:=vararraylock(result);
  try
   move(astring[1],p^,length(astring));
  finally
   vararrayunlock(result);
  end;
 end;
end;

end.
