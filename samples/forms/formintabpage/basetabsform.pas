unit basetabsform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,baseeditform,
 msedragglob,msescrollbar,msetabs,baseeditpageform;

type
 pageclassarty = array of editpageclassty;

 tbasetabsfo = class(tbaseeditfo)
   tabs: ttabwidget;
   procedure getsubformev(const sender: ttabpage;
                   var submoduleclass: widgetclassty;
                   var instancevarpo: pwidget);
   procedure initsubformev(const sender: ttabpage; const asubform: twidget);
  protected
   function getpageclasses(): pageclassarty virtual abstract;
 end;

implementation
uses
 basetabsform_mfm,sysutils;

procedure tbasetabsfo.getsubformev(const sender: ttabpage;
               var submoduleclass: widgetclassty; var instancevarpo: pwidget);
var
 pageclasses: pageclassarty;
begin
 pageclasses:= getpageclasses();
 if (sender.tag < 0) or (sender.tag > high(pageclasses)) then begin
  raise exception.create('Invalid tabpage tag');
 end;
 submoduleclass:= pageclasses[sender.tag];
end;

procedure tbasetabsfo.initsubformev(const sender: ttabpage;
                                         const asubform: twidget);
begin
 dataso.dataset:= tbaseeditpagefo(asubform).dataso.dataset;
end;

end.
