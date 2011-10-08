{ Contributed module by Tolstov Igor  (attid@yandex.ru) for MSEgui(c)

    See the file COPYING.MSE the part of the MSEgui distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

unit main;

{$ifdef FPC}{$mode objfpc}{$h+}{$INTERFACES CORBA}{$endif}

{

Task we get csv file (see test.csv)
it have next structure

series,number,barcode,

we must let user create sample disain and print it

with this project we will try work with MSE report in run time

special senks to IvankoB i see his project \mse\trunk\contributed\ivankob\examples\print_testcase 

and to Martin an it patience to answer on my question =) 

Attid attid@yandex.ru

}

interface

uses
 mseglob,msegui,mseclasses,mseforms,msesimplewidgets,msemenus,msereport,
 msedbedit,msesqldb,msedb,msedbgraphics,mseevent,mseactions,msebitmap,
 mseibconnection,msefiledialog, msestrings,msesplitter,msegraphics,
 msegraphutils,msewidgets,msedataedits,mseedit,msepostscriptprinter,mseprinter,
 msetypes,msegdiprint,msedatanodes,msegrids,mselistbrowser,msesys,msestat,
 msestatfile,mseimage,msedispwidgets,msegraphedits;

type
 tmainfo = class(tmseform)
   tbutton5: tbutton;
   myfilenameedit: tfilenameedit;
   tstatfile1: tstatfile;
   efon: teventwidget;
   bk: tstringdisp;
   ebk: teventwidget;
   ser: tstringdisp;
   eser: teventwidget;
   num: tlabel;
   enum: teventwidget;
   barcode: timage;
   ebarcode: teventwidget;
   r_pb: tpaintbox;
   tsimplewidget1: tsimplewidget;
   tlabel2: tlabel;
   sx: tintegeredit;
   sy: tintegeredit;
   tlabel5: tlabel;
   nx: tintegeredit;
   ny: tintegeredit;
   tlabel8: tlabel;
   cx: tintegeredit;
   cy: tintegeredit;
   tlabel11: tlabel;
   bx: tintegeredit;
   by: tintegeredit;
   bh: tintegeredit;
   bw: tintegeredit;
   zw: tintegeredit;
   zh: tintegeredit;
   tlabel18: tlabel;
   printcmd: tfilenameedit;
   cbUsePipe: tbooleanedit;
   procedure create_report_with_out_hate_mouse(const sender: TObject);
   procedure bf1(const sender: tcustomrecordband; var empty: Boolean);
   procedure onmouseevent(const sender: twidget; var info: mouseeventinfoty);
   procedure formcreate(const sender: TObject);
   procedure SaveToEdit;
   procedure onpreamble(const sender: tcustomreport; var apreamble: AnsiString);
   procedure bkpaint(const sender: twidget; const canvas: tcanvas);
   procedure retorepos(const sender: TObject);
 end;

var
 mainfo: tmainfo; // main form
 lastpos: pointty; // save last positon of widget 
 ch_cx: boolean;  // save last width of widget 
 ch_cy: boolean;  // save last heigth of widget 
 ch_drag: boolean;  // save drug state
 csvfile : TextFile; // file to print
 
 
implementation

uses
 main_mfm,
 msestream, // ttextstream
 sysutils,  // gettemp*
 mseprocutils, //execmse2 
 mseguiglob,  // bt_left
 msefileutils, // tosysfilepath 
 msepointer; // cursorshapety

procedure tmainfo.SaveToEdit;
begin
  sx.value := ser.bounds_x;
  sy.value := ser.bounds_y;

  nx.value := num.bounds_x;
  ny.value := num.bounds_y;

  cx.value := bk.bounds_x;
  cy.value := bk.bounds_y;

  zh.value := efon.bounds_cy;
  zw.value := efon.bounds_cx;

  bx.value := barcode.bounds_x;
  by.value := barcode.bounds_y;
  bw.value := barcode.bounds_cx;
  bh.value := barcode.bounds_cy;

end;


procedure tmainfo.bf1(const sender: tcustomrecordband;
               var empty: Boolean);
var s : string;
begin

  if not Eof(csvfile) then
  begin
    readln (csvfile,s);
//    showmessage(s);
    ser.value := copy(s,1,system.pos(',',s)-1);
    s := copy(s,system.pos(',',s)+1,length(s));

    num.caption := copy(s,1,system.pos(',',s)-1);
    s := copy(s,system.pos(',',s)+1,length(s));

    bk.value := copy(s,1,system.pos(',',s)-1);

    empty := False;
  end;
    
