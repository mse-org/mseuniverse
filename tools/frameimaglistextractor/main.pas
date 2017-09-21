unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msesplitter,
 msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,msestatfile,
 msestream,msestrings,sysutils,msesimplewidgets,mseimage,msebitmap,msedatanodes,
 msefiledialog,msegrids,mselistbrowser,msesys,msegraphicstream,mseformatpngread,
 mseformatjpgread, mseformatxpmread,mseformatbmpicoread,mseformatpnmread,
 mseformattgaread,mseformatpngwrite;

type
 tmainfo = class(tmainform)
   tspacer1: tspacer;
   heighted: trealspinedit;
   widthed: trealspinedit;
   b_add: trichbutton;
   tspacer29: tspacer;
   sourceimage: timage;
   timage3: timage;
   timage4: timage;
   timage5: timage;
   timage6: timage;
   timage7: timage;
   timage8: timage;
   timage9: timage;
   timage10: timage;
   trichbutton2: trichbutton;
   tbutton1: tbutton;
   fdopen: tfiledialog;
   mainstat: tstatfile;
   fdsave: tfiledialog;
   background: tbitmapcomp;
   procedure on_loadimage(const sender: TObject);
   procedure on_set_width_frameimage(const sender: TObject);
   procedure on_close_form(const sender: TObject);
   procedure on_save(const sender: TObject);
  protected
   function inputname: filenamety;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,msefileutils,mseformatstr;

function tmainfo.inputname: filenamety;
begin
 result:= filenamebase(fdopen.controller.filename);
end;

procedure tmainfo.on_loadimage(const sender: TObject);
begin
  if fdopen.controller.execute = mr_ok then
   BEGIN 
   try
   sourceimage.bitmap.loadfromfile(fdopen.controller.filename);
   tspacer1.enabled := true;
   on_set_width_frameimage(sender);
   caption:= 'MSEframeimage ('+inputname()+')';
   except
     showmessage('Error while loading !');
   end;
   END;
end;

procedure tmainfo.on_set_width_frameimage(const sender: TObject);
var btmp : tmaskedbitmap;
    r : rectty;
    p : pointty;
    
   procedure _load(_image : timage);
   begin
     _image.bitmap.options:= sourceimage.bitmap.options; 
                                         //copy original mask options
     btmp.Canvas.copyarea(sourceimage.bitmap.Canvas, r, p);
     if btmp.masked then begin
      btmp.mask.Canvas.copyarea(sourceimage.bitmap.mask.Canvas, r, p);
     end;
     _image.bitmap := btmp;
   end;
    
begin       
  if not sourceimage.bitmap.hasimage then begin
   exit;
  end;
  
  btmp := tmaskedbitmap.create(bmk_rgb);
  btmp.options:= sourceimage.bitmap.options; //copy original mask options
  
  btmp.size  := makesize(widthed.asinteger,heighted.asinteger);
  
  p.x := 0;
  p.y := 0;
  
  r.cx := btmp.Width;
  r.cy := btmp.height;

  //left-top
  r.x := 0;
  r.y := 0;
  _load(timage3);

  //left
  r.x := 0;
  r.y := round((sourceimage.bitmap.height - btmp.height) div 2);
  _load(timage6);

  //left-bottom
  r.x := 0;
  r.y := sourceimage.bitmap.height - btmp.height;
  _load(timage8);

  //bottom
  r.x := round((sourceimage.bitmap.width - btmp.Width) div 2);
  r.y := sourceimage.bitmap.height - btmp.height;
  _load(timage9);

  //right - bottom
  r.x := sourceimage.bitmap.width - btmp.Width;
  r.y := sourceimage.bitmap.height - btmp.height;
  _load(timage10);

  //right
  r.x := sourceimage.bitmap.width - btmp.Width;
  r.y := round((sourceimage.bitmap.height - btmp.height) div 2);;
  _load(timage7);

  //right-top
  r.x := sourceimage.bitmap.width - btmp.Width;
  r.y := 0;
  _load(timage5);

  //top
  r.x := round((sourceimage.bitmap.width - btmp.Width) div 2);
  r.y := 0;
  _load(timage4);
    
  btmp.free;
end;

procedure tmainfo.on_close_form(const sender: TObject);
begin
  close;
end;

procedure tmainfo.on_save(const sender: TObject);
var btmp : tmaskedbitmap;
    r : rectty;
    p : pointty;
    w,
    h : integer;

   procedure _load(_image : timage);
   begin
     btmp.Canvas.copyarea(_image.bitmap.Canvas, r, p);
     if btmp.masked then begin
      btmp.mask.Canvas.copyarea(_image.bitmap.mask.Canvas, r, p);
     end;
   end;

begin
 btmp := tmaskedbitmap.create(bmk_rgb);
 try
  w := timage3.bitmap.width;
  h := timage3.bitmap.height;

  btmp.options:= sourceimage.bitmap.options; //copy original mask options
  btmp.size  := makesize(w * 4,h * 2);

  //const
  r.x := 0;
  r.y := 0;
  r.cx := w;
  r.cy := w;

  
  p.x := 0;
  p.y := 0;
  _load(timage3);

  //left
  p.x := w;
  p.y := 0;
  _load(timage6);

  //left-bottom
  p.x := w * 2;
  p.y := 0;
  _load(timage8);

  //bottom
  p.x := w * 3;
  p.y := 0;
  _load(timage9);

  //right - bottom
  p.x := 0;
  p.y := h;
  _load(timage10);

  //right
  p.x := w;
  p.y := h;
  _load(timage7);

  //right-top
  p.x := w * 2;
  p.y := h;
  _load(timage5);

  //top
  p.x := w * 3;
  p.y := h;
  _load(timage4);
  fdsave.controller.filename:= inputname+'_'+
                                    inttostrmse(w) + 'x' + inttostrmse(h) + '.png';
  if fdsave.execute() = mr_ok then begin
   btmp.writetofile(fdsave.controller.filename,'png',[]);
  end;
 finally
  btmp.free;
 end;
end;

end.
