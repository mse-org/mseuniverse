unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msesignoise,
 msesignal,mseaudio,msestrings,msesigaudio,msefilter,mseact,msechartedit,
 msedataedits,mseedit,msegraphedits,mseificomp,mseificompglob,mseifiglob,
 msescrollbar,msesiggui,msestatfile,msestream,sysutils;

type
 tmainfo = class(tmainform)
   tsignoise1: tsignoise;
   tsigcontroller1: tsigcontroller;
   tsigoutaudio1: tsigoutaudio;
   tsigkeyboard1: tsigkeyboard;
   tsigfilter1: tsigfilter;
   tsigslider1: tsigslider;
   tstatfile1: tstatfile;
   tenvelopeedit1: tenvelopeedit;
 end;
var
 mainfo: tmainfo;
implementation
uses
 main_mfm;
end.