end;  

procedure tmainfo.create_report_with_out_hate_mouse(const sender: TObject);
var 
  myps: tpostscriptprinter;
  myreport : treport;
  myreportpage : treportpage;
  mytilearea : ttilearea;
  myrecordband: trecordband;

  vcolcount : integer;

  mystream : ttextstream;
  mybandgroup : tbandgroup;  

  tmpfilename : string;
  
begin
// check file 
  
  if not FileExists(tosysfilepath(myfilenameedit.value)) then 
  begin
    ShowMessage('File not exist');
    exit;
  end;

// i create this sample 
// not becouse i hate mouse =) , only becouse 
// people after read it sample will can create report 
// using mouse and will understand how it work
// when i see print_testcase by ivankob i can`t understand some think

// at first we mast create some object 
// we can drop it on form using mouse

// printer 
  myps := tpostscriptprinter.create(self);
// at this samle we print under windows and use gsview32.exe to preview
//myps.printcommand := 'C:/Program Files/Ghostgum/gsview/gsview32.exe';

// can create by - 'File'-'New'-Form'-'Report'. 
  myreport := treport.create(nil,false);
//  myreport.options := [reo_autorelease];
  myreport.onpreamble := @onpreamble;
  myreportpage := treportpage.create(myreport);
  myreport.insertwidget(myreportpage);

// create tile area to print many small recordband
  mytilearea := ttilearea.create(myreportpage);
  myreportpage.insertwidget(mytilearea,makepoint(0,0));
// set size
  vcolcount := 570 div efon.bounds_cx;
  mytilearea.colcount := vcolcount;
  mytilearea.bounds_cx := efon.bounds_cx * vcolcount;

  vcolcount := 810 div efon.bounds_cy;
  mytilearea.rowcount := vcolcount;
  mytilearea.bounds_cy := efon.bounds_cy * vcolcount;

// create recordband
  myrecordband := trecordband.create(myreportpage);
  mytilearea.insertwidget(myrecordband);
//  myrecordband.options := [bo_once];
  myrecordband.onbeforerender := @bf1;

// set size 
  myrecordband.anchors := [an_left,an_top];
  myrecordband.bounds_cx := efon.bounds_cx;
  myrecordband.bounds_cy := efon.bounds_cy;

// add labels
  myrecordband.insertwidget(ser);
  myrecordband.insertwidget(num);
  myrecordband.insertwidget(bk);
//  myrecordband.insertwidget(ser,makepoint(sx.value,sy.value));
//  myrecordband.insertwidget(num,makepoint(nx.value,ny.value));
//  myrecordband.insertwidget(bk,makepoint(cx.value,cy.value));
  myrecordband.insertwidget(r_pb,makepoint(barcode.bounds_x,barcode.bounds_y));
  r_pb.visible := True;
  r_pb.bounds_cx := barcode.bounds_cx;
  r_pb.bounds_cy := barcode.bounds_cy;

// open file 
  AssignFile(csvfile, tosysfilepath(myfilenameedit.value));
  Reset(csvfile);

//print it 
  if cbUsePipe.value then
  begin
    // there can work kghostview,gnome-gv,gv,lp
    myreport.render(myps,tosysfilepath(printcmd.value)+' -');
    myreport.waitfor; //wait while report render to return items from report to form
  end  
  else
  begin
    // there can work kghostview,gnome-gv,gv,lp,evince,gsview32.exe
    tmpfilename := gettempfilename(gettempdir ,'myreport');
    //showmessage(tmpfilename);
    myreport.render(myps,ttextstream.create(tmpfilename,fm_create));
    myreport.waitfor; // wait while report create file
    execwaitmse(tosysfilepath(printcmd.value)+' '+tmpfilename,false);//evince
  end;  


  // return widget 
//  efon.insertwidget(ser,makepoint(sx.value,sy.value));
//  efon.insertwidget(num,makepoint(nx.value,ny.value));
//  efon.insertwidget(bk,makepoint(cx.value,cy.value));
  efon.insertwidget(ser);
  efon.insertwidget(num);
  efon.insertwidget(bk);
  r_pb.visible := false;
  efon.insertwidget(r_pb);
  // some time we can lost label
  // i don`t undestant why, but if we set position back all will be work =)
  retorepos(nil);
  
  CloseFile(csvfile);

  myreport.free;
  myps.free; 
