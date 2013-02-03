unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msebitmap,msedataedits,
 msedatanodes,mseedit,msefiledialog,msegrids,mseifiglob,mselistbrowser,
 msestrings,msesys,msetypes,msesplitter,msestatfile;

type
 tmainfo = class(tmainform)
   tfilenameedit1: tfilenameedit;
   listview: tlistview;
   tspacer1: tspacer;
   imagelist: timagelist;
   tstatfile1: tstatfile;
   procedure setvalueexe(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,msefileutils,msegraphicstream,
 mseformatbmpicoread,mseformatjpgread,mseformatpngread,mseformatpnmread,
 mseformattgaread,mseformattiffread,mseformatxpmread;
 
procedure tmainfo.setvalueexe(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
var
 flist1: tfiledatalist;
 int1: integer;
 bmp1: tmaskedbitmap;
begin
 flist1:= tfiledatalist.create;
 bmp1:= tmaskedbitmap.create(false);
 application.beginwait;
 try
  flist1.adddirectory(avalue,fil_name,graphicfilemasks);
  listview.clear;
  listview.itemlist.count:= flist1.count;  
  imagelist.clear;
  imagelist.count:= flist1.count;
  for int1:= 0 to imagelist.count - 1 do begin
   bmp1.loadfromfile(avalue+flist1[int1].name);
   imagelist.setimage(int1,bmp1,true);
   listview[int1].imagenr:= int1;
  end;
 finally
  application.endwait;
  flist1.free;
  bmp1.free;
 end;
end;

end.
