unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mclasses,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,mdb,msebufdataset,
 msedatabase,msedb,mseifiglob,msesqldb,msqldb,sysutils,mselocaldataset,
 mselookupbuffer,msedataedits,msedbedit,mseedit,msegraphedits,msegrids,
 mseificomp,mseificompglob,msescrollbar,msestrings,msetypes,msestatfile;

type
 tmainfo = class(tmainform)
   ds: tlocaldataset;
   lb: tdblookupbuffer;
   dataso: tmsedatasource;
   tdbwidgetgrid1: tdbwidgetgrid;
   tdbstringedit1: tdbstringedit;
   tdbstringedit2: tdbstringedit;
   tdbnavigator1: tdbnavigator;
   dropdownedit: tdropdownlisteditlb;
   tstatfile1: tstatfile;
   caseinsed: tbooleanedit;
   wordstarted: tbooleaneditradio;
   wholeworded: tbooleaneditradio;
   procedure filterexe(const sender: tcustomlookupbuffer;
                   const physindex: Integer; var valid: Boolean);
   procedure beforefilterexe(const sender: tcustomdataedit);
   procedure searchoptionenteredexe(const sender: TObject);
  private
   ffilter: msestring;
   ffilterupper: msestring;
   fsearchoptions: searchoptionsty;
 end;
 
var
 mainfo: tmainfo;
 
implementation
uses
 main_mfm;

procedure tmainfo.beforefilterexe(const sender: tcustomdataedit);
begin
 if so_caseinsensitive in fsearchoptions then begin
  ffilter:= mselowercase(dropdownedit.text);
  ffilterupper:= mseuppercase(dropdownedit.text);
 end
 else begin
  ffilter:= dropdownedit.text;
  ffilterupper:= '';
 end;
end;

procedure tmainfo.filterexe(const sender: tcustomlookupbuffer;
               const physindex: Integer; var valid: Boolean);
begin
 if ffilter <> '' then begin
  valid:= msestringsearch(ffilter,
         sender.textvalue[1,physindex],1,fsearchoptions,ffilterupper) > 0;
 end;
end;

procedure tmainfo.searchoptionenteredexe(const sender: TObject);
begin
 fsearchoptions:= searchoptionsty(tbooleanedit(sender).valuebitmask);
end;

end.
