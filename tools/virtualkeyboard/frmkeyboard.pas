unit frmkeyboard;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msesimplewidgets,
 msewidgets,mseedit,mseimage,msegraphedits,mseificomp,mseificompglob,mseifiglob,
 msescrollbar,msetypes,msedataedits,msestrings,msegrids;
type
 tfrmkeyboardfo = class(tmseform)
   wnumbers: tsimplewidget;
   btnenter: tstockglyphbutton;
   btndec: tstockglyphbutton;
   btn0: tstockglyphbutton;
   btn9: tstockglyphbutton;
   btn8: tstockglyphbutton;
   btn7: tstockglyphbutton;
   btn4: tstockglyphbutton;
   btn5: tstockglyphbutton;
   btn6: tstockglyphbutton;
   btndel: tstockglyphbutton;
   btnback: tstockglyphbutton;
   btn3: tstockglyphbutton;
   btn2: tstockglyphbutton;
   btn1: tstockglyphbutton;
   wchars: tsimplewidget;
   btnq: tstockglyphbutton;
   btnw: tstockglyphbutton;
   btne: tstockglyphbutton;
   btnr: tstockglyphbutton;
   btnt: tstockglyphbutton;
   btny: tstockglyphbutton;
   btnu: tstockglyphbutton;
   btni: tstockglyphbutton;
   btno: tstockglyphbutton;
   btnp: tstockglyphbutton;
   btna: tstockglyphbutton;
   btns: tstockglyphbutton;
   btnd: tstockglyphbutton;
   btnf: tstockglyphbutton;
   btng: tstockglyphbutton;
   btnh: tstockglyphbutton;
   btnj: tstockglyphbutton;
   btnk: tstockglyphbutton;
   btnl: tstockglyphbutton;
   btnaposthrope: tstockglyphbutton;
   btnshift: tstockglyphbutton;
   btnz: tstockglyphbutton;
   btnx: tstockglyphbutton;
   btnc: tstockglyphbutton;
   btnv: tstockglyphbutton;
   btnb: tstockglyphbutton;
   btnn: tstockglyphbutton;
   btnm: tstockglyphbutton;
   btncomma: tstockglyphbutton;
   btnperiod: tstockglyphbutton;
   btnquestion: tstockglyphbutton;
   btnup: tstockglyphbutton;
   btnsymbols: tstockglyphbutton;
   btnctrl: tstockglyphbutton;
   btnspace: tstockglyphbutton;
   btnleft: tstockglyphbutton;
   btnright: tstockglyphbutton;
   btndown: tstockglyphbutton;
   btndel2: tstockglyphbutton;
   btnoptions: tstockglyphbutton;
   wsymbols: tsimplewidget;
   btncaret: tstockglyphbutton;
   btnabc: tstockglyphbutton;
   btnslash: tstockglyphbutton;
   btnasterisk: tstockglyphbutton;
   btnnext: tstockglyphbutton;
   btnprev: tstockglyphbutton;
   btnminus: tstockglyphbutton;
   btnUnderscore: tstockglyphbutton;
   btnequal: tstockglyphbutton;
   btnnumsign: tstockglyphbutton;
   btnat: tstockglyphbutton;
   btneclam: tstockglyphbutton;
   btntab: tstockglyphbutton;
   btnparenleft: tstockglyphbutton;
   btnampersand: tstockglyphbutton;
   btnpercent: tstockglyphbutton;
   btndollar: tstockglyphbutton;
   btncolon: tstockglyphbutton;
   btnsemicolon: tstockglyphbutton;
   btnbackslash: tstockglyphbutton;
   btnplus: tstockglyphbutton;
   btnvertbar: tstockglyphbutton;
   btnrightbrace: tstockglyphbutton;
   btnleftbrace: tstockglyphbutton;
   btnrightbracket: tstockglyphbutton;
   btnleftbracket: tstockglyphbutton;
   btnspace2: tstockglyphbutton;
   btnright2: tstockglyphbutton;
   btnleft2: tstockglyphbutton;
   btnless: tstockglyphbutton;
   btnsection: tstockglyphbutton;
   btntilde: tstockglyphbutton;
   btndoublequote: tstockglyphbutton;
   btnparenright: tstockglyphbutton;
   btngreater: tstockglyphbutton;
   woptions: tsimplewidget;
   wautocapital: tbooleanedit;
   btnclose: tstockglyphbutton;
   wlang: tstringgrid;
   procedure widgetactivechangeexe(const oldwidget: twidget;
                   const newwidget: twidget);
   procedure btn1_onexecute(const sender: TObject);
   procedure btn2_onexecute(const sender: TObject);
   procedure btn3_onexecute(const sender: TObject);
   procedure btn4_onexecute(const sender: TObject);
   procedure btn5_onexecute(const sender: TObject);
   procedure btn6_onexecute(const sender: TObject);
   procedure btn7_onexecute(const sender: TObject);
   procedure btn8_onexecute(const sender: TObject);
   procedure btn9_onexecute(const sender: TObject);
   procedure btn0_onexecute(const sender: TObject);
   procedure btndec_onexecute(const sender: TObject);
   procedure btnenter_onexecute(const sender: TObject);
   procedure btnback_onexecute(const sender: TObject);
   procedure btndel_onexecute(const sender: TObject);
   procedure btnq_onexecute(const sender: TObject);
   procedure btnw_onexecute(const sender: TObject);
   procedure btne_onexecute(const sender: TObject);
   procedure btnr_onexecute(const sender: TObject);
   procedure btnt_onexecute(const sender: TObject);
   procedure btny_onexecute(const sender: TObject);
   procedure btnu_onexecute(const sender: TObject);
   procedure btni_onexecute(const sender: TObject);
   procedure btno_onexecute(const sender: TObject);
   procedure btnp_onexecute(const sender: TObject);
   procedure btna_onexecute(const sender: TObject);
   procedure btns_onexecute(const sender: TObject);
   procedure btnd_onexecute(const sender: TObject);
   procedure btnf_onexecute(const sender: TObject);
   procedure btng_onexecute(const sender: TObject);
   procedure btnh_onexecute(const sender: TObject);
   procedure btnj_onexecute(const sender: TObject);
   procedure btnk_onexecute(const sender: TObject);
   procedure btnl_onexecute(const sender: TObject);
   procedure btnaposthrope_onexecute(const sender: TObject);
   procedure btnshift_onexecute(const sender: TObject);
   procedure btnz_onexecute(const sender: TObject);
   procedure btnx_onexecute(const sender: TObject);
   procedure btnc_onexecute(const sender: TObject);
   procedure btnv_onexecute(const sender: TObject);
   procedure btnb_onexecute(const sender: TObject);
   procedure btnn_onexecute(const sender: TObject);
   procedure btnm_onexecute(const sender: TObject);
   procedure btncomma_onexecute(const sender: TObject);
   procedure btnperiod_onexecute(const sender: TObject);
   procedure btnquestion_onexecute(const sender: TObject);
   procedure btnup_onexecute(const sender: TObject);
   procedure btnsymbols_onexecute(const sender: TObject);
   procedure btnctrl_onexecute(const sender: TObject);
   procedure btnspace_onexecute(const sender: TObject);
   procedure btnleft_onexecute(const sender: TObject);
   procedure btnright_onexecute(const sender: TObject);
   procedure btndown_onexecute(const sender: TObject);
   procedure form_onshow(const sender: TObject);
   procedure btnabc_onexecute(const sender: TObject);
   procedure btntab_onexecute(const sender: TObject);
   procedure btneclam_onexecute(const sender: TObject);
   procedure btnat_onexecute(const sender: TObject);
   procedure btnnumsign_onexecute(const sender: TObject);
   procedure btndollar_onexecute(const sender: TObject);
   procedure btnpercent_onexecute(const sender: TObject);
   procedure btnampersand_onexecute(const sender: TObject);
   procedure btnparentleft_onexecute(const sender: TObject);
   procedure btnparentright_onexecute(const sender: TObject);
   procedure btnminus_onexecute(const sender: TObject);
   procedure btnunderscore_onexecute(const sender: TObject);
   procedure btnequal_onexecute(const sender: TObject);
   procedure btnplus_onexecute(const sender: TObject);
   procedure btnbackslash_onexecute(const sender: TObject);
   procedure btnsemicolon_onexecute(const sender: TObject);
   procedure btncolon_onexecute(const sender: TObject);
   procedure btndoublequote_onexecute(const sender: TObject);
   procedure btnasterisk_onexecute(const sender: TObject);
   procedure btnslash_onexecute(const sender: TObject);
   procedure btnleftbracket_onexecute(const sender: TObject);
   procedure btnrightbracket_onexecute(const sender: TObject);
   procedure btnleftbrace_onexecute(const sender: TObject);
   procedure btnrightbrace_onexecute(const sender: TObject);
   procedure btnvertbar_onexecute(const sender: TObject);
   procedure btntilde_onexecute(const sender: TObject);
   procedure btncaret_onexecute(const sender: TObject);
   procedure btnsection_onexecute(const sender: TObject);
   procedure btnless_onexecute(const sender: TObject);
   procedure btngreater_onexecute(const sender: TObject);
   procedure btnprev_onexecute(const sender: TObject);
   procedure btnnext_onexecute(const sender: TObject);
   procedure btncloseoptions_onexecute(const sender: TObject);
   procedure btnoptions_onexecute(const sender: TObject);
  protected
   finputwidget: twidget;
   fshiftstate: shiftstatesty;
   procedure changelower;
   PROCEDURE changeupper;
   procedure linkinputwidget(const awidget: twidget);
   procedure unlinkinputwidget;
   procedure updatewindowpos;
   procedure objectevent(const sender: tobject; 
                        const event: objecteventty); override;
  public
   destructor destroy; override;
 end;

