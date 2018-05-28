unit portsettingsframe;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msecommport,
 msecommutils,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,
 msestrings,msetypes,msesercomm,msegraphedits,msescrollbar,msestatfile;
type
 tportsettingsfra = class(tsubform)
   ported: tcommselector;
   port: tsercommcomp;
   bauded: tenumtypeedit;
   databitsed: tenumtypeedit;
   parityed: tenumtypeedit;
   stopbited: tenumtypeedit;
   eor: thexstringedit;
   activeed: tbooleanedit;
   portstat: tstatfile;
   procedure baudinit(const sender: tenumtypeedit);
   procedure databitsinit(const sender: tenumtypeedit);
   procedure parityinit(const sender: tenumtypeedit);
   procedure stobbitsinit(const sender: tenumtypeedit);
   procedure loadedexe(const sender: TObject);
   procedure getactivecommexe(const sender: TObject; var avalue: commnrty);
   procedure portsetexe(const sender: TObject; var avalue: commnrty;
                   var accept: Boolean);
   procedure baudset(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
   procedure databitsset(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
   procedure parityset(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
   procedure stopbitset(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
   procedure activeset(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
   procedure paramenereev(const sender: TObject);
 end;

implementation
uses
 portsettingsframe_mfm;

procedure tportsettingsfra.baudinit(const sender: tenumtypeedit);
begin
 sender.typeinfopo:= typeinfo(commbaudratety);
end;

procedure tportsettingsfra.databitsinit(const sender: tenumtypeedit);
begin
 sender.typeinfopo:= typeinfo(commdatabitsty);
end;

procedure tportsettingsfra.parityinit(const sender: tenumtypeedit);
begin
 sender.typeinfopo:= typeinfo(commparityty);
end;

procedure tportsettingsfra.stobbitsinit(const sender: tenumtypeedit);
begin
 sender.typeinfopo:= typeinfo(commstopbitty);
end;

procedure tportsettingsfra.loadedexe(const sender: TObject);
begin
 with port.port do begin //set default values
  bauded.value:= ord(baud);
  ported.value:= commnr;
  databitsed.value:= ord(databits);
  parityed.value:= ord(parity);
  stopbited.value:= ord(stopbit);
 end;
end;

procedure tportsettingsfra.getactivecommexe(const sender: TObject;
               var avalue: commnrty);
begin
  //add current port to dropdown list
 if port.active and (port.port.commname = '') then begin
  avalue:= port.port.commnr;
 end;
end;

procedure tportsettingsfra.portsetexe(const sender: TObject;
               var avalue: commnrty; var accept: Boolean);
begin
 try
  if avalue = cnr_invalid then begin //special comm name
   port.port.commname:= tcommselector(sender).valuename;
  end
  else begin
   port.port.commname:= '';          //normal comm nr
   port.port.commnr:= avalue;
  end;
 finally
  activeed.value:= port.active; //reset in case of error
 end;
end;

procedure tportsettingsfra.baudset(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
 port.port.baud:= commbaudratety(avalue);
end;

procedure tportsettingsfra.databitsset(const sender: TObject;
               var avalue: Integer; var accept: Boolean);
begin
 port.port.databits:= commdatabitsty(avalue);
end;

procedure tportsettingsfra.parityset(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
 port.port.parity:= commparityty(avalue);
end;

procedure tportsettingsfra.stopbitset(const sender: TObject;
               var avalue: Integer; var accept: Boolean);
begin
 port.port.stopbit:= commstopbitty(avalue);
end;

procedure tportsettingsfra.activeset(const sender: TObject; var avalue: Boolean;
               var accept: Boolean);
begin
 port.active:= avalue;
end;

procedure tportsettingsfra.paramenereev(const sender: TObject);
begin
 port.active:= false;
 activeed.value:= false;
end;

end.
