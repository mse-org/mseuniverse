{*********************************************************}
{                     Repaz Dialog                        }
{             Dialog to choose report action              }
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
unit repazdialog;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msegui,msegraphics,msegraphutils,
 mseclasses,mseforms,msedataedits,msesimplewidgets,msegraphedits,msebitmap,
 msedatanodes,mseedit,msefiledialog,msegrids,mselistbrowser,msemenus,
 msescrollbar,msestrings,msesys,msetypes;
type
 trepazdialogfo = class(tmseform)
   cactions: tdropdownlistedit;
   tgroupbox1: tgroupbox;
   showagain: tbooleanedit;
   cdescription: tlabel;
   btnsetting: tbutton;
   btnok: tbutton;
   btncancel: tbutton;
   wfilename: tfilenameedit;
   procedure cactions_ondataentered(const sender: TObject);
   procedure repazdialogfo_oncreate(const sender: TObject);
   procedure btncancel_onexecute(const sender: TObject);
   procedure dialogloaded;virtual;
   procedure repazdialogfo_onloaded(const sender: TObject);
 end;
var
 repazdialogfo: trepazdialogfo;
implementation
uses
 repazdialog_mfm,mseconsts,repazconsts;

procedure trepazdialogfo.cactions_ondataentered(const sender: TObject);
begin
 cdescription.caption:= cactions.dropdown.cols[1].items[cactions.dropdown.itemindex];
end;

procedure trepazdialogfo.repazdialogfo_oncreate(const sender: TObject);
begin
 with cactions.dropdown.cols[0] do begin
  add(uc(ord(rcsDesignreport)));
  add(uc(ord(rcsPreview)));
  add(uc(ord(rcsPrinter)));
  add(uc(ord(rcsSavetops)));
  add(uc(ord(rcsSavetopdf)));
  add(uc(ord(rcsSavetotext)));
 end;
 with cactions.dropdown.cols[1] do begin
  add(uc(ord(rcsDesigninfo)));
  add(uc(ord(rcsPreviewinfo)));
  add(uc(ord(rcsPrintinfo)));
  add(uc(ord(rcsSavetopsinfo)));
  add(uc(ord(rcsSavetopdfinfo)));
  add(uc(ord(rcsSavetotextinfo)));
 end;
 btnsetting.caption:= uc(ord(rcsSetting));
 btnok.caption:=uc(ord(rcsok));
 btncancel.caption:=uc(ord(rcscancel));
 showagain.frame.caption:= uc(ord(rcsShowdlgagain));
 cactions.frame.caption:= uc(ord(rcsActiontype));
 tgroupbox1.frame.caption:= uc(ord(rcsDescription));
 dialogloaded;
end;

procedure trepazdialogfo.btncancel_onexecute(const sender: TObject);
begin
 self.close;
end;

procedure trepazdialogfo.dialogloaded;
begin
 //
end;

procedure trepazdialogfo.repazdialogfo_onloaded(const sender: TObject);
begin
end;

end.
