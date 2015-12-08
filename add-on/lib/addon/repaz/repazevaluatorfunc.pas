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
 sysutils,classes,mclasses,repazconsts,mseconsts,dateutils,msestrings,
 variants,repazevaluatortype,repazclasses;

type

 { functions }
 tidenuppercase=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenlowercase=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidensinus=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenmax=class(tidenfunction)
 protected
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
  function getevalvalue:variant;override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenmin=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;


 tidenfloattodatetime=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenstringtotime=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenstringtodatetime=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidentimetostring=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidendatetimetostring=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidendayofweek=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenround=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenroundtointeger=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenabs=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidencomparevalue=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenint=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenval=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenstr=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidentrim=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenleft=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenlength=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenisinteger=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenisnumeric=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenisvaliddatetime=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function getmodel: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidencheckexpression=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function getmodel: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenpos=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenmodul=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidendivide=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidensqrt=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenmonth=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenevaltext=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenmonthname=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenyear=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenday=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenright=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;


 tidenstringtobin=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidensubstr=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenformatstr=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenformatnum=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidennumtotext=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenreplacestr=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenfieldwithkey=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidensumfield=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenisdiscountday=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidenisholiday=class(tidenfunction)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { report header }
 
 tidenreportheader=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { report footer }
 
 tidenreportfooter=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;
 
 { page header }
 
 tidenpageheader=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { page footer }
 
 tidenpagefooter=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { content header }
 
 tidencontentheader=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { content footer }
 
 tidencontentfooter=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { table header }
 
 tidentableheader=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { table footer }
 
 tidentablefooter=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;
 
 { content data }
 
 tidencontentdata=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { group header }
 
 tidengroupheader=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { group footer }
 
 tidengroupfooter=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;
 
 { group data }
 
 tidengroupdata=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { page number }
 
 tidenpagenumber=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { header tree key }
 
 tidenheadertreekey=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { footer tree key }
 
 tidenfootertreekey=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { tree index }
 
 tidentreeindex=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { treefootervalue }
 
 tidentreefootervalue=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { treemainfootervalue }
 
 tidentreemainfootervalue=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { treefootervalue2 }
 
 tidentreefootervalue2=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { lettervalue }
 
 tidenlettervalue=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { record number }
 
 tidenrecordnumber=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { master number }
 
 tidenmasternumber=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { data number }
 
 tidendatanumber=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { group number }
 
 tidengroupnumber=class(tidenreport)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
  function getparam: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 { constants }

 tidentoday=class(tidenconstant)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidentime=class(tidenconstant)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidennow=class(tidenconstant)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
 public
  constructor create(aowner:tcomponent);override;
 end;

 tidennull=class(tidenconstant)
 protected
  function getevalvalue:variant;override;
  function gethelp: msestring; override;
  function getmodel: msestring; override;
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
end;

function tidenuppercase.gethelp: msestring;
begin
 result:=uc(ord(rcsuppercase));
end;

function tidenuppercase.getmodel: msestring;
begin
 result:='UpperCase(Strings:string):string';
end;

function tidenuppercase.getparam: msestring;
begin
 result:=uc(ord(rcspuppercase));
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
end;

function tidenlowercase.gethelp: msestring;
begin
 result:=uc(ord(rcslowercase));
end;

function tidenlowercase.getmodel: msestring;
begin
 result:='LowerCase(Strings:string):string';
end;

function tidenlowercase.getparam: msestring;
begin
 result:=uc(ord(rcsplowercase));
end;

constructor tidenfloattodatetime.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='FloatToDateTime';
end;

function tidenfloattodatetime.gethelp: msestring;
begin
 result:=uc(ord(rcsfloattodatetime));
end;

function tidenfloattodatetime.getmodel: msestring;
begin
 result:='FloatToDateTime(Number:double):tdatetime';
end;

function tidenfloattodatetime.getparam: msestring;
begin
 result:=uc(ord(rcspfloattodatetime));
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
end;

function tidenstringtotime.gethelp: msestring;
begin
 result:=uc(ord(rcsstringtotime));
end;

function tidenstringtotime.getmodel: msestring;
begin
 result:='StringToTime(Strings:string):tdatetime';
end;

function tidenstringtotime.getparam: msestring;
begin
 result:=uc(ord(rcspstringtotime));
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
end;

