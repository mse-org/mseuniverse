{*********************************************************}
{              Dialog For TRepazEvaluator                 }
{     Base idea from  :  Toni Martir (Reportman Author    }
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
unit frmevaldialog;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseapplication,msestat,msegui,msegraphics,msegraphutils,
 mseclasses,mseforms,msedataedits,msestrings,msesimplewidgets,msewidgets,
 msegrids,repazdatasources,repazevaluator,repazconsts,classes,mseconsts,
 repazevaluatortype,msesplitter,mseedit,msemenus,msetypes,msewidgetgrid,
 mseinplaceedit,msescrollbar,msestatfile,msegridsglob,sysutils,mseifiglob,
 mseeditglob,msesyntaxedit,msetextedit,msesyntaxpainter;

const
 fmaxlisthelp=6;

 expressionsyntax = 
  'caseinsensitive'+lineend+
  'styles'+lineend+
  ' default '''''+lineend+
  ' words ''b'' cl_dkblue'+lineend+
  ' comment ''i'' cl_dkyellow'+lineend+
  ' option ''b'' cl_dkgreen'+lineend+
  ' string '''' cl_dkred'+lineend+
  ' '+lineend+
  'keyworddefs evaluator'+lineend+
  ' ''TRUE'' ''FALSE'' ''TODAY'' ''TIME'' ''NOW'' ''NULL'' ''SIN'' ''MAX'''+LINEEND+
  ' ''MIN'' ''FLOATTODATETIME'' ''STRINGTOTIME'' ''STRINGTODATETIME'' ''TIMETOSTRING'''+LINEEND+
  ' ''DATETIMETOSTRING'' ''DAYOFWEEK'' ''ROUND'' ''ROUNDTOINTEGER'' ''INT'' ''ABS'''+LINEEND+
  ' ''COMPAREVALUE'' ''SQRT'' ''ISINTEGER'' ''ISNUMERIC'' ''ISVALIDDATETIME'' ''CHECKEXPRESSION'''+LINEEND+
  ' ''STRINGTOBIN'' ''STR'' ''VAL'' ''LEFT'' ''LENGTH'' ''TRIM'' ''POS'' ''MOD'''+LINEEND+
  ' ''MONTHNAME'' ''MONTH'' ''YEAR'' ''DAY'' ''RIGHT'' ''SUBSTR'' ''FORMATSTR'' ''FORMATNUM'''+LINEEND+
  ' ''UPPERCASE'' ''LOWERCASE'' ''EVALTEXT'' ''NUMTOTEXT'' ''REPLACESTR'' ''FIELDWITHKEY'''+LINEEND+
  ' ''ISHOLIDAY'' ''ISDISCOUNTDAY'' ''PAGENUMBER'' ''REPORTHEADER'' ''REPORTFOOTER'' ''PAGEHEADER'''+LINEEND+
  ' ''PAGEFOOTER'' ''CONTENTHEADER'' ''CONTENTFOOTER'' ''TABLEHEADER'' ''TABLEFOOTER'''+LINEEND+
  ' ''CONTENTDATA'' ''GROUPHEADER'' ''GROUPFOOTER'' ''GROUPDATA'' ''RECORDNUMBER'' ''MASTERNUMBER'''+LINEEND+
  ' ''DATANUMBER'' ''GROUPNUMBER'' ''HEADERTREEKEY'' ''FOOTERTREEKEY'' ''TREEFOOTERVALUE'' ''LETTERVALUE'''+LINEEND+
  ' ''IIF'' ''AND'' ''OR'' ''NOT'' ''+'' ''-'' ''*'' ''/'' ''='' ''=='''+LINEEND+
  ''+lineend+
  'scope comment1 comment'+lineend+
  ' endtokens'+lineend+
  '  ''*/'''+lineend+
  '  '+lineend+
  'scope comment2 comment'+lineend+
  ' endtokens'+lineend+
  '  '''''+lineend+
  '  '+lineend+
  'scope string string'+lineend+
  ' endtokens'+lineend+
  '  '''''''' '''''+lineend+
  '  '+lineend+
  'scope main'+lineend+
  ''+lineend+
  ' keywords words'+lineend+
  '  evaluator'+lineend+
  ' calltokens'+lineend+
  '  ''/*'' comment1'+lineend+
  '  ''--'' comment2'+lineend+
  '  '''''''' string'+lineend;

type
 tevalrechelp=class(tobject)
 public
  rfunction:string;
  help:string;
  model:string;
  params:string;
 end;

 tfrmevaldialogfo = class(tmseform)
   LItems: tstringgrid;
   LCategory: tstringgrid;
   lparams: tlabel;
   lmodel: tlabel;
   lhelp: tlabel;
   tlayouter1: tlayouter;
   bclear: tbutton;
   bshowresult: tbutton;
   bchecksyn: tbutton;
   tbutton3: tbutton;
   badd: tbutton;
   tlayouter2: tlayouter;
   bcancel: tbutton;
   bok: tbutton;
   tsimplewidget1: tsimplewidget;
   tsplitter1: tsplitter;
   tsplitter2: tsplitter;
   wformula: twidgetgrid;
   textedit: tsyntaxedit;
   tsyntaxpainter1: tsyntaxpainter;
   procedure frmevaldialogfo_oncreate(const sender: tobject);
   procedure frmevaldialogfo_ondestroy(const sender: tobject);
   procedure badd_onexecute(const sender: tobject);
   procedure bchecksyn_onexecute(const sender: tobject);
   procedure bshowresult_onexecute(const sender: tobject);
   procedure lcategory_oncellevent(const sender: tobject;
                   var info: celleventinfoty);
   procedure litems_oncellevent(const sender: tobject;
                   var info: celleventinfoty);
   procedure bok_onexecute(const sender: tobject);
   procedure bclear_onexecute(const sender: TObject);
   procedure frmevaldialogfo_onstatafterread(const sender: TObject);
   procedure doasyncevent(var atag: integer); override;
   procedure clearbrackets;
   procedure checkbrackets;
   procedure callcheckbrackets;
   procedure textedit_oneditnotifcation(const sender: TObject;
                   var info: editnotificationinfoty);
   procedure frmevaldialogfo_onloaded(const sender: TObject);
  private
   validate:boolean;
   aresult:variant;
   fevaluator:trepazcustomevaluator;
   fbracket1,fbracket2: gridcoordty;
   fbracketsetting,fbracketchecking: integer;
   llistes:array[0..fmaxlisthelp-1] of tstringlist;
   procedure setevaluator(aval:trepazcustomevaluator);
  public
   property evaluator:trepazcustomevaluator read fevaluator write setevaluator;
 end;

 trepazevaldialog = class(tcomponent)
 private
  fexpression:msestring;
  fevaldatasource:trepazdatasources;
  fevaluator:trepazevaluator;
  frmevaldialogfo: tfrmevaldialogfo;
 protected
  procedure notification(acomponent:tcomponent;operation:toperation);override;
 public
  constructor create(aowner:tcomponent);override;
  destructor destroy;override;
  function execute:boolean;
 published
  property expression:msestring read fexpression write fexpression;
  property datasource:trepazdatasources read fevaldatasource write fevaldatasource;
  property evaluator:trepazevaluator read fevaluator write fevaluator;
 end;

 
function changeexpression(formul:string;aval:trepazcustomevaluator):string;
function changeexpressionw(formul:msestring;aval:trepazcustomevaluator):msestring;
function expressioncalculatew(formul:msestring;aval:trepazcustomevaluator):variant;

implementation
uses
 frmevaldialog_mfm;
 
function changeexpression(formul:string;aval:trepazcustomevaluator):string;
var
 dia:tfrmevaldialogfo;
begin
 dia:=tfrmevaldialogfo.create(application);
 try
  if not assigned(aval) then
   dia.evaluator:=trepazevaluator.create(dia)
  else
   dia.evaluator:=aval;
  dia.textedit.settext(formul);
  result:=formul;
  if dia.show=mr_ok then
   result:=dia.textedit.gettext;
 finally
  dia.free;
 end;
end;

function changeexpressionw(formul:msestring;aval:trepazcustomevaluator):msestring;
var
 dia:tfrmevaldialogfo;
begin
 dia:=tfrmevaldialogfo.create(application);
 try
  if not assigned(aval) then
   dia.evaluator:=trepazevaluator.create(dia)
  else
   dia.evaluator:=aval;
  dia.textedit.settext(formul);
  result:=formul;
  if dia.show(true)=mr_ok then
   result:=dia.textedit.gettext;
 finally
  dia.free;
 end;
end;

function expressioncalculatew(formul:msestring;aval:trepazcustomevaluator):variant;
var
 dia:tfrmevaldialogfo;
begin
 result:=null;
 dia:=tfrmevaldialogfo.create(application);
 try
  dia.validate:=true;
  if not assigned(aval) then
   dia.evaluator:=trepazevaluator.create(dia)
  else
   dia.evaluator:=aval;
  dia.textedit.settext(formul);
  result:=dia.aresult;
  if dia.show(true)=mr_ok then
   result:=dia.aresult;
 finally
  dia.free;
 end;
end;

{ trepazevaldialog }

function trepazevaldialog.execute:boolean;
begin
 if fevaldatasource<>nil then fevaluator.datasource:=fevaldatasource;
  try
   frmevaldialogfo:= tfrmevaldialogfo.create(nil);
   frmevaldialogfo.evaluator:=fevaluator;
   frmevaldialogfo.textedit.settext(expression);
   result:= false;
   if frmevaldialogfo.show(true)=mr_ok then begin
    result:= true;
    expression:=frmevaldialogfo.textedit.gettext;
   end;
  finally
   frmevaldialogfo.destroy;
  end;
end;

constructor trepazevaldialog.create(aowner:tcomponent);
begin
 inherited create(aowner);
 fevaluator:=trepazevaluator.create(self);
 fexpression:='';
end;

destructor trepazevaldialog.destroy;
begin
 //fevaluator:= nil;
 inherited;
end;

procedure trepazevaldialog.notification(acomponent:tcomponent;operation:toperation);
begin
 inherited notification(acomponent,operation);
 if operation=opremove then begin
  if acomponent=fevaldatasource then begin
   datasource:=nil;
  end else begin
   if acomponent=fevaluator then begin
    fevaluator:=nil;
   end;
  end;
 end;
end;

procedure tfrmevaldialogfo.frmevaldialogfo_oncreate(const sender: tobject);
var
 i:integer;
begin
 inherited;
 //wformula.activate;
 for i:=0 to fmaxlisthelp-1 do begin
  llistes[i]:=tstringlist.create;
 end;
 bok.caption:=uc(ord(rcsok));
 bcancel.caption:=uc(ord(rcscancel));
 caption:=uc(ord(rcsexpcreator));
 lcategory.frame.caption:=uc(ord(rcscategory));
 litems.frame.caption:=uc(ord(rcsoperation));
 badd.caption:=uc(ord(rcsaddselection));
 bchecksyn.caption:=uc(ord(rcssyntaxcheck));
 bshowresult.caption:=uc(ord(rcsshowresult));
 bclear.caption:=uc(ord(rcsclear));
end;

procedure tfrmevaldialogfo.frmevaldialogfo_ondestroy(const sender: tobject);
var
 i,j:integer;
begin
  inherited;
 for i:=0 to fmaxlisthelp-1 do
 begin
  for j:=0 to llistes[i].count-1 do
  begin
   llistes[i].objects[j].free;
  end;
  llistes[i].free;
 end;
end;

procedure tfrmevaldialogfo.badd_onexecute(const sender: tobject);
begin
 if litems.row>=0 then begin
  textedit.beginupdate;
  if textedit.gettext='' then begin
   textedit.settext(litems[0][litems.row])
  end else begin
   textedit.inserttext(litems[0][litems.row]);
  end;
  textedit.endupdate;
 end;
end;

procedure tfrmevaldialogfo.bchecksyn_onexecute(const sender: tobject);
begin
 evaluator.expression:=textedit.gettext;
 try
  evaluator.checksyntax;
  showmessage(uc(ord(rcsmsgTrueSyntax)));
 except
  wformula.setfocus;
  textedit.editor.selstart:=evaluator.poserror;
  textedit.editor.sellength:=0;
  raise;
 end;
end;

procedure tfrmevaldialogfo.bshowresult_onexecute(const sender: tobject);
begin
 evaluator.expression:=textedit.gettext;
 try
  evaluator.evaluate;
 except
  wformula.setfocus;
  textedit.editor.selstart:=evaluator.poserror;
  textedit.editor.sellength:=0;
  raise;
 end;
 showmessage(tevalvaluetostring(evaluator.evalresult));
end;

procedure tfrmevaldialogfo.lcategory_oncellevent(const sender: tobject;
               var info: celleventinfoty);
var
 int1: integer;
begin
 if (info.eventkind=cek_buttonrelease) or (info.eventkind=cek_keyup) then begin
  litems.clear;
  for int1:=0 to llistes[lcategory.row].count-1 do begin
   litems.appendrow(llistes[lcategory.row].strings[int1]);
  end;
  lhelp.caption:='';
  lparams.caption:='';
  lmodel.caption:='';
 end;
end;

procedure tfrmevaldialogfo.litems_oncellevent(const sender: tobject;
               var info: celleventinfoty);
begin
 if LItems.rowcount<=0 then exit;
 if (info.eventkind=cek_buttonrelease) or (info.eventkind=cek_keyup) then
 begin
  lhelp.caption:=(llistes[lcategory.row].objects[litems.row] 
   as tevalrechelp).help;
  lparams.caption:=(llistes[lcategory.row].objects[litems.row]
   as tevalrechelp).params;
  lmodel.caption:=(llistes[lcategory.row].objects[litems.row]
   as tevalrechelp).model;
 end;
 
 if iscellclick(info,[ccr_dblclick]) then
 begin
  textedit.beginupdate;
  if textedit.gettext='' then begin
   textedit.settext(litems[0][litems.row])
  end else begin
   textedit.inserttext(litems[0][litems.row]);
  end;
  textedit.endupdate;
 end;
end;

procedure tfrmevaldialogfo.bok_onexecute(const sender: tobject);
begin
 if validate then
 begin
  evaluator.expression:=textedit.gettext;
  try
   evaluator.evaluate;
   aresult:=evaluator.evalresult;
  except
   wformula.setfocus;
   textedit.editor.selstart:=evaluator.poserror;
   textedit.editor.sellength:=0;
   raise;
  end;
 end;
 close;
end;

procedure tfrmevaldialogfo.setevaluator(aval:trepazcustomevaluator);
var
 lista1:tstringlist;
 i:integer;
 iden:tevalidentifier;
 rec:tevalrechelp;
begin
 fevaluator:=aval;
 lcategory.clear;
 lcategory.appendrow(uc(ord(rcsdbfields)));
 lcategory.appendrow(uc(ord(rcsfunctions)));
 lcategory.appendrow(uc(ord(rcsvariables)));
 lcategory.appendrow(uc(ord(rcsconstants)));
 if fevaluator.withreport then begin
  lcategory.appendrow(uc(ord(rcsreportfunctions)));
 end;
 lcategory.appendrow(uc(ord(rcsoperators)));
 for i:=0 to fmaxlisthelp-1 do
 begin
  llistes[i].clear;
 end;
 lista1:=llistes[0];
 if aval.datasource<>nil then
 begin
  aval.datasource.fillwithfields(lista1);
  for i:=0 to lista1.count -1 do
  begin
   rec:=tevalrechelp.create;
   rec.rfunction:=lista1.strings[i];
   lista1.objects[i]:=rec;
  end;
 end;
 for i:=0 to aval.identifiers.count-1 do
 begin
  iden:=tevalidentifier(aval.identifiers.objects[i]);

  if iden<>nil then begin
   case iden.rtype of
    rtypeidenfunction:
     begin
     lista1:=llistes[1];
     end;
    rtypeidenvariable:
     begin
      lista1:=llistes[2];
     end;
    rtypeidenconstant:
     begin
      lista1:=llistes[3];
     end;
    rtypeidenreport:
     begin
      lista1:=llistes[4];
     end;
   end;
  	rec:=tevalrechelp.create;
   rec.rfunction:=aval.identifiers.strings[i];
   rec.help:=iden.help;
   rec.model:=iden.model;
   rec.params:=iden.aparams;
   lista1.addobject(rec.rfunction,rec);
  end;
 end;
 if fevaluator.withreport then begin
  lista1:=llistes[5];
 end else begin
  lista1:=llistes[4];
 end;
 // +
 rec:=tevalrechelp.create;
 rec.rfunction:='+';
 rec.help:=uc(ord(rcsoperatorsum));
 lista1.addobject(rec.rfunction,rec);
 // -
 rec:=tevalrechelp.create;
 rec.rfunction:='-';
 rec.help:=uc(ord(rcsoperatordif));
 lista1.addobject(rec.rfunction,rec);
 // *
 rec:=tevalrechelp.create;
 rec.rfunction:='*';
 rec.help:=uc(ord(rcsoperatormul));
 lista1.addobject(rec.rfunction,rec);
 // /
 rec:=tevalrechelp.create;
 rec.rfunction:='/';
 rec.help:=uc(ord(rcsoperatordiv));
 lista1.addobject(rec.rfunction,rec);
 // =
 rec:=tevalrechelp.create;
 rec.rfunction:='=';
 rec.help:=uc(ord(rcsoperatorcomp));
 lista1.addobject(rec.rfunction,rec);
 // ==
 rec:=tevalrechelp.create;
 rec.rfunction:='==';
 rec.help:=uc(ord(rcsoperatorcomp));
 lista1.addobject(rec.rfunction,rec);
 // >=
 rec:=tevalrechelp.create;
 rec.rfunction:='>=';
 rec.help:=uc(ord(rcsoperatorcomp));
 lista1.addobject(rec.rfunction,rec);
 // <=
 rec:=tevalrechelp.create;
 rec.rfunction:='<=';
 rec.help:=uc(ord(rcsoperatorcomp));
 lista1.addobject(rec.rfunction,rec);
 // >
 rec:=tevalrechelp.create;
 rec.rfunction:='>';
 rec.help:=uc(ord(rcsoperatorcomp));
 lista1.addobject(rec.rfunction,rec);
 // <
 rec:=tevalrechelp.create;
 rec.rfunction:='<';
 rec.help:=uc(ord(rcsoperatorcomp));
 lista1.addobject(rec.rfunction,rec);
 // <>
 rec:=tevalrechelp.create;
 rec.rfunction:='<>';
 rec.help:=uc(ord(rcsoperatorcomp));
 lista1.addobject(rec.rfunction,rec);
 // iif
 rec:=tevalrechelp.create;
 rec.rfunction:='IIF';
 rec.help:=uc(ord(rcsoperatordec));
 rec.model:=uc(ord(rcsoperatordecm));
 rec.params:=uc(ord(rcsoperatordecp));
 lista1.addobject(rec.rfunction,rec);
 // and
 rec:=tevalrechelp.create;
 rec.rfunction:='AND';
 rec.help:=uc(ord(rcsoperatorlog));
 lista1.addobject(rec.rfunction,rec);
 // or
 rec:=tevalrechelp.create;
 rec.rfunction:='OR';
 rec.help:=uc(ord(rcsoperatorlog));
 lista1.addobject(rec.rfunction,rec);
 // not
 rec:=tevalrechelp.create;
 rec.rfunction:='NOT';
 rec.help:=uc(ord(rcsoperatorlog));
 lista1.addobject(rec.rfunction,rec);
 // ;
 rec:=tevalrechelp.create;
 rec.rfunction:=';';
 rec.help:=uc(ord(rcsoperatorsep));
 rec.params:=uc(ord(rcsoperatorsepp));
 lista1.addobject(rec.rfunction,rec);
 lcategory.row:=0;
end;

procedure tfrmevaldialogfo.bclear_onexecute(const sender: TObject);
begin
 textedit.settext('');
end;

procedure tfrmevaldialogfo.frmevaldialogfo_onstatafterread(const sender: TObject);
begin
 self.visible:= false;
end;

procedure tfrmevaldialogfo.doasyncevent(var atag: integer);
var
 mstr1: filenamety;
begin
 case atag of
  99: begin
   dec(fbracketchecking);
   checkbrackets;
  end;
 end;
end;

procedure tfrmevaldialogfo.clearbrackets;
begin
 if (fbracket1.col >= 0) and (fbracketsetting = 0) then begin
  inc(fbracketsetting);
  try
   with textedit do begin
    setfontstyle(fbracket1,makegridcoord(fbracket1.col+1,fbracket1.row),
                                   fs_bold,false);
    setfontstyle(fbracket2,makegridcoord(fbracket2.col+1,fbracket2.row),
                                   fs_bold,false);
    refreshsyntax(fbracket1.row,1);
    refreshsyntax(fbracket2.row,1);
    fbracket1:= invalidcell;
    fbracket2:= invalidcell;
    if syntaxpainterhandle >= 0 then begin
     syntaxpainter.boldchars[syntaxpainterhandle]:= nil;
    end;
   end;
  finally
   dec(fbracketsetting);
  end;
 end;  
end;

procedure tfrmevaldialogfo.checkbrackets;
var
 mch1: msechar;
 br1,br2: bracketkindty;
 open,open2: boolean;
 pt1,pt2: gridcoordty;
 ar1: gridcoordarty;
begin
 clearbrackets;
 pt2:= invalidcell;
 with textedit do begin
  pt1:= editpos;
  mch1:= charatpos(pt1);
  br1:= checkbracketkind(mch1,open);
  if (br1 <> bki_none) and (pt1.col > 0) then begin
   dec(pt1.col);
   br2:= checkbracketkind(charatpos(pt1),open2);
   if (br2 = bki_none) or (open <> open2) then begin
    inc(pt1.col);
   end
   else begin
    br1:= br2;
   end;
   pt2:= matchbracket(pt1,br1,open);
  end
  else begin
   dec(pt1.col);
   if pt1.col >= 0 then begin
    mch1:= charatpos(pt1);
    br1:= checkbracketkind(mch1,open);
    if br1 <> bki_none then begin
     pt2:= matchbracket(pt1,br1,open);
    end;
   end;
  end;
  if pt2.col >= 0 then begin
   fbracket1:= pt1;
   fbracket2:= pt2;
   inc(fbracketsetting);
   try
    setfontstyle(pt1,makegridcoord(pt1.col+1,pt1.row),fs_bold,true);
    setfontstyle(pt2,makegridcoord(pt2.col+1,pt2.row),fs_bold,true);
   finally
    dec(fbracketsetting);
   end;
   if syntaxpainterhandle >= 0 then begin
    setlength(ar1,2);
    ar1[0]:= fbracket1;
    ar1[1]:= fbracket2;
    syntaxpainter.boldchars[syntaxpainterhandle]:= ar1;
    refreshsyntax(fbracket1.row,1);
    refreshsyntax(fbracket2.row,1);
   end;
  end;
 end;
end;

procedure tfrmevaldialogfo.callcheckbrackets;
begin
 if (fbracketchecking = 0) then begin
  inc(fbracketchecking);
  asyncevent(99);
 end;
end;

procedure tfrmevaldialogfo.textedit_oneditnotifcation(const sender: TObject;
               var info: editnotificationinfoty);
begin
 if (info.action = ea_beforechange) and not textedit.syntaxchanging then begin
  clearbrackets;
 end
 else begin
  if info.action in [ea_indexmoved,ea_delchar,ea_deleteselection,ea_pasteselection,
                     ea_textentered] then begin
   callcheckbrackets;
  end;
 end;
end;

procedure tfrmevaldialogfo.frmevaldialogfo_onloaded(const sender: TObject);
begin
 tsyntaxpainter1.readdeffile(expressionsyntax);
 textedit.setsyntaxdef(0);
end;

end.
