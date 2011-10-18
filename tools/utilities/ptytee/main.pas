{ MSEtools Copyright (c) 2011 by Martin Schreiber
   
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
 mseglob,mseapplication,mseclasses,msedatamodules,msepipestream,mseprocess,
 msestrings,msesysenv,msestream;

type
 tmainmo = class(tmsedatamodule)
   proc: tmseprocess;
   sysenv: tsysenvmanager;
   procedure loadedexe(const sender: TObject);
   procedure intsysenv(sender: tsysenvmanager);
   procedure procfiniexe(const sender: TObject);
   procedure inpavailexe(const sender: tpipereader);
  private
   fteestream: tbufstream;
  public
   destructor destroy; override;
 end;

var
 mainmo: tmainmo;

implementation
uses
 main_mfm,msesysintf,msesys;
type
 argumentsty = (arg_command,arg_outputfile);
const
 commandarguments: array[argumentsty] of argumentdefty = (
  (kind: ak_pararg; name: '-command'; anames: nil; flags:[]; initvalue: ''),
  (kind: ak_pararg; name: '-file'; anames: nil; flags:[]; initvalue: '')
 );

destructor tmainmo.destroy;
begin
 fteestream.free;
 inherited;
end;
 
procedure tmainmo.loadedexe(const sender: TObject);
begin
 proc.commandline:= sysenv.value[ord(arg_command)];
 if proc.commandline = '' then begin
  application.terminated:= true;
 end
 else begin
  if sysenv.value[ord(arg_outputfile)] <> '' then begin
   fteestream:= tbufstream.create(sysenv.value[ord(arg_outputfile)],fm_create);
   fteestream.usewritebuffer:= true;
  end;
  proc.active:= true;
 end;
end;

procedure tmainmo.intsysenv(sender: tsysenvmanager);
begin
 sender.init(commandarguments);
end;

procedure tmainmo.procfiniexe(const sender: TObject);
begin
 application.terminated:= true;
end;

procedure tmainmo.inpavailexe(const sender: tpipereader);
var
 str1: string;
begin
 str1:= sender.readdatastring;
 if str1 <> '' then begin
  sys_write(sys_stdout,pointer(str1),length(str1));
  if fteestream <> nil then begin
   fteestream.write(str1[1],length(str1));
  end;
 end;
end;

end.
