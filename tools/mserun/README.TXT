 MSErun Copyright (c) 2015-2017 by Martin Schreiber
   
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.2014-09-19 mse

MSErun is a unit test and program group compile tool.

Command line paramers:
--macrogroup=<n>
 Use 'Macros'-'Active group' number <n>, <n> = 1..6.
--macrodef=<name>,<value>{,<name>,<value>}
 Macro definition, will be overridden by 'Macros'. Example:
 --macrodef=MAC1,abc,MAC2,def
 defines ${MAC1} with value 'abc' and ${MAC2} with value 'def'.
--fontalias=<alias>,<fontname>[,<fontheight>[,<fontwidth>[,<options>[,<xscale>]
                              [,<ancestor>]]]]
 Change the used fonts. <alias> can be stf_default, stf_menu or mseide_source.

Predefined macros:
${FILE}        the file path of the current item.

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
