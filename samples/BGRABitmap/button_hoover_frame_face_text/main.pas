unit main;

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface

uses
  BGRABitmap,
  BGRABitmapTypes,
  bgracanvas2d,
  BGRATextFX,
  msegui,
  msegraphics,
  msegraphutils,
  mseforms,
  msesimplewidgets,
  msebitmap;

type
  tmainfo = class(tmainform)
    tbutton1: TButton;
    tfacelist1: tfacelist;
    timagelist1: timagelist;
    procedure drawface(const Sender: TObject; radius: integer);
    procedure drawframe(radius: integer);
    procedure oncreate(const Sender: TObject);
   end;

var
  mainfo: tmainfo;

implementation

uses
  main_mfm;

procedure tmainfo.drawframe(radius: integer);
var
  bitmapsize, x, x2: integer;
  aBGRABitmap_arc, aBGRABitmap_line : TBGRABitmap;
  ctxarc: TBGRACanvas2D;
  amaskedbitmap: Tmaskedbitmap;
begin

  bitmapsize         := radius;
  timagelist1.Clear;
  timagelist1.Count  := 0;
  timagelist1.Width  := bitmapsize;
  timagelist1.Height := bitmapsize;

  amaskedbitmap := Tmaskedbitmap.Create(bmk_rgb);

  aBGRABitmap_arc  := tBGRABitmap.Create(bitmapsize, bitmapsize, BGRAPixelTransparent);
  aBGRABitmap_line := tBGRABitmap.Create(bitmapsize, bitmapsize, BGRAPixelTransparent);
  
  for x := 0 to 1 do
  begin

    // rounded corners
    aBGRABitmap_arc.Fill(BGRAPixelTransparent);
    ctxarc           := aBGRABitmap_arc.Canvas2D;
    ctxarc.lineWidth := 1;

    if x = 0 then
      ctxarc.strokeStyle(cl_green)
    else
      ctxarc.strokeStyle($FF9000);

    ctxarc.beginPath();
    ctxarc.arc(bitmapsize, 0, bitmapsize, 0, Pi * 2, True);
    ctxarc.stroke();
    
    BGRAReplace(aBGRABitmap_arc, aBGRABitmap_arc.RotateCW);

    // sides
    aBGRABitmap_line.Fill(BGRAPixelTransparent);

    if x = 0 then
      aBGRABitmap_line.DrawLineAntiAlias(0, 0, 0, bitmapsize, cl_green, 1.0)
    else
      aBGRABitmap_line.DrawLineAntiAlias(0, 0, 0, bitmapsize, $FF9000, 1.0);

    // assign rounded corners and sides
    for x2 := 0 to 3 do
    begin
      if x2 > 0 then
        BGRAReplace(aBGRABitmap_arc, aBGRABitmap_arc.RotateCCW);
      amaskedbitmap.Assign(aBGRABitmap_arc.bitmap);
      timagelist1.addimage(amaskedbitmap);

      if x2 > 0 then
        BGRAReplace(aBGRABitmap_line, aBGRABitmap_line.RotateCCW);
      amaskedbitmap.Assign(aBGRABitmap_line.bitmap);
      timagelist1.addimage(amaskedbitmap);
    end;

  end;

  aBGRABitmap_line.Free;
  aBGRABitmap_arc.Free;
  amaskedbitmap.Free;
end;

procedure tmainfo.drawface(const Sender: TObject; radius: integer);
var
  x: integer;
  bmp : TBGRABitmap;
  txt: TBGRACustomBitmap;
  ctx: TBGRACanvas2D;
  gradient0, gradient1, gradient2: IBGRACanvasGradient2D;
begin
  bmp := TBGRABitmap.Create(TButton(Sender).Width, TButton(Sender).Height, BGRAPixelTransparent);
  ctx := bmp.Canvas2d;

  // Draw the outer rounded rectangle
  gradient0 := ctx.createLinearGradient(100, 30, 100, 120);
  gradient1 := ctx.createLinearGradient(100, 30, 100, 100);
  gradient2 := ctx.createLinearGradient(100, 30, 100, 120);
  
  txt := TextShadow(TButton(Sender).Width,TButton(Sender).height-10,'BGRA-Button',20,BGRABlack,$515151,5,5,5);

  for x := 0 to 2 do
  begin
  
    bmp.Fill(BGRAPixelTransparent);

    ctx.beginPath();

    if x = 0 then
    begin
      gradient0.addColorStop(0, '#F5F5F5');
      gradient0.addColorStop(1, '#7C878A');
      ctx.fillStyle(gradient0);
    end
    else if x = 1 then
    begin
      gradient1.addColorStop(0, '#F3FFE3');
      gradient1.addColorStop(1, '#7C878A');
      ctx.fillStyle(gradient1);
    end
    else if x = 2 then
    begin
      gradient2.addColorStop(0, '#FFDEB2');
      gradient2.addColorStop(1, '#FF9000');
      ctx.fillStyle(gradient2);
    end;

    if x = 2 then
      ctx.roundRect(6, 4, TButton(Sender).Width - 15, TButton(Sender).Height - 14, radius)
    else
      ctx.roundRect(4, 2, TButton(Sender).Width - 8, TButton(Sender).Height - 8, radius);

    ctx.save();
    ctx.shadowBlur    := 4;
    ctx.shadowColor('rgba(0,0,0, .8)');
    ctx.shadowOffsetX := 0;
    ctx.shadowOffsetY := 4;
    ctx.fill();
    ctx.restore();
    
     bmp.PutImage(0,0,txt,dmDrawWithTransparency);

    tfacelist1.list[x].image.Assign(bmp.bitmap);

  end;

  bmp.Free;
  txt.free;

end;

procedure tmainfo.oncreate(const Sender: TObject);
begin
  drawframe(20);
  drawface(tbutton1,20);
end;

end.

