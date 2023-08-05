unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,
 msestatfile,msestream,msestrings,sysutils,msegraphedits,msescrollbar,
 msefileutils,msemenuwidgets,msegrids,msewidgetgrid,msebitmap,msedatanodes,
 msefiledialog,mselistbrowser,msesys,msesignal,msebarcode;

type
 tmainfo = class(tmainform)
   tbutton1: tbutton;
   tstringedit1: tstringedit;
   tbooleanedit1: tbooleanedit;
   tbooleaneditradio1: tbooleaneditradio;
   tbooleaneditradio2: tbooleaneditradio;
   tbooleaneditradio3: tbooleaneditradio;
   tslider1: tslider;
   tmemoedit1: tmemoedit;
   tmainmenuwidget1: tmainmenuwidget;
   demogrid: tstringgrid;
   procedure initit(const sender: TObject);
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm, load_fcarbonskin;
 
  function randommoney: msestring;
  var
    x: integer;
  begin
     x := random(3);
    case x of
      0: Result := ' €';
      1: Result := ' £';
      2: Result := ' $';
    end;
  end;

procedure tmainfo.initit(const sender: TObject);
  var
x, y  : integer;
 begin
  randomize;
    for x := 0 to 4 do
      for y := 0 to 5 do
     demogrid[x][y]  := IntToStr(random(1000))  + randommoney;
 end;
 
 
end.
