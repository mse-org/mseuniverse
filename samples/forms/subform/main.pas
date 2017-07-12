unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,subform1,subform2;

type
 subformty = (sf_none,sf_1,sf_2);
 
 tmainfo = class(tmainform)
   cont: tgroupbox;
   tbutton1: tbutton;
   tbutton2: tbutton;
   tbutton3: tbutton;
   procedure selectformexe(const sender: TObject);
  protected
   fcurrentform: subformty;
   procedure setcurrentform(const kind: subformty);
  public
   property currentform: subformty read fcurrentform write setcurrentform;
 end;
var
 mainfo: tmainfo;
 subform1inst: tsubform1fo;
 subform2inst: tsubform2fo;
  
implementation
uses
 main_mfm,sysutils;

type
 subforminfoty = record
  classty: class of tmseform;
  instancevarad: ^tmseform;
 end;
 
const
 subforminfo: array[subformty] of subforminfoty = (
  (classty: nil; instancevarad: nil),                     //sf_none
  (classty: tsubform1fo; instancevarad: @subform1inst),   //sf_1
  (classty: tsubform2fo; instancevarad: @subform2inst)    //sf_2
 );
 
{ tmainfo }

procedure tmainfo.setcurrentform(const kind: subformty);
begin
 if fcurrentform <> kind then begin
  if fcurrentform <> sf_none then begin
   with subforminfo[fcurrentform] do begin
    if instancevarad^ <> nil then begin
     instancevarad^.release;
     instancevarad^:= nil;
    end;
   end;
  end;
  fcurrentform:= kind;
  if fcurrentform <> sf_none then begin
   with subforminfo[fcurrentform] do begin
    instancevarad^:= classty.create(self);
    instancevarad^.parentwidget:= cont;
    instancevarad^.show();
   end;
  end;
 end;
end;

procedure tmainfo.selectformexe(const sender: TObject);
begin
 currentform:= subformty(tmsecomponent(sender).tag);
end;

end.
