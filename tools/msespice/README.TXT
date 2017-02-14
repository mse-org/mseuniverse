MSEspice, GUI for Ngspice
Version 2.0.8 2017-02-14

- Download and install ngspice from
http://sourceforge.net/projects/ngspice/

Note: The Windows standard download is the GUI-version of ngspice.
With the GUI-version there is a ngspice message window 
at every simulation run which must be closed by pressing Enter.
The console version of ngspice for Windows does not suffer from that problem.
Currently there is no compiled console version available.

- Download msespice_* for your system from
  http://sourceforge.net/projects/mseuniverse/
- Extract the archive into a directory of your choice (MYDIRECTORY).
- On Linux cd in MYDIRECTORY/msespice_*, start msespice,
  on Windows cd in MYDIRECTORY\msespice_*, start msespice.exe.

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
https://gitlab.com/groups/mseide-msegui repository mseide-msegui

First step is to install Free Pascal and MSEide+MSEgui 

1. Download and install FPC 2.6.4 or FPC 3.0, you can get it from 
   http://www.freepascal.org/download.var
2. Download mseide_msegui_src_4_0.zip and the mseide_* archive for your system.
   http://sourceforge.net/projects/mseide-msegui/files/mseide-msegui/4.0/
3. Extract them to a directory of your choice ('yourdirectory') .
4. Run 'yourdirectory/bin/mseide' on linux or 
   'yourdirectory\bin\mseide.exe' on windows.
5. In 'Settings'-'Configure MSEide'-'${MSEDIR}' select 'yourdirectory/msegui'.
6. In 'Project'-'Open' select 'yourdirectory/msegui/apps/demo/demo.prj'.
7. 'Target'-'Continue'.

If that works get the MSEspice sources from here:
https://gitlab.com/groups/mseuniverse repository mseuniverse, tools/msespice.

In MSEide 'Project'-'Open', select tools/msespice/msespice.prj, press F9.
The project will be compiled and started in debugger.

Command line parameters:
--macrodef=<name>,<value>{,<name>,<value>}
 Example:
 --macrodef=MAC1,abc,MAC2,def
 defines ${MAC1} with value 'abc' and ${MAC2} with value 'def'.
--fontalias=<alias>,<fontname>[,<fontheight>[,<fontwidth>[,<options>[,<xscale>]
                              [,<ancestor>]]]]
 Change the used fonts. <alias> can be stf_default, stf_menu or mseide_source.

Predefined macros:
${PROJECNAME}
${NETLIST}

Macro functions:
${MAC_IFDEF(macroname)} returns the macro value if defined.
${MAC_IFDEF(macroname,notdefinedvalue)} returns the macro value if defined,
 notdefinedvalue otherwise.
${MAC_IFDEF(macroname,notdefinedvalue,definedvalue)}
 returns definedvalue if macroname is defined, notdefinedvalue otherwise.

Environment macros:
${ENV_VAR(variablename)} returns the macro value if defined.
${ENV_VAR(variablename,notdefinedvalue)} returns the variable value if defined,
 notdefinedvalue otherwise.
${ENV_VAR(variablename,notdefinedvalue,definedvalue)}
 returns definedvalue if variablename is defined, notdefinedvalue otherwise.

File path macros, format is ${FILE_*(fileparameter)} or ${FILE_*("fileparameter")}:
FILE_MSE       convert to MSE format.
FILE_SYS       convert to sys format.
FILE_PATH      absolute path.
FILE_FILE      no trailing path delimiter.
FILE_DIR       trailing path delimiter.
FILE_NAME      no directory part.
FILE_NAMEBASE  no directory and no name extension part.
FILE_EXT       file name extension.
FILE_NONAME    directory part only.
FILE_NOEXT     no file name extension.

Have a lot of fun!

Martin
