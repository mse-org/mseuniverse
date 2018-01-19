unit tokenlist1form;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 mdb,mseact,msedataedits,msedbedit,msedropdownlist,mseedit,msegraphedits,
 msegrids,mseificomp,mseificompglob,mseifiglob,mselookupbuffer,msescrollbar,
 msestream,sysutils,msedb,mseassistivehandler,msedbdialog;
type
 ttokenlist1fo = class(tmseform)
   tstatfile1: tstatfile;
   grid: tdbwidgetgrid;
   numbered: tdbintegeredit;
   issuedateed: tdbdatetimeedit;
   expirydateed: tdbdatetimeedit;
   descriptioned: tdbstringedit;
   quantityed: tdbrealedit;
   united: tdbstringedit;
   valueed: tdbrealedit;
   commented: tdbmemodialogedit;
   dataso: tmsedatasource;
   tassistivewidgetitem1: tassistivewidgetitem;
   honourdateed: tdbdatetimeedit;
   tdatabutton1: tdatabutton;
   tdatabutton2: tdatabutton;
   tdatabutton3: tdatabutton;
   recipiented: tdbstringedit;
   customered: tdbstringedit;
 end;
var
 tokenlist1fo: ttokenlist1fo;
implementation
uses
 tokenlist1form_mfm;
end.
