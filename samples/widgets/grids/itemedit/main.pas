unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedataedits,
 mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,msestatfile,msestream,
 msestrings,msewidgetgrid,sysutils,msedatanodes,mselistbrowser,mserealsumedit,
 msesimplewidgets,msegraphedits,msescrollbar,msebitmap,msevaluenodes;

type

 tmainfo = class(tmainform)
   grid1: twidgetgrid;
   itemed: titemedit;
   trealedit1: trealedit;
   tintegeredit1: tintegeredit;
   tdatetimeedit1: tdatetimeedit;
   tstringedit1: tstringedit;
   tbooleanedit1: tbooleanedit;
   tslider1: tslider;
   trealedit2: trealedit;
   tprogressbar2: tprogressbar;
   grid2: twidgetgrid;
   treeedit: ttreeitemedit;
   recfielded: trecordfieldedit;
   ima: timagelist;
   tstatfile1: tstatfile;
   inted: tintegeredit;
   tslider2: tslider;
   stred: tstringedit;
   procedure createexe(const sender: TObject);
   procedure initdata(const sender: TObject);
   procedure statreaditemexe(const sender: TObject; const reader: tstatreader;
                   var aitem: tlistitem);
 end;
var
 mainfo: tmainfo;

implementation
uses
 main_mfm,msedatalist,msevaluenodesglob,mseformatstr;

const
 rectypenum = -1; //type num for statfile
type
 trecitem = class(trecordvaluelistedititem)
  private
   fstrval: msestring; //2
   fintval: int32;     //1
  protected 
   function getvaluetype: listdatatypety; override;
   procedure getvalueinfo(out avalues: recvaluearty; const aindex: int32 = -1);
                                                                       override;
   procedure setvalue(const atype: listdatatypety;
         const aindex: int32; const getvaluemethod: getvaluemethodty); override;
  public
   procedure dostatread(const reader: tstatreader); override;
   procedure dostatwrite(const writer: tstatwriter); override;
 end;

 tmynode = class(trecordtreelistedititem)
  private
   fstrfield: msestring; //index 0
   fintfield: integer ;  //index 1
   frealfield: real;     //index 2
   procedure setstrfield(const avalue: msestring);
   procedure setintfield(const avalue: integer);
   procedure setrealfield(const avalue: real);
  protected
   function createsubnode: ttreelistitem; override;
   procedure getvalueinfo(out avalues: recvaluearty; const aindex: int32 = -1);
                                                                      override;
//   function getfieldtext(const fieldindex: integer): msestring; override;
//   procedure setfieldtext(const fieldindex: integer;
//                                              var avalue: msestring); override; 
  public
   constructor create(const aowner: tcustomitemlist = nil;
              const aparent: ttreelistitem = nil); override;
   procedure dostatread(const reader: tstatreader); override;
   procedure dostatwrite(const writer: tstatwriter); override;
   function getvaluetext: msestring; override;
   property strfield: msestring read fstrfield write setstrfield;
   property intfield: integer read fintfield write setintfield;
   property realfield: real read frealfield write setrealfield;
 end;

{ trecitem }

procedure trecitem.getvalueinfo(out avalues: recvaluearty;
                                               const aindex: int32 = -1);
begin
 setlength(avalues,2);
 initvalueinfo(2,fstrval,avalues[0]);
 initvalueinfo(1,fintval,avalues[1]);
end;

procedure trecitem.setvalue(const atype: listdatatypety; const aindex: int32;
               const getvaluemethod: getvaluemethodty);
begin
 case aindex of
  2: getvaluemethod(fstrval);
  1: getvaluemethod(fintval);
 end;
end;

function trecitem.getvaluetype: listdatatypety;
begin
 result:= listdatatypety(rectypenum);
end;

procedure trecitem.dostatread(const reader: tstatreader);
begin
 inherited;
 reader.readrecord('r',[@fstrval,@fintval],[fstrval,fintval]);
end;

