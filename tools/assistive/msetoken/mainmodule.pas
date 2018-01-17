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
 mdb,msebufdataset,msedb,mseifiglob,msesqldb,mserttistat,mclasses,tokenlistform,
 newtokenform,mseificomp,mseificompglob;

type
 topt = class(toptions)
  private
   feditobjectpk: int64;
   ftokenobjectpk: int64;
   ftokensortnumber: boolean;
   ftokensortissuedate: boolean;
   ftokensorthonourdate: boolean;
   ftokensortexpirydate: boolean;
   ftokensortquantity: boolean;
   ftokensortunit: boolean;
   ftokensortvalue: boolean;
   ftokensortdescription: boolean;
   ftokensortdesc: boolean;
  published
   property editobjectpk: int64 read feditobjectpk write feditobjectpk;
   property tokenobjectpk: int64 read ftokenobjectpk write ftokenobjectpk;
   property tokensortissuedate: boolean read ftokensortissuedate
                                                    write ftokensortissuedate;
   property tokensorthonourdate: boolean read ftokensorthonourdate
                                                    write ftokensorthonourdate;
   property tokensortexpirydate: boolean read ftokensortexpirydate
                                                    write ftokensortexpirydate;
   property tokensortnumber: boolean read ftokensortnumber
                                                    write ftokensortnumber;
   property tokensortquantity: boolean read ftokensortquantity
                                                    write ftokensortquantity;
   property tokensortunit: boolean read ftokensortunit
                                                    write ftokensortunit;
   property tokensortvalue: boolean read ftokensortvalue
                                                    write ftokensortvalue;
   property tokensortdescription: boolean read ftokensortdescription
                                                    write ftokensortdescription;
   property tokensortdesc: boolean read ftokensortdesc
                                                    write ftokensortdesc;
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
   printtokenact: taction;
   printvoucheract: taction;
   newtokenstoreact: taction;
   newtokencloseact: taction;
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
   tokenlistact: taction;
   tokenlistshowact: taction;
   tokensexpirydate: tmsedatefield;
   honourcheck: tifistringlinkcomp;
   honournumber: tifiint64linkcomp;
   tokensdso: tmsedatasource;
   honourtokenact: taction;
   honourdate: tifidatetimelinkcomp;
   tokensdispdso: tmsedatasource;
   tokenshonourdate: tmsedatefield;
   honourtokenfinishact: taction;
   honourform: tififormlinkcomp;
   tokensnumbertext: tmsestringfield;
   printduplicateact: taction;
   mainform: tififormlinkcomp;
   procedure newtokenev(const sender: TObject);
   procedure objectsev(const sender: TObject);
   procedure newobjectev(const sender: TObject);
   procedure editobjectev(const sender: TObject);
   procedure deleteobjectev(const sender: TObject);
   procedure getstatobjev(const sender: TObject; var aobject: TObject);
   procedure tokenobjectchangev(Sender: TField);
   procedure tokenquantitiychangeev(Sender: TField);
   procedure tokenstoreev(const sender: TObject);
   procedure tokenlistshowev(const sender: TObject; var accept: Boolean);
   procedure updateexpirydateev(Sender: TField);
   procedure honourtokenev(const sender: TObject);
   procedure tokenlistev(const sender: TObject);
   procedure honourdataentev(const sender: tcustomificlientcontroller;
                   const aclient: iificlient; const aindex: Integer);
   procedure honourmodalresultev(const sender: tcustomificlientcontroller;
                   const aclient: iificlient;
                   var amodalresult: modalresultty);
   procedure tokensmodifiedev(DataSet: TDataSet);
   procedure printtokenev(const sender: TObject);
   procedure printvoucherev(const sender: TObject);
   procedure tokennumberchangeev(Sender: TField);
   procedure printduplicateev(const sender: TObject);
   procedure mainfomdalresev(const sender: tcustomificlientcontroller;
                   const aclient: iificlient;
                   const amodalresult: modalresultty);
  private
   fopt: topt;
   ftokenused: boolean;
   fvoucherprinted,ftokenprinted: boolean;
   ftokenlistfo: ttokenlistfo;
   fnewtokenfo: tnewtokenfo;
  protected
   function selectobject(const apk: int64): int64;
   procedure updatetokenvalue();
   procedure resetprintflags();
   function checkprintok(): boolean;
   function checknewtokenok(): boolean;
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
 msegui,mainmodule_mfm,objectsform,msewidgets,msestrings,
 newobjectform,selectobjectform,editobjectform,deleteobjectform,mseformatstr,
 tokenlist1form,honourform,dateutils,msegraphedits,msestockobjects;

