unit editform; 
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,baseeditform,
 msedragglob,msescrollbar,msetabs,basetabsform;

type
 teditfo = class(tbasetabsfo)
   ttabpage1: ttabpage;
   ttabpage2: ttabpage;
   ttabpage3: ttabpage;
  protected
   function getpageclasses(): pageclassarty override;
 end;

var
 editfo: teditfo;

implementation
uses
 editform_mfm,sysutils,baseeditpageform,
 editpage1form,editpage2form,editpage3form;

type
 editkindsty = (ek_1,ek_2,ek_3);
const
 editpageclasses: array[editkindsty] of editpageclassty = 
                             (teditpage1fo,teditpage2fo,teditpage3fo);
                             
{ teditfo }

function teditfo.getpageclasses(): pageclassarty;
begin
 result:= editpageclasses;
end;

end.
