MSEspice, GUI for Ngspice
Version 1.4 2014-08-15

- Download and install ngspice from
http://sourceforge.net/projects/ngspice/

Note: The Windows standard download is the GUI-version of ngspice.
With the GUI-version there is a ngspice message window 
at every simulation run which must be closed by pressing Enter.
The console version of ngspice for Windows does not suffer from that problem.
Currently there is no compiled console version available.

- Download msespice_i386_linux_1_4.tar.gz or msespice_x86_64_linux_1_4.tar.gz
on Linux or
msespice_i386_win32_1_4.zip on Windows from
http://sourceforge.net/projects/mseuniverse/

- Extract them into a directory of your choice (MYDIRECTORY).
- On Linux cd in MYDIRECTORY/msespice_i386_linux or 
  MYDIRECTORY/msespice_x86_64_linux, start msespice,
  on Windows cd in MYDIRECTORY\msespice_i386_win32, start msespice.exe.

- 'File'-'Open Project', select 'examples/rclowpass.msp'.
- Pess F9.

If the ngspice program is not in path select it in 
'Options'-'Global'-'Ngspice Program'.

How to compile MSEspice
-----------------------
MSEspice is made with MSEide+MSEgui cross platform development environment
for Free Pascal:
http://sourceforge.net/projects/mseide-msegui/
Source is here:
https://gitorious.org/mseide-msegui repository mseide-msegui

First step is to install Free Pascal and MSEide+MSEgui 

1. Download and install FPC 2.6.4, you can get it from 
   http://www.freepascal.org/download.var
2. Download mseide_msegui_src_3_4.zip and mseide_i386_win32_3_4.zip or
   mseide_i386_linux_3_4.tar.gz or mseide_x84_64_linux_3_4.tar.gz
   http://sourceforge.net/projects/mseide-msegui/files/mseide-msegui/3.0/
3. Extract them to a directory of your choice ('yourdirectory') .
4. Run 'yourdirectory/bin/mseide' on linux or 
   'yourdirectory\bin\mseide.exe' on windows.
5. In 'Settings'-'Configure MSEide'-'${MSEDIR}' select 'yourdirectory/msegui'.
6. In 'Project'-'Open' select 'yourdirectory/msegui/apps/demo/demo.prj'.
7. 'Target'-'Continue'.

If that works get the MSEspice sources from here:
https://gitorious.org/mseuniverse repository mseuniverse, tools/msespice.

In MSEide 'Project'-'Open', select tools/msespice/msespice.prj, press F9.
The project will be compiled and started in debugger.

Have a lot of fun!

Martin