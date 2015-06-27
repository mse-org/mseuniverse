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
  grid.rowcount:= 8;
  captions[0]:= 'Commit:';
  disp[0]:= logfo.commit.value;
  captions[1]:= 'Commit Date:';
  disp[1]:= datetimetostring(logfo.commitdate.value,'${dt}');
  captions[2]:= 'Parent:';
  disp[2]:= logfo.parent.value;
  captions[3]:= 'Tree:';
  disp[3]:= logfo.tree.value;
  captions[4]:= 'Committer:';
  disp[4]:= logfo.committer.value;
  captions[5]:= 'Author:';
  disp[5]:= logfo.author.value;
  captions[6]:= 'Author Date:';
  disp[6]:= datetimetostring(logfo.authordate.value,'${dt}');
  captions[7]:= 'Message:';
  disp[7]:= tlogitem(logfo.message.item).origmessage;
 end;
end;

procedure tcommitdispfo.doclear;
begin
 grid.clear();
end;

procedure tcommitdispfo.textmouseexe(const sender: TObject;
               var info: textmouseeventinfoty);
begin
 if (info.pos.row = 2) and istextdblclick(info) then begin
  logfo.findcommit(disp.wordatpos(info.pos,' '+lineend,[]));
 end;
end;

end.
