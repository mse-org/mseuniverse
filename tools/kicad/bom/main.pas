{ MSEkicad Copyright (c) 2016 by Martin Schreiber
   
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
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
}
unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msestatfile,
 mseact,msebitmap,msedataedits,msedatanodes,mseedit,msefiledialog,msegrids,
 mseificomp,mseificompglob,mseifiglob,mselistbrowser,msestream,msestrings,
 msesys,sysutils,msesimplewidgets,kicadschemaparser;

type
 tmainfo = class(tmainform)
   tstatfile1: tstatfile;
   filepath: tfilenameedit;
   tbutton1: tbutton;
   procedure parseev(const sender: TObject);
  protected
   procedure docomp(const sender: tkicadschemaparser; var info: compinfoty);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
 
procedure tmainfo.parseev(const sender: TObject);
var
 parser: tkicadschemaparser;
 stream: ttextstream;
begin
 parser:= tkicadschemaparser.create(nil);
 parser.oncomp:= @docomp;
 stream:= nil; 
 try
  stream:= ttextstream.create(filepath.value,fm_read);
  stream.encoding:= ce_utf8;
  parser.parse(stream);
 finally
  parser.destroy();
  stream.free();
 end;
end;

procedure tmainfo.docomp(const sender: tkicadschemaparser;
               var info: compinfoty);
begin
end;

end.