function tidenstringtodatetime.gethelp: msestring;
begin
 result:= uc(ord(rcsstringtodatetime));
end;

function tidenstringtodatetime.getmodel: msestring;
begin
 result:='StringToDateTime(Strings:string):tdatetime';
end;

function tidenstringtodatetime.getparam: msestring;
begin
 result:=uc(ord(rcspstringtodatetime));
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
end;

function tidentimetostring.gethelp: msestring;
begin
 result:=uc(ord(rcstimetostring));
end;

function tidentimetostring.getmodel: msestring;
begin
 result:='TimeToString(mask:string, Date:tdatetime):string';
end;

function tidentimetostring.getparam: msestring;
begin
 result:=uc(ord(rcsptimetostring));
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
end;

function tidendatetimetostring.gethelp: msestring;
begin
 result:= uc(ord(rcsdatetimetostring));
end;

function tidendatetimetostring.getmodel: msestring;
begin
 result:='DateTimeToString(mask:string, Date:tdatetime):string';
end;

function tidendatetimetostring.getparam: msestring;
begin
 result:=uc(ord(rcspdatetimetostring));
end;

function tidendatetimetostring.getevalvalue:variant;
begin
 result:= '';
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
end;

function tidendayofweek.gethelp: msestring;
begin
 result:= uc(ord(rcsdayofweek));
end;

function tidendayofweek.getmodel: msestring;
begin
 result:='DayOfWeek(Date:tdatetime):integer';
end;

function tidendayofweek.getparam: msestring;
begin
 result:=uc(ord(rcspdayofweek));
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
end;

function tidensinus.gethelp: msestring;
begin
 result:= uc(ord(rcssin));
end;

function tidensinus.getmodel: msestring;
begin
 result:= 'SIN(Angular:double):double';
end;

function tidensinus.getparam: msestring;
begin
 result:= uc(ord(rcspsin));
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
end;

function tidenmax.getparam: msestring;
begin
 result:= '';
end;

function tidenmax.gethelp: msestring;
begin
 result:= uc(ord(rcsmax));
end;

function tidenmax.getmodel: msestring;
begin
 result:= 'MAX(Number1:double,Number2:double):double';
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
end;

function tidenmin.gethelp: msestring;
begin
 result:= uc(ord(rcsmin));
end;

function tidenmin.getmodel: msestring;
begin
 result:= 'MIN(Number1:double,Number2:double):double';
end;

function tidenmin.getparam: msestring;
begin
 result:= '';
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
end;

function tidenround.gethelp: msestring;
begin
 result:= uc(ord(rcsround));
end;

function tidenround.getmodel: msestring;
begin
 result:= 'Round(Number:double,Rounded:double):double';
end;

function tidenround.getparam: msestring;
begin
 result:= uc(ord(rcspround));
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
end;

function tidenroundtointeger.gethelp: msestring;
begin
 result:= uc(ord(rcsround));
end;

function tidenroundtointeger.getmodel: msestring;
begin
 result:= 'RoundToInteger(Number:double):integer';
end;

function tidenroundtointeger.getparam: msestring;
begin
 result:= '';
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
end;

function tidenabs.gethelp: msestring;
begin
 result:= uc(ord(rcsabs));
end;

function tidenabs.getmodel: msestring;
begin
 result:= 'ABS(Number:double):double';
end;

function tidenabs.getparam: msestring;
begin
 result:= uc(ord(rcspabs));
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
end;

function tidencomparevalue.gethelp: msestring;
begin
 result:= uc(ord(rcscomparevalue));
end;

function tidencomparevalue.getmodel: msestring;
begin
 result:= 'Compare(Number1,Number2,Epsilon:double):integer';
end;

function tidencomparevalue.getparam: msestring;
begin
 result:= uc(ord(rcspcomparevalue));
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
end;

function tidenint.gethelp: msestring;
begin
 result:= uc(ord(rcsint));
end;

function tidenint.getmodel: msestring;
begin
 result:= 'Int(Number:double):integer';
end;

function tidenint.getparam: msestring;
begin
 result:= uc(ord(rcspint));
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
end;

function tidenstr.gethelp: msestring;
begin
 result:= uc(ord(rcsstr));
end;

function tidenstr.getmodel: msestring;
begin
 result:= 'Str(Number:variant):string';
end;

function tidenstr.getparam: msestring;
begin
 result:= uc(ord(rcspstr));
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
end;

