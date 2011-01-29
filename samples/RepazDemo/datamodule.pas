unit datamodule;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msewidgets,mseglob,mseclasses,msedatamodules,msegui,mseevent,sysutils,
 msebitmap,msegraphics,msegraphutils,msestat,msestatfile,mseskin,msestrings,
 msedataedits,msemenus,msetypes,msegraphedits,mseformatbmpicoread;

type

 tdatamo = class(tmsedatamodule)
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
   skinblue: tskincontroller;
   tframebutton: tframecomp;
   tfacegridrow: tfacecomp;
   tframeframe: tframecomp;
   tfacebutton: tfacecomp;
   tframecomp2: tframecomp;
   tframescrollbar: tframecomp;
   tfacescrollbarhorz: tfacecomp;
   tfacescrollbarvertend: tfacecomp;
   tfacescrollbarhorzend: tfacecomp;
   tframeframebutton: tframecomp;
   tfaceframebutton: tfacecomp;
   tfacescrollbarvert: tfacecomp;
   tframetab: tframecomp;
   tfacecaptiontab: tfacecomp;
   tfacetab: tfacecomp;
   tframetabpage: tframecomp;
   tfacetabpage: tfacecomp;
 end;
var
 datamo: tdatamo;

implementation
uses
 datamodule_mfm;


end.
