unit main;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,mseforms,msewidgets,msebitmap,
 msedataedits,msedatanodes,mseedit,msefiledialog,msegrids,mseifiglob,
 mselistbrowser,msestrings,msesys,msetypes,msedock,msestatfile,
 msesysdnd,msemime;

type
 tmainfo = class(tdockform,imimesource)
   source: tsimplewidget;
   dest: tsimplewidget;
   sourcedata: tfilenameedit;
   destdata: tstringgrid;
   formatdisp: tstringgrid;
   tstatfile1: tstatfile;
   procedure dragbeginexe(const asender: tobject; const apos: pointty;
                   var adragobject: tdragobject; var processed: boolean);
   procedure dragoverexe(const asender: tobject; const apos: pointty;
                   var adragobject: tdragobject; var accept: boolean;
                   var processed: boolean);
   procedure dragdropexe(const asender: tobject; const apos: pointty;
                   var adragobject: tdragobject; var processed: boolean);
  protected
   procedure convertmimedata(const sender: tmimedragobject;
                             var adata: string; const atypeindex: integer);
   procedure convertmimetext(const sender: tmimedragobject;
                          var adata: msestring; const atypeindex: integer );
 end;

var
 mainfo: tmainfo;

implementation
uses
 main_mfm,msearrayutils,sysutils;

const 
 knownformats: array[0..1] of msestring = ('text/uri-list','CF_HDROP');
type
 dropfilesty = record
  pfiles: dword;
  pt: pointty;    
  fnc: longbool;    
  fwide: longbool;  
 end;           
 pdropfilesty = ^dropfilesty;
 
procedure tmainfo.dragbeginexe(const asender: tobject; const apos: pointty;
               var adragobject: tdragobject; var processed: boolean);
begin
 if widgetatpos(apos) = source then begin
  tsysmimedragobject.createwrite(asender,adragobject,nullpoint,
                   msestringarty(knownformats),[],[dnda_copy],imimesource(self));
 end;
 processed:= true;
end;

procedure tmainfo.convertmimedata(const sender: tmimedragobject;
               var adata: string; const atypeindex: integer);
var
 mstr1: msestring;
 int1: integer;
begin
 case atypeindex of
  0: begin
   adata:= 'file://'+sourcedata.value+c_return+c_linefeed;
                 //hosname missing!
  end;
  1: begin  
   mstr1:= sourcedata.sysvalue;
   int1:= length(mstr1);
   setlength(mstr1,int1+2);
   mstr1[int1+1]:= #0;
   mstr1[int1+2]:= #0;
   setlength(adata,sizeof(dropfilesty)+length(mstr1)*sizeof(msechar));
   with pdropfilesty(pointer(adata))^ do begin
    pfiles:= sizeof(dropfilesty);
//    pt:= sender.droppos;
//    fnc:= true;
    pt:= nullpoint;
    fnc:= false;
    fwide:= true;
   end;
   move(mstr1[1],adata[sizeof(dropfilesty)+1],length(mstr1)*sizeof(msechar));
  end;
 end;
end;

procedure tmainfo.convertmimetext(const sender: tmimedragobject;
               var adata: msestring; const atypeindex: integer);
begin
 //dummy
end;

procedure tmainfo.dragoverexe(const asender: tobject; const apos: pointty;
               var adragobject: tdragobject; var accept: boolean;
               var processed: boolean);
begin
 if adragobject is tmimedragobject then begin
  with tmimedragobject(adragobject) do begin
   actions:= [dnda_copy];
   formatdisp[0].datalist.asarray:= formats;
   if checkformat(msestringarty(knownformats)) then begin
    if widgetatpos(apos) = dest then begin
     accept:= true;
    end;
    processed:= true;
   end;
  end;
 end;
end;

procedure tmainfo.dragdropexe(const asender: tobject; const apos: pointty;
               var adragobject: tdragobject; var processed: boolean);
var
 ar1: msestringarty;
 po1: pdropfilesty;
 pc1,pc2: pchar;
 pw1,pw2: pmsechar;
 pend: pointer;
begin
 if adragobject is tmimedragobject then begin
  with tmimedragobject(adragobject) do begin
   case wantedformatindex of 
    0: begin
     ar1:= breaklines(msestring(trim(data)));
     if (ar1 <> nil) and (ar1[high(ar1)] = '') then begin
      setlength(ar1,high(ar1));
     end;
    end;
    1: begin
     if length(data) > sizeof(dropfilesty) then begin
      po1:= pointer(data);
      pend:= pointer(po1)+length(data);
      if po1^.fwide then begin
       pw1:= pointer(po1) + po1^.pfiles;
       while pw1 < pend do begin
        pw2:= pw1;
        while (pw1 < pend) and (pw1^ <> #0) do begin
         inc(pw1);
        end;
        additem(ar1,psubstr(pw2,pw1));
        if pw1^ <> #0 then begin
         break;
        end;
        inc(pw1);
        if pw1^ = #0 then begin
         break;
        end;
       end;
      end
      else begin
       pc1:= pointer(po1) + po1^.pfiles;
       while pc1 < pend do begin
        pc2:= pc1;
        while (pc1 < pend) and (pc1^ <> #0) do begin
         inc(pc1);
        end;
        additem(ar1,psubstr(pc2,pc1));
        if pc1^ <> #0 then begin
         break;
        end;
        inc(pc1);
        if pc1^ <> #0 then begin
         break;
        end;
       end;
      end;
     end;
    end;
   end;
   destdata[0].datalist.asarray:= ar1;
  end;
  processed:= true;
 end;
end;

end.
