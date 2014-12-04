 MSEtest Copyright (c) 2014 by Martin Schreiber
   
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

MSEtest is a unit test and program group compile tool.

Predefined macros:
${FILE}        the file path of the current item.

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
