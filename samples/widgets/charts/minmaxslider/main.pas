unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msedispwidgets,mserichstring,msestrings,msechartedit,msestatfile;

type
 tmainfo = class(tmainform)
   value1disp: trealdisp;
   value0disp: trealdisp;
   txychartedit1: txychartedit;
   tstatfile1: tstatfile;
   procedure setmarkerexe(const sender: tcustomchartedit; const isy: Boolean;
                   const adial: Integer; const aindex: Integer;
                   var avalue: realty);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
 
procedure tmainfo.setmarkerexe(const sender: tcustomchartedit;
               const isy: Boolean; const adial: Integer; const aindex: Integer;
               var avalue: realty);
begin
 with sender.xdials[adial] do begin
  case aindex of
   0: begin
    value0disp.value:= avalue;
    if markers[1].value < avalue then begin
     markers[1].value:= avalue;
    end;
   end;
   1: begin
    value1disp.value:= avalue;
    if markers[0].value > avalue then begin
     markers[0].value:= avalue;
    end;
   end;
  end;
 end;
end;

end.
