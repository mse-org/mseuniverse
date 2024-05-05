unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msescrollbar,msetabs,
 msewidgets,sysutils,msestatfile,db,msebufdataset,msedb,mselocaldataset,tab3,
 msedragglob,msestream,msestrings;

type
 tmainfo = class(tmainform)
   tabs: ttabwidget;
   ttabpage1: ttabpage;
   ttabpage2: ttabpage;
   mainstat: tstatfile;
   ttabpage3: ttabpage;
   ttabpage4: ttabpage;
   ttabpage5: ttabpage;
   procedure getsub0exe(const sender: TObject;
                   var submoduleclass: widgetclassty;
                   var instancevarpo: pwidget);
   procedure getsub1exe(const sender: TObject;
                   var submoduleclass: widgetclassty;
                   var instancevarpo: pwidget);
   procedure getsub2exe(const sender: TObject;
                   var submoduleclass: widgetclassty;
                   var instancevarpo: pwidget);
   procedure getsub3exe(const sender: TObject;
                   var submoduleclass: widgetclassty;
                   var instancevarpo: pwidget);
   procedure getsub2aexe(const sender: TObject;
                   var submoduleclass: widgetclassty;
                   var instancevarpo: pwidget);
   public
    tab3: ttab3fo;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,tab0,tab1,tab2,tab2a;
 
procedure tmainfo.getsub0exe(const sender: TObject;
               var submoduleclass: widgetclassty; var instancevarpo: pwidget);
begin
 submoduleclass:= ttab0fo;
end;

procedure tmainfo.getsub1exe(const sender: TObject;
               var submoduleclass: widgetclassty; var instancevarpo: pwidget);
begin
 submoduleclass:= ttab1fo;
end;

procedure tmainfo.getsub2exe(const sender: TObject;
               var submoduleclass: widgetclassty; var instancevarpo: pwidget);
begin
 submoduleclass:= ttab2fo;
 instancevarpo:= @tab2fo;
end;

procedure tmainfo.getsub2aexe(const sender: TObject;
               var submoduleclass: widgetclassty; var instancevarpo: pwidget);
begin
 submoduleclass:= ttab2afo;
 instancevarpo:= @tab2afo;
end;

procedure tmainfo.getsub3exe(const sender: TObject;
               var submoduleclass: widgetclassty; var instancevarpo: pwidget);
begin
 submoduleclass:= ttab3fo;
 instancevarpo:= @tab3;
end;

end.
