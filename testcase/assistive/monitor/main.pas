unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$interfaces corba}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms, mseassistivehandler,
 mseassistiveserver,mseassistiveclient,msegrids,msestrings,msesimplewidgets,
 msedataedits,mseedit,mseificomp,mseificompglob,mseifiglob,msestatfile,
 msestream,sysutils,mseact,msegraphedits,msescrollbar,msetoolbar,msemenuwidgets,
 msebitmap,mseshapes,msewidgetgrid,msedispwidgets,mserichstring,mseeditglob,
 msetextedit,msedragglob,msetabs;

type
 tassistivemonitor = class(tobject,iassistiveserver)
  private
   fgrid: tstringgrid;
  protected
   procedure track(const prefix: msestring; const sender: iassistiveclient; 
                                                   const atext: msestring);
   procedure track(const prefix: msestring; const sender: tobject; 
                                                     const atext: msestring);
    //iassistiveserver
   procedure doapplicationactivated();
   procedure doapplicationdeactivated();
   procedure dowindowactivated(const sender: iassistiveclient);
   procedure dowindowdeactivated(const sender: iassistiveclient);
   
   procedure dowindowclosed(const sender: iassistiveclient);
   
   procedure doactivate(const sender: iassistiveclient);
   procedure dodeactivate(const sender: iassistiveclient);

   procedure dodbvaluechanged(const sender: iassistiveclientdata);
   procedure dodataentered(const sender: iassistiveclientdata);

   procedure dogridbordertouched(const sender: iassistiveclientgrid;
                                       const adirection: graphicdirectionty);

   procedure doeditcharenter(const sender: iassistiveclientedit;
                                                const achar: msestring);
 
   procedure doeditchardelete(const sender: iassistiveclientedit;
                                                const achar: msestring);
   
     procedure doeditwithdrawn(const sender: iassistiveclientedit);
  procedure doeditindexmoved(const sender: iassistiveclientedit;
                                                const aindex: int32);
  procedure doeditinputmodeset(const sender: iassistiveclientedit;
                                                const amode: editinputmodety);
  procedure doedittextblock(const sender: iassistiveclientedit;
                    const amode: edittextblockmodety; const atext: msestring);
  procedure donavigbordertouched(const sender: iassistiveclient;
                                       const adirection: graphicdirectionty);
  procedure dotabordertouched(const sender: iassistiveclient;
                                                        const adown: boolean);   
                                                        
    procedure doactionexecute(const sender: iassistiveclient;//sender can be nil
                            const senderobj: tobject; const info: actioninfoty);
  procedure doitementer(const sender: iassistiveclient;    //sender can be nil
                            const items: shapeinfoarty; const aindex: integer);
  procedure domenuactivated(const sender: iassistiveclientmenu);
  procedure doitementer(const sender: iassistiveclientmenu;//sender can be nil
                         const items: menucellinfoarty; const aindex: integer);
  procedure dodatasetevent(const sender: iassistiveclient;
                const akind: assistivedbeventkindty;
                                  const adataset: pointer); //tdataset
                                                                                                
 
   procedure doenter(const sender: iassistiveclient);
 
   procedure doclientmouseevent(const sender: iassistiveclient;
                                           const info: mouseeventinfoty);
   procedure dofocuschanged(const sender: iassistiveclient;
                                const oldwidget,newwidget: iassistiveclient);
   
   procedure dokeydown(const sender: iassistiveclient;
                                        const info: keyeventinfoty);
   procedure doactionexecute(const sender: tobject; const info: actioninfoty);
   procedure dochange(const sender: iassistiveclient);
   procedure docellevent(const sender: iassistiveclientgrid;
                                      const info: celleventinfoty);
  public
   constructor create(const agrid: tstringgrid);
   destructor destroy(); override;
 end;
 
 tmainfo = class(tmainform)
   stringgrid: tstringgrid;
   tbutton1: tbutton;
   tbutton2: tbutton;
   tstringedit1: tstringedit;
   tstringedit2: tstringedit;
   tbooleanedit1: tbooleanedit;
   tslider1: tslider;
   ttoolbar1: ttoolbar;
   tmainmenuwidget1: tmainmenuwidget;
   tfacecomp1: tfacecomp;
   tframecomp1: tframecomp;
   tframecomp2: tframecomp;
   tfacecomp2: tfacecomp;
   timagelist1: timagelist;
   tstringgrid1: tstringgrid;
   widgetgrid: twidgetgrid;
   tstringedit3: tstringedit;
   tintegeredit1: tintegeredit;
   tstatfile1: tstatfile;
   assistivecaption: tstringdisp;
   assistivetext: tstringdisp;
   assistivename: tstringdisp;
   ttextedit1: ttextedit;
   intval: tintegerdisp;
   stringval: tstringdisp;
   realval: trealdisp;
   datetimeval: tdatetimedisp;
   tintegeredit2: tintegeredit;
   trealedit1: trealedit;
   tdatetimeedit1: tdatetimeedit;
   colmindi: tintegerdisp;
   colmaxdi: tintegerdisp;
   rowmaxdi: tintegerdisp;
   rowmindi: tintegerdisp;
   boolval: tbooleandisp;
   assistivehint: tstringdisp;
   assistivecaretindex: tintegerdisp;
   ttabbar1: ttabbar;
   ttabwidget1: ttabwidget;
   ttabpage1: ttabpage;
   ttabpage2: ttabpage;
   ttabpage3: ttabpage;
   ttabpage4: ttabpage;
   gridcell: tbooleandisp;
   procedure createexe(const sender: TObject);
   procedure destroyexe(const sender: TObject);
   procedure exe(const sender: TObject);
   procedure exitexe(const sender: TObject);
  private
   fmonitor: tassistivemonitor;
  public
   procedure showvalues(const sender: iassistiveclient);
   procedure showtext(const atext: msestring);
 end;
 
