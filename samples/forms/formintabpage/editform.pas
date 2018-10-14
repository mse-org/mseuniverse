unit editform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,baseeditform,
 msedragglob,msescrollbar,msetabs;

type
 teditfo = class(tbaseeditfo)
   tabs: ttabwidget;
   ttabpage1: ttabpage;
   ttabpage2: ttabpage;
   ttabpage3: ttabpage;
   procedure getsubformev(const sender: ttabpage;
                   var submoduleclass: widgetclassty;
                   var instancevarpo: pwidget);
   procedure initsubformev(const sender: ttabpage; const asubform: twidget);
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
                             
procedure teditfo.getsubformev(const sender: ttabpage;
               var submoduleclass: widgetclassty; var instancevarpo: pwidget);
begin
 if (sender.tag < 0) or (sender.tag > ord(high(editpageclasses))) then begin
  raise exception.create('Invalid tabpage tag');
 end;
 submoduleclass:= editpageclasses[editkindsty(sender.tag)];
end;

procedure teditfo.initsubformev(const sender: ttabpage;
                                         const asubform: twidget);
begin
 dataso.dataset:= tbaseeditpagefo(asubform).dataso.dataset;
end;

end.