resourcestring
 deletequestion = 'Wollen sie den Datensatz %0:S löschen?';
 recorddeleted = 'Datensatz %0:S wurde gelöscht.';
 recordchanged = 'Datensatz %0:S wurde geändert.';
 internalerror = 'Interner Fehler';
 closewindowcancelrecordquestion = 
                 'Wollen Sie den geänderten Datensatz verwerfen?';
 honourok = 'Gutschein in Ordnung.';
 honourdateerror = 'Gutschein seit %d Tagen abgelaufen!';
 honourhonourerror = 'Gutschein bereits eingelöst am %s!';
 cancelhonourquery = 'Wollen Sie die Gutscheineinlösung abbrechen?';
 tokenmustbeprinted = 'Gutschein muss ausgedruckt werden!';
 vouchermustbeprinted = 'Beleg muss ausgedruckt werden!';
 tokenstored = 'Gutschein Nummer %d wurde eingetragen.';
 msetokencloses = 'MSEtoken wird beendet.';
 

{ topt }

{ tmainmo }

procedure showinternalerror();
begin
 showerror(rs(internalerror));
 application.terminated:= true;
end;

procedure tmainmo.resetprintflags();
begin
 fvoucherprinted:= false;
 ftokenprinted:= false;
end;

function tmainmo.checkprintok(): boolean;
begin
 result:= false;
 if not ftokenprinted then begin
  fnewtokenfo.printtokenbu.setfocus();
  showerror(rs(tokenmustbeprinted));
 end
 else begin
  if not fvoucherprinted then begin
   fnewtokenfo.printvoucherbu.setfocus();
   showerror(rs(vouchermustbeprinted));
  end
  else begin
   result:= true;
  end;
 end;
end;

function tmainmo.checknewtokenok(): boolean;
begin
 tokensqu.modify(false);
 result:= fnewtokenfo.canparentclose();
 if result then begin
  fnewtokenfo.dataso.updaterecord();
 end;
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

procedure tmainmo.tokenstoreev(const sender: TObject);
begin
 if checkprintok() then begin
  if tokensqu.post1() then begin
   showmessage(formatmse(rs(tokenstored),[tokensnumber.asinteger]));
   fnewtokenfo.window.modalresult:= mr_ok;
  end
  else begin
   fnewtokenfo.window.modalresult:= mr_cancel;
  end;
 end;
end;

procedure tmainmo.newtokenev(const sender: TObject);
var
 b1: boolean;
begin
 resetprintflags();
 tokensqu.open();
 try
  b1:= false;
  ftokenused:= false;
  repeat
   try
    numbersqu.insert();
    numbersnumber.asinteger:= random(9999);
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
  fnewtokenfo:= tnewtokenfo.create(nil);
  with fnewtokenfo do begin
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
 if (amodalres <> mr_ok) and adataso.dataset.modified then begin
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

procedure tmainmo.tokenlistshowev(const sender: TObject; var accept: Boolean);
var
 w1: tcustombooleaneditradio;
begin
 with ttokenlist1fo.create(nil) do begin
  try
   w1:= ftokenlistfo.tokensortissuedate.checkeditem;
   if w1 <> nil then begin
    with grid.datacols[w1.tag] do begin
     sortdescend:= ftokenlistfo.tokensortdesc.value;
    end;
    grid.datacols.sortcol:= w1.tag;
   end;
   tokensqu.first();
   show(ml_application);
  finally
   destroy();
  end;
 end;
end;

