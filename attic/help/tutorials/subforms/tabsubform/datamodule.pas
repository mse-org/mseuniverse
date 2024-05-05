unit datamodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseapplication,mseclasses,msedatamodules,mdb,msedb,msebufdataset,
 mselocaldataset,mseificomp,mseificompglob,mseifiglob;

type
 tdatamo = class(tmsedatamodule)
   dataso: tmsedatasource;
   dataset: tlocaldataset;
   formlink: tififormlinkcomp;
   dsactivator: tactivator;
   procedure formstatechaexe(const sender: tcustomificlientcontroller;
                   const aclient: iificlient; const astate: ifiwidgetstatesty;
                   const achangedstate: ifiwidgetstatesty);
 end;
var
 datamo: tdatamo;
implementation
uses
 datamodule_mfm;
 
procedure tdatamo.formstatechaexe(const sender: tcustomificlientcontroller;
               const aclient: iificlient; const astate: ifiwidgetstatesty;
               const achangedstate: ifiwidgetstatesty);
begin
 if iws_loaded in (achangedstate * astate) then begin
  dsactivator.active:= true;
 end
 else begin
  if iws_releasing in (achangedstate * astate) then begin
   dsactivator.active:= false;
  end;
 end;
end;

end.
