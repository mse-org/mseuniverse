MSEspice, GUI for Ngspice
Version 1.0a 2013-09-29

- Download and install ngspice from
http://sourceforge.net/projects/ngspice/

Note: The Windows standard download is the GUI-version of ngspice.
There will be a a ngspice error message window with the GUI version
at every simulation run. The console version of ngspice for Windows
does not suffer from that problem. Currently there is no compiled
console version available.

- Download msespice_i386_linux_1_0a.tar.gz on Linux or
msespice_i386_win32_1_0a.zip on Windows from
http://sourceforge.net/projects/mseuniverse/

- Extract them into a directory of your choice (MYDIRECTORY).
- On Linux cd in MYDIRECTORY/msespice_i386_linux, start msespice,
on Windows cd in MYDIRECTORY\msespice_i386_win32, start msespice.exe.

- 'File'-'Open Project', select 'examples/rclowpass.msp'.
- Pess F9.

If the ngspice program is not in path select it in 
'Options'-'Global'-'Ngspice Program'.

MSEide+MSEgui development environment is here:
http://sourceforge.net/projects/mseide-msegui/
MSEspice 1.0 needs MSEide+MSEgui git master branch from here:
http://gitorious.org/mseide-msegui

Have a lot of fun!

Martin