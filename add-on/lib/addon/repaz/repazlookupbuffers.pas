{*********************************************************}
{   Repaz Component to link Repaz with mselookupbuffer    }
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
unit repazlookupbuffers;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseclasses,classes,mclasses,mselookupbuffer,msearrayprops;
type
 trepazlookupbuffers = class;
 
 tlookupbufferitem = class(tvirtualpersistent)
  protected
   flookupbuffer: tcustomlookupbuffer;
   procedure setlookupbuffer(const avalue:tcustomlookupbuffer);
  published
   property lookupbuffer: tcustomlookupbuffer read flookupbuffer write setlookupbuffer;
 end;

 tlookupbufferitems = class(tpersistentarrayprop)
  private
   function getlookupbufferitems(index: integer): tlookupbufferitem;
  protected
   procedure createitem(const index: integer; var item: tpersistent); override;
  public
   constructor create;
   class function getitemclasstype: persistentclassty; override;
   property items[index: integer]: tlookupbufferitem read getlookupbufferitems; default;
 end;

 trepazlookupbuffers = class(tmsecomponent)
  private
   flookupbuffers: tlookupbufferitems;
   procedure setlookupbuffer(const Value: tlookupbufferitems);
  public
   constructor create(aowner: tcomponent); overload; override;
   destructor destroy; override;
   function count: integer;
  published
   property lookupbuffer: tlookupbufferitems read flookupbuffers write setlookupbuffer;
 end;

implementation

procedure tlookupbufferitem.setlookupbuffer(const avalue:tcustomlookupbuffer);
begin
 if avalue<>flookupbuffer then begin
  flookupbuffer:= avalue;
 end;
end;

constructor tlookupbufferitems.create;
begin
 inherited create(tlookupbufferitem);
end;

class function tlookupbufferitems.getitemclasstype: persistentclassty;
begin
 result:= tlookupbufferitem;
end;

function tlookupbufferitems.getlookupbufferitems(index: integer): tlookupbufferitem;
begin
 result:= tlookupbufferitem(inherited getitems(index));
end;

procedure tlookupbufferitems.createitem(const index: integer; var item: tpersistent);
begin
 inherited;
end;

{ trepazlookupbuffers }

constructor trepazlookupbuffers.create(aowner: tcomponent);
begin
 inherited;
 flookupbuffers:= tlookupbufferitems.create;
end;

destructor trepazlookupbuffers.destroy;
begin
 flookupbuffers.Free;
 inherited;
end;

procedure trepazlookupbuffers.setlookupbuffer(const Value: tlookupbufferitems);
begin
 flookupbuffers.assign(Value);
end;

function trepazlookupbuffers.count: integer;
begin
 result:= flookupbuffers.count;
end;

end.
