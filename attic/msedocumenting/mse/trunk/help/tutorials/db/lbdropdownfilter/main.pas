unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,mdb,msebufdataset,
 msedatabase,msedb,mseifiglob,msesqldb,msqldb,sysutils,mselocaldataset,
 mselookupbuffer,msedataedits,msedbedit,mseedit,msegraphedits,msegrids,
 mseificomp,mseificompglob,msescrollbar,msestrings,msetypes;

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
   procedure filterexe(const sender: tcustomlookupbuffer;
                   const physindex: Integer; var valid: Boolean);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
 
procedure tmainfo.filterexe(const sender: tcustomlookupbuffer;
               const physindex: Integer; var valid: Boolean);
begin
 if dropdownedit.text <> '' then begin
  valid:= msestringsearch(
        dropdownedit.text,sender.textvalue[1,physindex],1,[so_wordstart]) > 0;
 end;
end;

end.
