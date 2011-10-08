//Created by Sri Wahono
//Modified from bmp2pas console mode (written by Martin Schreiber)
//This tool is to convert bitmap file(s) to pascal code
//The especially function of this tool is to create icon of tmsecomponent

unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msesplitter,msesimplewidgets,
 msewidgets,msebitmap,msedataedits,msedatanodes,mseedit,msefiledialog,msegrids,
 mselistbrowser,msestrings,msesys,msetypes,msewidgetgrid,mseformdatatools,
 msefileutils,SysUtils,msegraphicstream;

type
 tmainfo = class(tmseform)
   tlayouter8: tlayouter;
   btncancel: tbutton;
   btnconvert: tbutton;
   unitfilename: tfilenameedit;
   twidgetgrid1: twidgetgrid;
   bitmapfiles: tfilenameedit;
   compsname: tstringedit;
   tbitmapcomp1: tbitmapcomp;
   btnsave: tbutton;
   tfiledialog1: tfiledialog;
   btnload: tbutton;
   procedure btnconvert_onexecute(const sender: TObject);
   procedure btnsave_onexecute(const sender: TObject);
   procedure btnload_onexecute(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,mseformatbmpicoread;
procedure tmainfo.btnconvert_onexecute(const sender: TObject);
var
 ar1,ar2: msestringarty;
 int1: integer;
 bmps: array of tbitmapcomp;
 str1,str2: msestring;
begin
 try
  ar1:= bitmapfiles.gridvalues;
  ar2:= compsname.gridvalues;
  setlength(bmps,length(ar1));
  try
   for int1:= 0 to high(ar1) do begin
    if ar1[int1] <> '' then begin
     bmps[int1]:= tbitmapcomp.create(nil);
     bmps[int1].name:= ar2[int1];
     bmps[int1].bitmap.loadfromfile(ar1[int1]);
    end;
   end;
   str1:= removefileext(filename(unitfilename.value));
   str2:= unitfilename.value;
   componentstoobjsource(componentarty(bmps),str2,'msebitmap',str1);
   showmessage('Converting success!');
  finally
   for int1:= 0 to high(bmps) do begin
    bmps[int1].Free;
   end;
  end;
 except
  on e: exception do begin
   showmessage(e.message);
  end;
 end;
end;

procedure tmainfo.btnsave_onexecute(const sender: TObject);
var
 writer1: tstatwriter;
 ffilename: filenamety;
begin
 with tfiledialog1 do begin
  dialogkind:= fdk_save;
  if not (execute=mr_ok) then exit;
  ffilename:= controller.filename;
 end;
 try
  writer1:= nil;
  writer1:= tstatwriter.create(ffilename);
  with writer1 do begin
   writesection('componentsbitmapfile');
   writearray('bitmapfiles',bitmapfiles.gridvalues);
   writearray('componentnames',compsname.gridvalues);
   writesection('unitfilename');
   writemsestring('unitfilename',unitfilename.value);
  end;
 finally
  writer1.free;
 end;
end;

procedure tmainfo.btnload_onexecute(const sender: TObject);
var
 reader1: tstatreader;
 ffilename: filenamety;
 fbmpfiles, fcompnames: msestringarty;
 funitnames: msestring;
begin
 with tfiledialog1 do begin
  dialogkind:= fdk_open;
  if not (execute=mr_ok) then exit;
  ffilename:= controller.filename;
 end;
 try
  reader1:= nil;
  reader1:= tstatreader.create(ffilename);
  fbmpfiles:= nil;
  fcompnames:= nil;
  with reader1 do begin
   setsection('componentsbitmapfile');
   fbmpfiles:= readarray('bitmapfiles',fbmpfiles);
   bitmapfiles.gridvalues:= fbmpfiles;
   fcompnames:= readarray('componentnames',fcompnames);
   compsname.gridvalues:= fcompnames;
   setsection('unitfilename');
   funitnames:= '';
   funitnames:= readmsestring('unitfilename',funitnames);
   unitfilename.value:= funitnames;
  end;
 finally
  reader1.free;
 end;
end;

end.
