{ MSEtoken Copyright (c) 2018 by Martin Schreiber
   
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
}
unit mainmodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseapplication,mseclasses,msedatamodules,msestat,msestatfile,
 mseassistivehandler,mseactions,msedatabase,msefb3connection,msqldb,sysutils,
 mdb,msebufdataset,msedb,mseifiglob,msesqldb,mserttistat,mclasses;

type
 topt = class(toptions)
  private
   feditobjectpk: int64;
  published
   property editobjectpk: int64 read feditobjectpk write feditobjectpk;
 end;
 
 tmainmo = class(tmsedatamodule)
   tstatfile1: tstatfile;
   assistivehandler: tassistivehandler;
   newtokenact: taction;
   conn: tfb3connection;
   trans: tmsesqltransaction;
   objectsqu: tmsesqlquery;
   objectsact: taction;
   newobjectact: taction;
   editobjectact: taction;
   deleteobjectact: taction;
   tactivator1: tactivator;
   trttistat1: trttistat;
   tokenqu: tmsesqlquery;
   newtokenprintandstoreact: taction;
   newtokenprintact: taction;
   newtokenstoreact: taction;
   nowtokencloseact: taction;
   objectsdso: tmsedatasource;
   tokenobject: tmselargeintfield;
   tokenunit: tmsestringfield;
   tokenvalue: tmsebcdfield;
   tokenduration: tmsefloatfield;
   tokendescription: tmsestringfield;
   objectsunit: tmsestringfield;
   tokenquantity: tmsefloatfield;
   objectsprice: tmsefloatfield;
   objectsdescription: tmsestringfield;
   objectsduration: tmsefloatfield;
   tokenissuedate: tmsedatefield;
   procedure newtokenev(const sender: TObject);
   procedure objectsev(const sender: TObject);
   procedure newobjectev(const sender: TObject);
   procedure editobjectev(const sender: TObject);
   procedure deleteobjectev(const sender: TObject);
   procedure getstatobjev(const sender: TObject; var aobject: TObject);
   procedure tokenobjectchangev(Sender: TField);
   procedure tokenquantitiychangeev(Sender: TField);
  private
   fopt: topt;
  protected
   function selectobject(const apk: int64): int64;
   procedure updatetokenvalue();
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy(); override;
   property opt: topt read fopt;
 end;
 
var
 mainmo: tmainmo;
 
implementation
uses
 msegui,mainmodule_mfm,newtokenform,objectsform,msewidgets,msestrings,
 newobjectform,selectobjectform,editobjectform,deleteobjectform,mseformatstr;

resourcestring
 deletequestion = 'Wollen sie den Datensatz %0:S löschen?';
 recorddeleted = 'Datensatz %0:S wurde gelöscht.';
 recordchanged = 'Datensatz %0:S wurde geändert.';

{ topt }

{ tmainmo }

procedure tmainmo.newtokenev(const sender: TObject);
begin
 tokenqu.open();
 try
  tokenqu.insert();
  tokenissuedate.asdate:= now();
  with tnewtokenfo.create(nil) do begin
   try
    case show(ml_application) of
     mr_ok: begin
//      objectsqu.post();
     end;
    end;
   finally
    destroy();
   end;
  end;
 finally
  tokenqu.cancel();
 end;
end;

procedure tmainmo.objectsev(const sender: TObject);
begin
 with tobjectsfo.create(nil) do begin
  show(ml_application);
 end;
end;

procedure tmainmo.newobjectev(const sender: TObject);
begin
 objectsqu.open();
 try
  objectsqu.insert();
  with tnewobjectfo.create(nil) do begin
   try
    case show(ml_application) of
     mr_ok: begin
      objectsqu.post();
     end;
    end;
   finally
    destroy();
   end;
  end;
 finally
  objectsqu.cancel();
 end;
end;

function tmainmo.selectobject(const apk: int64): int64;
begin
 result:= -1;
 objectsqu.open();
 with tselectobjectfo.create(nil) do begin
  selector.value:= apk;
  try
   case show(ml_application) of
    mr_ok: begin
     result:= selector.value;
    end;
   end;
  finally
   destroy();
  end;
 end;
end;

constructor tmainmo.create(aowner: tcomponent);
begin
 fopt:= topt.create();
 inherited;
end;

destructor tmainmo.destroy();
begin
 inherited;
 fopt.free();
end;

procedure tmainmo.editobjectev(const sender: TObject);
var
 i1: int64;
begin
 try
  i1:= selectobject(fopt.editobjectpk);
  mainmo.assistivehandler.speakcontinue();
  if i1 >= 0 then begin
   fopt.editobjectpk:= i1;
   objectsqu.indexlocal[0].find([i1],[]);
   with teditobjectfo.create(nil) do begin
    try
     case show(ml_application) of
      mr_ok: begin
       objectsqu.post();
      {
       with assistivehandler do begin
        speaktext(format(rs(recordchanged),[nameed.value]),voicecaption,true);
       end;
      }
      end;
     end;
    finally
     destroy();
    end;
   end;
  end;
 finally
  objectsqu.cancel();
 end;
end;

procedure tmainmo.deleteobjectev(const sender: TObject);
var
 i1: int64;
begin
 try
  i1:= selectobject(-1);
  mainmo.assistivehandler.speakcontinue();
  if i1 >= 0 then begin
   objectsqu.indexlocal[0].find([i1],[]);
   with tdeleteobjectfo.create(nil) do begin
    try
     case show(ml_application) of
      mr_ok: begin
       if askyesno(formatmse(rs(deletequestion),[nameed.value])) then begin
        objectsqu.delete();
       {
        with assistivehandler do begin
         speaktext(format(rs(recorddeleted),[nameed.value]),voicecaption,true);
        end;
       }
       end;
      end;
     end;
    finally
     destroy();
    end;
   end;
  end;
 finally
  objectsqu.cancel();
 end;
end;

procedure tmainmo.getstatobjev(const sender: TObject; var aobject: TObject);
begin
 aobject:= fopt;
end;

procedure tmainmo.updatetokenvalue();
var
 bookmark1: bookmarkdataty;
begin
 if not tokenquantity.isnull then begin
  if objectsqu.indexlocal[0].find([tokenobject],bookmark1) then begin
   tokenvalue.asfloat:= 
           objectsqu.currentbmasfloat[objectsprice,bookmark1] * 
                                                    tokenquantity.asfloat;
  end;
 end
 else begin
  tokenvalue.clear;
 end;
end;

procedure tmainmo.tokenobjectchangev(Sender: TField);
var
 bookmark1: bookmarkdataty;
begin
 if objectsqu.indexlocal[0].find([tokenobject],bookmark1) then begin
  tokenunit.asmsestring:= objectsqu.currentbmasmsestring[objectsunit,bookmark1];
  tokenduration.asfloat:= objectsqu.currentbmasfloat[objectsduration,bookmark1];
  updatetokenvalue();
 end;
end;

procedure tmainmo.tokenquantitiychangeev(Sender: TField);
begin
 updatetokenvalue();
end;

end.
