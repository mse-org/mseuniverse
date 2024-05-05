unit imageviewer;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msemenus,msegui,msegraphics,
 msegraphutils,mseevent,mseclasses,mseforms,msebitmap,mseimage,msedataedits,
 msedatanodes,mseedit,msefiledialog,msegrids,mselistbrowser,msestrings,msesys,
 msetypes,msesimplewidgets,msewidgets,msegraphedits;
type
 timageviewerfo = class(tmseform)
   imgPreview: timage;
   imageFileName: tfilenameedit;
   btnLoadImage: tbutton;
   imgWidth: tintegeredit;
   imgHeight: tintegeredit;
   btnThumbnail: tbutton;
   resizeProportioal: tbooleanedit;
   procedure doLoadImage(const sender: TObject);
   procedure doSaveImage(const sender: TObject);
   procedure doResizeImage(const sender: TObject);
   
   procedure doInit(const sender: TObject);
   procedure doFinish(const sender: TObject);
   procedure checkAlignment(img : timage);
   protected
   
   imgmb : tmaskedbitmap;
 end;
var
 imageviewerfo: timageviewerfo;
implementation
uses
 imageviewer_mfm, mseformatbmpicoread, mseformatjpgread, mseformatpngread, 
 mseformatpnmread, mseformattgaread, mseformatxpmread, msestream, strutils,
 msegraphicstream, mseformatjpgwrite, mseformatpngwrite;

procedure timageviewerfo.checkAlignment(img : timage);
begin
    with img do
    begin
		if (bounds_cx < imgWidth.value) or 
			(bounds_cy < imgHeight.value) then
			bitmap.alignment := bitmap.alignment + [al_fit]
		else
			bitmap.alignment := bitmap.alignment - [al_fit];
	end;
end;
 
procedure timageviewerfo.doLoadImage(const sender: TObject);
begin
	if imageFileName.value <> '' then
	begin
		//imgPreview.bitmap.loadfromfile(imageFileName.value);
        with imgPreview do
        begin
            imgmb.loadfromfile(imageFileName.value);
			bitmap.size := imgmb.size;
            imgmb.stretch(bitmap);
            imgWidth.value := bitmap.size.cx;
            imgHeight.value := bitmap.size.cy;
            checkAlignment(imgPreview);
		end;
	end;
end;

procedure timageviewerfo.doSaveImage(const sender: TObject);
var
	fn, fmt : string;
	stream: tmsefilestream;
begin
    fn := AnsiReplaceStr(imageFileName.value,'.', '-s.');
	stream:= tmsefilestream.create(fn,fm_create);
    if AnsiEndsStr(pnglabel,fn) then fmt := pnglabel
    else fmt := jpglabel;
	try
        writegraphic(stream, imgPreview.bitmap, fmt, []);
 	finally
 		stream.free;
	end;    
end;

procedure timageviewerfo.doResizeImage(const sender: TObject);
var
    isize : sizety; 
begin
    isize := imgPreview.bitmap.size;
    if sender = imgWidth then 
    begin
        if resizeProportioal.value then
        begin
            isize.cy := round((imgWidth.value / isize.cx) * imgHeight.value);
            imgHeight.value := isize.cy;
        end;
        isize.cx := imgWidth.value;
    end
    else if sender = imgHeight then 
    begin
        if resizeProportioal.value then 
        begin
            isize.cx := round((imgHeight.value / isize.cy) * imgWidth.value);
            imgWidth.value := isize.cx;
        end;
        isize.cy := imgHeight.value;
    end;
    imgPreview.bitmap.size := isize;
    imgmb.stretch(imgPreview.bitmap);
    checkAlignment(imgPreview);
    imgPreview.invalidate;
end;

procedure timageviewerfo.doInit(const sender: TObject);
begin
    imgmb := tmaskedbitmap.create(false);
end;

procedure timageviewerfo.doFinish(const sender: TObject);
begin
    imgmb.destroy;
end;

end.
