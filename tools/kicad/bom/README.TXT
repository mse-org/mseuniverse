MSEkicadBOM Copyright (c) 2016-2017 by Martin Schreiber
***********
Version 0.8.2

MSEkicadBOM is a component database and document/production files generator
for KiCad based on MSEide+MSEgui. Database is Firebird 3.0, license is GPL.
Wiki:
https://gitlab.com/mseide-msegui/mseuniverse/wikis/msekicadbom/MSEkicadBOM

Predefined macros:

Project macros
**************
prjectname

Component macros
****************
value
value1
value2
footprint
footprintident
footprintlibrary
footprintdescription
manufacturer
description
parameter1
parameter2
parameter3
parameter4

Component-kind macros
*********************
k_footprint
k_footprintident
k_footprintlibrary
k_footprintdescription
k_manufacturer
k_description
k_parameter1
k_parameter2
k_parameter3
k_parameter4

Macro functions
***************
${MAC_IFDEF(macroname)} returns the macro value if defined.
${MAC_IFDEF(macroname,notdefinedvalue)} returns the macro value if defined,
 notdefinedvalue otherwise.
${MAC_IFDEF(macroname,notdefinedvalue,definedvalue)}
 returns definedvalue if macroname is defined, notdefinedvalue otherwise.

Environment macros
******************
${ENV_VAR(variablename)} returns the variable value if defined.
${ENV_VAR(variablename,notdefinedvalue)} returns the variable value if defined,
 notdefinedvalue otherwise.
${ENV_VAR(variablename,notdefinedvalue,definedvalue)}
 returns definedvalue if variablename is defined, notdefinedvalue otherwise.

String macros
*************
Macro format is ${STR_*(text)}.
STR_TRIM
 Trim whitespace from the ends of text.
STR_TRIMLEFT
 Trim whitespace from the beginning of text.
STR_TRIMRIGHT
 Trim whitespace from the end of text.

STR_COALESCE
 Return first not empty value. Format is
 ${STR_COALESCE(text[,text...])} or
 ${STR_COALESCE("text"[,"text"...])}

File macros
***********
Macro format is ${FILE_*(fileparameter)} or ${FILE_*("fileparameter")}.
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