var
 mainfo: tmainfo;

implementation
uses
 main_mfm,typinfo,mclasses,mseactions,mseformatstr,msegridsglob;

function getname(const sender: iassistiveclient): msestring;
begin
 if sender = nil then begin
  result:= 'NIL';
 end
 else begin
  result:= sender.getassistivename;
 end;
end;
 
{ tassistivemonitor }

constructor tassistivemonitor.create(const agrid: tstringgrid);
begin
 fgrid:= agrid;
 assistiveserver:= iassistiveserver(self);
end;

destructor tassistivemonitor.destroy();
begin
 assistiveserver:= nil;
 fgrid.free();
end;

procedure tassistivemonitor.track(const prefix: msestring; 
                       const sender: iassistiveclient; const atext: msestring);
var
 mstr1: msestring;
// inst1: tobject;               
begin
 if (sender = nil) or (sender.getinstance <> fgrid) then begin
  mstr1:= '<'+getname(sender)+'> ';
  fgrid.appendrow(prefix+mstr1+atext);
  fgrid.showlastrow();
 end;
end;

procedure tassistivemonitor.track(const prefix: msestring;
                                const sender: tobject; const atext: msestring);
var
 intf1: iassistiveclient;
 mstr1: msestring;
begin
 if getcorbainterface(sender,typeinfo(iassistiveclient),intf1) then begin
  track(prefix,intf1,atext);
 end
 else begin
  mstr1:= '';
  if sender is tcomponent then begin
   mstr1:= msestring(tcomponent(sender).name+' ');
  end;
  track(prefix,iassistiveclient(nil),mstr1+atext);
 end;
end;

procedure tassistivemonitor.doenter(const sender: iassistiveclient);
begin
 mainfo.showvalues(sender);
 track('<doenter>',sender,'');
end;

procedure tassistivemonitor.doitementer(const sender: iassistiveclient; //sender can be nil
                            const items: shapeinfoarty; const aindex: integer);  
