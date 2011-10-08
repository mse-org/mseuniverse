unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,msewidgets,
 msedataedits,mseedit,msestrings,msetypes,msegraphedits,RAWPrinter;

type
 tmainfo = class(tmseform)
   tbutton1: tbutton;
   tmemoedit1: tmemoedit;
   tbooleanedit1: tbooleanedit;
   TRAWPrinter1: TRAWPrinter;
   procedure changeejectpaper(const sender: TObject);
   procedure cmdprint(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
 
procedure tmainfo.changeejectpaper(const sender: TObject);
begin
	TRAWPrinter1.ejectonfinish:=tbooleanedit1.value;
end;

procedure tmainfo.cmdprint(const sender: TObject);
var
	tmpresult: msestring;
	resultprn: msestringarty;
begin
	tmpresult:=removechar(tmemoedit1.value,#10);
	splitstring(tmpresult,resultprn,#13,false);
	with TRAWPrinter1 do begin
		BeginDoc;
		WriteList(resultprn, true);
  		EndDoc;
  	end;
end;

end.