function tidenval.gethelp: msestring;
begin
 result:= uc(ord(rcsval));
end;

function tidenval.getmodel: msestring;
begin
 result:= 'Val(Strings:string):double';
end;

function tidenval.getparam: msestring;
begin
 result:= uc(ord(rcspval));
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
end;

function tidentrim.gethelp: msestring;
begin
 result:= uc(ord(rcstrim));
end;

function tidentrim.getmodel: msestring;
begin
 result:= 'Trim(Strings:string):string';
end;

function tidentrim.getparam: msestring;
begin
 result:= uc(ord(rcsptrim));
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
end;

function tidenleft.gethelp: msestring;
begin
 result:= uc(ord(rcsleft));
end;

function tidenleft.getmodel: msestring;
begin
 result:= 'Left(Strings:string,Count:integer):string';
end;

function tidenleft.getparam: msestring;
begin
 result:= uc(ord(rcspleft));
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
end;

function tidenlength.gethelp: msestring;
begin
 result:= uc(ord(rcslength));
end;

function tidenlength.getmodel: msestring;
begin
 result:= 'Length(Strings:string):integer';
end;

function tidenlength.getparam: msestring;
begin
 result:= uc(ord(rcsplength));
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
end;

function tidenisinteger.gethelp: msestring;
begin
 result:= uc(ord(rcsisinteger));
end;

function tidenisinteger.getmodel: msestring;
begin
 result:= 'IsInteger(Strings:string):boolean';
end;

function tidenisinteger.getparam: msestring;
begin
 result:= '';
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
end;

function tidenisnumeric.gethelp: msestring;
begin
 result:= uc(ord(rcsisnumeric));
end;

function tidenisnumeric.getmodel: msestring;
begin
 result:= 'IsNumeric(Strings:string):boolean';
end;

function tidenisnumeric.getparam: msestring;
begin
 result:= '';
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
end;

function tidenisvaliddatetime.getmodel: msestring;
begin
 result:= 'IsValidDateTime(Strings:string):boolean';
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
end;

function tidencheckexpression.getmodel: msestring;
begin
 result:= 'CheckExpression(expression,message:string):boolean';
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
end;

function tidenpos.gethelp: msestring;
begin
 result:= uc(ord(rcspos));
end;

function tidenpos.getmodel: msestring;
begin
 result:= 'Pos(SubString:string,Strings:string):integer';
end;

function tidenpos.getparam: msestring;
begin
 result:= uc(ord(rcsppos));
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
end;

function tidensqrt.gethelp: msestring;
begin
 result:= uc(ord(rcssqrt));
end;

function tidensqrt.getmodel: msestring;
begin
 result:= 'SQRT(Number:double):double';
end;

function tidensqrt.getparam: msestring;
begin
 result:= uc(ord(rcspsqrt));
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
end;

function tidenmodul.gethelp: msestring;
begin
 result:= uc(ord(rcsmod));
end;

function tidenmodul.getmodel: msestring;
begin
 result:= 'MOD(Number1:integer,Number2:integer):integer';
end;

function tidenmodul.getparam: msestring;
begin
 result:= uc(ord(rcspmod));
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
end;

function tidendivide.gethelp: msestring;
begin
 result:= uc(ord(rcsdiv));
end;

function tidendivide.getmodel: msestring;
begin
 result:= 'DIV(Number1:integer,Number2:integer):integer';
end;

function tidendivide.getparam: msestring;
begin
 result:= uc(ord(rcspdiv));
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
end;

function tidentoday.gethelp: msestring;
begin
 result:= uc(ord(rcstoday));
end;

function tidentoday.getmodel: msestring;
begin
 result:= 'Today'+':date';
end;

function tidentoday.getevalvalue:variant;
begin
 result:=date;
end;

constructor tidentime.create(aowner:tcomponent);
begin
 inherited create(aowner);
 idenname:='Time';
end;

function tidentime.gethelp: msestring;
begin
 result:= uc(ord(rcstimeh));
end;

function tidentime.getmodel: msestring;
begin
 result:= 'Time'+':time';
end;

function tidentime.getevalvalue:variant;
begin
 result:=timeof(now);
end;

constructor tidennull.create(aowner:tcomponent);
begin
 inherited create(aowner);
 idenname:='Null';
end;

function tidennull.gethelp: msestring;
begin
 result:= uc(ord(rcsnull));
end;

function tidennull.getmodel: msestring;
begin
 result:= 'Null';
