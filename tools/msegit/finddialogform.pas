{ MSEide Copyright (c) 1999-2014 by Martin Schreiber
   
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
unit finddialogform;

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface
uses
 mseforms,msesimplewidgets,msedataedits,msegraphedits,msetextedit,msestrings,
 msetypes,msestat,msestatfile,mseglob,mseevent,msegui,
 msemenus,msesplitter,msegraphics,msegraphutils,msewidgets,mclasses;

type

 findinfoty = record
  text: msestring;
  options: searchoptionsty;
  selectedonly: boolean;
  history: msestringarty;
 end;

 tfinddialogfo = class(tmseform)
   findtext: thistoryedit;
   statfile1: tstatfile;
   ok: tbutton;
   tlayouter1: tlayouter;
   cancel: tbutton;
   tbutton2: tbutton;
   tlayouter2: tlayouter;
   selectedonly: tbooleanedit;
   wholeword: tbooleanedit;
   casesensitive: tbooleanedit;
   procedure statupdateexe(const sender: TObject; const filer: tstatfiler);
   procedure closequeryexe(const sender: tcustommseform;
                   var amodalresult: modalresultty);
  private
   finfo: findinfoty;
   procedure valuestoinfo(out info: findinfoty);
   procedure infotovalues(const info: findinfoty);
  public
   constructor create(aowner: tcomponent); override;
 end;

procedure updatefindvalues(const astatfiler: tstatfiler;
                                          var aoptions: findinfoty);
function finddialogexecute(out info: findinfoty): boolean;
procedure findintextedit(const edit: tcustomtextedit; var info: findinfoty;
                     var findpos: gridcoordty);

implementation
uses
 mseguiglob,mseeditglob,msegridsglob,finddialogform_mfm;
const
 findshowpos = cep_rowcentered;

procedure updatefindvalues(const astatfiler: tstatfiler;
                                          var aoptions: findinfoty);
var
 int1: integer;
begin
 with astatfiler,aoptions do begin
  updatevalue('finddtext',text);
  updatevalue('findhistory',history);
  int1:= {$ifdef FPC}longword{$else}byte{$endif}(options);
  updatevalue('findoptions',int1);
  options:= searchoptionsty({$ifdef FPC}longword{$else}byte{$endif}(int1));
 end;
end;

function finddialogexecute(out info: findinfoty): boolean;
var
 fo: tfinddialogfo;
begin
 fo:= tfinddialogfo.create(nil);
 try
  fo.infotovalues(fo.finfo);
  result:= fo.show(true,nil) = mr_ok;
  if result then begin
   fo.valuestoinfo(fo.finfo);
  end;
  info:= fo.finfo;
 finally
  fo.Free;
 end;
end;

procedure textnotfound(const ainfo: findinfoty);
begin
 showmessage('Text '''+ainfo.text+''' not found.');
end;

procedure findintextedit(const edit: tcustomtextedit; var info: findinfoty;
                     var findpos: gridcoordty);
var
 pt1: gridcoordty;
begin
 with info do begin
  if selectedonly then begin
   if edit.hasselection then begin
    normalizetextrect(edit.selectstart,edit.selectend,findpos,pt1);
    if not edit.find(text,options,findpos,pt1,true) then begin
     textnotfound(info);
    end
    else begin
     selectedonly:= false;
    end;
   end;
  end
  else begin
   findpos:= edit.editpos;
//   dec(ffindpos.col);
   if not edit.find(text,options,findpos,bigcoord,true,findshowpos) then begin
    if (findpos.row = 0) and (findpos.col = 0) then begin
     textnotfound(info);
    end
    else begin
     if askok('Text '''+text+
              ''' not found. Restart from begin of file?') then begin
      findpos:= nullcoord;
      if not edit.find(text,options,findpos,edit.editpos,true,findshowpos) then begin
       textnotfound(info);
      end;
     end;
    end;
   end;
  end;
 end;
end;

{ tfinddialogfo }

constructor tfinddialogfo.create(aowner: tcomponent);
begin
 finfo.options:= [so_caseinsensitive];
 inherited;
end;

procedure tfinddialogfo.valuestoinfo(out info: findinfoty);
begin
 with info do begin
  text:= findtext.value;
  history:= findtext.dropdown.valuelist.asarray;
  options:= encodesearchoptions(not casesensitive.value,wholeword.value);
  selectedonly:= self.selectedonly.value;
 end;
end;

procedure tfinddialogfo.infotovalues(const info: findinfoty);
begin
 with info do begin
  findtext.value:= text;
  findtext.dropdown.valuelist.asarray:= history;
  casesensitive.value:= not (so_caseinsensitive in options);
  wholeword.value:= so_wholeword in options;
//  self.selectedonly.value:= selectedonly;
 end;
end;

procedure tfinddialogfo.statupdateexe(const sender: TObject;
               const filer: tstatfiler);
begin
 updatefindvalues(filer,finfo);
end;

procedure tfinddialogfo.closequeryexe(const sender: tcustommseform;
               var amodalresult: modalresultty);
begin
 valuestoinfo(finfo);
end;

end.
