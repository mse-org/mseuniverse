unit basetabs;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms, msedragglob,
 msescrollbar,msetabs,sysutils,msesimplewidgets,strutils,mdb,mseact,
 msedataedits,msedbedit,msedropdownlist,mseedit,msegraphedits,msegrids,
 msegridsglob,mseificomp,mseificompglob,mseifiglob,mselookupbuffer,msestatfile,
 msestream,msedblookup,msebitmap,frmbase;

type
 tbasetabsfo = class(tfrmbasefo)
   ttabwidget1: ttabwidget;
   procedure WhenGetSubForm(const sender: TTabpage;
                   var submoduleclass: widgetclassty;
                   var instancevarpo: pwidget);
   procedure WhenInitSubForm(const sender: ttabpage; const asubform: twidget);
   procedure WhenCreated(const sender: TObject);
  protected
 end;
var
 basetabsfo: tbasetabsfo; 
 implementation
uses
 basetabs_mfm;

procedure tbasetabsfo.WhenGetSubForm(const sender: TTabpage;
               var submoduleclass: widgetclassty; var instancevarpo: pwidget);
begin
submoduleclass:=widgetclassty(sender.tagpo);
end;

procedure tbasetabsfo.WhenInitSubForm(const sender: ttabpage;
               const asubform: twidget);
begin
with asubform do
begin
sender.bounds_cx:=bounds_cx+10;
sender.bounds_cy:=bounds_cy+10;
ttabwidget1.bounds_cx:=bounds_cx+4;
ttabwidget1.bounds_cy:=bounds_cy+24;

end; end;

procedure tbasetabsfo.WhenCreated(const sender: TObject);
begin
ttabwidget1.activepageindex:=0;
end;
end.