end;

function tidennull.getevalvalue:variant;
begin
 result:=null;
end;

constructor tidennow.create(aowner:tcomponent);
begin
 inherited create(aowner);
 idenname:='Now';
end;

function tidennow.gethelp: msestring;
begin
 result:= uc(ord(rcsnow));
end;

function tidennow.getmodel: msestring;
begin
 result:= 'Now'+':datetime';
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
 idenname:='PageNumber';
end;

function tidenpagenumber.getparam: msestring;
begin
 result:= '';
end;

function tidenpagenumber.gethelp: msestring;
begin
 result:= uc(ord(rcspagenumber));
end;

function tidenpagenumber.getmodel: msestring;
begin
 result:= 'PageNumber : integer';
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
 idenname:='HeaderTreeKey';
end;

function tidenheadertreekey.getparam: msestring;
begin
 result:= '';
end;

function tidenheadertreekey.gethelp: msestring;
begin
 result:= uc(ord(rcsheadertreekey));
end;

function tidenheadertreekey.getmodel: msestring;
begin
 result:= 'HeaderTreeKey : variant';
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
 idenname:='FooterTreeKey';
end;

function tidenfootertreekey.getparam: msestring;
begin
 result:= '';
end;

function tidenfootertreekey.gethelp: msestring;
begin
 result:= uc(ord(rcsfootertreekey));
end;

function tidenfootertreekey.getmodel: msestring;
begin
 result:= 'FooterTreeKey : variant';
end;

function tidenfootertreekey.getevalvalue:variant;
begin
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).footertreekey;
 end else begin
  result:= null;
 end;
end;

{ tidenTreeIndex }

constructor tidenTreeIndex.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=0;
 idenname:='TreeIndex';
end;

function tidenTreeIndex.getparam: msestring;
begin
 result:= '';
end;

function tidenTreeIndex.gethelp: msestring;
begin
 result:= uc(ord(rcsTreeIndex));
end;

function tidenTreeIndex.getmodel: msestring;
begin
 result:= 'TreeIndex : integer';
end;

function tidenTreeIndex.getevalvalue:variant;
begin
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).TreeIndex;
 end else begin
  result:= -1;
 end;
end;

{ tidentreefootervalue }

constructor tidentreefootervalue.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=3;
 idenname:='TreeFooterValue';
end;

function tidentreefootervalue.getparam: msestring;
begin
 result:= uc(ord(rcsptreefootervalue));
end;

function tidentreefootervalue.gethelp: msestring;
begin
 result:= uc(ord(rcstreefootervalue));
end;

function tidentreefootervalue.getmodel: msestring;
begin
 result:= 'TreeFooterValue(IndexRow:Integer, IndexCol:Integer, IndexTree:Integer): variant';
end;

function tidentreefootervalue.getevalvalue:variant;
begin
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).treefootervalue(integer(params[0]),integer(params[1]),integer(params[2]));
 end else begin
  result:= null;
 end;
end;

{ tidentreemainfootervalue }

constructor tidentreemainfootervalue.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=3;
 idenname:='TreeMainFooterValue';
end;

function tidentreemainfootervalue.getparam: msestring;
begin
 result:= uc(ord(rcsptreemainfootervalue));
end;

function tidentreemainfootervalue.gethelp: msestring;
begin
 result:= uc(ord(rcstreemainfootervalue));
end;

function tidentreemainfootervalue.getmodel: msestring;
begin
 result:= 'TreeMainFooterValue(IndexRow:Integer, IndexCol:Integer, IndexTree:Integer): variant';
end;

function tidentreemainfootervalue.getevalvalue:variant;
begin
 if owner.owner is TRepaz then begin
  result:= (owner.owner as TRepaz).treemainfootervalue(integer(params[0]),integer(params[1]),integer(params[2]));
 end else begin
  result:= null;
 end;
end;

{ tidentreefootervalue2 }

constructor tidentreefootervalue2.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=2;
 idenname:='TreeFooterValue2';
end;

function tidentreefootervalue2.getparam: msestring;
begin
 result:= uc(ord(rcsptreefootervalue2));
end;

function tidentreefootervalue2.gethelp: msestring;
begin
 result:= uc(ord(rcstreefootervalue2));
end;

function tidentreefootervalue2.getmodel: msestring;
begin
 result:= 'TreeFooterValue2(IndexCol:Integer, IndexTree:Integer): variant';
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
 idenname:='LetterValue';
