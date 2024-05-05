unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msegrids,msestrings,
 msetypes,msedrag,msedragglob;

type
 tmainfo = class(tmainform)
   tstringgrid1: tstringgrid;
   tstringgrid2: tstringgrid;
   procedure beforedragbeginexe(const sender: TObject; const apos: pointty;
                   var dragobject: tdragobject; var processed: Boolean);
   procedure beforedragoverexe(const sender: TObject; const apos: pointty;
                   var dragobject: tdragobject; var accept: Boolean;
                   var processed: Boolean);
   procedure beforedragdropexe(const sender: TObject; const apos: pointty;
                   var dragobject: tdragobject; var processed: Boolean);
 end;
var
 mainfo: tmainfo;

implementation
uses
 main_mfm;
 
procedure tmainfo.beforedragbeginexe(const sender: TObject; const apos: pointty;
               var dragobject: tdragobject; var processed: Boolean);
var
 co1: gridcoordty;
begin
 with tstringgrid(sender) do begin
  if cellatpos(apos,co1) = ck_data then begin
   tstringdragobject.create(sender,dragobject,apos).data:= 
                                            datacols[co1.col][co1.row];
   processed:= true;
  end;
 end;
end;

procedure tmainfo.beforedragoverexe(const sender: TObject; const apos: pointty;
               var dragobject: tdragobject; var accept: Boolean;
               var processed: Boolean);
var
 co1: gridcoordty;
begin
 if dragobject is tstringdragobject then begin
  with tstringgrid(sender) do begin
   if (sender <> dragobject.sender) and 
                            (cellatpos(apos,co1) = ck_data) then begin
    accept:= true;
    processed:= true;
   end;
  end;
 end;
end;

procedure tmainfo.beforedragdropexe(const sender: TObject; const apos: pointty;
               var dragobject: tdragobject; var processed: Boolean);
var
 co1: gridcoordty;
begin
 if dragobject is tstringdragobject then begin
  with tstringgrid(sender) do begin
   if (cellatpos(apos,co1) = ck_data) then begin
    datacols[co1.col][co1.row]:= tstringdragobject(dragobject).data;
    processed:= true;
   end;
  end;
 end;
end;

end.
