{*********************************************************}
{             Collection Datasources for Repaz            }
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
unit repazdatasources;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 classes,mclasses,mseclasses,mdb,msedb,msearrayprops,repazevaluatortype,
 msebufdataset;
type
 trepazdatasources = class;
 
 tdatasourceitem = class(tvirtualpersistent)
  protected
   fdatasource: tdatasource;
   procedure setdatasource(const avalue: tdatasource);
  published
   property datasource: tdatasource read fdatasource write setdatasource;
 end;

 tdatasourceitems = class(tpersistentarrayprop)
  private
  protected
   function getitems(const index: integer): tdatasourceitem;
   procedure createitem(const index: integer; var item: tpersistent); override;
  public
   constructor create;
   class function getitemclasstype: persistentclassty; override;
   property items[const index: integer]: tdatasourceitem read getitems;default;
  published
 end;

 trepazdatasources = class(tmsecomponent)
  private
   iden:tidenfield;
   fdatasources: tdatasourceitems;
   procedure setdatasource(const Value: tdatasourceitems);
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy; override;
   function getdatasource(aname: string): tdatasource;
   function count: integer;
   function searchfield(aname:string):tevalidentifier;
   function searchfieldwithdataset(adataset:string;aname:string):tevalidentifier;
   function searchfieldwithkey(adataset:string;keyname:string;keyvalue:array of const;fieldvaluename:string):variant;
   function sumfield(adataset:string;afieldname:string):variant;
   procedure fillwithfields(lines:tstrings);
  published
   property datasource: tdatasourceitems read fdatasources write setdatasource;
 end;

implementation

{ tdatasourceitem }

procedure tdatasourceitem.setdatasource(const avalue:tdatasource);
begin
 if avalue<>fdatasource then begin
  fdatasource:= avalue;
 end;
end;

{ tdatasourceitems }

constructor tdatasourceitems.create;
begin
 inherited create(tdatasourceitem);
end;

function tdatasourceitems.getitems(const index: integer): tdatasourceitem;
begin
 result:= tdatasourceitem(inherited getitems(index));
end;

procedure tdatasourceitems.createitem(const index: integer; var item: tpersistent);
begin
 inherited;
end;

class function tdatasourceitems.getitemclasstype: persistentclassty;
begin
 result:= tdatasourceitem;
end;

{ trepazdatasources }

constructor trepazdatasources.create(aowner: tcomponent);
begin
 fdatasources:= tdatasourceitems.create;
 iden:=tidenfield.createfield(self,'');
 inherited;
end;

destructor trepazdatasources.destroy;
begin
 fdatasources.Free;
 inherited;
end;

function trepazdatasources.getdatasource(aname: string): tdatasource;
var
 int1: integer;
begin
 result:= nil;
 for int1:=0 to fdatasources.count-1 do begin
  if lowercase(aname)=lowercase(fdatasources[int1].DataSource.name) then begin
   result:= fdatasources[int1].DataSource;
   exit;
  end;
 end;
end;

procedure trepazdatasources.setdatasource(const Value: tdatasourceitems);
begin
 fdatasources.assign(Value);
end;

function trepazdatasources.count: integer;
begin
 result:= fdatasources.count;
end;

// searching a field in the list
function trepazdatasources.searchfield(aname:string):tevalidentifier;
var 
 field:tfield;
 i,j: integer;
begin
 result:=nil;
 if fdatasources.count>0 then begin
  for i:=0 to fdatasources.count-1 do begin
   for j:=0 to fdatasources[i].datasource.dataset.fieldcount-1 do begin
    if lowercase(aname)=lowercase(fdatasources[i].datasource.dataset.fields[j].fieldname) then begin
     field:=fdatasources[i].datasource.dataset.fieldbyname(aname);
     if field<>nil then begin
      iden.field:=field;
      result:=iden;
     end;
     exit;
    end;
   end;
  end;
 end;
end;

function trepazdatasources.searchfieldwithdataset(adataset:string;aname:string):tevalidentifier;
var 
 field:tfield;
 i:integer;
begin
 result:=nil;
 if fdatasources.count>0 then begin
  for i:=0 to fdatasources.count-1 do begin
   if lowercase(adataset)=lowercase(fdatasources[i].datasource.name) then begin
    field:=fdatasources[i].datasource.dataset.fieldbyname(aname);
    if field<>nil then begin
     iden.field:=field;
     result:=iden;
    end;
    exit;
   end;
  end;
 end;
end;

function trepazdatasources.searchfieldwithkey(adataset:string;keyname:string;keyvalue:array of const;fieldvaluename:string):variant;
var 
 i:integer;
begin
 result:=null;
 if fdatasources.count>0 then begin
  for i:=0 to fdatasources.count-1 do begin
   if adataset<>'' then begin
    if lowercase(adataset)=lowercase(fdatasources[i].datasource.name) then begin
     if fdatasources[i].datasource.dataset.recordcount>0 then begin
      if tmsebufdataset(fdatasources[i].datasource.dataset).locate(
             [fdatasources[i].datasource.dataset.fieldbyname(keyname)],
                                       keyvalue,[false],[],[])=loc_ok then begin
       result:=fdatasources[i].datasource.dataset.fieldbyname(fieldvaluename).asvariant;
      end;
     end;
     exit;
    end;
   end else begin
    if fdatasources[i].datasource.dataset.recordcount>0 then begin
     if tmsebufdataset(fdatasources[i].datasource.dataset).locate([fdatasources[i].datasource.dataset.fieldbyname(keyname)],keyvalue,[false],[],[])=loc_ok then begin
      result:=fdatasources[i].datasource.dataset.fieldbyname(fieldvaluename).asvariant;
     end;
    end;
    exit;
   end;
  end;
 end;
end;

function trepazdatasources.sumfield(adataset:string;afieldname:string):variant;
var 
 i:integer;
begin
 result:=null;
 if fdatasources.count>0 then begin
  for i:=0 to fdatasources.count-1 do begin
   if adataset<>'' then begin
    if lowercase(adataset)=lowercase(fdatasources[i].datasource.name) then begin
     if fdatasources[i].datasource.dataset.recordcount>0 then begin
      result:= tmsebufdataset(fdatasources[i].datasource.dataset).sumfielddouble(
        fdatasources[i].datasource.dataset.fieldbyname(afieldname));
     end;
     exit;
    end;
   end else begin
    if fdatasources[i].datasource.dataset.recordcount>0 then begin
     tmsebufdataset(fdatasources[i].datasource.dataset).sumfielddouble(
       fdatasources[i].datasource.dataset.fieldbyname(afieldname));
    end;
    exit;
   end;
  end;
 end;
end;

// fills a string list with the fieldnames in a
// aliaslist as alias.field
procedure trepazdatasources.fillwithfields(lines:tstrings);
var
 i,j:integer;
begin
 lines.clear;
 if fdatasources.count>0 then begin
  for i:=0 to fdatasources.count-1 do begin
   for j:=0 to fdatasources[i].datasource.dataset.fieldcount-1 do begin
    if fdatasources.count=1 then begin
     lines.add(fdatasources[i].datasource.dataset.fields[j].fieldname);
    end else begin
     lines.add(fdatasources[i].datasource.name + '.' + fdatasources[i].datasource.dataset.fields[j].fieldname);
    end;
   end;
  end;
 end;
end;

end.