end;

function tidenlettervalue.getparam: msestring;
begin
 result:= uc(ord(rcsplettervalue));
end;

function tidenlettervalue.gethelp: msestring;
begin
 result:= uc(ord(rcslettervalue));
end;

function tidenlettervalue.getmodel: msestring;
begin
 result:= 'LetterValue(IndexRow:Integer, IndexCol:Integer): variant';
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
 idenname:='RecordNumber';
end;

function tidenrecordnumber.getparam: msestring;
begin
 result:= '';
end;

function tidenrecordnumber.gethelp: msestring;
begin
 result:= uc(ord(rcsrecordnumber));
end;

function tidenrecordnumber.getmodel: msestring;
begin
 result:= 'RecordNumber : integer';
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
 idenname:='MasterNumber';
end;

function tidenmasternumber.getparam: msestring;
begin
 result:= '';
end;

function tidenmasternumber.gethelp: msestring;
begin
 result:= uc(ord(rcsmasternumber));
end;

function tidenmasternumber.getmodel: msestring;
begin
 result:= 'MasterNumber : integer';
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
 idenname:='DataNumber';
end;

function tidendatanumber.getparam: msestring;
begin
 result:= '';
end;

function tidendatanumber.gethelp: msestring;
begin
 result:= uc(ord(rcsdatanumber));
end;

function tidendatanumber.getmodel: msestring;
begin
 result:= 'DataNumber : integer';
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
 idenname:='GroupNumber';
end;

function tidengroupnumber.getparam: msestring;
begin
 result:= uc(ord(rcspgroupnumber));;
end;

function tidengroupnumber.gethelp: msestring;
begin
 result:= uc(ord(rcsgroupnumber));
end;

function tidengroupnumber.getmodel: msestring;
begin
 result:= 'GroupNumber(Index:integer) : integer';
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
 idenname:='ReportHeader';
end;

function tidenreportheader.getparam: msestring;
begin
 result:= uc(ord(rcspreportheader));
end;

function tidenreportheader.gethelp: msestring;
begin
 result:= uc(ord(rcsreportheader));
end;

function tidenreportheader.getmodel: msestring;
begin
 result:= 'ReportHeader(RowIndex:integer, ColIndex:integer):variant';
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
 idenname:='ReportFooter';
end;

function tidenreportfooter.getparam: msestring;
begin
 result:= uc(ord(rcspreportfooter));
end;

function tidenreportfooter.gethelp: msestring;
begin
 result:= uc(ord(rcsreportfooter));
end;

function tidenreportfooter.getmodel: msestring;
begin
 result:= 'ReportFooter(RowIndex:integer, ColIndex:integer):variant';
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
 idenname:='PageHeader';
end;

function tidenpageheader.getparam: msestring;
begin
 result:= uc(ord(rcsppageheader));
end;

function tidenpageheader.gethelp: msestring;
begin
 result:= uc(ord(rcspageheader));
end;

function tidenpageheader.getmodel: msestring;
begin
 result:= 'PageHeader(RowIndex:integer, ColIndex:integer):variant';
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
 idenname:='PageFooter';
end;

function tidenpagefooter.getparam: msestring;
begin
 result:= uc(ord(rcsppagefooter));
end;

function tidenpagefooter.gethelp: msestring;
begin
 result:= uc(ord(rcspagefooter));
end;

function tidenpagefooter.getmodel: msestring;
begin
 result:= 'PageFooter(RowIndex:integer, ColIndex:integer):variant';
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
 idenname:='ContentHeader';
end;

function tidencontentheader.getparam: msestring;
begin
 result:= uc(ord(rcspcontentheader));
end;

function tidencontentheader.gethelp: msestring;
begin
 result:= uc(ord(rcscontentheader));
end;

function tidencontentheader.getmodel: msestring;
begin
 result:= 'ContentHeader(ColIndex:integer):variant';
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
 idenname:='ContentFooter';
end;

function tidencontentfooter.getparam: msestring;
begin
 result:= uc(ord(rcspcontentfooter));
end;

function tidencontentfooter.gethelp: msestring;
begin
 result:= uc(ord(rcscontentfooter));
end;

function tidencontentfooter.getmodel: msestring;
begin
 result:= 'ContentFooter(ColIndex:integer):variant';
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
 idenname:='TableHeader';
end;