begin
 mainfo.showvalues(sender);
 track('<doitementer shape>',sender,inttostrmse(aindex));
end;

procedure tassistivemonitor.doclientmouseevent(const sender: iassistiveclient;
               const info: mouseeventinfoty);
begin
 if info.eventkind in [ek_clientmouseenter,ek_buttonpress] then begin
  mainfo.showvalues(sender);
 end;
 track('<clientmouseevent '+msestring(getenumname(typeinfo(eventkindty),
                       ord(info.eventkind)))+'>',sender,'');
end;

 procedure tassistivemonitor.dofocuschanged(const sender: iassistiveclient;
                                const oldwidget,newwidget: iassistiveclient);
begin
 track('<dofocuschanged '+getname(newwidget)+'>',oldwidget,'');
end;

procedure tassistivemonitor.dokeydown(const sender: iassistiveclient;
               const info: keyeventinfoty);
begin
 with info do begin
  mainfo.showvalues(sender);
  track('<dokeydown '+
 //          getenumname(typeinfo(eventkindty),ord(info.eventkind)) + ' ' +
           getshortcutname(shortcutty(key)) + ' "'+chars + '" ' +
   msestring(settostring(ptypeinfo(typeinfo(shiftstate)),
                               int32(shiftstate),true) + ' ' +
   settostring(ptypeinfo(typeinfo(eventstate)),
                               int32(eventstate),true) + '>'),sender,'');
 end;
end;

procedure tassistivemonitor.doactionexecute(const sender: tobject;
               const info: actioninfoty);
begin
 track('<doactionexecute>',sender,'');
 guibeep();
end;

procedure tassistivemonitor.dochange(const sender: iassistiveclient);
begin
 mainfo.showvalues(sender);
 track('<dochange>',sender,'');
end;

procedure tassistivemonitor.docellevent(const sender: iassistiveclientgrid;
               const info: celleventinfoty);
               
var
 aflags: assistiveflagsty;               
begin
 track('<docellevent>',sender,msestring(getenumname(typeinfo(info.eventkind),
           int32(info.eventkind)))+' col:'+inttostrmse(info.cell.col)+
                                 ' row:'+inttostrmse(info.cell.row));
 if info.eventkind = cek_enter then begin
  mainfo.showtext(sender.getassistivecelltext(info.cell, aflags));
 end;
end;

// not yet used

procedure tassistivemonitor.dodataentered(Const sender: iassistiveclientdata);
begin
end;

procedure tassistivemonitor.doeditcharenter(Const sender: iassistiveclientedit;
                               Const achar: msestring);
begin
end;
procedure tassistivemonitor.doeditchardelete(Const sender: iassistiveclientedit;
                                Const achar: msestring);
begin
end;
procedure tassistivemonitor.doeditwithdrawn(Const sender: iassistiveclientedit);
begin
end;
procedure tassistivemonitor.doeditindexmoved(Const sender: iassistiveclientedit;
                                Const aindex: int32);
begin
end;
procedure tassistivemonitor.doeditinputmodeset(Const sender: iassistiveclientedit;
                                  Const amode: editinputmodety);
begin
end;
procedure tassistivemonitor.doedittextblock(Const sender: iassistiveclientedit;
                               Const amode: edittextblockmodety; Const atext: msestring);
begin
end;

procedure tassistivemonitor.dodbvaluechanged(const sender: iassistiveclientdata);
begin
end;

procedure tassistivemonitor.dogridbordertouched(const sender: iassistiveclientgrid;
                                       const adirection: graphicdirectionty);
begin
end;

procedure tassistivemonitor.dotabordertouched(const sender: iassistiveclient;
                                                        const adown: boolean);   
begin
end;

procedure tassistivemonitor.doitementer(const sender: iassistiveclientmenu;//sender can be nil
                         const items: menucellinfoarty; const aindex: integer);
