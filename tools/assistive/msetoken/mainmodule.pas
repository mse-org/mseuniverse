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
{$ifdef FPC}{$mode objfpc}{$h+}{$goto on}{$endif}
interface
uses
 msetypes,mseglob,mseapplication,mseclasses,msedatamodules,msestat,msestatfile,
 mseassistivehandler,mseactions,msedatabase,msefb3connection,msqldb,sysutils,
 mdb,msebufdataset,msedb,mseifiglob,msesqldb,mserttistat,mclasses;

type
 topt = class(toptions)
  private
   feditobjectpk: int64;
   ftokenobjectpk: int64;
  published
   property editobjectpk: int64 read feditobjectpk write feditobjectpk;
   property tokenobjectpk: int64 read ftokenobjectpk write ftokenobjectpk;
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
   tokensqu: tmsesqlquery;
   newtokenprintandstoreact: taction;
   newtokenprintact: taction;
   newtokenstoreact: taction;
   nowtokencloseact: taction;
   objectsdso: tmsedatasource;
   tokensobject: tmselargeintfield;
   tokensunit: tmsestringfield;
   tokensvalue: tmsebcdfield;
   tokensduration: tmsefloatfield;
   tokensdescription: tmsestringfield;
   objectsunit: tmsestringfield;
   tokensquantity: tmsefloatfield;
   objectsprice: tmsefloatfield;
   objectsdescription: tmsestringfield;
   objectsduration: tmsefloatfield;
   tokensissuedate: tmsedatefield;
   numbersqu: tmsesqlquery;
   numbersnumber: tmselongintfield;
   numberdso: tmsedatasource;
   tokensnumber: tmselongintfield;
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
   ftokenused: boolean;
  protected
   function selectobject(const apk: int64): int64;
   procedure updatetokenvalue();
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy(); override;
   property opt: topt read fopt;
   procedure closequery(const adataso: tdatasource; 
                                     var amodalres: modalresultty);
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
 internalerror = 'Interner Fehler';
 closewindowcancelrecordquestion = 
                 'Wollen Sie den geänderten Datensatz verwerfen?';

{ topt }

{ tmainmo }

procedure showinternalerror();
begin
 showerror(rs(internalerror));
 application.terminated:= true;
end;

procedure tmainmo.newtokenev(const sender: TObject);
var
 b1: boolean;
begin
 tokensqu.open();
 try
  b1:= false;
  ftokenused:= false;
  repeat
   try
    numbersqu.insert();
    numbersnumber.asinteger:= random(999);
    numbersqu.post();
    b1:= true;
   except
    on e: efberror do begin
     if e.error <> -803 then begin //unique_key_violation
      showinternalerror();
      exit;
     end;
    end;
    else begin
     showinternalerror();
     exit;
    end;
   end;
  until b1;
  tokensqu.insert();
  tokensissuedate.asdate:= now();
  tokensnumber.asinteger:= numbersnumber.asinteger;
  if objectsqu.indexlocal[0].find([fopt.tokenobjectpk],[]) then begin
   tokensobject.asid:= fopt.tokenobjectpk;
  end;
  tokensqu.resetmodified();
  with tnewtokenfo.create(nil) do begin
   try
    case show(ml_application) of
     mr_ok: begin
//      objectsqu.post();
     end;
    end;
    if not ftokenused then begin
     numbersqu.delete();
    end;
    fopt.tokenobjectpk:= tokensobject.asid;
   finally
    destroy();
   end;
  end;
 finally
  tokensqu.cancel();
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

procedure tmainmo.closequery(const adataso: tdatasource;
               var amodalres: modalresultty);
begin
 if adataso.dataset.modified then begin
  if not askyesno(rs(closewindowcancelrecordquestion)) then begin
   amodalres:= mr_none;
  end;
 end;
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
 if not tokensquantity.isnull then begin
  if objectsqu.indexlocal[0].find([tokensobject],bookmark1) then begin
   tokensvalue.asfloat:= 
           objectsqu.currentbmasfloat[objectsprice,bookmark1] * 
                                                    tokensquantity.asfloat;
  end;
 end
 else begin
  tokensvalue.clear;
 end;
end;

procedure tmainmo.tokenobjectchangev(Sender: TField);
var
 bookmark1: bookmarkdataty;
begin
 if objectsqu.indexlocal[0].find([tokensobject],bookmark1) then begin
  tokensunit.asmsestring:= objectsqu.currentbmasmsestring[objectsunit,bookmark1];
  tokensduration.asfloat:= objectsqu.currentbmasfloat[objectsduration,bookmark1];
  updatetokenvalue();
 end;
end;

procedure tmainmo.tokenquantitiychangeev(Sender: TField);
begin
 updatetokenvalue();
end;

initialization
 randomize();
end.