function tidentableheader.getparam: msestring;
begin
 result:= uc(ord(rcsptableheader));
end;

function tidentableheader.gethelp: msestring;
begin
 result:= uc(ord(rcstableheader));
end;

function tidentableheader.getmodel: msestring;
begin
 result:= 'TableHeader(TableIndex:integer, RowIndex:integer, ColIndex:integer):variant';
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
 idenname:='TableFooter';
end;

function tidentablefooter.getparam: msestring;
begin
 result:= uc(ord(rcsptablefooter));
end;

function tidentablefooter.gethelp: msestring;
begin
 result:= uc(ord(rcstablefooter));
end;

function tidentablefooter.getmodel: msestring;
begin
 result:= 'TableFooter(TableIndex:integer, RowIndex:integer, ColIndex:integer):variant';
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
 idenname:='ContentData';
end;

function tidencontentdata.getparam: msestring;
begin
 result:= uc(ord(rcspcontentdata));
end;

function tidencontentdata.gethelp: msestring;
begin
 result:= uc(ord(rcscontentdata));
end;

function tidencontentdata.getmodel: msestring;
begin
 result:= 'ContentData(ColIndex:integer):variant';
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
 idenname:='GroupHeader';
end;

function tidengroupheader.getparam: msestring;
begin
 result:= uc(ord(rcspgroupheader));
end;

function tidengroupheader.gethelp: msestring;
begin
 result:= uc(ord(rcsgroupheader));
end;

function tidengroupheader.getmodel: msestring;
begin
 result:= 'GroupHeader(RowIndex:integer, ColIndex:integer):variant';
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
 idenname:='GroupFooter';
end;

function tidengroupfooter.getparam: msestring;
begin
 result:= uc(ord(rcspgroupfooter));
end;

function tidengroupfooter.gethelp: msestring;
begin
 result:= uc(ord(rcsgroupfooter));
end;

function tidengroupfooter.getmodel: msestring;
begin
 result:= 'GroupFooter(RowIndex:integer, ColIndex:integer):variant';
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
 idenname:='GroupData';
end;

function tidengroupdata.getparam: msestring;
begin
 result:= uc(ord(rcspgroupdata));
end;

function tidengroupdata.gethelp: msestring;
begin
 result:= uc(ord(rcsgroupdata));
end;

function tidengroupdata.getmodel: msestring;
begin
 result:= 'GroupData(ColIndex:integer):variant';
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
end;

function tidenmonthname.gethelp: msestring;
begin
 result:= uc(ord(rcsmonthname));
end;

function tidenmonthname.getmodel: msestring;
begin
 result:= 'MonthName(Date:datetime):string';
end;

function tidenmonthname.getparam: msestring;
begin
 result:= uc(ord(rcspmonthname));
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
end;

function tidenevaltext.gethelp: msestring;
begin
 result:= uc(ord(rcsevaltext));
end;

function tidenevaltext.getmodel: msestring;
begin
 result:= 'EvalText(Expression:string):variant';
end;

function tidenevaltext.getparam: msestring;
begin
 result:= uc(ord(rcspevaltext));
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
end;

function tidenmonth.gethelp: msestring;
begin
 result:= uc(ord(rcsmonth));
end;

function tidenmonth.getmodel: msestring;
begin
 result:= 'Month(Date:datetime):integer';
end;

function tidenmonth.getparam: msestring;
begin
 result:= uc(ord(rcspmonth));
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
end;

function tidenyear.gethelp: msestring;
begin
 result:= uc(ord(rcsyear));
end;

function tidenyear.getmodel: msestring;
begin
 result:= 'Year(Date:datetime):integer';
end;

function tidenyear.getparam: msestring;
begin
 result:= uc(ord(rcspyear));
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
end;

function tidenday.gethelp: msestring;
begin
 result:= uc(ord(rcsday));
end;

function tidenday.getmodel: msestring;
begin
 result:= 'Day(Date:datetime):integer';
end;

function tidenday.getparam: msestring;
begin
 result:= uc(ord(rcspday));
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
end;

function tidenright.gethelp: msestring;
begin
 result:= uc(ord(rcsright));
end;

function tidenright.getmodel: msestring;
begin
 result:= 'Right(Strings:string,Count:integer):string';
end;

function tidenright.getparam: msestring;
begin
 result:= uc(ord(rcspright));
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
end;

function tidensubstr.gethelp: msestring;
begin
 result:= uc(ord(rcssubstr));
