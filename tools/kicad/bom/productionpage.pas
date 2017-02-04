unit productionpage;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msetabs,
 msesplitter,mseact,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,
 msestatfile,msestream,msestrings,sysutils,msegrids,msewidgetgrid,msebitmap,
 msedatanodes,msefiledialog,mselistbrowser,msesys,msegraphedits,msescrollbar,
 msedragglob;
type
 tproductionpagefo = class(ttabform)
   tlayouter1: tlayouter;
   nameed: tstringedit;
   productiondired: tfilenameedit;
   tlayouter2: tlayouter;
   productionzipfilenameed: tfilenameedit;
   tlayouter3: tlayouter;
   createproductionziped: tbooleanedit;
   productionzipdired: tstringedit;
   ttabwidget1: ttabwidget;
   ttabpage1: ttabpage;
   plotsgrid: twidgetgrid;
   layered: tdropdownlistedit;
   plotfileed: tstringedit;
   plotformated: tenumedit;
   ttabpage2: ttabpage;
   drillgrid: twidgetgrid;
   layerbed: tdropdownlistedit;
   drillfileed: tstringedit;
   layeraed: tdropdownlistedit;
   nonplateded: tbooleanedit;
   statf: tstatfile;
   drillmarked: tdropdownlistedit;
   procedure namesetev(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure createev(const sender: TObject);
   procedure showhintev(const sender: TObject; var info: hintinfoty);
   procedure hintplotfilenamecolev(const sender: tdatacol; const arow: Integer;
                   var info: hintinfoty);
   procedure hintdrillfilenamecolev(const sender: tdatacol; const arow: Integer;
                   var info: hintinfoty);
   procedure selectev(const sender: TObject);
   procedure deselectev(const sender: TObject);
   procedure drilldataentered(const sender: TObject);
   procedure drillfilesetev(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure plotfilesetev(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure plotdataenteredev(const sender: TObject);
  protected
   function buildplotfilename(): msestring;
   function checkfileduplicate(const aedit: tcustomstringedit;
                                          const avalue: msestring): boolean;
   function builddrillfilename(): msestring;
 end;

implementation
uses
 productionpage_mfm,mainmodule;

procedure tproductionpagefo.createev(const sender: TObject);
begin
 layered.dropdown.cols[0].asarray:= mainmo.layernames;
 layeraed.dropdown.cols[0].asarray:= mainmo.culayernames;
 layerbed.dropdown.cols[0].asarray:= mainmo.culayernames;
 plotformated.dropdown.cols[0].asarray:= mainmo.fileformats;
 drillmarked.dropdown.cols[0].asarray:= mainmo.drillmarknames;
end;

procedure tproductionpagefo.namesetev(const sender: TObject;
               var avalue: msestring; var accept: Boolean);
begin
 caption:= avalue;
end;

function tproductionpagefo.buildplotfilename(): msestring;
begin
 result:= layertoplotname(layered.value);
end;

function tproductionpagefo.checkfileduplicate(const aedit: tcustomstringedit;
                                              const avalue: msestring): boolean;
var
 i1: int32;
 s1: msestring;
begin
 result:= false;
 s1:= mseuppercase(avalue);
 if (avalue <> '') and (s1 <> mseuppercase(aedit.value)) then begin
  for i1:= 0 to aedit.gridrowhigh do begin
   if mseuppercase(aedit[i1]) = s1 then begin
    result:= true;
    break;
   end;
  end;
 end;
end;

procedure tproductionpagefo.plotdataenteredev(const sender: TObject);
var
 s1: msestring;
begin
 s1:= buildplotfilename();
 if checkfileduplicate(plotfileed,s1) then begin
  s1:= '';
 end;
 plotfileed.value:= s1;
end;

procedure tproductionpagefo.plotfilesetev(const sender: TObject;
               var avalue: msestring; var accept: Boolean);
begin
 if checkfileduplicate(tcustomstringedit(sender),avalue) then begin
  errormessage('Duplicate filename.');
  accept:= false;
 end;
end;

function tproductionpagefo.builddrillfilename(): msestring;
begin
 result:= layertoplotname(layeraed.value)+'-'+layertoplotname(layerbed.value);
 if nonplateded.value then begin
  result:= result+'-npth';
 end;
end;

procedure tproductionpagefo.drilldataentered(const sender: TObject);
var
 s1: msestring;
begin
 s1:= builddrillfilename();
 if checkfileduplicate(drillfileed,s1) then begin
  s1:= '';
 end;
 drillfileed.value:= s1;
end;

procedure tproductionpagefo.drillfilesetev(const sender: TObject;
               var avalue: msestring; var accept: Boolean);
begin
 if checkfileduplicate(tcustomstringedit(sender),avalue) then begin
  errormessage('Duplicate filename.');
  accept:= false;
 end;
end;

procedure tproductionpagefo.showhintev(const sender: TObject;
               var info: hintinfoty);
begin
 mainmo.hintmacros(tedit(sender).text,info);
end;

procedure tproductionpagefo.hintplotfilenamecolev(const sender: tdatacol;
               const arow: Integer; var info: hintinfoty);
begin
 mainmo.hintmacros(plotfileed[arow],info);
end;

procedure tproductionpagefo.hintdrillfilenamecolev(const sender: tdatacol;
               const arow: Integer; var info: hintinfoty);
begin
 mainmo.hintmacros(drillfileed[arow],info);
end;

procedure tproductionpagefo.selectev(const sender: TObject);
begin
 statf.readstat();
end;

procedure tproductionpagefo.deselectev(const sender: TObject);
begin
 statf.writestat();
end;

end.
