Main concept of porting MSEgui to Windows, Linux, Mac OS, Andrid and iOS :
- Use SDL 2 for windowing, input event, thread management, networking, audio, and I/O management for all OS
- Use OpenGL context only for drawing from SDL2.0 (http://wiki.libsdl.org/moin.cgi/CategoryVideo)
- 2 options for 2D drawing engine, use cairo or mseopenglgdi.pas
- Use cairo for drawing engine, put pixels from cairo surface to opengl texture.
  http://bazaar.launchpad.net/~macslow/gl-cairo-simple/trunk/files and
  http://cairographics.org/OpenGL/

  

* place lib/common/kernel/sdl to your MSEgui lib folder
* open testsdl project

Note: tested in Windows only (I've compile SDL.dll for Windows in folder "testsdl",
to test in Linux, you should compile SDL 2.0 from source