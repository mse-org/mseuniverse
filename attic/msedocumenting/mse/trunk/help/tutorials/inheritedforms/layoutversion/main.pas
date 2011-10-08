unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,
 msewidgets,baseform,msedataedits,mseedit,msestrings,msetypes;

type
 tmainfo = class(tmainform)
   bu1: tbutton;
   bu2: tbutton;
   bu3: tbutton;
   textedit: tstringedit;
   procedure showformex(const sender: TObject);
   procedure settext(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
  private
   ftheform: tbasefo;
   procedure settheform(const avalue: tbasefo);
  public
   property theform: tbasefo read ftheform write settheform;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,smallform,bigform,classes;
 
procedure tmainfo.showformex(const sender: TObject);
var
 aclass: widgetclassty;
begin
 case tcomponent(sender).tag of
  0: begin
   aclass:= tsmallfo;
  end;
  2: begin
   aclass:= tbigfo;
  end;
  else begin
   aclass:= tbasefo;
  end;
 end;
 application.createform(aclass,ftheform);
 theform:= ftheform;
 ftheform.edit1.value:= textedit.value;
end;

procedure tmainfo.settheform(const avalue: tbasefo);
var
 bo1: boolean;
begin
 ftheform:= avalue;
 bo1:= avalue = nil;
 bu1.enabled:= bo1;
 bu2.enabled:= bo1;
 bu3.enabled:= bo1;
end;

procedure tmainfo.settext(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 if ftheform <> nil then begin
  ftheform.edit1.value:= avalue;
 end;
end;

end.
