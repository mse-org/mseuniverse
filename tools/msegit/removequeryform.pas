{ MSEgit Copyright (c) 2011-2014 by Martin Schreiber
   
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
unit removequeryform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,mainmodule,msestatfile,
 filelistframe,msesimplewidgets,msewidgets,msegraphedits,mseifiglob,msetypes,
 msedispwidgets,msestrings,msedataedits,mseedit,msesplitter,msememodialog,
 msegitcontroller,commitdiffform,msegrids,filechecklistframe,mserichstring;
type
 tremovequeryfo = class(tmseform)
   revert: tbutton;
   tstatfile1: tstatfile;
//   diff: tcommitdifffo;
   tsplitter2: tsplitter;
   filelist: tfilechecklistframefo;
   tlayouter2: tlayouter;
   filecountdisp: tintegerdisp;
   tlayouter1: tlayouter;
   tbutton1: tbutton;
   procedure selectsetexe(const sender: TObject; var avalue: Boolean;
                   var accept: Boolean);
//   procedure celleventexe(const sender: TObject; var info: celleventinfoty);
   procedure removeupdateexe(const sender: tcustombutton);
  private
  protected
   froot: tgitdirtreenode;
  public
 end;

implementation
uses
 removequeryform_mfm,msedatanodes,lastmessageform,msearrayutils;

{ tremovequeryfo }
 
procedure tremovequeryfo.selectsetexe(const sender: TObject;
               var avalue: Boolean; var accept: Boolean);
begin
 if avalue then begin
  filecountdisp.value:= filecountdisp.value + 1;
 end
 else begin
  filecountdisp.value:= filecountdisp.value - 1;
 end;
end;
{
procedure tremovequeryfo.celleventexe(const sender: TObject;
               var info: celleventinfoty);
begin
 if isrowenter(info) then begin
  diff.refresh(froot,filelist.currentitem,'','');
 end;
end;
}
procedure tremovequeryfo.removeupdateexe(const sender: tcustombutton);
begin
 sender.enabled:= filecountdisp.value > 0;
end;

end.
