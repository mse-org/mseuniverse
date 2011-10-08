unit nodsgrouping;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,nods,db,msereport,mserichstring,
 msesplitter,msestrings;

type
 tnodsgroupingfo = class(tnodsre)
   tbandgroup1: tbandgroup;
   bandGroup: trecordband;
   datarec1: trecordband;
   procedure fillDataLine(const sender: tcustomrecordband; 
   		var empty: Boolean);override;
   procedure goNext(const sender: tcustomrecordband);
   protected
 end;
var
 nodsgroupingfo: tnodsgroupingfo;
implementation
uses
 nodsgrouping_mfm, sysutils;

procedure tnodsgroupingfo.fillDataLine(const sender: tcustomrecordband;
               var empty: Boolean);
var
	snum : string;   
	bo : boolean;   
	groupOf : string;         
begin
	if dataCount > 100 then exit;
	snum := IntToStr(dataCount);

	if (dataCount mod 10) = 0 then groupOf := '10'
	else if (dataCount mod 5) = 0 then groupOf := '5'
	else groupOf := '';

	if groupOf <> '' then
	begin
		bandGroup.tabs[0].value := 'Group of ' + groupOf + '  / ' + snum;
		bandgroup.visible:= true;
	end
    else begin
     bandgroup.visible:= false;
    end;

	dataRec1.tabs[0].value := snum;
	dataRec1.tabs[1].value := 'A data name ' + snum;
	dataRec1.tabs[2].value := 'phone n# ' + snum;
	empty := false;
end;
 
procedure tnodsgroupingfo.goNext(const sender: tcustomrecordband);
begin
	advanceCounter(sender);
end;
 
end.
