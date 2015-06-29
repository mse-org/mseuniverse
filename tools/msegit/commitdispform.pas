unit commitdispform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,dispform,
 msedispwidgets,mserichstring,msestrings,msedataedits,mseedit,mseificomp,
 mseificompglob,mseifiglob,msestatfile,msestream,sysutils,msesplitter,msegrids,
 msewidgetgrid,mseeditglob,msetextedit,msesyntaxedit,msegraphedits,msescrollbar;

type
 tcommitdispfo = class(tdispfo)
   grid: twidgetgrid;
   disp: tsyntaxedit;
   captions: tstringedit;
   tspacer1: tspacer;
   listbranches: tbooleanedit;
   procedure textmouseexe(const sender: TObject;
                   var info: textmouseeventinfoty);
   procedure listbranachesdatentexe(const sender: TObject);
  protected
   procedure dorefresh; override;
   procedure doclear; override;
 end;
var
 commitdispfo: tcommitdispfo;
implementation
uses
 commitdispform_mfm,logform,mseformatstr,msegridsglob,mainmodule;
 
{ tcommitdispfo }

procedure tcommitdispfo.dorefresh;
var
 bo1: boolean;
 ar1: msestringarty;
begin
 if logfo.grid.row < 0 then begin
  doclear();
 end
 else begin
//  bo1:= mainmo.repostat.logfiltercommit <> '';
  bo1:= listbranches.value;
  if bo1 then begin
   grid.rowcount:= 7;
  end
  else begin
   grid.rowcount:= 6;
  end;
  captions[0]:= 'Commit:';
  disp[0]:= logfo.commit.value;
  captions[1]:= 'Parent:';
  disp[1]:= logfo.parent.value;
  captions[2]:= 'Tree:';
  disp[2]:= logfo.tree.value;
  captions[3]:= 'Committer:';
  disp[3]:= datetimetostring(logfo.commitdate.value,'${dt}')+' '+
                                                   logfo.committer.value;
  captions[4]:= 'Author:';
  disp[4]:= datetimetostring(logfo.authordate.value,'${dt}')+' '+
                                                   logfo.author.value;
  captions[grid.rowhigh]:= 'Message:';
  disp[grid.rowhigh]:= tlogitem(logfo.message.item).origmessage;
  if bo1 then begin
   captions[5]:= 'Branches:';
   disp[5]:= '*** Querying Branches ***';
   if mainmo.git.findbranches(mainmo.repostat.logfiltercommit,ar1) then begin
    disp[5]:= concatstrings(ar1,lineend);
   end
   else begin
    disp[5]:= '';
   end;
  end;  
 end;
end;

procedure tcommitdispfo.doclear;
begin
 grid.clear();
end;

procedure tcommitdispfo.textmouseexe(const sender: TObject;
               var info: textmouseeventinfoty);
begin
 if (info.pos.row = 1) and istextdblclick(info) then begin
  logfo.findcommit(disp.wordatpos(info.pos,' '+lineend,[]));
 end;
end;

procedure tcommitdispfo.listbranachesdatentexe(const sender: TObject);
begin
 refresh();
end;

end.
