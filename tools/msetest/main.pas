unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 msedataedits,mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,msestream,
 msestrings,msewidgetgrid,sysutils,msedatanodes,mselistbrowser,mseifiendpoint;

type
 tmainfo = class(tmainform)
   tmainmenu1: tmainmenu;
   grid: twidgetgrid;
   treeed: ttreeitemedit;
   connectmodule: tifiactionendpoint;
   projectcaption: tifistringendpoint;
   procedure connectmoduleexe(const sender: TObject);
   procedure createitemexe(const sender: tcustomitemlist;
                   var item: ttreelistedititem);
   procedure captionchaexe(const sender: TObject; var avalue: msestring);
   procedure closequeryexe(const sender: tcustommseform;
                   var amodalresult: modalresultty);
 end;
 
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,mainmodule;
 
procedure tmainfo.connectmoduleexe(const sender: TObject);
begin
 treeed.itemlist.rootnode:= mainmo.rootnode;
end;

procedure tmainfo.createitemexe(const sender: tcustomitemlist;
               var item: ttreelistedititem);
begin
 item:= ttestnode.create(sender);
 with ttreeitemeditlist(sender) do begin
  insertparent.insert(item,insertparentindex);
 end;
 mainmo.projectchanged();
end;

procedure tmainfo.captionchaexe(const sender: TObject; var avalue: msestring);
begin
 caption:= 'MSEtest ('+ avalue+')';
end;

procedure tmainfo.closequeryexe(const sender: tcustommseform;
               var amodalresult: modalresultty);
begin
 if not mainmo.closeproject() then begin
  amodalresult:= mr_none;
 end;
end;

end.
