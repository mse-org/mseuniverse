unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$define mse_with_ifi}

interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msestatfile,
 msedataedits,mseedit,msestrings,msetypes,msesimplewidgets,msewidgets,msegrids,
 msewidgetgrid,msedatalist,classes,msegraphedits,mserttistat,msecolordialog;

type
{$M+} //ttestrttistat needs RTTI
 ttestrttistat = class(tobject)
  private
   fint1: integer;
   fint641: int64;
   freal1: realty;
   fcolor1: colorty;
   fstr1: msestring;
   fansistr1: ansistring;
   fbool1: boolean;
   fintlist1: tintegerdatalist;
   fintar1: integerarty;
   fintar2: integerarty;
   fmstrar1: msestringarty;
   fboolar1: booleanarty;
   fcolorar1: colorarty;
  protected
  public
   constructor create;
   destructor destroy; override;
  published
   property int1: integer read fint1 write fint1;
   property int641: int64 read fint641 write fint641;
   property real1: realty read freal1 write freal1;
   property color1: colorty read fcolor1 write fcolor1;
   property str1: msestring read fstr1 write fstr1;
   property ansistr1: ansistring read fansistr1 write fansistr1;
   property bool1: boolean read fbool1 write fbool1;
   property intlist1: tintegerdatalist read fintlist1;
   property intar1: integerarty read fintar1 write fintar1;
   property intar2: integerarty read fintar2 write fintar2;
   property mstrar1: msestringarty read fmstrar1 write fmstrar1;
   property boolar1: booleanarty read fboolar1 write fboolar1;
   property colorar1: colorarty read fcolorar1 write fcolorar1;
 end;
   
 tmainfo = class(tmainform)
   stat: tstatfile;
   stred: tstringedit;
   tbutton1: tbutton;
   tbutton2: tbutton;
   inted: tintegeredit;
   realed: trealedit;
   int64ed: tint64edit;
   ansistred: tstringedit;
   twidgetgrid1: twidgetgrid;
   intlist: tintegeredit;
   tbutton3: tbutton;
   tbutton4: tbutton;
   stated: tstatfile;
   ansistr1: tstringedit;
   str1: tstringedit;
   real1: trealedit;
   int641: tint64edit;
   int1: tintegeredit;
   tbutton5: tbutton;
   tbutton6: tbutton;
   twidgetgrid2: twidgetgrid;
   intlist1: tintegeredit;
   intara: tintegeredit;
   intar1: tintegeredit;
   intarb: tintegeredit;
   intar2: tintegeredit;
   rttista: trttistat;
   mstrara: tstringedit;
   mstrar1: tstringedit;
   boolara: tbooleanedit;
   boolar1: tbooleanedit;
   booled: tbooleanedit;
   bool1: tbooleanedit;
   colored: tcoloredit;
   color1: tcoloredit;
   colorara: tcoloredit;
   colorar1: tcoloredit;
   procedure cre(const sender: TObject);
   procedure loadex(const sender: TObject);
   procedure saveex(const sender: TObject);
   procedure setint(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
   procedure setstr(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure int64set(const sender: TObject; var avalue: Int64;
                   var accept: Boolean);
   procedure floatset(const sender: TObject; var avalue: realty;
                   var accept: Boolean);
   procedure setansistr(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure loadedex(const sender: TObject);
   procedure saveedex(const sender: TObject);
   procedure getcompex(const sender: TObject);
   procedure setcompex(const sender: TObject);
   procedure listdatent(const sender: TObject);
   procedure getobj(const sender: TObject; var avalue: TObject);
   procedure setbool(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure getobjs(const sender: TObject; var aobjects: objectinfoarty);
   procedure colorset(const sender: TObject; var avalue: colorty;
                   var accept: Boolean);
  private
   frttistat: ttestrttistat;
   procedure updatedispvalues;
  public
   destructor destroy; override;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,typinfo,mseificompglob;
 
{ ttestrttistat }

constructor ttestrttistat.create;
begin
 inherited;
 fintlist1:= tintegerdatalist.create;
end;

destructor ttestrttistat.destroy;
begin
 fintlist1.free;
 inherited;
end;

{ tmainfo }

destructor tmainfo.destroy;
begin
 frttistat.free;
 inherited;
end;

procedure tmainfo.cre(const sender: TObject);
begin
 frttistat:= ttestrttistat.create;
end;

procedure tmainfo.updatedispvalues;
begin
 with frttistat do begin
  inted.value:= int1;
  int64ed.value:= int641;
  realed.value:= real1; 
  colored.value:= color1; 
  stred.value:= str1;
  ansistred.value:= ansistr1;
  booled.value:= bool1;
  intlist.griddata.assign(intlist1);
  intara.gridvalues:= intar1;
  intarb.gridvalues:= intar2;
  colorara.gridvalues:= colorar1;
  mstrara.gridvalues:= mstrar1;
  boolara.gridbooleanvalues:= boolar1;
 end;
end;

procedure tmainfo.loadex(const sender: TObject);
begin
 stat.readstat;
 updatedispvalues;
end;

procedure tmainfo.saveex(const sender: TObject);
begin
 stat.writestat;
end;

procedure tmainfo.setint(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
 frttistat.int1:= avalue;
end;

procedure tmainfo.setstr(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 frttistat.str1:= avalue;
end;

procedure tmainfo.int64set(const sender: TObject; var avalue: Int64;
               var accept: Boolean);
begin
 frttistat.int641:= avalue;
end;

procedure tmainfo.floatset(const sender: TObject; var avalue: realty;
               var accept: Boolean);
begin
 frttistat.real1:= avalue; 
end;

procedure tmainfo.colorset(const sender: TObject; var avalue: colorty;
               var accept: Boolean);
begin
 frttistat.color1:= avalue; 
end;

procedure tmainfo.setansistr(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 frttistat.ansistr1:= avalue;
end;

procedure tmainfo.setbool(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 frttistat.bool1:= avalue;
end;

procedure tmainfo.listdatent(const sender: TObject);
begin
 frttistat.intlist1.assign(intlist.griddata);
 frttistat.intar1:= intara.gridvalues;
 frttistat.intar2:= intarb.gridvalues;
 frttistat.mstrar1:= mstrara.gridvalues;
 frttistat.boolar1:= boolara.gridbooleanvalues;
 frttistat.colorar1:= colorara.gridvalues;
end;

procedure tmainfo.loadedex(const sender: TObject);
begin
 stated.readstat;
end;

procedure tmainfo.saveedex(const sender: TObject);
begin
 stated.writestat;
end;

procedure tmainfo.getcompex(const sender: TObject);
begin
 rttista.valuestoobj(self);
 updatedispvalues;
end;

procedure tmainfo.setcompex(const sender: TObject);
begin
 rttista.objtovalues(self);
end;

procedure tmainfo.getobj(const sender: TObject; var avalue: TObject);
begin
 avalue:= frttistat;
end;

procedure tmainfo.getobjs(const sender: TObject; var aobjects: objectinfoarty);
begin
// aobjects:= opentodynarray([frttistat],['p_']);
end;

end.
