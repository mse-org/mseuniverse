program testsdl;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype gui}{$endif}
{$endif}
uses
 {$define testlib} //test SDL lib
 {.$define testgui} //test MSEgui
 
 {$ifdef FPC}{$ifdef unix}cthreads,{$endif}{$endif}
 {$ifdef testgui}msegui,mseforms,main,form2,{$endif}msesysutils,sdl4msegui,msetypes,sysutils;

{$ifndef testgui}
var
  win : winidty;
  renderer : SDL_Renderer;
  bitmapTex : SDL_Texture;
  bitmapSurface : PSDL_Surface;
  e: SDL_Event;
  r,g,b: byte;
  rect1: SDL_Rect;
const
  posX = 100;
  posY = 100;
  width = 800;
  height = 600;

procedure changecolor;
begin
 if r<255 then begin
  inc(r);
  if r=255 then begin
   r:= 0;
   if g<255 then begin
    inc(g);
    if g=255 then begin
     g:= 0;
     if b<255 then begin
      inc(b);
      if b=255 then b:= 0;
     end;
    end;
   end;
  end;
 end;
 SDL_SetRenderDrawColor(renderer,r,g,b,0);
end;
{$endif}

begin
 {$ifdef testgui}
 application.createform(tmainfo,mainfo);
 application.createform(tform2fo,form2fo);
 application.run;
 {$else}
 win := SDL_CreateWindow('Test SDL2 library', posX, posY, width, height, [SDL_WINDOW_SHOWN,SDL_WINDOW_RESIZABLE{,SDL_WINDOW_MAXIMIZED}]);

 renderer := SDL_CreateRenderer(win, -1, SDL_RENDERER_ACCELERATED);

 //bitmapSurface := SDL_LoadBMP('c:/a.bmp');
 //bitmapTex := SDL_CreateTextureFromSurface(renderer, bitmapSurface);
 //SDL_FreeSurface(bitmapSurface);
 r:=0;
 g:=100;
 b:=100;
 rect1.x:= 10;
 rect1.y:= 10;
 rect1.w:= 100;
 rect1.h:= 200;
 SDL_SetRenderDrawColor(renderer,255,255,255,0);
 SDL_RenderClear(renderer);
 while true do begin
  if (SDL_PollEvent(@e)>0) then begin
   case e.type_ of
    SDL_QUITEV:  begin     
     break;
    end;
    SDL_WINDOWEVENT :begin
     if (e.window.event = SDL_WINDOWEVENT_MAXIMIZED) then begin
      debugwriteln('maximized');
     end else if (e.window.event = SDL_WINDOWEVENT_CLOSE) then begin
      debugwriteln('Close');
     end;
    end;
    SDL_KEYDOWN :begin
     //debugwriteln('press key : '+e.key.keysym);
    end;
    SDL_TEXTINPUT :begin
     debugwriteln(e.text.text);
    end;
    SDL_MOUSEMOTION: begin
     changecolor;
     SDL_RenderDrawPoint(renderer,e.motion.x,e.motion.y);
     debugwriteln('mouse move :'+inttostr(e.motion.x)+' - '+inttostr(e.motion.y));
    end;
   end;
  end;
  SDL_RenderFillRect(renderer,@rect1);
  //SDL_SetTextureColorMod(renderer,0,0,255);
  //SDL_RenderDrawLine(renderer,0,0,100,100);
  //SDL_RenderCopy(renderer, bitmapTex, nil, nil);
 SDL_RenderPresent(renderer);
 end;

 //SDL_DestroyTexture(bitmapTex);
 SDL_DestroyRenderer(renderer);
 SDL_DestroyWindow(win); 
{$endif}
end.
