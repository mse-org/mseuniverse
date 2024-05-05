unit clientform;
{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msegrids,mseifigui,msedataedits,
 mseedit,msestrings,msetypes,msesimplewidgets,msewidgets,mseact,mseactions,
 msedispwidgets,mseifilink,db,msebufdataset,msedb,mseifids,msesqldb,msqldb,
 sysutils,msedbedit,msedialog,msegraphedits,mseskin;
type
 tclientfo = class(tmseform)
   tformlink1: tformlink;
   tstringedit1: tstringedit;
   tbutton1: tbutton;
   buttonact: taction;
   buttondisp: tstringdisp;
   dataset: trxdataset;
   datasource: tmsedatasource;
   tdbstringgrid1: tdbstringgrid;
   progressbar: tprogressbar;
   menu: tmainmenu;
   menu1a: taction;
   menu1b: taction;
   menu1c: taction;
   menu2a: taction;
   quit: taction;
   nullface: tfacecomp;
   fadecontainer: tfacecomp;
   fadehorzconcave: tfacecomp;
   fadevertconcave: tfacecomp;
   skin: tskincontroller;
   fadehorzconvex: tfacecomp;
   fadevertkonvex: tfacecomp;
   menuitemframe: tframecomp;
   menuframe: tframecomp;
   tdbnavigator1: tdbnavigator;
 end;
var
 clientfo: tclientfo;
implementation
uses
 clientform_mfm;
end.