var
 frmkeyboardfo: tfrmkeyboardfo;
implementation
uses
 frmkeyboard_mfm,msekeyboard;

destructor tfrmkeyboardfo.destroy;
begin
 unlinkinputwidget;
 inherited;
end;

procedure tfrmkeyboardfo.changelower;
begin
 btnq.caption:= 'q';
 btnw.caption:= 'w';
 btne.caption:= 'e';
 btnr.caption:= 'r';
 btnt.caption:= 't';
 btny.caption:= 'y';
 btnu.caption:= 'u';
 btni.caption:= 'i';
 btno.caption:= 'o';
 btnp.caption:= 'p';
 btna.caption:= 'a';
 btns.caption:= 's';
 btnd.caption:= 'd';
 btnf.caption:= 'f';
 btng.caption:= 'g';
 btnh.caption:= 'h';
 btnj.caption:= 'j';
 btnk.caption:= 'k';
 btnl.caption:= 'l';
 btnaposthrope.caption:= '''';
 btnz.caption:= 'z';
 btnx.caption:= 'x';
 btnc.caption:= 'c';
 btnv.caption:= 'v';
 btnb.caption:= 'b';
 btnn.caption:= 'n';
 btnm.caption:= 'm';
 btncomma.caption:= ';';
 btnperiod.caption:= ':';
 btnquestion.caption:= '!';
end;

procedure tfrmkeyboardfo.changeupper;
begin
 btnq.caption:= 'Q';
 btnw.caption:= 'W';
 btne.caption:= 'E';
 btnr.caption:= 'R';
 btnt.caption:= 'T';
 btny.caption:= 'Y';
 btnu.caption:= 'U';
 btni.caption:= 'I';
 btno.caption:= 'O';
 btnp.caption:= 'P';
 btna.caption:= 'A';
 btns.caption:= 'S';
 btnd.caption:= 'D';
 btnf.caption:= 'F';
 btng.caption:= 'G';
 btnh.caption:= 'H';
 btnj.caption:= 'J';
 btnk.caption:= 'K';
 btnl.caption:= 'L';
 btnaposthrope.caption:= '"';
 btnz.caption:= 'Z';
 btnx.caption:= 'X';
 btnc.caption:= 'C';
 btnv.caption:= 'V';
 btnb.caption:= 'B';
 btnn.caption:= 'N';
 btnm.caption:= 'M';
 btncomma.caption:= ',';
 btnperiod.caption:= '.';
 btnquestion.caption:= '?';
end;

procedure tfrmkeyboardfo.linkinputwidget(const awidget: twidget);
begin
 setlinkedvar(awidget,tmsecomponent(finputwidget));
 if finputwidget <> nil then begin
  finputwidget.window.registermovenotification(ievent(self));
 end;
end;

procedure tfrmkeyboardfo.unlinkinputwidget;
begin
 if finputwidget <> nil then begin
  finputwidget.window.unregistermovenotification(ievent(self));
 end;
 setlinkedvar(nil,tmsecomponent(finputwidget));
                //automatically nil'd if inputwidget has been destroyed
end;

procedure tfrmkeyboardfo.updatewindowpos;
begin
 if finputwidget <> nil then begin
  widgetrect:= placepopuprect(finputwidget,mr(nullpoint,finputwidget.size),
                                                  cp_bottomleft,size);
 end;
end;

procedure tfrmkeyboardfo.widgetactivechangeexe(const oldwidget: twidget;
                                                  const newwidget: twidget);
var
 bo1 : boolean;
begin
 bo1:= false;
 if (newwidget <> nil) then begin
  if not checkdescendent(newwidget) and ((newwidget is tcustomdataedit) and not tcustomdataedit(newwidget).readonly) then begin
   if (newwidget is tcustomrealedit) then begin
    bo1:= true;
    btndec.visible:= true;
    self.width:= 200;
    wnumbers.left:= 0;
    wnumbers.visible:= true;
    wchars.visible:= false;
    wsymbols.visible:= false;
    woptions.visible:= false;
   end else if (newwidget is tcustomintegeredit) or (newwidget is tcustomint64edit) then begin
    bo1:= true;
    btndec.visible:= false;
    self.width:= 200;
    wnumbers.left:= 0;
    wnumbers.visible:= true;
    wchars.visible:= false;
    wsymbols.visible:= false;
    woptions.visible:= false;
   end else if (newwidget is tcustomstringedit) then begin
    bo1:= true;
    btndec.visible:= true;
    self.width:= 632;
    wnumbers.left:= 432;
    wnumbers.visible:= false;
    wchars.visible:= true;
    wsymbols.visible:= false;
    woptions.visible:= false;
    changelower;
   end;
  end;
 end;
 if bo1 then begin
  linkinputwidget(newwidget);
  updatewindowpos;
  show(ml_none,newwidget.window);
 end else begin
  unlinkinputwidget;
  hide;
 end;
end;

procedure tfrmkeyboardfo.objectevent(const sender: tobject;
                                               const event: objecteventty);
begin
 inherited;
 if (finputwidget <> nil) and (event = oe_changed) and 
                      (sender = finputwidget.window) then begin
  updatewindowpos;  
 end;              
end;

//bo_nocandefocus must be set in button options
procedure tfrmkeyboardfo.btn1_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_1,fshiftstate,false,'1');
 end;
end;

procedure tfrmkeyboardfo.btn2_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_2,fshiftstate,false,'2');
 end;
end;

procedure tfrmkeyboardfo.btn3_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_3,fshiftstate,false,'3');
 end;
end;

procedure tfrmkeyboardfo.btn4_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_4,fshiftstate,false,'4');
 end;
end;

procedure tfrmkeyboardfo.btn5_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_5,fshiftstate,false,'5');
 end;
end;

procedure tfrmkeyboardfo.btn6_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_6,fshiftstate,false,'6');
 end;
end;

procedure tfrmkeyboardfo.btn7_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_7,fshiftstate,false,'7');
 end;
end;

procedure tfrmkeyboardfo.btn8_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_8,fshiftstate,false,'8');
 end;
end;

procedure tfrmkeyboardfo.btn9_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_9,fshiftstate,false,'9');
 end;
end;

procedure tfrmkeyboardfo.btn0_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_0,fshiftstate,false,'0');
 end;
end;

procedure tfrmkeyboardfo.btndec_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_decimal,fshiftstate,false,'.');
 end;
end;

procedure tfrmkeyboardfo.btnenter_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_return,fshiftstate,false,'');
  unlinkinputwidget;
  hide;
 end;
end;

procedure tfrmkeyboardfo.btnback_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Backspace,fshiftstate,false,'');
 end;
end;

procedure tfrmkeyboardfo.btndel_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Delete,fshiftstate,false,'');
 end;
end;

procedure tfrmkeyboardfo.btnq_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Q,fshiftstate,false,btnq.caption);
 end;
end;

procedure tfrmkeyboardfo.btnw_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_W,fshiftstate,false,btnw.caption);
 end;
end;

procedure tfrmkeyboardfo.btne_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_E,fshiftstate,false,btne.caption);
 end;
end;

procedure tfrmkeyboardfo.btnr_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_R,fshiftstate,false,btnr.caption);
 end;
end;

procedure tfrmkeyboardfo.btnt_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_T,fshiftstate,false,btnt.caption);
 end;
end;

procedure tfrmkeyboardfo.btny_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Y,fshiftstate,false,btny.caption);
 end;
end;

procedure tfrmkeyboardfo.btnu_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_U,fshiftstate,false,btnu.caption);
 end;
end;

procedure tfrmkeyboardfo.btni_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_I,fshiftstate,false,btni.caption);
 end;
end;

procedure tfrmkeyboardfo.btno_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_O,fshiftstate,false,btno.caption);
 end;
end;

procedure tfrmkeyboardfo.btnp_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_P,fshiftstate,false,btnp.caption);
 end;
end;

procedure tfrmkeyboardfo.btna_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_A,fshiftstate,false,btna.caption);
 end;
end;

procedure tfrmkeyboardfo.btns_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_S,fshiftstate,false,btns.caption);
 end;
end;

procedure tfrmkeyboardfo.btnd_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_D,fshiftstate,false,btnd.caption);
 end;
end;

procedure tfrmkeyboardfo.btnf_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_F,fshiftstate,false,btnf.caption);
 end;
end;

procedure tfrmkeyboardfo.btng_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_G,fshiftstate,false,btng.caption);
 end;
end;

procedure tfrmkeyboardfo.btnh_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_H,fshiftstate,false,btnh.caption);
 end;
end;

procedure tfrmkeyboardfo.btnj_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_J,fshiftstate,false,btnj.caption);
 end;
end;

procedure tfrmkeyboardfo.btnk_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_K,fshiftstate,false,btnk.caption);
 end;
end;

procedure tfrmkeyboardfo.btnl_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_L,fshiftstate,false,btnl.caption);
 end;
end;

procedure tfrmkeyboardfo.btnaposthrope_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  if not (ss_shift in fshiftstate) then
   finputwidget.window.postkeyevent(key_Apostrophe,fshiftstate,false,btnaposthrope.caption)
  else
   finputwidget.window.postkeyevent(key_QuoteDbl,fshiftstate,false,btnaposthrope.caption)
 end;
end;

procedure tfrmkeyboardfo.btnshift_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  if not (ss_shift in fshiftstate) then begin
   include(fshiftstate, ss_shift);
   btnshift.colorglyph:= cl_ltgreen;
   changeupper;
  end else begin
   exclude(fshiftstate, ss_shift);
   btnshift.colorglyph:= cl_black;
   changelower;
  end;
  finputwidget.window.postkeyevent(key_shift,fshiftstate,false,'');
 end;
end;

procedure tfrmkeyboardfo.btnz_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Z,fshiftstate,false,btnz.caption);
 end;
end;

procedure tfrmkeyboardfo.btnx_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_X,fshiftstate,false,btnx.caption);
 end;
end;

procedure tfrmkeyboardfo.btnc_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_C,fshiftstate,false,btnc.caption);
 end;
end;

procedure tfrmkeyboardfo.btnv_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_V,fshiftstate,false,btnv.caption);
 end;
end;

procedure tfrmkeyboardfo.btnb_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_B,fshiftstate,false,btnb.caption);
 end;
end;

procedure tfrmkeyboardfo.btnn_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_N,fshiftstate,false,btnn.caption);
 end;
end;

procedure tfrmkeyboardfo.btnm_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_M,fshiftstate,false,btnm.caption);
 end;
end;

procedure tfrmkeyboardfo.btncomma_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  if not (ss_shift in fshiftstate) then
   finputwidget.window.postkeyevent(key_Comma,fshiftstate,false,btncomma.caption)
  else
   finputwidget.window.postkeyevent(key_Semicolon,fshiftstate,false,btncomma.caption);
 end;
end;

procedure tfrmkeyboardfo.btnperiod_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  if not (ss_shift in fshiftstate) then
   finputwidget.window.postkeyevent(key_period,fshiftstate,false,btnperiod.caption)
  else
   finputwidget.window.postkeyevent(key_division,fshiftstate,false,btnperiod.caption);
 end;
end;

procedure tfrmkeyboardfo.btnquestion_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  if not (ss_shift in fshiftstate) then
   finputwidget.window.postkeyevent(key_Question,fshiftstate,false,btnquestion.caption)
  else
   finputwidget.window.postkeyevent(key_Exclam,fshiftstate,false,btnquestion.caption);
 end;
end;

procedure tfrmkeyboardfo.btnup_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Up,fshiftstate,false,'');
 end;
end;

procedure tfrmkeyboardfo.btnsymbols_onexecute(const sender: TObject);
begin
 wchars.visible:= false;
 wnumbers.left:= 432;
 wnumbers.visible:= true;
 wsymbols.visible:= true;
end;

procedure tfrmkeyboardfo.btnctrl_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  if not (ss_ctrl in fshiftstate) then begin
   include(fshiftstate, ss_ctrl);
   btnctrl.colorglyph:= cl_ltgreen;
  end else begin
   exclude(fshiftstate, ss_ctrl);
   btnctrl.colorglyph:= cl_black;
  end;
 end;
end;

procedure tfrmkeyboardfo.btnspace_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Space,fshiftstate,false,' ');
 end;
end;

procedure tfrmkeyboardfo.btnleft_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Left,fshiftstate,false,'');
 end;
end;

procedure tfrmkeyboardfo.btnright_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Right,fshiftstate,false,'');
 end;
end;

procedure tfrmkeyboardfo.btndown_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Down,fshiftstate,false,'');
 end;
end;

procedure tfrmkeyboardfo.form_onshow(const sender: TObject);
begin
 fshiftstate:= [];
end;

procedure tfrmkeyboardfo.btnabc_onexecute(const sender: TObject);
begin
 wchars.visible:= true;
 wnumbers.visible:= false;
 wsymbols.visible:= false;
end;

procedure tfrmkeyboardfo.btntab_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Tab,fshiftstate,false,'');
 end;
end;

procedure tfrmkeyboardfo.btneclam_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Exclam,fshiftstate,false,'!');
 end;
end;

procedure tfrmkeyboardfo.btnat_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_At,fshiftstate,false,'@');
 end;
end;

procedure tfrmkeyboardfo.btnnumsign_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_NumberSign,fshiftstate,false,'#');
 end;
end;

procedure tfrmkeyboardfo.btndollar_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Dollar,fshiftstate,false,'$');
 end;
end;

procedure tfrmkeyboardfo.btnpercent_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Percent,fshiftstate,false,'%');
 end;
end;

procedure tfrmkeyboardfo.btnampersand_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Ampersand,fshiftstate,false,'&');
 end;
end;

procedure tfrmkeyboardfo.btnparentleft_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_ParenLeft,fshiftstate,false,'(');
 end;
end;

procedure tfrmkeyboardfo.btnparentright_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_ParenRight,fshiftstate,false,')');
 end;
end;

procedure tfrmkeyboardfo.btnminus_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Minus,fshiftstate,false,'-');
 end;
end;

procedure tfrmkeyboardfo.btnunderscore_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_UnderScore,fshiftstate,false,'_');
 end;
end;

procedure tfrmkeyboardfo.btnequal_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Equal,fshiftstate,false,'=');
 end;
end;

procedure tfrmkeyboardfo.btnplus_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Plus,fshiftstate,false,'+');
 end;
end;

procedure tfrmkeyboardfo.btnbackslash_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Backslash,fshiftstate,false,'\');
 end;
end;

procedure tfrmkeyboardfo.btnsemicolon_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Semicolon,fshiftstate,false,';');
 end;
end;

procedure tfrmkeyboardfo.btncolon_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Colon,fshiftstate,false,':');
 end;
end;

procedure tfrmkeyboardfo.btndoublequote_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_QuoteDbl,fshiftstate,false,'"');
 end;
end;

procedure tfrmkeyboardfo.btnasterisk_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Asterisk,fshiftstate,false,'*');
 end;
end;

procedure tfrmkeyboardfo.btnslash_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Slash,fshiftstate,false,'/');
 end;
end;

procedure tfrmkeyboardfo.btnleftbracket_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_BracketLeft,fshiftstate,false,'[');
 end;
end;

procedure tfrmkeyboardfo.btnrightbracket_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_BracketRight,fshiftstate,false,']');
 end;
end;

procedure tfrmkeyboardfo.btnleftbrace_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_BraceLeft,fshiftstate,false,'{');
 end;
end;

procedure tfrmkeyboardfo.btnrightbrace_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_BraceRight,fshiftstate,false,'}');
 end;
end;

procedure tfrmkeyboardfo.btnvertbar_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Bar,fshiftstate,false,'|');
 end;
end;

procedure tfrmkeyboardfo.btntilde_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_AsciiTilde,fshiftstate,false,'~');
 end;
end;

procedure tfrmkeyboardfo.btncaret_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_AsciiCircum,fshiftstate,false,'^');
 end;
end;

procedure tfrmkeyboardfo.btnsection_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Section,fshiftstate,false,'`');
 end;
end;

procedure tfrmkeyboardfo.btnless_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Less,fshiftstate,false,'<');
 end;
end;

procedure tfrmkeyboardfo.btngreater_onexecute(const sender: TObject);
begin
 if finputwidget <> nil then begin
  finputwidget.window.postkeyevent(key_Greater,fshiftstate,false,'>');
 end;
end;

procedure tfrmkeyboardfo.btnprev_onexecute(const sender: TObject);
begin
 //for others symbol/language
end;

procedure tfrmkeyboardfo.btnnext_onexecute(const sender: TObject);
begin
 //for others symbol/language
end;

procedure tfrmkeyboardfo.btncloseoptions_onexecute(const sender: TObject);
begin
 woptions.visible:= false;
 wchars.visible:= true;
end;

procedure tfrmkeyboardfo.btnoptions_onexecute(const sender: TObject);
begin
 wchars.visible:= false;
 wsymbols.visible:= false;
 woptions.visible:= true;
end;

end.