begin
end;                         
                         
procedure tassistivemonitor.dodatasetevent(const sender: iassistiveclient;
                const akind: assistivedbeventkindty;
                                  const adataset: pointer); //tdataset
begin
end;  

procedure tassistivemonitor.dodeactivate(const sender: iassistiveclient);
begin
end;

procedure tassistivemonitor.doapplicationactivated();
begin
end;

procedure tassistivemonitor.doapplicationdeactivated();
begin
end;

procedure tassistivemonitor.dowindowactivated(Const sender: iassistiveclient);
begin
end;

procedure tassistivemonitor.dowindowdeactivated(Const sender: iassistiveclient);
begin
end;

procedure tassistivemonitor.dowindowclosed(Const sender: iassistiveclient);
begin
end;

procedure tassistivemonitor.doactivate(Const sender: iassistiveclient);
begin
end;

procedure tassistivemonitor.donavigbordertouched(Const sender: iassistiveclient;
                                    Const adirection: graphicdirectionty);
begin
end;

procedure tassistivemonitor.doactionexecute(Const sender: iassistiveclient;//sender can be nil
                               Const senderobj: tobject; Const info: actioninfoty);
begin
end;

procedure tassistivemonitor.domenuactivated(Const sender: iassistiveclientmenu);
begin
end;




{ tmainfo }

procedure tmainfo.createexe(const sender: TObject);
begin
 fmonitor:= tassistivemonitor.create(stringgrid);
end;

procedure tmainfo.destroyexe(const sender: TObject);
begin
 fmonitor.free();
end;

procedure tmainfo.exe(const sender: TObject);
begin
 guibeep();
end;

procedure tmainfo.exitexe(const sender: TObject);
begin
 application.terminated:= true;
end;

procedure tmainfo.showvalues(const sender: iassistiveclient);
var
 dataintf: iifidatalink;
 valueprop: ppropinfo;
 flags: assistiveflagsty;
 rea1: real;
begin
 flags:= sender.getassistiveflags();
 assistivename.value:= sender.getassistivename();
 assistivecaption.value:= sender.getassistivecaption();
 assistivetext.value:= sender.getassistivetext();
 assistivehint.value:= sender.getassistivehint();
 assistivecaretindex.value:= sender.getassistivecaretindex();
 stringval.clear();
 intval.clear();
 realval.clear();
 datetimeval.clear();
 boolval.clear();
 if not (asf_gridcell in flags) then begin
  colmindi.clear();
  colmaxdi.clear();
  rowmindi.clear();
  rowmaxdi.clear();
 end;

 if asf_grid in flags then begin
  with iassistiveclientgrid(sender).getassistivegridinfo() do begin
   colmindi.value:= colmin;
   colmaxdi.value:= colmax;
   rowmindi.value:= rowmin;
   rowmaxdi.value:= rowmax;
  end;
 end;
 gridcell.value:= asf_gridcell in flags;
   
 dataintf:= sender.getifidatalinkintf();
 if dataintf <> nil then begin
  valueprop:= dataintf.getvalueprop();
  if valueprop <> nil then begin
   case valueprop^.proptype^.kind of
    tkustring: begin
     stringval.value:= getunicodestrprop(sender.getinstance(),valueprop);
    end;
    tkinteger: begin
     intval.value:= getordprop(sender.getinstance(),valueprop);
    end;
    tkfloat: begin
     rea1:= getfloatprop(sender.getinstance(),valueprop);
     if asf_datetime in flags then begin
      datetimeval.value:= rea1;
     end
     else begin
      realval.value:= rea1;
     end;
    end;
    tkbool: begin
     boolval.value:= getordprop(sender.getinstance,valueprop) <> 0;
    end;
   end;
  end;
 end;
end;

procedure tmainfo.showtext(const atext: msestring);
begin
 assistivename.value:= '';
 assistivecaption.value:= '';
 assistivetext.value:= atext;
end;

end.
