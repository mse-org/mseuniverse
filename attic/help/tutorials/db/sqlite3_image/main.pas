unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedatabase,
 msesqlite3conn,sysutils,db,msebufdataset,msedb,msesqldb,msqldb,msedataedits,
 msedbedit,mseedit,msegrids,mselookupbuffer,msestrings,msetypes,msedbgraphics,
 msesplitter,msestatfile,msebitmap,msedatanodes,msefiledialog,mselistbrowser,
 msescrollbar,msesys,msedbdispwidgets,mseskin;

type
 tmainfo = class(tmainform)
   conn: tsqlite3connection;
   trans: tmsesqltransaction;
   query: tmsesqlquery;
   imagequery: tmsesqlquery;
   dataso: tmsedatasource;
   tdbwidgetgrid1: tdbwidgetgrid;
   thumb: tdbdataimage;
   tsplitter1: tsplitter;
   tstatfile1: tstatfile;
   tdbnavigator1: tdbnavigator;
   image: tdbdataimage;
   filedialog: tfiledialog;
   imagedataso: tmsedatasource;
   pklink: tfieldparamlink;
   writetrans: tmsesqltransaction;
   thumbf: tmsegraphicfield;
   tdbstringedit1: tdbstringedit;
   tdbstringdisp1: tdbstringdisp;
   procedure insertexe(DataSet: TDataSet);
   procedure asyncex(const sender: TObject; var atag: Integer);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,mseformatpngread,mseformatpngwrite,mseformatjpgread,mseformatjpgwrite;

const
 thumbsize: sizety = (cx:50;cy:50);
 
procedure tmainfo.insertexe(DataSet: TDataSet);
begin
 asyncevent;
end;

procedure tmainfo.asyncex(const sender: TObject; var atag: Integer);
var
 str1: string;
begin
 if filedialog.execute = mr_ok then begin
  pklink.delayoff;         //switch off lookup delay
  try
   try
    query.controller.options:= query.controller.options - [dso_autocommit];
                           //we need a single transaction
    query.post;            //create pk
    str1:= image.loadfromfile(filedialog.controller.filename);
                           //sets imagequery to edit mode    
    imagequery.post;       //store big image
    thumb.bitmap.size:= fitsize(image.bitmap.size,thumbsize);
                           //thumbnail image has the same aspect ration
    image.bitmap.stretch(thumb.bitmap);
    thumb.storeimage('png',[]);
                           //sets query to edit mode
    query.fieldbyname('format').asstring:= str1;
    query.post;            //store thumb
    writetrans.commit;     //commit transaction
   except
    writetrans.rollback;   //revert settings in case of an error
    raise;
   end;
  finally
   pklink.delayon;         //restore options
   query.controller.options:= query.controller.options + [dso_autocommit];
                           
  end;
 end
 else begin
  query.cancel;
 end;
end;

//
// wit intermediate bitmap
//
{
procedure tmainfo.asyncex(const sender: TObject; var atag: Integer);
const
 thumbsize: sizety = (cx:50;cy:50);
var
 bmp: tmaskedbitmap;
begin
 if filedialog.execute = mr_ok then begin
  bmp:= tmaskedbitmap.create(false);
  pklink.delayoff;         //switch off lookup delay
  try
   try
    query.controller.options:= query.controller.options - [dso_autocommit];
                           //we need a single transaction
    query.post;            //create pk
    image.loadfromfile(filedialog.controller.filename);
                           //sets imagequery to edit mode    
    imagequery.post;       //store big image
    bmp.size:= fitsize(image.bitmap.size,thumbsize);
                           //thumbnail image has the same aspect ration
    image.bitmap.stretch(bmp);
    query.edit;
    thumbf.storebitmap(bmp,'png');
    query.post;            //store thumb
    writetrans.commit;     //commit transaction
   except
    writetrans.rollback;   //revert settings in case of an error
    raise;
   end;
  finally
   bmp.free;
   pklink.delayon;
   query.controller.options:= query.controller.options + [dso_autocommit];
                           //restore options
  end;
 end
 else begin
  query.cancel;
 end;
end;
}
end.
