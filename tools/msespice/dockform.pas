{ MSEspice Copyright (c) 2012 by Martin Schreiber
   
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
unit dockform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,msetypes,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msedockpanelform,
 msechart,msedock,msetimer,mseact,mseactions,mseifiglob;

type
 tdockfo = class(tdockpanelform)
   timer: ttimer;
   popupme: tpopupmenu;
   printact: taction;
   procedure boundschangedexe(const sender: tdockcontroller);
   procedure timerexe(const sender: TObject);
   procedure updateprintexe(const sender: tcustomaction);
   procedure printexe(const sender: TObject);
  public
   procedure chartchanged(const sender: twidget);
 end;

implementation
uses
 dockform_mfm,chartform,main,printwindow;
 
procedure tdockfo.boundschangedexe(const sender: tdockcontroller);
begin
 syncfitframe(sender);
end;

procedure tdockfo.chartchanged(const sender: twidget);
begin
 timer.enabled:= true;
end;

procedure tdockfo.timerexe(const sender: TObject);
begin
 syncfitframe(dragdock);  
end;

procedure tdockfo.updateprintexe(const sender: tcustomaction);
begin
 sender.visible:= (parentwidget = nil) or (parentofcontainer = mainfo);
end;

procedure tdockfo.printexe(const sender: TObject);
begin
 tprintwindowfo.create(container); 
end;

end.