end;

procedure tmainfo.onmouseevent(const sender: twidget;
               var info: mouseeventinfoty);
var
  w: twidget;
begin
  // get widget for move\resize
  case sender.tag of
    2: w := barcode;
    3: w := efon;
    4: w := ser;
    5: w := num;
    6: w := bk;
    else exit;
  end;

  if (info.eventkind = ek_buttonpress) and (info.button = mb_left) then 
  begin
    lastpos := info.pos;
    // start move
    if (application.widgetcursorshape = cr_arrow) and (w <> efon) then
    begin
      application.widgetcursorshape:= cr_drag;       
      ch_drag := True;
    end;  
    // start resize
    if (application.widgetcursorshape = cr_sizehor) then
      ch_cx := True;
    if (application.widgetcursorshape = cr_sizever) then
      ch_cy := True;
  end;  

  if (info.eventkind = ek_buttonrelease) and (info.button = mb_left) then 
  begin
    // end move
    if ch_drag then
    begin
      application.widgetcursorshape:= cr_arrow;        
      ch_drag := false;
      
      with w do 
      begin 
        if bounds_x > efon.bounds_cx - bounds_cx then
          bounds_x := efon.bounds_cx - bounds_cx;
        if bounds_y > efon.bounds_cy - bounds_cy then
          bounds_y := efon.bounds_cy - bounds_cy;

        if bounds_x < 0 then
          bounds_x := 0;
        if bounds_y < 0 then
          bounds_y := 0;
      end; 
    end;

    // end resize
    ch_cx := False;
    ch_cy := False;     
    
    SaveToEdit;
  end;  

  if (info.eventkind = ek_mousemove) and (ch_drag)  then 
  begin
    // move  
    with w do 
    begin 
      bounds_x := bounds_x - (lastpos.x - info.pos.x);
      bounds_y := bounds_y - (lastpos.y - info.pos.y);   
    end; 
  end;

  if (info.eventkind = ek_mousemove) and (not ch_drag)  then 
  begin
    // resize 
    if ch_cx then
      with w do 
      begin 
        bounds_cx := bounds_cx - (lastpos.x - info.pos.x);
        lastpos := info.pos;
        if bounds_cx < 4 then bounds_cx := 4;
      end
    else
    if ch_cy then
      with w do 
      begin 
        bounds_cy := bounds_cy - (lastpos.y - info.pos.y);
        lastpos := info.pos;     
        if bounds_cy < 4 then bounds_cy := 4;
      end
    else
    // set cursor
    if (info.pos.x > (sender.bounds_cx - 4)) then 
      application.widgetcursorshape:= cr_sizehor           
    else
    if (info.pos.y > (sender.bounds_cy - 4)) then 
      application.widgetcursorshape:= cr_sizever           
    else
      application.widgetcursorshape:= cr_arrow;       
  end;
  
end;

procedure tmainfo.formcreate(const sender: TObject);
begin
 ch_cx := False;
 ch_cy := False;
 ch_drag := false;
end;

procedure tmainfo.onpreamble(const sender: tcustomreport;
               var apreamble: AnsiString);
var
  stream1: ttextstream;
begin
  stream1:= ttextstream.create('barcode.ps');
  apreamble:= stream1.readdatastring;
  stream1.free;
end;

procedure tmainfo.bkpaint(const sender: twidget; const canvas: tcanvas);
begin
  // procedure to drow barcode using barcode.ps
  tpostscriptcanvas(canvas).pscommand(
   tpostscriptcanvas(canvas).posstring(
     makepoint(sender.innerclientpos.x+20,sender.innerclientpos.y+sender.innerclientsize.cy)) +            
    ' moveto (^104'+bk.value+') (height=5) code128 barcode'+lineend);
end;

procedure tmainfo.retorepos(const sender: TObject);
begin
  // restore position of widget after load
  if zw.value = 0 then exit;
  
  ser.bounds_x := sx.value;
  ser.bounds_y := sy.value;

  num.bounds_x := nx.value;
  num.bounds_y := ny.value;

  bk.bounds_x := cx.value;
  bk.bounds_y := cy.value;

  efon.bounds_cx := zw.value;
  efon.bounds_cy := zh.value;

  barcode.bounds_x := bx.value;
  barcode.bounds_y := by.value;
  barcode.bounds_cx := bw.value;
  barcode.bounds_cy := bh.value;

end;

end.
