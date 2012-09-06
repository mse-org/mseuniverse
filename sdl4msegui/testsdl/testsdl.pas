program testsdl;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ifdef FPC}
 {$ifdef mswindows}{$apptype gui}{$endif}
{$endif}
uses
 {.$define testlib} //test SDL lib
 {$define testgui} //test MSEgui
 
 {$ifdef FPC}{$ifdef unix}cthreads,{$endif}{$endif}
 {$ifdef testgui}msegui,mseforms,main{,form2},{$endif}msesysutils,sdl4msegui,msetypes,sysutils,
 mseformatstr;

{$ifndef testgui}
var
  win1,win2 : winidty;
  renderer1, renderer2 : SDL_Renderer;
  bitmaptex1, bitmaptex2, tmptext : SDL_Texture;
  bitmapSurface1,bitmapSurface2, tmpsurf : PSDL_Surface;
  e: SDL_Event;
  r,g,b: byte;
  rect1,rect2: SDL_Rect;
  str1: string;
  int1,int2: integer;
  pixels: ptruint;
  pinfo: SDL_RendererInfo;
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
 SDL_SetRenderDrawColor(renderer1,r,g,b,0);
end;
{$endif}

begin
 {$ifdef testgui}
 application.createform(tmainfo,mainfo);
 //application.createform(tform2fo,form2fo);
 application.run;
 {$else}
 SDL_Init(SDL_INIT_VIDEO);
 int1:= SDL_GetNumRenderDrivers;
 for int2:= 0 to int1 do begin
  if SDL_GetRenderDriverInfo(int2,@pinfo)=0 then begin
   debugwriteln(pinfo.name+' w = '+inttostr(pinfo.max_texture_width)+' h = '+inttostr(pinfo.max_texture_width));
  end;
 end;

 win1 := SDL_CreateWindow('Test SDL2 library', posX, posY, width, height, SDL_WINDOW_RESIZABLE);
 SDL_CheckError('create win 1');
 //win2 := SDL_CreateWindow('Test Window 2', posX, posY, width, height, [SDL_WINDOW_SHOWN,SDL_WINDOW_RESIZABLE{,SDL_WINDOW_MAXIMIZED}]);
 //SDL_CheckError('create win 2');
 renderer1 := SDL_CreateRenderer(win1, -1, SDL_RENDERER_ACCELERATED);
 SDL_CheckError('create renderer');
 if SDL_GetRendererInfo(renderer1,@pinfo)=0 then begin
  debugwriteln(pinfo.name+' w = '+inttostr(pinfo.max_texture_width)+' h = '+inttostr(pinfo.max_texture_width));
 end;

 bitmapSurface1 := SDL_LoadBMPFromFile('b.bmp');
 bitmapSurface2 := SDL_LoadBMPFromFile('a.bmp');
 renderer2 := SDL_CreateSoftwareRenderer(bitmapsurface2);
 SDL_SetRenderDrawColor(renderer2,255,255,255,0);
 SDL_SetTextureColorMod(renderer2,0,0,255);
 SDL_RenderDrawLine(renderer2,0,0,100,10);

 bitmaptex2 := SDL_CreateTextureFromSurface(renderer2, bitmapSurface2);
 bitmaptex1 := SDL_CreateTextureFromSurface(renderer1, bitmapSurface1);
 SDL_FreeSurface(bitmapSurface1);
 r:=0;
 g:=100;
 b:=100;
 rect1.x:= 10;
 rect1.y:= 10;
 rect1.w:= 100;
 rect1.h:= 75;

 rect2.x:= 200;
 rect2.y:= 10;
 rect2.w:= 100;
 rect2.h:= 75;

 SDL_SetRenderDrawColor(renderer1,255,255,255,0);
 SDL_RenderClear(renderer1);
 SDL_RenderFillRect(renderer1,@rect1);
 SDL_SetTextureColorMod(renderer1,0,0,255);
 SDL_RenderDrawLine(renderer1,0,0,100,100);
 SDL_RenderCopy(renderer1, bitmaptex1, nil, @rect1);
 SDL_RenderCopy(renderer1, bitmaptex1, nil, @rect2);
 while true do begin
  if (SDL_PollEvent(@e)>0) then begin
   case e.type_ of
    SDL_QUITEV:  begin     
     break;
    end;
    SDL_WINDOWEVENT :begin
     if (e.window.event = SDL_WINDOWEVENT_RESIZED) then begin
      SDL_GetWindowSurface(win1);
      SDL_CheckError('resized');
     end else if (e.window.event = SDL_WINDOWEVENT_CLOSE) then begin
      if e.window.window=win1 then begin
       debugwriteln('Close');
      end;
     end;
    end;
    SDL_KEYDOWN :begin
     if e.keydown.keysym.sym= $61 then begin
      debugwriteln('benar')
     end;
     debugwriteln('press key : keycode = '+
       inttostr(SDL_GetKeyFromScancode(e.keydown.keysym.scancode))+ //keycode
       ' keyname = '+SDL_GetKeyName(e.keydown.keysym.sym)+
       ' KEYCODE 2 = '+wordtohex(e.keydown.keysym.sym,false));
     if e.keydown.keysym.mods=KMOD_SHIFT then begin
      debugwriteln('Has mod SHIFT');
     end;
    end;
    SDL_KEYUP :begin
     debugwriteln('release key : keycode = '+
       inttostr(SDL_GetKeyFromScancode(e.keydown.keysym.scancode))+ //keycode
       ' keyname = '+SDL_GetKeyName(e.keydown.keysym.sym)+
       ' KEYCODE 2 = '+inttostr(e.keydown.keysym.sym));
     if (e.keydown.keysym.mods and KMOD_SHIFT)<>0 then begin
      debugwriteln('Has mod SHIFT');
     end;
     if (e.keydown.keysym.mods and KMOD_ALT)<>0 then begin
      debugwriteln('Has mod ALT');
     end;
     if (e.keydown.keysym.mods and KMOD_CTRL)<>0 then begin
      debugwriteln('Has mod CTRL');
     end;
    end;
    SDL_TEXTINPUT :begin
     debugwriteln(e.text.text);
     if e.text.text='d' then begin
      SDL_RenderClear(renderer1);
      rect2.x:= rect2.x+1;
      SDL_RenderCopy(renderer1, bitmaptex1, nil, @rect2);
     end else if e.text.text='a' then begin
      SDL_RenderClear(renderer1);
      rect2.x:= rect2.x-1;
      SDL_RenderCopy(renderer1, bitmaptex1, nil, @rect2);
     end else if e.text.text='w' then begin
      SDL_RenderClear(renderer1);
      rect2.y:= rect2.y-1;
      SDL_RenderCopy(renderer1, bitmaptex1, nil, @rect2);
     end else if e.text.text='s' then begin
      SDL_RenderClear(renderer1);
      rect2.y:= rect2.y+1;
      SDL_RenderCopy(renderer1, bitmaptex1, nil, @rect2);
     end else if e.text.text='c' then begin
      tmpsurf:= SDL_CreateRGBSurface(0,100,75,32,0,0,0,0);
      if SDL_UpperBlit(bitmapsurface2,nil, tmpsurf, nil)=0 then begin
       tmptext:= SDL_CreateTextureFromSurface(renderer1,tmpsurf);
       SDL_RenderCopy(renderer1, tmptext, nil, @rect2);
      end;
     end;
    end;
    SDL_MOUSEMOTION: begin
     changecolor;
     SDL_RenderDrawPoint(renderer1,e.motion.x,e.motion.y);
     //debugwriteln('mouse move :'+inttostr(e.motion.x)+' - '+inttostr(e.motion.y));
    end;
   end;
  end;
  SDL_RenderPresent(renderer1);
 end;

 SDL_DestroyTexture(bitmaptex1);
 SDL_DestroyRenderer(renderer1);
 SDL_DestroyWindow(win1); 
 SDL_DestroyWindow(win2); 
{$endif}
end.
