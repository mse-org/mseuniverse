unit pythonconsoleform;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,mseact,
 msedataedits,mseedit,msegrids,mseificomp,mseificompglob,mseifiglob,msestatfile,
 msestream,msestrings,msewidgetgrid,sysutils,mseterminal;
type
 tpythonconsolefo = class(tmseform)
   twidgetgrid1: twidgetgrid;
   term: tterminal;
   tstatfile1: tstatfile;
   procedure procfinishedev(const sender: TObject);
   procedure sendtextev(const sender: TObject; var atext: msestring;
                   var donotsend: Boolean);
  private
   flast: boolean;
  public
   procedure show(const last: boolean);
   procedure writeln(const atext: msestring);
 end;

implementation
uses
 pythonconsoleform_mfm,mseformatstr;
 
procedure tpythonconsolefo.procfinishedev(const sender: TObject);
var
 i1: int32;
begin
 i1:= term.process.exitcode;
 if i1 = 0 then begin
  if flast then begin
   term.addline('* Terminated OK *');
  end
  else begin
   endmodal();
   exit;
  end;
 end
 else begin
  term.addline('***** ERROR '+inttostrmse(i1)+' ******');
 end;
 term.addchars('Press Enter ');
end;

procedure tpythonconsolefo.sendtextev(const sender: TObject;
               var atext: msestring; var donotsend: Boolean);
begin
 if not term.process.active then begin
  donotsend:= true;
  close();
 end;
end;

procedure tpythonconsolefo.show(const last: boolean);
begin
 flast:= last;
 activate();
 inherited show(ml_application);
end;

procedure tpythonconsolefo.writeln(const atext: msestring);
begin
 term.addchars(atext);
 term.addline('');
end;

end.
