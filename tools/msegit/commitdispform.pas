unit commitdispform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,dispform,
 msedispwidgets,mserichstring,msestrings,msedataedits,mseedit,mseificomp,
 mseificompglob,mseifiglob,msestatfile,msestream,sysutils,msesplitter,msegrids,
 msewidgetgrid,mseeditglob,msetextedit,msesyntaxedit;

type
 tcommitdispfo = class(tdispfo)
   grid: twidgetgrid;
   disp: tsyntaxedit;
   captions: tstringedit;
   procedure textmouseexe(const sender: TObject;
                   var info: textmouseeventinfoty);
  protected
   procedure dorefresh; override;
   procedure doclear; override;
 end;
var
 commitdispfo: tcommitdispfo;
implementation
uses
 commitdispform_mfm,logform,mseformatstr,msegridsglob;
 
{ tcommitdispfo }

procedure tcommitdispfo.dorefresh;
begin
 if logfo.grid.row < 0 then begin
  doclear();
 end
 else begin
  grid.rowcount:= 6;
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
  captions[5]:= 'Message:';
  disp[5]:= tlogitem(logfo.message.item).origmessage;
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

end.
