unit main;

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface

uses
  BGRABitmap,
  BGRABitmapTypes,
  BGRACanvas2d,
  BGRATextFX,
  msegui,
  mseforms,
  msesimplewidgets;

type
  tmainfo = class(tmainform)
    tbutton1: TButton;
    tfacelist1: tfacelist;
    procedure drawface(const Sender: TObject; radius: integer);
    procedure oncreate(const Sender: TObject);
   end;

var
  mainfo: tmainfo;

implementation

uses
  main_mfm;

procedure tmainfo.drawface(const Sender: TObject; radius : integer);
var
  x: integer;
  bmp : TBGRABitmap;
  txt: TBGRACustomBitmap;
  ctx: TBGRACanvas2D;
  gradient0, gradient1, gradient2: IBGRACanvasGradient2D;
begin
  bmp := TBGRABitmap.Create(TButton(Sender).Width, TButton(Sender).Height, BGRAPixelTransparent);
  ctx := bmp.Canvas2d;
  txt := TextShadow(TButton(Sender).Width,TButton(Sender).height-10,'BGRA-Button',20,BGRABlack,$515151,5,5,5);

  gradient0 := ctx.createLinearGradient(100, 30, 100, 120);
  gradient1 := ctx.createLinearGradient(100, 30, 100, 100);
  gradient2 := ctx.createLinearGradient(100, 30, 100, 120);
  
  // Draw the outer rounded rectangle
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
      ctx.roundRect(6, 4, TButton(Sender).Width - 14, TButton(Sender).Height - 14, radius)
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
  drawface(tbutton1, 20);
end;

end.