end;

function tidensubstr.getmodel: msestring;
begin
 result:= 'SubStr(Strings:string,Start:integer,Length:integer):string';
end;

function tidensubstr.getparam: msestring;
begin
 result:= uc(ord(rcspsubstr));
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
end;

function tidenformatstr.gethelp: msestring;
begin
 result:= uc(ord(rcsformatstr));
end;

function tidenformatstr.getmodel: msestring;
begin
 result:= 'FormatStr(format:string,Value:variant):string';
end;

function tidenformatstr.getparam: msestring;
begin
 result:= uc(ord(rcspformatstr));
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
end;

function tidenformatnum.getmodel: msestring;
begin
 result:= 'FormatNum(mask:string,Number:double):string';
end;

function tidenformatnum.getparam: msestring;
begin
 result:= uc(ord(rcspformatnum));
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
end;

function tidennumtotext.gethelp: msestring;
begin
 result:= uc(ord(rcsnumtotext));
end;

function tidennumtotext.getmodel: msestring;
begin
 result:= 'NumToText(Number:double):string';
end;

function tidennumtotext.getparam: msestring;
begin
 result:= uc(ord(rcspnumtotext));
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
end;

function tidenreplacestr.gethelp: msestring;
begin
 result:= uc(ord(rcsreplacestr));
end;

function tidenreplacestr.getmodel: msestring;
begin
 result:= 'ReplaceStr(Strings:string, OldPattern:string, NewPattern:string;): string';
end;

function tidenreplacestr.getparam: msestring;
begin
 result:= uc(ord(rcspreplacestr));
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
end;

function tidenfieldwithkey.gethelp: msestring;
begin
 result:= uc(ord(rcsfieldwithkey));
end;

function tidenfieldwithkey.getmodel: msestring;
begin
 result:= 'FieldWithKey(KeyField:string, KeyValue:variant, ValueField:string): variant';
end;

function tidenfieldwithkey.getparam: msestring;
begin
 result:= uc(ord(rcspfieldwithkey));
end;

function tidenfieldwithkey.getevalvalue:variant;
var
 pos1,pos2: integer;
 adataset,afield,afield2: string;
begin
 if (not varisstring(params[0]))
  or (not varisstring(params[2])) then
   raise tevalnamedexception.create(uc(ord(rcsevaltype)),idenname);
 pos1:=pos('.',params[0]);
 adataset:=copy(params[0],0,pos1-1);
 afield:=copy(params[0],pos1+1,length(params[0])-pos1);
 pos2:=pos('.',params[2]);
 afield2:=copy(params[2],pos2+1,length(params[2])-pos2);
 result:= trepazevaluator(owner).datasource.searchfieldwithkey(adataset,afield,[params[1]],afield2);
end;

{ tidensumfield }

constructor tidensumfield.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fparamcount:=1;
 idenname:='sumfield';
end;

function tidensumfield.gethelp: msestring;
begin
 result:= uc(ord(rcssumfield));
end;

function tidensumfield.getmodel: msestring;
begin
 result:= 'sumfield(FieldName:string): variant';
end;

function tidensumfield.getparam: msestring;
begin
 result:= uc(ord(rcspsumfield));
end;

function tidensumfield.getevalvalue:variant;
var
 pos1: integer;
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
end;

function tidenisdiscountday.gethelp: msestring;
begin
 result:= uc(ord(rcsisdiscountday));
end;

function tidenisdiscountday.getmodel: msestring;
begin
 result:= 'IsDiscountday(ADate:tdatetime, IncludeSunday:boolean): boolean';
end;

function tidenisdiscountday.getparam: msestring;
begin
 result:= uc(ord(rcspisdiscountday));
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
end;

function tidenisholiday.gethelp: msestring;
begin
 result:= uc(ord(rcsisholiday));
end;

function tidenisholiday.getmodel: msestring;
begin
 result:= 'IsHoliday(ADate:tdatetime, IncludeSunday:boolean): boolean';
end;

function tidenisholiday.getparam: msestring;
begin
 result:= uc(ord(rcspisholiday));
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
end;

function tidenstringtobin.gethelp: msestring;
begin
 result:= uc(ord(rcsdecode64));
end;

function tidenstringtobin.getmodel: msestring;
begin
 result:= 'StringToBin(Strings:string):binary';
end;

function tidenstringtobin.getparam: msestring;
begin
 result:= '';
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
