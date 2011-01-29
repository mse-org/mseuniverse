{*********************************************************}
{        Repaz Dialog to find text in preview form        }
{*********************************************************}
{            Copyright (c) 2011 Sri Wahono                }
{*********************************************************}
{ License Agreement:                                      }
{ This library is distributed in the hope that it will be }
{ useful, but WITHOUT ANY WARRANTY; without even the      }
{ implied warranty of MERCHANTABILITY or FITNESS FOR      }
{ A PARTICULAR PURPOSE.  See the GNU Lesser General       }
{ Public License for more details.                        }
{                                                         }
{ The source code of the Repaz libraries and packages are }
{ distributed under the Library GNU General Public        }
{ License with the following  modification:               }
{ As a special exception, the copyright holders of this   }
{ library give you permission to link this library with   }
{ independent modules to produce an executable,           }
{ regardless of the license terms of these independent    }
{ modules, and to copy and distribute the resulting       }
{ executable under terms of your choice, provided that    }
{ you also meet, for each linked independent module,      }
{ the terms and conditions of the license of that module. }
{ An independent module is a module which is not derived  }
{ from or based on this library.                          }
{                                                         }
{ Feel free to participate with reports bug, create new   }
{ report template, etc with join with Repaz forum  :      }
{                                                         }
{                http://www.msegui.org/repaz              }
{                                                         }
{*********************************************************}
unit findtextdialogform;

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface
uses
 mseforms,msesimplewidgets,msedataedits,msegraphedits,msestrings,
 msestat,msestatfile,mseglob,msegui,repazglob,
 msesplitter,msegraphics,msegraphutils;

type

 tfindtextdialogfo = class(tmseform)
   statfile1: tstatfile;
   ok: tbutton;
   tlayouter1: tlayouter;
   cancel: tbutton;
   tbutton2: tbutton;
   tgroupbox1: tgroupbox;
   casesensitive: tbooleanedit;
   wholeword: tbooleanedit;
   findtext: thistoryedit;
   tgroupbox2: tgroupbox;
   currentpage: tbooleaneditradio;
   allpage: tbooleaneditradio;
  private
   procedure valuestoinfo(out info: findtextinfoty);
   procedure infotovalues(const info: findtextinfoty);
 end;

function findtextdialogexecute(var info: findtextinfoty): boolean;

implementation
uses
 mseguiglob,findtextdialogform_mfm;

function findtextdialogexecute(var info: findtextinfoty): boolean;
var
 fo: tfindtextdialogfo;
begin
 fo:= tfindtextdialogfo.create(nil);
 try
  fo.infotovalues(info);
  result:= fo.show(true,nil) = mr_ok;
  if result then begin
   fo.valuestoinfo(info);
  end;
 finally
  fo.Free;
 end;
end;

{ tfindtextdialogfo }

procedure tfindtextdialogfo.valuestoinfo(out info: findtextinfoty);
begin
 info.text:= findtext.value;
 info.options:= encodesearchoptions(not casesensitive.value,wholeword.value);
 info.allpage:= allpage.value;
 info.history:= findtext.dropdown.valuelist.asarray;
end;

procedure tfindtextdialogfo.infotovalues(const info: findtextinfoty);
begin
 findtext.value:= info.text;
 findtext.dropdown.valuelist.asarray:= info.history;
 casesensitive.value:= not (so_caseinsensitive in info.options);
 wholeword.value:= so_wholeword in info.options;
 allpage.value:= info.allpage;
end;

end.
