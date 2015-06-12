unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedataedits,
 mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,msestatfile,msestream,
 msestrings,msewidgetgrid,sysutils,msedatanodes,mselistbrowser,mserealsumedit,
 msesimplewidgets;

type
 tmainfo = class(tmainform)
   twidgetgrid1: twidgetgrid;
   itemed: titemedit;
   trealedit1: trealedit;
   procedure createexe(const sender: TObject);
 end;
var
 mainfo: tmainfo;

implementation
uses
 main_mfm,msedatalist,msevaluenodes;

type
 tmyitem = class(trecordvaluelistedititem)
  private
   frealval: real;
   procedure setrealval(const avalue: real);
  protected
   procedure getvalueinfo(out atype: listdatatypety;
                        out aindex: int32; out avaluead: pointer); override;
   procedure setvalue(const atype: listdatatypety;
       const aindex: int32; const getvaluemethod: getvaluemethodty); override;
  public
   property realval: real read frealval write setrealval;
 end;
  
{ tmyitem }

procedure tmyitem.setrealval(const avalue: real);
begin
 if frealval <> avalue then begin
  frealval:= avalue;
  valuechange();
 end;
end;

procedure tmyitem.getvalueinfo(out atype: listdatatypety; out aindex: int32;
                                                        out avaluead: pointer);
begin
 atype:= dl_real;
 aindex:= 0;
 avaluead:= @frealval;
end;

procedure tmyitem.setvalue(const atype: listdatatypety;
               const aindex: int32; const getvaluemethod: getvaluemethodty);
var
 rea1: realty;
begin
 if (atype = dl_real) and (aindex = 0) then begin
  getvaluemethod(rea1);
  realval:= rea1;
 end;
end;

procedure tmainfo.createexe(const sender: TObject);
begin
 itemed.itemlist.add(tmyitem.create);
end;

end.
