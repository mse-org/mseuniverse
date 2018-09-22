{ MSEcoupon Copyright (c) 2018 by Martin Schreiber
   
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
 newtokenform,mseificomp,mseificompglob,mseact,msedataedits,msedropdownlist,
 mseedit,msegraphics,msegraphutils,msegui,mseguiglob,msemenus,msereport,
 msepostscriptprinter,mseprinter,msestream,msepipestream,mseprocess,mseforms,
 mselookupbuffer,msesqlresult,msefb3service,msetimer,msespeak;

const
 versiontext = '1.0';

type
 topt = class(toptions)
  private
   feditobjectpk: int64;
   ftokenobjectpk: int64;
   ftokensortnumber: boolean;
   ftokensortcustomer: boolean;
   ftokensortdonator: boolean;
   ftokensortrecipient: boolean;
   ftokensortissuedate: boolean;
   ftokensorthonourdate: boolean;
   ftokensortexpirydate: boolean;
   ftokensortquantity: boolean;
   ftokensortunit: boolean;
   ftokensortvalue: boolean;
   ftokensortdescription: boolean;
   ftokensortdesc: boolean;
   fassistiverate: flo64;
   fassistivevolume: flo64;
   fissuedateon: boolean;
   fissuedatecapt: msestring;
   fissuedatex: flo64;
   fissuedatey: flo64;
   fexpirydateon: boolean;
   fexpirydatecapt: msestring;
   fexpirydatex: flo64;
   fexpirydatey: flo64;
   fdurationon: boolean;
   fdurationcapt: msestring;
   fdurationx: flo64;
   fdurationy: flo64;
   fnumberon: boolean;
   fnumbercapt: msestring;
   fnumberx: flo64;
   fnumbery: flo64;
   fbarcodeon: boolean;
   fbarcodecapt: msestring;
   fbarcodex: flo64;
   fbarcodey: flo64;
   fquantityon: boolean;
   fquantitycapt: msestring;
   fquantityx: flo64;
   fquantityy: flo64;
   fdescriptionon: boolean;
   fdescriptioncapt: msestring;
   fdescriptionx: flo64;
   fdescriptiony: flo64;
   frecipienton: boolean;
   frecipientcapt: msestring;
   frecipientx: flo64;
   frecipienty: flo64;
   fdonatoron: boolean;
   fdonatorcapt: msestring;
   fdonatorx: flo64;
   fdonatory: flo64;
   fpdfvariables: boolean;
   fpsbackground: boolean;
   ftokenfile: msestring;
   forigx: flo64;
   forigy: flo64;
   fps2pdf: msestring;
   fpdftk: msestring;
   fpsviewer: msestring;
   fpsviewerparams: msestring;
   fissuedatew: flo64;
   fexpirydatew: flo64;
   fdurationw: flo64;
   fnumberw: flo64;
   fbarcodew: flo64;
   fquantityw: flo64;
   fdescriptionw: flo64;
   frecipientw: flo64;
   fdonatorw: flo64;
   fgs: msestring;
   fpreview: boolean;
   fgsparams: msestring;
   fps2pdfparams: msestring;
   fpdftkparams: msestring;
   fconcatdesc: boolean;
   fenabledelete: boolean;
   procedure setassistiverate(const avalue: flo64);
   procedure setassistivevolume(const avalue: flo64);
  protected
   procedure change() override;
  public
   constructor create();
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
//   property tokensortclient: boolean read ftokensortclient
//                                                    write ftokensortclient;
   property tokensortdonator: boolean read ftokensortdonator
                                                    write ftokensortdonator;
   property tokensortrecipient: boolean read ftokensortrecipient
                                                    write ftokensortrecipient;
   property tokensortquantity: boolean read ftokensortquantity
                                                    write ftokensortquantity;
   property tokensortunit: boolean read ftokensortunit
                                                    write ftokensortunit;
   property tokensortvalue: boolean read ftokensortvalue
                                                    write ftokensortvalue;
   property tokensortcustomer: boolean read ftokensortcustomer
                                                    write ftokensortcustomer;
   property tokensortdescription: boolean read ftokensortdescription
                                                    write ftokensortdescription;
   property tokensortdesc: boolean read ftokensortdesc
                                                    write ftokensortdesc;
   property assistiverate: flo64 read fassistiverate write setassistiverate;
   property assistivevolume: flo64 read fassistivevolume 
                                               write setassistivevolume;

   property ps2pdf: msestring read fps2pdf write fps2pdf;
   property ps2pdfparams: msestring read fps2pdfparams write fps2pdfparams;
   property pdftk: msestring read fpdftk write fpdftk;
   property pdftkparams: msestring read fpdftkparams write fpdftkparams;
   property gs: msestring read fgs write fgs;
   property gsparams: msestring read fgsparams write fgsparams;
   property psviewer: msestring read fpsviewer write fpsviewer;
   property psviewerparams: msestring read fpsviewerparams 
                                                   write fpsviewerparams;
   
   property preview: boolean read fpreview write fpreview;
   property pdfvariables: boolean read fpdfvariables write fpdfvariables;
   property psbackground: boolean read fpsbackground write fpsbackground;
   property tokenfile: msestring read ftokenfile write ftokenfile;
   property enabledelete: boolean read fenabledelete write fenabledelete;
   property origx: flo64 read forigx write forigx;
   property origy: flo64 read forigy write forigy;
 
   property issuedateon: boolean read fissuedateon write fissuedateon;
   property issuedatecapt: msestring read fissuedatecapt write fissuedatecapt;
   property issuedatex: flo64 read fissuedatex write fissuedatex;
   property issuedatey: flo64 read fissuedatey write fissuedatey;
   property issuedatew: flo64 read fissuedatew write fissuedatew;
   property expirydateon: boolean read fexpirydateon write fexpirydateon;
   property expirydatecapt: msestring read fexpirydatecapt write fexpirydatecapt;
   property expirydatex: flo64 read fexpirydatex write fexpirydatex;
   property expirydatey: flo64 read fexpirydatey write fexpirydatey;
   property expirydatew: flo64 read fexpirydatew write fexpirydatew;
   property durationon: boolean read fdurationon write fdurationon;
   property durationcapt: msestring read fdurationcapt write fdurationcapt;
   property durationx: flo64 read fdurationx write fdurationx;
   property durationy: flo64 read fdurationy write fdurationy;
   property durationw: flo64 read fdurationw write fdurationw;
   property numberon: boolean read fnumberon write fnumberon;
   property numbercapt: msestring read fnumbercapt write fnumbercapt;
   property numberx: flo64 read fnumberx write fnumberx;
   property numbery: flo64 read fnumbery write fnumbery;
   property numberw: flo64 read fnumberw write fnumberw;
   property barcodeon: boolean read fbarcodeon write fbarcodeon;
   property barcodecapt: msestring read fbarcodecapt write fbarcodecapt;
   property barcodex: flo64 read fbarcodex write fbarcodex;
   property barcodey: flo64 read fbarcodey write fbarcodey;
   property barcodew: flo64 read fbarcodew write fbarcodew;
   property quantityon: boolean read fquantityon write fquantityon;
   property quantitycapt: msestring read fquantitycapt write fquantitycapt;
   property quantityx: flo64 read fquantityx write fquantityx;
   property quantityy: flo64 read fquantityy write fquantityy;
   property quantityw: flo64 read fquantityw write fquantityw;
   property concatdesc: boolean read fconcatdesc write fconcatdesc;
   property descriptionon: boolean read fdescriptionon write fdescriptionon;
   property descriptioncapt: msestring read fdescriptioncapt 
                                                    write fdescriptioncapt;
   property descriptionx: flo64 read fdescriptionx write fdescriptionx;
   property descriptiony: flo64 read fdescriptiony write fdescriptiony;
   property descriptionw: flo64 read fdescriptionw write fdescriptionw;
   property recipienton: boolean read frecipienton write frecipienton;
   property recipientcapt: msestring read frecipientcapt write frecipientcapt;
   property recipientx: flo64 read frecipientx write frecipientx;
   property recipienty: flo64 read frecipienty write frecipienty;
   property recipientw: flo64 read frecipientw write frecipientw;
   property donatoron: boolean read fdonatoron write fdonatoron;
   property donatorcapt: msestring read fdonatorcapt write fdonatorcapt;
   property donatorx: flo64 read fdonatorx write fdonatorx;
   property donatory: flo64 read fdonatory write fdonatory;
   property donatorw: flo64 read fdonatorw write fdonatorw;
 end;
 
 tmainmo = class(tmsedatamodule)
   mainstat: tstatfile;
   assistivehandler: tassistivehandler;
   newtokenact: taction;
   conn: tfb3connection;
   trans: tmsesqltransaction;
   objectsqu: tmsesqlquery;
   objectsact: taction;
   newobjectact: taction;
   editobjectact: taction;
   deleteobjectact: taction;
   activa: tactivator;
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
   honourtokenlistact: taction;
   tokenspk: tmselargeintfield;
   tokensbarcode: tmselargeintfield;
   printer: tpostscriptprinter;
   psviewer: tmseprocess;
   printvoucherduplicateact: taction;
   tokensprice: tmsefloatfield;
   settingsact: taction;
   tokenoverviewact: taction;
   overviewfrom: tifidatetimelinkcomp;
   overviewto: tifidatetimelinkcomp;
   overviewissuedcount: tifiintegerlinkcomp;
   overviewissuedvalue: tifireallinkcomp;
   overviewhonouredvalue: tifireallinkcomp;
   overviewhonouredcount: tifiintegerlinkcomp;
   overviewexpiredvalue: tifireallinkcomp;
   overviewexpiredcount: tifiintegerlinkcomp;
   overviewopenvalue: tifireallinkcomp;
   overviewopencount: tifiintegerlinkcomp;
   printoverviewact: taction;
   issuedres: tsqlresult;
   issuedcount: tsqlresultconnector;
   issuedvalue: tsqlresultconnector;
   honouredvalue: tsqlresultconnector;
   honouredcount: tsqlresultconnector;
   honouredres: tsqlresult;
   expiredvalue: tsqlresultconnector;
   expiredcount: tsqlresultconnector;
   expiredres: tsqlresult;
   openvalue: tsqlresultconnector;
   opencount: tsqlresultconnector;
   openres: tsqlresult;
   createdbact: taction;
   service: tfb3service;
   numbertext: tifistringlinkcomp;
   deletetoken: tifiactionlinkcomp;
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
   procedure afterstatreadev(const sender: TObject);
   procedure beforestatwriteev(const sender: TObject);
   procedure honourtokenlistev(const sender: TObject);
   procedure printvoucherduplicateev(const sender: TObject);
   procedure settingsev(const sender: TObject);
   procedure tokenoverviewev(const sender: TObject);
   procedure overviewrangev(const sender: tcustomificlientcontroller;
                   const aclient: iificlient; const aindex: Integer);
   procedure befresexeev(const sender: tcustomsqlstatement;
                   const adatabase: tcustomsqlconnection;
                   const atransaction: TSQLTransaction);
   procedure printoverviewev(const sender: TObject);
   procedure honourfinishev(const sender: TObject);
   procedure connecterrorev(const sender: tmdatabase;
                   const aexception: Exception; var handled: Boolean);
   procedure createdbev(const sender: TObject);
   procedure statmissengev(const sender: tstatfile; const afilename: msestring;
                   var astream: ttextstream; var aretry: Boolean);
   procedure espeakconnectev(const sender: tcustomespeakng);
   procedure createev(const sender: TObject);
   procedure honoursetev(const sender: tcustomificlientcontroller;
                   const aclient: iificlient; var avalue: Int64;
                   var accept: Boolean; const aindex: Integer);
   procedure deletetokenev(const sender: tcustomificlientcontroller;
                   const aclient: iificlient);
  private
   fopt: topt;
   ftokenused: boolean;
   fvoucherprinted,ftokenprinted: boolean;
   ftokenlistfo: ttokenlistfo;
   fnewtokenfo: tnewtokenfo;
  protected
   fhonourdateerror: boolean;
   fexpiredinterval: flo64;
   function selectobject(const apk: int64): int64;
   procedure updatetokenvalue();
   procedure resetprintflags();
   function checkprintok(): boolean;
   function checknewtokenok(): boolean;
   procedure checkhonourstate();
   procedure honourtoken(const anumber: int64);
   function print(const afile: filenamety;
                         const acaption: msestring): boolean;
   function printreport(const areport: treport;
                                const acaption: msestring;
                                const background: filenamety): boolean;
   function printvoucher(): boolean;
   function printtoken(): boolean;
   procedure calctokenoverview();
   function createdatabase(): boolean;
  public
   constructor create(aowner: tcomponent); override;
   destructor destroy(); override;
   property opt: topt read fopt;
   procedure closequery(const adataso: tdatasource; 
                                     var amodalres: modalresultty);
   procedure closequery(const asender: tmseform; 
                                     var amodalres: modalresultty);
 end;
 
var
 mainmo: tmainmo;

implementation
uses
 mainmodule_mfm,objectsform,msewidgets,msestrings,voucherreport,tokenreport,
 msefileutils,settingsform,tokenoverviewform,overviewreport,firebird,
 newobjectform,selectobjectform,editobjectform,deleteobjectform,mseformatstr,
 tokenlist1form,honourform,dateutils,msegraphedits,msestockobjects,msesys,
 msedbdialog,dbdata,msemacros;

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
 cancelhonourquery = 'Wollen Sie die Gutschein-Einlösung abbrechen?';
 tokenmustbeprinted = 'Gutschein muss ausgedruckt werden!';
 vouchermustbeprinted = 'Beleg muss ausgedruckt werden!';
 tokenstored = 'Betrag %1:s.'+lineend+
                'Nummer %0:d.'+lineend+
                'Gutschein wurde eingetragen.';
 tokenhonoured = 'Betrag %1:s.'+lineend+
                'Nummer %0:d.'+lineend+
                'Gutschein wurde eingelöst.';
 msecouponcloses = 'MSEcoupon wird beendet.';
 servicestored = 'Leistung wurde gespeichert.';
 voucherprinted = 'Beleg wird gedruckt.';
 tokenprinted = 'Gutschein wird gedruckt.';
 valueschangedquery = 'Werte wurden geändert. Wollen Sie speichern?';
 overviewprinted = 'Gutschein Übersicht wird gedruckt.';
 honourexpiredok = 'Gutschein seit %d Tagen abgelaufen.'+lineend+
                   'Wollen Sie trotzdem eintragen?'; 
 dbalreadyopen = 'Datenbank ist bereits geöffnet.';
 alreadyrunning = 'MSEcoupon wurde möglicherweise bereits gestartet.';
 cannotdeleteobject = 'Leistung kann nicht gelöscht werden,'+lineend+
                    'sie wird verwendet.';
 numberdoesnotexist = 'Gutschein Nummer %0:s existiert nicht.';
 
procedure datasettofdf(const source: tdataset; const dest: ttextstream);
const
 preamble = 
'<?xml version="1.0" encoding="UTF-8"?>'+lineend+
'<xfdf xmlns="http://ns.adobe.com/xfdf/">'+lineend+
'    <fields>'+lineend;

 trailer =
'    </fields>'+lineend+
'</xfdf>'+lineend;

var
 s1,s2: msestring;
 i1: int32;
 f1: tfield;
begin
 dest.write(preamble);
 for i1:= 0 to source.fields.count - 1 do begin
  f1:= source.fields[i1];
  case f1.datatype of
   ftsmallint,ftword,ftinteger,ftlargeint,ftfloat,ftcurrency,ftbcd: begin
    s2:= formatfloatmse(f1.asfloat,
                   utf8tostring(tnumericfield(f1).displayformat));
   end;
   ftdate,fttime,fttimestamp: begin
    s2:= formatdatetimemse(f1.asdatetime,
                   utf8tostring(tnumericfield(f1).displayformat));
   end;
   else begin
    s2:= f1.asmsestring;
   end;
  end;
  s1:= 
'        <field name="'+msestring(f1.fieldname)+'">'+lineend+
'            <value>'+encodexmlstring(s2)+'</value>'+lineend+
'        </field>'+lineend;
  dest.write(s1);
 end;
 dest.write(trailer);
end;

function fna(const aname: filenamety): filenamety;
begin
 result:= tosysfilepath(quotefilename(aname));
end;

procedure showinternalerror();
begin
 showerror(rs(internalerror));
 application.handleexception();
// application.terminated:= true;
end;

function execcommand(const acommand,params,input1,input2,
                                           output: msestring): boolean;
var
 s1: string;
 s2: msestring;
begin
 s2:= fna(acommand)+' '+expandmacros1(params,
                          ['INPUT',    'INPUT1',   'INPUT2',   'OUTPUT'],
                          [fna(input1),fna(input1),fna(input2),fna(output)]);
 result:= getprocessoutput(s2,'',s1) = 0;
 if not result then begin
  showerror(msestring(s1));
 end;
end;

{ topt }

constructor topt.create();
begin
 fassistiverate:= 1;
 fassistivevolume:= 1;
end;

procedure topt.setassistiverate(const avalue: flo64);
begin
 fassistiverate:= avalue;
 if fassistiverate < ratemin then begin
  fassistiverate:= ratemin;
 end;
 if fassistiverate > ratemax then begin
  fassistiverate:= ratemax;
 end;
end;

procedure topt.setassistivevolume(const avalue: flo64);
begin
 fassistivevolume:= avalue;
 if fassistivevolume < volumemin then begin
  fassistivevolume:= volumemin;
 end;
 if fassistivevolume > volumemax then begin
  fassistivevolume:= volumemax;
 end;
end;

procedure topt.change();
begin
 mainmo.deletetoken.c.enabled:= enabledelete;
end;

{ tmainmo }

function tmainmo.createdatabase(): boolean;
var
 s1: msestring;
 stream1: tobjectdatastream;
 stream2: tmsefilestream;
begin
 result:= false;
 conn.connected:= false;
 service.username:= stringtoutf8(conn.username);
 service.password:= stringtoutf8(conn.password);
 service.hostname:= stringtoutf8(conn.hostname);
 service.connected:= true;
 stream1:= tobjectdatastream.create(@dbdata.data);
 stream2:= nil;
 application.beginwait();
 try
  s1:= msegettempfilename('msecoupon');
  stream2:= tmsefilestream.create(s1,fm_create);
  stream2.copyfrom(stream1,stream1.size);
  freeandnil(stream2);
  service.restorestart(s1,conn.databasename,[]);
  while service.busy() do begin
   application.unlock();
   sleep(100);
   application.lock();
  end;
  result:= true;
 finally
  application.endwait();
  service.connected:= false;
  stream1.free;
  stream2.free;
  if s1 <> '' then begin
   trydeletefile(s1);
  end;
 end;
end;

procedure tmainmo.resetprintflags();
begin
 fvoucherprinted:= false;
 ftokenprinted:= false;
end;

function tmainmo.checkprintok(): boolean;
begin
 result:= false;
 if checknewtokenok() then begin
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
end;

function tmainmo.checknewtokenok(): boolean;
begin
 tokensqu.modify(false);
// result:= fnewtokenfo.canclose(nil);
 result:= fnewtokenfo.canparentclose(nil);
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
  tokensprice.asfloat:= objectsqu.currentbmasfloat[objectsprice,bookmark1];
  tokensdescription.asmsestring:= 
                 objectsqu.currentbmasmsestring[objectsdescription,bookmark1];
 end
 else begin
  tokensunit.clear();
  tokensduration.clear();
  tokensprice.clear();
  tokensdescription.clear();
 end;
 updatetokenvalue();
end;

procedure tmainmo.tokenquantitiychangeev(Sender: TField);
begin
 updatetokenvalue();
end;

procedure tmainmo.tokenstoreev(const sender: TObject);
begin
 if checkprintok() then begin
  if tokensqu.post1() then begin
   showmessage(formatmse(rs(tokenstored),[tokensnumber.asinteger,
                 formatfloatmse(tokensvalue.asfloat,'0.00')]));
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
  ftokenused:= false;
  b1:= false;
  repeat
   try
    numbersqu.insert();
    numbersnumber.asinteger:= random(8999)+1000;
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
  tokensbarcode.asid:= numbersnumber.asinteger;
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
//      assistivehandler.speaktext1(rs(servicestored));
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
 if not (amodalres in [mr_ok,mr_canclose]) and 
                                        adataso.dataset.modified then begin
  if not askyesno(rs(closewindowcancelrecordquestion)) then begin
   amodalres:= mr_none;
  end;
 end;
end;

procedure tmainmo.closequery(const asender: tmseform;
               var amodalres: modalresultty);
begin
 if not (amodalres in [mr_cancel,mr_ok]) then begin
  amodalres:= askyesnocancel(rs(valueschangedquery));
  if amodalres = mr_cancel then begin
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
   if tokensqu.indexlocal.indexbyname('object').find([i1],[]) then begin
    showerror(rs(cannotdeleteobject));
    exit;
   end;
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
 tokensqu.active:= true;
 with ttokenlist1fo.create(nil) do begin
  try
   w1:= ftokenlistfo.tokensortissuedate.checkeditem;
   if w1 <> nil then begin
    with grid.datacols[w1.tag] do begin
     sortdescend:= ftokenlistfo.tokensortdesc.value;
    end;
    grid.datacols.sortcol:= w1.tag;
    grid.sorted:= true;
   end;
   tokensqu.first();
   show(ml_application);
   tokensqu.checkbrowsemode();
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

procedure tmainmo.honourfinishev(const sender: TObject);
begin
 if fhonourdateerror then begin
  case askyesnocancel(formatmse(rs(honourexpiredok),[round(fexpiredinterval)]),
                                                        sc(sc_warningupper)) of
   mr_yes: begin
    honourform.c.modalresult:= mr_ok;
   end;
   mr_no: begin
    honourform.c.modalresult:= mr_cancel;
   end
   else begin
    honourform.c.modalresult:= mr_none;
   end;
  end;
 end
 else begin
  honourform.c.modalresult:= mr_ok;
 end;
end;

procedure tmainmo.checkhonourstate();
begin
 honourcheck.c.value:= '';
 honourtokenfinishact.enabled:= false;
 if honournumber.c.value < 0 then begin
  tokensdispdso.dataset:= nil;
  honourcheck.c.value:= '';
 end
 else begin
  tokensqu.indexlocal[0].find([honournumber.c.value],[]);
  tokensdispdso.dataset:= tokensqu;
  fhonourdateerror:= false;
  if not tokenshonourdate.isnull then begin
   honourcheck.c.value:= formatmse(rs(honourhonourerror),
               [datetimetostring(tokenshonourdate.asdate,'${dateformat}')]);
   showerror(honourcheck.c.value,sc(sc_error),0,'',true);
  end
  else begin
   if not tokensexpirydate.isnull and 
                     not (honourdate.c.value = emptydatetime) then begin
    fexpiredinterval:= honourdate.c.value - tokensexpirydate.asdate;
    fhonourdateerror:= fexpiredinterval > 0.99999;
    if fhonourdateerror then begin
     honourcheck.c.value:= formatmse(rs(honourdateerror),
                                           [round(fexpiredinterval)]);
     showerror(honourcheck.c.value,sc(sc_error),0,'',true);
    end
    else begin
     honourcheck.c.value:= rs(honourok);
     showerror(honourcheck.c.value,'',0,'',true);
    end;
    honourtokenfinishact.enabled:= true;
   end
   else begin
    honourcheck.c.value:= '';
   end;
  end;
 end;
end;

procedure tmainmo.honourdataentev(const sender: tcustomificlientcontroller;
               const aclient: iificlient; const aindex: Integer);
begin
 checkhonourstate();
end;

procedure tmainmo.honourtoken(const anumber: int64);
begin
 with thonourfo.create(nil) do begin
  try
   honourtokenfinishact.enabled:= false;
   honournumber.c.value:= anumber;
//   honourcheck.c.value:= '';
   honourdate.c.value:= trunc(now);
//   tokensdispdso.dataset:= nil;
//   if anumber <> -1 then begin
    checkhonourstate();
//   end;
   case show(ml_application) of
    mr_ok: begin
     tokensqu.edit();
     tokenshonourdate.asdate:= honourdate.c.value;
     tokensqu.post();
     showmessage(formatmse(rs(tokenhonoured),[tokensnumber.asinteger,
                   formatfloatmse(tokensvalue.asfloat,'0.00')]));
    end;
   end;
  finally
   destroy();
   tokensqu.cancel();
  end;
 end;
end;

procedure tmainmo.honourtokenev(const sender: TObject);
begin
 honourtoken(-1);
end;

procedure tmainmo.honourtokenlistev(const sender: TObject);
begin
 honourtoken(tokenspk.asid);
end;

procedure tmainmo.honourmodalresultev(const sender: tcustomificlientcontroller;
               const aclient: iificlient; var amodalresult: modalresultty);
begin
 if (amodalresult in [mr_windowclosed,mr_cancel]) and honourtokenfinishact.enabled
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
 if checknewtokenok() and printtoken() then begin
  ftokenprinted:= true;
 end;
end;

function tmainmo.print(const afile: filenamety;
                         const acaption: msestring): boolean;
begin
 result:= true;
 showmessage(acaption);
 assistivehandler.speakstop(true); //remove window activtion talk
 try
  if fopt.preview then begin
   psviewer.filename:= fopt.psviewer;
   psviewer.parameter:= expandmacros1(fopt.psviewerparams,
                                             ['INPUT',   'INPUT1'],
                                             [fna(afile),fna(afile)]);
   psviewer.active:= true;
   psviewer.waitforprocess();
  end
  else begin
   result:= execcommand(fopt.gs,fopt.gsparams,afile,'','');
  {
  i1:= getprocessoutput(fna(fopt.gs)+' '+fopt.gsparams+' '+
                                    fna(afile),'',s1,2000000);
  if i1 > 0 then begin
   showerror(msestring(s1));
   result:= false;
  end;
  }
  end;
 finally
  assistivehandler.speakcontinue();
  assistivehandler.speakall(application.activewidget,[spo_path]);
 end;
end;

function tmainmo.printreport(const areport: treport;
                                        const acaption: msestring;
                                        const background: filenamety): boolean;
var
 s1,s2,s3,s4: filenamety;
 stream1: ttextstream;
begin
 result:= true;
 with areport do begin
  try
   s1:= msegettempfilename('msecoupon')+'.ps';
   s4:= s1;
   stream1:= ttextstream.create(s1,fm_create);
   render(printer,stream1);
   if background <> '' then begin
    s2:= msegettempfilename('msecoupon1')+'.pdf';
    result:= execcommand(fna(fopt.ps2pdf),fopt.ps2pdfparams,s1,'',s2);
    if result then begin
     s3:= msegettempfilename('msecoupon2')+'.pdf';
     result:= execcommand(fna(fopt.pdftk),fopt.pdftkparams,s2,background,s3);
     {
     if getprocessoutput(fna(fopt.pdftk)+' '+fopt.pdftkparams+' '+fna(s2)+
         ' background '+fna(background)+
         ' output '+fna(s3),'',s5) <> 0 then begin
      showerror(msestring(s5));
      result:= false;
     end;
     }
     trydeletefile(s2);
     s4:= s3;
    end;
    trydeletefile(s1);
   end;
   if result then begin
    result:= print(s4,acaption);
   end;
   trydeletefile(s4);
  finally
   destroy();
  end;
 end;
end;

function tmainmo.printvoucher(): boolean;
begin
 result:= printreport(tvoucherre.create(nil),rs(voucherprinted),'');
end;

procedure tmainmo.printoverviewev(const sender: TObject);
var
 rep1: toverviewre;
begin
 rep1:= toverviewre.create(nil);
 with rep1 do begin
  
  printreport(rep1,rs(overviewprinted),'');
 end;
end;


function tmainmo.printtoken(): boolean;
var
 rep1: ttokenre;

 function mpr(const x,y: flo64): pointty;
 begin
  result.x:= round((x + fopt.origx) * rep1.ppmm);
  result.y:= round((y + fopt.origy) * rep1.ppmm);
 end; //mpr
 
 procedure setsi(const awidget: twidget; const w: flo64);
 begin
  if w > 0 then begin
   awidget.optionswidget1:= awidget.optionswidget1 - [ow1_autowidth];
   awidget.width:= round(w*rep1.ppmm);
  end;
 end;
 
var
 s1,s2: msestring;
 s3: string;
 stream1: ttextstream;
 
begin
 if fopt.pdfvariables then begin
  s1:= msegettempfilename('msecoupon');
  s2:= msegettempfilename('msecoupon1');
  stream1:= ttextstream.create(s1,fm_create);
  try
   datasettofdf(tokensqu,stream1);
   freeandnil(stream1);
   if getprocessoutput(fna(fopt.pdftk)+' '+fna(fopt.tokenfile)+
       ' fillform '+fna(s1)+
       ' output '+fna(s2),'',s3) <> 0 then begin
    showerror(msestring(s3));
    result:= false;
   end
   else begin
    result:= print(s2,rs(tokenprinted));
   end;
  finally
   stream1.free;
   trydeletefile(s1);
   trydeletefile(s2);
  end;
 end
 else begin
  rep1:= ttokenre.create(nil);
  with rep1 do begin
   issuedate.visible:= fopt.issuedateon;
   issuedate.frame.caption:= fopt.issuedatecapt;
   issuedate.pos:= mpr(fopt.issuedatex,fopt.issuedatey);
   setsi(issuedate,fopt.issuedatew);
   expirydate.visible:= fopt.expirydateon;
   expirydate.frame.caption:= fopt.expirydatecapt;
   expirydate.pos:= mpr(fopt.expirydatex,fopt.expirydatey);
   setsi(expirydate,fopt.expirydatew);
   duration.visible:= fopt.durationon;
   duration.frame.caption:= fopt.durationcapt;
   duration.pos:= mpr(fopt.durationx,fopt.durationy);
   setsi(duration,fopt.durationw);
   number.visible:= fopt.numberon;
   number.frame.caption:= fopt.numbercapt;
   number.pos:= mpr(fopt.numberx,fopt.numbery);
   setsi(number,fopt.numberw);
   barcode.visible:= fopt.barcodeon;
   barcode.frame.caption:= fopt.barcodecapt;
   barcode.pos:= mpr(fopt.barcodex,fopt.barcodey);
   setsi(barcode,fopt.barcodew);
   quantity.visible:= fopt.quantityon;
   quantity.frame.caption:= fopt.quantitycapt;
   quantity.pos:= mpr(fopt.quantityx,fopt.quantityy);
   setsi(quantity,fopt.quantityw);
   unit_.visible:= quantity.visible;
   unit_.pos:= mp(quantity.left+quantity.width+2,quantity.top);
   description.visible:= fopt.descriptionon;
   description.frame.caption:= fopt.descriptioncapt;
   if fopt.concatdesc then begin
    description.pos:= mp(unit_.left+unit_.width+2,quantity.top);
   end
   else begin
    description.pos:= mpr(fopt.descriptionx,fopt.descriptiony);
   end;
   setsi(description,fopt.descriptionw);
   recipient.visible:= fopt.recipienton;
   recipient.frame.caption:= fopt.recipientcapt;
   recipient.pos:= mpr(fopt.recipientx,fopt.recipienty);
   setsi(recipient,fopt.recipientw);
   donator.visible:= fopt.donatoron;
   donator.frame.caption:= fopt.donatorcapt;
   donator.pos:= mpr(fopt.donatorx,fopt.donatory);
   setsi(donator,fopt.donatorw);
  end;
  result:= printreport(rep1,rs(tokenprinted),fopt.tokenfile);
 end;
end;

procedure tmainmo.befresexeev(const sender: tcustomsqlstatement;
               const adatabase: tcustomsqlconnection;
               const atransaction: TSQLTransaction);
begin
 sender.params.parambyname('datefrom').asdatetime:= overviewfrom.c.value;
 sender.params.parambyname('dateto').asdatetime:= overviewto.c.value;
end;

procedure tmainmo.calctokenoverview();
begin
 issuedres.refresh();
 overviewissuedcount.c.value:= issuedcount.col.asinteger;
 overviewissuedvalue.c.value:= issuedvalue.col.asfloat;
 honouredres.refresh();
 overviewhonouredcount.c.value:= honouredcount.col.asinteger;
 overviewhonouredvalue.c.value:= honouredvalue.col.asfloat;
 expiredres.refresh();
 overviewexpiredcount.c.value:= expiredcount.col.asinteger;
 overviewexpiredvalue.c.value:= expiredvalue.col.asfloat;
 openres.refresh();
 overviewopencount.c.value:= opencount.col.asinteger;
 overviewopenvalue.c.value:= openvalue.col.asfloat;
end;

procedure tmainmo.printvoucherev(const sender: TObject);
begin
 if checknewtokenok() and printvoucher() then begin
  fvoucherprinted:= true;
 end;
end;

procedure tmainmo.tokennumberchangeev(Sender: TField);
begin
 tokensnumbertext.asmsestring:= inttostrmse(tokensnumber.asinteger);
end;

procedure tmainmo.printduplicateev(const sender: TObject);
begin
 printtoken();
end;

procedure tmainmo.printvoucherduplicateev(const sender: TObject);
begin
 printvoucher();
end;

procedure tmainmo.mainfomdalresev(const sender: tcustomificlientcontroller;
               const aclient: iificlient; const amodalresult: modalresultty);
begin
 with assistivehandler do begin
  speaktext1(rs(msecouponcloses),voicecaption);
  wait();
 end;
end;

procedure tmainmo.afterstatreadev(const sender: TObject);
begin
 assistivehandler.speaker.rate:= fopt.assistiverate;
 assistivehandler.speaker.volume:= fopt.assistivevolume;
end;

procedure tmainmo.beforestatwriteev(const sender: TObject);
begin
 fopt.assistiverate:= assistivehandler.speaker.rate;
 fopt.assistivevolume:= assistivehandler.speaker.volume;
end;

procedure tmainmo.settingsev(const sender: TObject);
var
 fo1: tsettingsfo;
begin
 if askyesno('Wollen Sie die Programm-Einstellungen bearbeiten?',
                                            'WARNUNG',mr_no) then begin
  fo1:= tsettingsfo.create(nil);
  with fo1 do begin
   try
    fopt.loadvalues(fo1);
    if show(ml_application) in [mr_ok,mr_yes] then begin
     fopt.storevalues(fo1);
     mainstat.writestat();
    end;
   finally
    destroy();
   end;
  end;
 end;
end;

procedure tmainmo.tokenoverviewev(const sender: TObject);
begin
 with ttokenoverviewfo.create(nil) do begin
  try
   show(ml_application);
  finally
   destroy();
  end;
 end;
end;

procedure tmainmo.overviewrangev(const sender: tcustomificlientcontroller;
               const aclient: iificlient; const aindex: Integer);
begin
 calctokenoverview();
end;

procedure tmainmo.connecterrorev(const sender: tmdatabase;
               const aexception: Exception; var handled: Boolean);
begin
 if aexception is efberror then begin
  with efberror(aexception) do begin
   createdbact.enabled:= (error = -902) and (gdscode = isc_io_error){ and 
                  (pos('"open"',message) > 0)}; //unreliable
   if (pos('"lock"',message) > 0) then begin //linux only
    showerror(rs(dbalreadyopen));
    application.terminate();
    exit;
   end;
  end;
 end;
 if not createdbact.enabled then begin
  application.showexception(aexception);
  application.terminate();
 end
 else begin
  showerror(rs(alreadyrunning));
  application.showexception(aexception);
  handled:= true;
 end; 
end;

procedure tmainmo.createdbev(const sender: TObject);
begin
 if createdatabase() then begin
  activa.activateclients;
 end;
end;

const
 defaultstatdata =
'[mainmo.trttistat1]'+lineend+
'editobjectpk=2'+lineend+
'tokenobjectpk=2'+lineend+
'tokensortissuedate=1'+lineend+
'tokensorthonourdate=0'+lineend+
'tokensortexpirydate=0'+lineend+
'tokensortnumber=0'+lineend+
'tokensortclient=0'+lineend+
'tokensortdonator=0'+lineend+
'tokensortrecipient=0'+lineend+
'tokensortquantity=0'+lineend+
'tokensortunit=0'+lineend+
'tokensortvalue=0'+lineend+
'tokensortdescription=0'+lineend+
'tokensortdesc=1'+lineend+
'assistiverate=1'+lineend+

{$ifdef mswindows}
'ps2pdf=/C:/Program Files/gs/gs9.22/bin/gswin64c.exe'+lineend+
'ps2pdfparams=-q -P- -dSAFER -dNOPAUSE -dBATCH -sDEVICE#pdfwrite'+
                                ' -sOutputFile=${output} ${input1}'+lineend+
'pdftk=/C:/Program Files (x86)/PDFtk/bin/pdftk.exe'+lineend+
'pdftkparams=${input1} background ${input2} output ${output}'+lineend+
'gs=/C:/Program Files/gs/gs9.22/bin/gswin64c.exe'+lineend+
'gsparams=-q -P- -dSAFER -dNOPAUSE -dBATCH -sDEVICE#mswinpr2'+
                   ' "-sOutputFile=%printer%Your Printer" ${input1}'+lineend+
'psviewer=/C:/Program Files/Artifex Software/gsview6.0/bin/gsview.exe'+lineend+
'psviewerparams=${input1}'+lineend+
{$else}
'ps2pdf=ps2pdf'+lineend+
'ps2pdfparams=-sPAPERSIZE=a4 ${input} ${output}'+lineend+
'pdftk=pdftk'+lineend+
'pdftkparams=${input1} background ${input2} output ${output}'+lineend+
'gs=gs'+lineend+
'gsparams=-sOutputFile=%pipe%lpr -sNOPAUSE -sBATCH'+
                                 ' -sDEVICE=ps2write ${input}'+lineend+
'psviewer=okular'+lineend+
'psviewerparams=${input}'+lineend+
{$endif}

'preview=1'+lineend+
'pdfvariables=0'+lineend+
'psbackground=1'+lineend+
'tokenfile=gutschein.pdf'+lineend+
'origx=0'+lineend+
'origy=0'+lineend+
'issuedateon=1'+lineend+
'issuedatecapt='+lineend+
'issuedatex=40'+lineend+
'issuedatey=235'+lineend+
'issuedatew=0'+lineend+
'expirydateon=0'+lineend+
'expirydatecapt='+lineend+
'expirydatex=10'+lineend+
'expirydatey=20'+lineend+
'expirydatew=0'+lineend+
'durationon=0'+lineend+
'durationcapt='+lineend+
'durationx=10'+lineend+
'durationy=30'+lineend+
'durationw=0'+lineend+
'numberon=1'+lineend+
'numbercapt='+lineend+
'numberx=160'+lineend+
'numbery=117'+lineend+
'numberw=0'+lineend+
'barcodeon=1'+lineend+
'barcodecapt='+lineend+
'barcodex=152'+lineend+
'barcodey=251.5'+lineend+
'barcodew=0'+lineend+
'quantityon=1'+lineend+
'quantitycapt='+lineend+
'quantityx=40'+lineend+
'quantityy=208'+lineend+
'quantityw=0'+lineend+
'concatdesc=1'+lineend+
'descriptionon=1'+lineend+
'descriptioncapt='+lineend+
'descriptionx=0'+lineend+
'descriptiony=208'+lineend+
'descriptionw=0'+lineend+
'recipienton=1'+lineend+
'recipientcapt='+lineend+
'recipientx=40'+lineend+
'recipienty=156'+lineend+
'recipientw=0'+lineend+
'donatoron=1'+lineend+
'donatorcapt='+lineend+
'donatorx=40'+lineend+
'donatory=178'+lineend+
'donatorw=0'+lineend+
'';

procedure tmainmo.statmissengev(const sender: tstatfile;
               const afilename: msestring; var astream: ttextstream;
               var aretry: Boolean);
begin
 astream:= ttextstringcopystream.create(defaultstatdata);
end;

procedure tmainmo.espeakconnectev(const sender: tcustomespeakng);
begin
 if (sender.datapath <> '') and 
      not finddir(sender.datapath+'/espeak-ng-data') then begin
  sender.datapath:= '';
 end;
end;

procedure tmainmo.createev(const sender: TObject);
begin
 conn.databasename:= filepath(conn.databasename);
  //windows needs absolute path
end;

procedure tmainmo.honoursetev(const sender: tcustomificlientcontroller;
               const aclient: iificlient; var avalue: Int64;
               var accept: Boolean; const aindex: Integer);
begin
 if avalue < 0 then begin
  tokensdispdso.dataset:= nil;
  honourcheck.c.value:= '';
  accept:= false;
  showerror(formatmse(rs(numberdoesnotexist),[numbertext.c.value]));
 end;
end;

procedure tmainmo.deletetokenev(const sender: tcustomificlientcontroller;
               const aclient: iificlient);
begin
 if askyesno('Wollen Sie den ausgewählten Gutschein löschen?',
                                                   'WARNUNG',mr_no) then begin
  tokensqu.delete();
 end;
end;

initialization
 randomize();
end.