procedure tmainmo.tokenlistev(const sender: TObject);
begin
 ftokenlistfo:= ttokenlistfo.create(nil); 
 with ftokenlistfo do begin
  try
   fopt.loadvalues(ftokenlistfo);
   show(ml_application);
   fopt.storevalues(ftokenlistfo);
  finally
   destroy();
  end;
 end;
end;

procedure tmainmo.updateexpirydateev(Sender: TField);
var
 flo1: flo64;
begin
 if not tokensissuedate.isnull and not tokensduration.isnull then begin
  flo1:= tokensduration.asfloat;
  if frac(flo1) = 0 then begin
   tokensexpirydate.asdatetime:= incyear(tokensissuedate.asdate,round(flo1));
  end
  else begin
   tokensexpirydate.asdate:= tokensissuedate.asdate+365*flo1;
  end;
 end;
end;

procedure tmainmo.honourdataentev(const sender: tcustomificlientcontroller;
               const aclient: iificlient; const aindex: Integer);
var
 f1: flo64;
begin
 honourcheck.c.value:= '';
 honourtokenfinishact.enabled:= false;
 if honournumber.c.value < 0 then begin
  tokensdispdso.dataset:= nil;
 end
 else begin
  tokensqu.indexlocal[0].find([honournumber.c.value],[]);
  tokensdispdso.dataset:= tokensqu;
  if not tokenshonourdate.isnull then begin
   honourcheck.c.value:= formatmse(rs(honourhonourerror),
               [datetimetostring(tokenshonourdate.asdate,'${dateformat}')]);
   showerror(honourcheck.c.value,sc(sc_error),0,'',true);
  end
  else begin
   if not tokensexpirydate.isnull and 
                     not (honourdate.c.value = emptydatetime) then begin
    f1:= honourdate.c.value - tokensexpirydate.asdate;
    if f1 > 0.99999 then begin
     honourcheck.c.value:= formatmse(rs(honourdateerror),[round(f1)]);
     showerror(honourcheck.c.value,sc(sc_error),0,'',true);
    end
    else begin
     honourtokenfinishact.enabled:= true;
     honourcheck.c.value:= rs(honourok);
     showerror(honourcheck.c.value,'',0,'',true);
    end;
   end
   else begin
    honourcheck.c.value:= '';
   end;
  end;
 end;
end;

procedure tmainmo.honourtokenev(const sender: TObject);
begin
 with thonourfo.create(nil) do begin
  try
   honourtokenfinishact.enabled:= false;
   honournumber.c.value:= -1;
   honourdate.c.value:= trunc(now);
   tokensdispdso.dataset:= nil;
   case show(ml_application) of
    mr_ok: begin
     tokensqu.edit();
     tokenshonourdate.asdate:= honourdate.c.value;
     tokensqu.post();
    end;
   end;
  finally
   destroy();
   tokensqu.cancel();
  end;
 end;
end;

procedure tmainmo.honourmodalresultev(const sender: tcustomificlientcontroller;
               const aclient: iificlient; var amodalresult: modalresultty);
begin
 if (amodalresult = mr_windowclosed) and honourtokenfinishact.enabled
         and not askyesno(rs(cancelhonourquery)) then begin
  amodalresult:= mr_none;
 end;
end;

procedure tmainmo.tokensmodifiedev(DataSet: TDataSet);
begin
 resetprintflags();
end;

procedure tmainmo.printtokenev(const sender: TObject);
begin
 if checknewtokenok() then begin
  ftokenprinted:= true;
 end;
end;

procedure tmainmo.printvoucherev(const sender: TObject);
begin
 if checknewtokenok() then begin
  fvoucherprinted:= true;
 end;
end;

procedure tmainmo.tokennumberchangeev(Sender: TField);
begin
 tokensnumbertext.asmsestring:= inttostrmse(tokensnumber.asinteger);
end;

procedure tmainmo.printduplicateev(const sender: TObject);
begin
 guibeep();
end;

procedure tmainmo.mainfomdalresev(const sender: tcustomificlientcontroller;
               const aclient: iificlient; const amodalresult: modalresultty);
begin
 with assistivehandler do begin
  speaktext(rs(msetokencloses),voicecaption);
  wait();
 end;
end;

{ topt }

initialization
 randomize();
end.
