unit componenteditform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 recordeditform,msesplitter,mdb,mseact,msedataedits,msedbedit,mseedit,
 msegraphedits,msegrids,mseificomp,mseificompglob,mseifiglob,mselookupbuffer,
 msescrollbar,msestatfile,msestream,msestrings,sysutils,msedb,msedbdialog;

type
 tcomponenteditfo = class(trecordeditfo)
   stripe2: tlayouter;
   value2ed: tdbstringedit;
   value1ed: tdbstringedit;
   valueed: tdbstringedit;
   stripe3: tlayouter;
   footprinted: tdbenum64editdb;
   compkinded: tdbenum64editdb;
   tsimplewidget2: tsimplewidget;
   stripe4: tlayouter;
   designationed: tdbdialogstringedit;
   stripe5: tlayouter;
   parameter1ed: tdbdialogstringedit;
   stripe6: tlayouter;
   parameter2ed: tdbdialogstringedit;
   stripe7: tlayouter;
   parameter3ed: tdbdialogstringedit;
   stripe8: tlayouter;
   parameter4ed: tdbdialogstringedit;
   procedure closeev(const sender: TObject);
   procedure editfootprintev(const sender: TObject);
   procedure editcompkindev(const sender: TObject);
   procedure datachangeev(Sender: TObject; Field: TField);
   procedure macrohintev(const sender: TObject; var info: hintinfoty);
  public
   constructor create(const idfield: tmselargeintfield;
                                        const nonavig: boolean); reintroduce;
 end;
implementation
uses
 componenteditform_mfm,mainmodule,main,msebufdataset;

{ tcomponenteditfo }

constructor tcomponenteditfo.create(const idfield: tmselargeintfield;
                                                    const nonavig: boolean);
begin
 mainmo.begincomponentedit(idfield);
 inherited create(nil);
 if nonavig then begin
  navig.options:= navig.options + [dno_nonavig,dno_noinsert];
 end
 else begin
  navig.options:= navig.options - [dno_nonavig,dno_noinsert];
 end;
end;

procedure tcomponenteditfo.closeev(const sender: TObject);
begin
 mainmo.endcomponentedit(dno_nonavig in navig.options); //true -> full refresh
end;

procedure tcomponenteditfo.editfootprintev(const sender: TObject);
begin
 mainfo.editfootprintev(sender);
end;

procedure tcomponenteditfo.editcompkindev(const sender: TObject);
begin
 mainfo.editcomponentkind(mainmo.sc_componentkind);
end;

procedure tcomponenteditfo.datachangeev(Sender: TObject; Field: TField);
var
 bm1: bookmarkdataty;
begin
 with mainmo do begin
  if (field = nil) or (field = sc_componentkind) then begin
   if not sc_componentkind.isnull and 
         compkindqu.indexlocal[0].find([sc_componentkind],bm1) then begin
    footprinted.empty_text:= 
                     compkindqu.currentbmasmsestring[k_footprintname,bm1];

    designationed.empty_text:= 
                     compkindqu.currentbmasmsestring[k_designation,bm1];
    parameter1ed.empty_text:= compkindqu.currentbmasmsestring[k_parameter1,bm1];
    parameter2ed.empty_text:= compkindqu.currentbmasmsestring[k_parameter2,bm1];
    parameter3ed.empty_text:= compkindqu.currentbmasmsestring[k_parameter3,bm1];
    parameter4ed.empty_text:= compkindqu.currentbmasmsestring[k_parameter4,bm1];
   end
   else begin
    footprinted.empty_text:= '';
    designationed.empty_text:= '';
    parameter1ed.empty_text:= '';
    parameter2ed.empty_text:= '';
    parameter3ed.empty_text:= '';
    parameter4ed.empty_text:= '';
   end;
  end;
 end;
end;

procedure tcomponenteditfo.macrohintev(const sender: TObject;
               var info: hintinfoty);
begin
 info.caption:= mainmo.expandcomponentmacros(
                         tmsestringfield(tdbstringedit(sender).datalink.field));
 include(info.flags,hfl_show); //show empty hint
end;

end.
