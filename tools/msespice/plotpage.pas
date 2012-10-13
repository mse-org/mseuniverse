{ MSEgit Copyright (c) 2012 by Martin Schreiber
   
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
unit plotpage;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msetabs,msedataedits,
 mseedit,mseifiglob,msestrings,msetypes,msewidgets,classes,plotoptions;
 
type
 tplotpagefo = class(ttabform)
   plotname: tstringedit;
   plotkind: tenumedit;
   plotcont: tsimplewidget;
   procedure setnameexe(const sender: TObject; var avalue: msestring;
                   var accept: Boolean);
   procedure kindsetexe(const sender: TObject; var avalue: Integer;
                   var accept: Boolean);
  private
   fplot: tplotoptionsfo;
  protected
   procedure setkind(const akind: integer);
  public
   constructor create(const aowner: tcomponent; const akind: integer);
   function kind: integer;
 end;

implementation
uses
 plotpage_mfm,dcplot,acplot,transplot,sysutils;

const
 plotclasses: array[0..2] of plotsfoclassty = (
  tdcplotfo,tacplotfo,ttransplotfo);

function getplotclass(const akind: integer): plotsfoclassty;
begin
 if (akind < 0) or (akind > high(plotclasses)) then begin
  result:= nil;
 end
 else begin
  result:= plotclasses[akind];
 end;
end;

function getplotkind(const aclass: tplotoptionsfo): integer;
var
 int1: integer;
 po1: pointer;
begin
 result:= -1;
 if aclass <> nil then begin
  po1:= aclass.classtype;
  for int1:= 0 to high(plotclasses) do begin
   if plotclasses[int1] = plotsfoclassty(po1) then begin
    result:= int1;
    break;
   end;
  end;
 end;
end;

 {tplotpagefo}

constructor tplotpagefo.create(const aowner: tcomponent; const akind: integer);
begin
 inherited create(aowner);
 caption:= plotname.value;
 setkind(akind);
end;
 
procedure tplotpagefo.setnameexe(const sender: TObject; var avalue: msestring;
               var accept: Boolean);
begin
 caption:= avalue;
end;

procedure tplotpagefo.kindsetexe(const sender: TObject; var avalue: Integer;
               var accept: Boolean);
begin
 if avalue <> plotkind.value then begin
  setkind(avalue);
 end;
end;

procedure tplotpagefo.setkind(const akind: integer);
var
 cla1: plotsfoclassty;
begin
 freeandnil(fplot);
 cla1:= getplotclass(akind);
 if cla1 <> nil then begin
  fplot:= cla1.create(self);
  fplot.parentwidget:= plotcont;
  fplot.visible:= true;
 end;
end;

function tplotpagefo.kind: integer;
begin
 result:= getplotkind(fplot);
end;

end.
