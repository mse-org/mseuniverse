unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msestatfile,
 msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,msestrings,msetypes,
 msesimplewidgets,msewidgets,msebitmap,msedatanodes,msefiledialog,msegrids,
 mselistbrowser,msesys;

type
 tmainfo = class(tmainform)
   tstatfile1: tstatfile;
   maxwied: tintegeredit;
   scaleed: tintegeredit;
   tbutton1: tbutton;
   filenameed: tfilenameedit;
   procedure runexe(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm,msestream;
 
procedure tmainfo.runexe(const sender: TObject);
var
 r2: real;
 n: integer;
 int1,int2,int3,int4: integer;
 stream1: ttextstream;
 step: real;
begin
 stream1:= ttextstream.create(filenameed.value,fm_create);
 r2:= scaleed.value*scaleed.value;
 stream1.writeln('(');
 for int1:= 0 to maxwied.value do begin
  stream1.write(' (');
  int3:= int1 div 2;
  if int3 > 0 then begin
   step:= scaleed.value / int1;
   for int2:= 1 to int3 do begin
    if int2 <> 1 then begin
     stream1.write(',');
    end;
    int4:= round(sqrt(r2-(int2*step)*(int2*step)));
    if int4 >= scaleed.value then begin
     int4:= scaleed.value - 1;
    end;
    stream1.write(int4);
   end;
  end
  else begin
   stream1.write('0');
   int3:= 1;
  end;
  for int2:= int3 to maxwied.value div 2 - 1 do begin
   stream1.write([',',0]);
  end;
  stream1.write(')');
  if int1 < maxwied.value then begin
   stream1.write(',');
  end;
  stream1.write([' //',int1]);
  stream1.writeln;
 end;
 stream1.writeln(');');
 stream1.free;
end;

end.
