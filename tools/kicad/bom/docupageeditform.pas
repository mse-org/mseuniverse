{ MSEkicad Copyright (c) 2016-2017 by Martin Schreiber
   
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
unit docupageeditform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,mainmodule,
 msestatfile,msesplitter,msesimplewidgets,mseact,msedataedits,mseedit,
 mseificomp,mseificompglob,mseifiglob,msestream,msestrings,sysutils;
type
 tdocupageeditfo = class(tmseform)
   tstatfile1: tstatfile;
   tsplitter1: tsplitter;
   tbutton2: tbutton;
   tbutton1: tbutton;
   tspacer2: tspacer;
   val_title: tstringedit;
   procedure closeev(const sender: TObject);
   procedure macrohintev(const sender: TObject; var info: hintinfoty);
  private
  protected
   fpage: tdocupage;
   procedure loadvalues() virtual;
   procedure storevalues() virtual;
  public
   constructor create(const apage: tdocupage);
 end;

implementation
uses
 docupageeditform_mfm;

{ tdocupageeditfo }

constructor tdocupageeditfo.create(const apage: tdocupage);
begin
 fpage:= apage;
 inherited create(nil);
 loadvalues();
end;

procedure tdocupageeditfo.loadvalues();
begin
 fpage.loadvalues(self,'val_');
end;

procedure tdocupageeditfo.storevalues();
begin
 fpage.storevalues(self,'val_');
end;

procedure tdocupageeditfo.closeev(const sender: TObject);
begin
 if window.modalresult = mr_ok then begin
  storevalues();
 end;
end;

procedure tdocupageeditfo.macrohintev(const sender: TObject;
               var info: hintinfoty);
begin
 mainmo.hintmacros(tedit(sender).text,info);
end;

end.