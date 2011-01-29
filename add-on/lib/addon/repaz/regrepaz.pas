{*********************************************************}
{                Register Repaz Components                }
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
unit regrepaz;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 classes,msecomponenteditors,msedesignintf,sysutils,repazclasses,
 repazdatasources,mseglob,repazpreview,repazevaluator,frmevaldialog,
 repazconsts,repazlookupbuffers,repazchart;

type
 trepazeditor = class(tcomponenteditor)
  public
   constructor create(const adesigner: idesigner; acomponent: tcomponent); override;
   procedure edit; override;
 end;
 
implementation
uses
 repazdesign,regrepaz_bmp;

constructor trepazeditor.create(const adesigner: idesigner; acomponent: tcomponent);
begin
 inherited;
 fstate:= fstate + [cs_canedit];
end;

procedure trepazeditor.edit;
begin
 trepaz(fcomponent).reportdesign;
 fdesigner.componentmodified(fcomponent);
end;

procedure Register;
begin
 registercomponents('Repaz',[trepaz,trepazdatasources,trepazlookupbuffers,tpreview,
   trepazevaluator,trepazevaldialog,TRepazChart]); 
 registercomponenttabhints(['Repaz'],['Repaz Component','Collection of Repaz datasources','Collection of Repaz mselookupbuffer','Repaz Preview',
   'Expression evaluator','Dialog for expression evaluator','Repaz Chart']);
 registercomponenteditor(trepaz,trepazeditor)
end;

initialization
 register;
end.