procedure trecitem.dostatwrite(const writer: tstatwriter);
begin
 inherited;
 writer.writerecord('r',[fstrval,fintval]);
end;

{ tmynode }

constructor tmynode.create(const aowner: tcustomitemlist = nil;
               const aparent: ttreelistitem = nil);
begin
 inherited;                                                //image base = -1
 state:= state + [ns_readonly];
 add(trecordfieldvalueitem.create(irecordvaluefield(self),0,
                                                   'String Field',true,1));
 add(trecordfieldvalueitem.create(irecordvaluefield(self),1,
                                                  'Integer Field',true,2));
 add(trecordfieldvalueitem.create(irecordvaluefield(self),2,
                                                      'Real Field',true,3));
 include(fstate1,ns1_nodefaultimagelist);
end;

function tmynode.createsubnode: ttreelistitem;
begin
 result:= trecordfielditem.create(irecordvaluefield(self),count,'',true);
end;

procedure tmynode.dostatread(const reader: tstatreader);
begin
 inherited;
 fstrfield:= reader.readstring('str',fstrfield);
 fintfield:= reader.readinteger('int',fintfield);
 frealfield:= reader.readreal('rea',frealfield,emptyreal);
end;

procedure tmynode.dostatwrite(const writer: tstatwriter);
begin
 inherited;
 writer.writestring('str',fstrfield);
 writer.writeinteger('int',fintfield);
 writer.writereal('rea',frealfield);
end;

procedure tmynode.setstrfield(const avalue: msestring);
begin
 fstrfield:= avalue;
 trecordfielditem(fitems[0]).valuechange();
end;

procedure tmynode.setintfield(const avalue: integer);
begin
 fintfield:= avalue;
 trecordfielditem(fitems[1]).valuechange();
end;

procedure tmynode.setrealfield(const avalue: real);
begin
 frealfield:= avalue;
 trecordfielditem(fitems[2]).valuechange();
end;

function tmynode.getvaluetext: msestring;
begin
 result:= ''; //no caption copy in field edit
end;

procedure tmynode.getvalueinfo(out avalues: recvaluearty;
               const aindex: int32 = -1);
begin
 if aindex < 0 then begin
  avalues:= nil; //branch
 end
 else begin      //leafs
  avalues:= buildvalueinfos([valuefield(fstrfield),valuefield(fintfield),
                            valuefield(frealfield)],aindex);
 end;
end;

{ tmainfo} 

procedure tmainfo.createexe(const sender: TObject);
begin 
 treeedit.itemlist.itemclass:= tmynode; 
end;

procedure tmainfo.initdata(const sender: TObject);
var
 n1: trealvaluelistedititem;
begin

 if grid1.rowcount = 0 then begin //not loaded by statfile
  itemed.itemlist.add(trecitem.create());
  itemed.itemlist.add(trealvaluelistedititem.create(0));
  itemed.itemlist.add(tintegervaluelistedititem.create(1));
  itemed.itemlist.add(tmsestringvaluelistedititem.create(2));
  itemed.itemlist.add(tdatetimevaluelistedititem.create(3));
  itemed.itemlist.add(tbooleanvaluelistedititem.create(4));
  itemed.itemlist.add(trealvaluelistedititem.create(5));
  itemed.itemlist.add(trealvaluelistedititem.create(5));
  n1:= trealvaluelistedititem.create(6);
  n1.value:= 0.33;
  itemed.itemlist.add(n1);
 end;
 
 if grid2.rowcount = 0 then begin //not loaded by statfile
  grid2.rowcount:= 2; //root nodes
  with tmynode(treeedit[0]) do begin
   caption:= 'AAAAA';
  end;
  with tmynode(treeedit[1]) do begin
   caption:= 'BBBBBBBBBB';
  end;
 end;
end;

procedure tmainfo.statreaditemexe(const sender: TObject;
               const reader: tstatreader; var aitem: tlistitem);
begin
 if reader.readinteger(valuenodetypename) = rectypenum then begin
  aitem:= trecitem.create();
 end;
end;

end.
