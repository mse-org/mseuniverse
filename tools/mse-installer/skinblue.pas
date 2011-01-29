unit skinblue;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseclasses,msedatamodules,msegui,sysutils,
 msegraphics,msegraphutils,msestat,mseskin;

type

 tskinblue = class(tmsedatamodule)
   tfaceactivemenu: tfacecomp;
   tfaceboolean: tfacecomp;
   tfacetabactive: tfacecomp;
   tfacebuttontoolbar: tfacecomp;
   tfaceform: tfacecomp;
   tfaceframe: tfacecomp;
   tfacegridcol: tfacecomp;
   tfacemenu: tfacecomp;
   tfacepmenu: tfacecomp;
   tframeboolean: tframecomp;
   tframetoolbar: tframecomp;
   tframemenuactive: tframecomp;
   tframeEdit: tframecomp;
   tframeform: tframecomp;
   tframegrid: tframecomp;
   tframemenu: tframecomp;
   tframepopupmenu: tframecomp;
   tframepopupmenuitem: tframecomp;
   cskinblue: tskincontroller;
   tframebutton: tframecomp;
   tfacegridrow: tfacecomp;
   tframeframe: tframecomp;
   tframescrollbar: tframecomp;
   tfacescrollbarhorz: tfacecomp;
   tfacescrollbarvertend: tfacecomp;
   tfacescrollbarhorzend: tfacecomp;
   tframeframebutton: tframecomp;
   tfaceframebutton: tfacecomp;
   tfacescrollbarvert: tfacecomp;
   tframetab: tframecomp;
   tfacetab: tfacecomp;
   tframetabpage: tframecomp;
   tfacetabpage: tfacecomp;
   tframegridrow: tframecomp;
   tfacetabopo: tfacecomp;
   tfacetabactiveopo: tfacecomp;
   tfacebutton: tfacecomp;
   tfacevtab: tfacecomp;
   tfacevtabactive: tfacecomp;
   tframevtab: tframecomp;
   procedure skinblue_oncreate(const sender: TObject);
   procedure cskinblue_onafterupdate(const sender: tcustomskincontroller;
                   const ainfo: skininfoty);
 end;
var
 skinbluemo: tskinblue;

implementation
uses
 skinblue_mfm;


procedure tskinblue.skinblue_oncreate(const sender: TObject);
begin
 cskinblue.active:= true;
end;

procedure tskinblue.cskinblue_onafterupdate(const sender: tcustomskincontroller;
               const ainfo: skininfoty);
begin
 
end;

end.
