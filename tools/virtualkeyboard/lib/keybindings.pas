{ MSEgui Copyright (c) 2014 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit keybindings;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msestrings,msekeyboard,mseguiglob;

const
 keymax = 99;
type
 keyinfoty = record
  key: keyty;
  shiftstate: shiftstatesty; //[] -> current, [ss_none] -> force []
  chars: msestring;
  caption: msestring; //'' -> same as chars
 end;
 keybindingsty = array[0..keymax] of keyinfoty;
 pkeybindingsty = ^keybindingsty;
 
 keyboardlangty = record
  name: msestring;
  lower: pkeybindingsty;
  upper: pkeybindingsty;
 end;

 keylangty = (kl_en,kl_de,kl_ru,kl_uzcyr,kl_fr,kl_es,kl_zh);

const
 qwertylower: keybindingsty = (
  (key: key_q; shiftstate: []; chars: 'q'; caption: ''),                 //0     
  (key: key_w; shiftstate: []; chars: 'w'; caption: ''),                 //1
  (key: key_e; shiftstate: []; chars: 'e'; caption: ''),                 //2     
  (key: key_r; shiftstate: []; chars: 'r'; caption: ''),                 //3     
  (key: key_t; shiftstate: []; chars: 't'; caption: ''),                 //4     
  (key: key_y; shiftstate: []; chars: 'y'; caption: ''),                 //5     
  (key: key_u; shiftstate: []; chars: 'u'; caption: ''),                 //6     
  (key: key_i; shiftstate: []; chars: 'i'; caption: ''),                 //7     
  (key: key_o; shiftstate: []; chars: 'o'; caption: ''),                 //8     
  (key: key_p; shiftstate: []; chars: 'p'; caption: ''),                 //9     
  (key: key_backspace; shiftstate: [ss_none]; chars: '';
                                                  caption: 'Backspace'), //10     
  (key: key_delete; shiftstate: [ss_none]; chars: ''; caption: 'Del'),   //11     
  (key: key_a; shiftstate: []; chars: 'a'; caption: ''),                 //12    
  (key: key_s; shiftstate: []; chars: 's'; caption: ''),                 //13    
  (key: key_d; shiftstate: []; chars: 'd'; caption: ''),                 //14    
  (key: key_f; shiftstate: []; chars: 'f'; caption: ''),                 //15    
  (key: key_g; shiftstate: []; chars: 'g'; caption: ''),                 //16    
  (key: key_h; shiftstate: []; chars: 'h'; caption: ''),                 //17    
  (key: key_j; shiftstate: []; chars: 'j'; caption: ''),                 //18    
  (key: key_k; shiftstate: []; chars: 'k'; caption: ''),                 //19    
  (key: key_l; shiftstate: []; chars: 'l'; caption: ''),                 //20     
  (key: key_apostrophe; shiftstate: []; chars: ''''; caption: ''),       //21     
  (key: key_return; shiftstate: [ss_none]; chars: ''; caption: 'Enter'), //22    
  (key: key_shift; shiftstate: []; chars: ''; caption: 'Shift'),         //23    
  (key: key_z; shiftstate: []; chars: 'z'; caption: ''),                 //24    
  (key: key_x; shiftstate: []; chars: 'x'; caption: ''),                 //25    
  (key: key_c; shiftstate: []; chars: 'c'; caption: ''),                 //26    
  (key: key_v; shiftstate: []; chars: 'v'; caption: ''),                 //27    
  (key: key_b; shiftstate: []; chars: 'b'; caption: ''),                 //28    
  (key: key_n; shiftstate: []; chars: 'n'; caption: ''),                 //29    
  (key: key_m; shiftstate: []; chars: 'm'; caption: ''),                 //30    
  (key: key_comma; shiftstate: []; chars: ','; caption: ''),             //31     
  (key: key_period; shiftstate: []; chars: '.'; caption: ''),            //32     
  (key: key_question; shiftstate: []; chars: '?'; caption: ''),          //33    
  (key: key_up; shiftstate: []; chars: ''; caption: ''),                 //34    
  (key: key_control; shiftstate: []; chars: ''; caption: 'Ctrl'),        //35    
  (key: key_space; shiftstate: [ss_none]; chars: ' '; caption: 'Space'), //36    
  (key: key_left; shiftstate: []; chars: ''; caption: ''),               //37    
  (key: key_down; shiftstate: []; chars: ''; caption: ''),               //38    
  (key: key_right; shiftstate: []; chars: ''; caption: ''),              //39    
  
  (key: key_1; shiftstate: []; chars: '1'; caption: ''),                 //40     
  (key: key_2; shiftstate: []; chars: '2'; caption: ''),                 //41     
  (key: key_3; shiftstate: []; chars: '3'; caption: ''),                 //42    
  (key: key_backspace; shiftstate: [ss_none]; chars: '';
                                                  caption: 'Back'),      //43    
  (key: key_4; shiftstate: []; chars: '4'; caption: ''),                 //44    
  (key: key_5; shiftstate: []; chars: '5'; caption: ''),                 //45    
  (key: key_6; shiftstate: []; chars: '6'; caption: ''),                 //46    
  (key: key_delete; shiftstate: [ss_none]; chars: ''; caption: 'Del'),   //47    
  (key: key_7; shiftstate: []; chars: '7'; caption: ''),                 //48    
  (key: key_8; shiftstate: []; chars: '8'; caption: ''),                 //49    
  (key: key_9; shiftstate: []; chars: '9'; caption: ''),                 //50     
  (key: key_0; shiftstate: []; chars: '0'; caption: ''),                 //51     
  (key: key_decimal; shiftstate: []; chars: '.'; caption: ''),           //52    
  (key: key_return; shiftstate: [ss_none]; chars: ''; caption: 'Enter'), //53    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //54    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //55    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //56    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //57    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //58    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //59
      
  (key: key_tab; shiftstate: []; chars: ''; caption: 'Tab'),             //60    
  (key: key_exclam; shiftstate: []; chars: '!'; caption: ''),            //61    
  (key: key_at; shiftstate: []; chars: '@'; caption: ''),                //62    
  (key: key_numbersign; shiftstate: []; chars: '#'; caption: ''),        //63    
  (key: key_dollar; shiftstate: []; chars: '$'; caption: ''),            //64    
  (key: key_percent; shiftstate: []; chars: '%'; caption: ''),           //65    
  (key: key_ampersand; shiftstate: []; chars: '&'; caption: '&&'),       //66    
  (key: key_parenleft; shiftstate: []; chars: '('; caption: ''),         //67    
  (key: key_parenright; shiftstate: []; chars: ')'; caption: ''),        //68    
  (key: key_minus; shiftstate: []; chars: '-'; caption: ''),             //69    
  (key: key_underscore; shiftstate: []; chars: '_'; caption: ''),        //70    
  (key: key_equal; shiftstate: []; chars: '='; caption: ''),             //71    
  (key: key_plus; shiftstate: []; chars: '+'; caption: ''),              //72    
  (key: key_backslash; shiftstate: []; chars: '\'; caption: ''),         //73    
  (key: key_semicolon; shiftstate: []; chars: ';'; caption: ''),         //74    
  (key: key_colon; shiftstate: []; chars: ':'; caption: ''),             //75    
  (key: key_quotedbl; shiftstate: []; chars: '"'; caption: ''),          //76    
  (key: key_asterisk; shiftstate: []; chars: '*'; caption: ''),          //77    
  (key: key_slash; shiftstate: []; chars: '/'; caption: ''),             //78    
  (key: key_bracketleft; shiftstate: []; chars: '['; caption: ''),       //79    
  (key: key_bracketright; shiftstate: []; chars: ']'; caption: ''),      //80    
  (key: key_braceleft; shiftstate: []; chars: '{'; caption: ''),         //81    
  (key: key_braceright; shiftstate: []; chars: '}'; caption: ''),        //82  
  (key: key_bar; shiftstate: []; chars: '|'; caption: ''),               //83  
  (key: key_asciitilde; shiftstate: []; chars: '~'; caption: ''),        //84  
    
  (key: key_asciicircum; shiftstate: []; chars: '^'; caption: ''),       //85    
  (key: key_section; shiftstate: []; chars: '`'; caption: ''),           //86    
  (key: key_less; shiftstate: []; chars: '<'; caption: ''),              //87    
  (key: key_greater; shiftstate: []; chars: '>'; caption: ''),           //88    
  (key: key_left; shiftstate: []; chars: ''; caption: ''),               //89    
  (key: key_right; shiftstate: []; chars: ''; caption: ''),              //90    
  (key: key_space; shiftstate: [ss_none]; chars: ' '; caption: 'Space'), //91    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //92    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //93    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //94    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //95    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //96    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //97    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //98    
  (key: key_none; shiftstate: []; chars: ''; caption: '')                //99    
 );
 
 qwertyupper: keybindingsty = (
  (key: key_q; shiftstate: []; chars: 'Q'; caption: ''),                 //0     
  (key: key_w; shiftstate: []; chars: 'W'; caption: ''),                 //1
  (key: key_e; shiftstate: []; chars: 'E'; caption: ''),                 //2     
  (key: key_r; shiftstate: []; chars: 'R'; caption: ''),                 //3     
  (key: key_t; shiftstate: []; chars: 'T'; caption: ''),                 //4     
  (key: key_y; shiftstate: []; chars: 'Y'; caption: ''),                 //5     
  (key: key_u; shiftstate: []; chars: 'U'; caption: ''),                 //6     
  (key: key_i; shiftstate: []; chars: 'I'; caption: ''),                 //7     
  (key: key_o; shiftstate: []; chars: 'O'; caption: ''),                 //8     
  (key: key_p; shiftstate: []; chars: 'P'; caption: ''),                 //9     
  (key: key_backspace; shiftstate: [ss_none]; chars: '';
                                                  caption: 'Backspace'), //10     
  (key: key_delete; shiftstate: [ss_none]; chars: ''; caption: 'Del'),   //11     
  (key: key_a; shiftstate: []; chars: 'A'; caption: ''),                 //12    
  (key: key_s; shiftstate: []; chars: 'S'; caption: ''),                 //13    
  (key: key_d; shiftstate: []; chars: 'D'; caption: ''),                 //14    
  (key: key_f; shiftstate: []; chars: 'F'; caption: ''),                 //15    
  (key: key_g; shiftstate: []; chars: 'G'; caption: ''),                 //16    
  (key: key_h; shiftstate: []; chars: 'H'; caption: ''),                 //17    
  (key: key_j; shiftstate: []; chars: 'J'; caption: ''),                 //18    
  (key: key_k; shiftstate: []; chars: 'K'; caption: ''),                 //19    
  (key: key_l; shiftstate: []; chars: 'L'; caption: ''),                 //20     
  (key: key_quotedbl; shiftstate: []; chars: '"'; caption: ''),          //21     
  (key: key_return; shiftstate: [ss_none]; chars: ''; caption: 'Enter'), //22    
  (key: key_shift; shiftstate: []; chars: ''; caption: 'Shift'),         //23    
  (key: key_z; shiftstate: []; chars: 'Z'; caption: ''),                 //24    
  (key: key_x; shiftstate: []; chars: 'X'; caption: ''),                 //25    
  (key: key_c; shiftstate: []; chars: 'C'; caption: ''),                 //26    
  (key: key_v; shiftstate: []; chars: 'V'; caption: ''),                 //27    
  (key: key_b; shiftstate: []; chars: 'B'; caption: ''),                 //28    
  (key: key_n; shiftstate: []; chars: 'N'; caption: ''),                 //29    
  (key: key_m; shiftstate: []; chars: 'M'; caption: ''),                 //20    
  (key: key_semicolon; shiftstate: []; chars: ';'; caption: ''),         //31     
  (key: key_division; shiftstate: []; chars: '/'; caption: ''),          //32     
  (key: key_exclam; shiftstate: []; chars: '!'; caption: ''),            //33    
  (key: key_up; shiftstate: []; chars: ''; caption: ''),                 //34    
  (key: key_control; shiftstate: []; chars: ''; caption: 'Ctrl'),        //35    
  (key: key_space; shiftstate: [ss_none]; chars: ' '; caption: 'Space'), //36    
  (key: key_left; shiftstate: []; chars: ''; caption: ''),               //37    
  (key: key_down; shiftstate: []; chars: ''; caption: ''),               //38    
  (key: key_right; shiftstate: []; chars: ''; caption: ''),              //39    

  (key: key_1; shiftstate: []; chars: '1'; caption: ''),                 //40     
  (key: key_2; shiftstate: []; chars: '2'; caption: ''),                 //41     
  (key: key_3; shiftstate: []; chars: '3'; caption: ''),                 //42    
  (key: key_backspace; shiftstate: [ss_none]; chars: '';
                                                  caption: 'Back'),      //43    
  (key: key_4; shiftstate: []; chars: '4'; caption: ''),                 //44    
  (key: key_5; shiftstate: []; chars: '5'; caption: ''),                 //45    
  (key: key_6; shiftstate: []; chars: '6'; caption: ''),                 //46    
  (key: key_delete; shiftstate: []; chars: ''; caption: 'Del'),          //47    
  (key: key_7; shiftstate: []; chars: ''; caption: ''),                  //48    
  (key: key_8; shiftstate: []; chars: ''; caption: ''),                  //49    
  (key: key_9; shiftstate: []; chars: ''; caption: ''),                  //50     
  (key: key_0; shiftstate: []; chars: '0'; caption: ''),                 //51     
  (key: key_decimal; shiftstate: []; chars: '.'; caption: ''),           //52    
  (key: key_return; shiftstate: [ss_none]; chars: ''; caption: 'Enter'), //53    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //54    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //55    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //56    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //57    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //58    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //59    

  (key: key_tab; shiftstate: []; chars: ''; caption: 'Tab'),             //60    
  (key: key_exclam; shiftstate: []; chars: '!'; caption: ''),            //61    
  (key: key_at; shiftstate: []; chars: '@'; caption: ''),                //62    
  (key: key_numbersign; shiftstate: []; chars: '#'; caption: ''),        //63    
  (key: key_dollar; shiftstate: []; chars: '$'; caption: ''),            //64    
  (key: key_percent; shiftstate: []; chars: '%'; caption: ''),           //65    
  (key: key_ampersand; shiftstate: []; chars: '&'; caption: ''),         //66    
  (key: key_parenleft; shiftstate: []; chars: '('; caption: ''),         //67    
  (key: key_parenright; shiftstate: []; chars: ')'; caption: ''),        //68    
  (key: key_minus; shiftstate: []; chars: '-'; caption: ''),             //69    
  (key: key_underscore; shiftstate: []; chars: '_'; caption: ''),        //70    
  (key: key_equal; shiftstate: []; chars: '='; caption: ''),             //71    
  (key: key_plus; shiftstate: []; chars: '+'; caption: ''),              //72    
  (key: key_backslash; shiftstate: []; chars: '\'; caption: ''),         //73    
  (key: key_semicolon; shiftstate: []; chars: ';'; caption: ''),         //74    
  (key: key_colon; shiftstate: []; chars: ':'; caption: ''),             //75    
  (key: key_quotedbl; shiftstate: []; chars: '"'; caption: ''),          //76    
  (key: key_asterisk; shiftstate: []; chars: '*'; caption: ''),          //77    
  (key: key_slash; shiftstate: []; chars: '/'; caption: ''),             //78    
  (key: key_bracketleft; shiftstate: []; chars: '['; caption: ''),       //79    
  (key: key_bracketright; shiftstate: []; chars: ']'; caption: ''),      //80    
  (key: key_braceleft; shiftstate: []; chars: '{'; caption: ''),         //81    
  (key: key_braceright; shiftstate: []; chars: '}'; caption: ''),        //82    
  (key: key_asciicircum; shiftstate: []; chars: '^'; caption: ''),       //83    
  (key: key_section; shiftstate: []; chars: '`'; caption: ''),           //84    
  (key: key_less; shiftstate: []; chars: '<'; caption: ''),              //85    
  (key: key_greater; shiftstate: []; chars: '>'; caption: ''),           //86    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //87    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //88    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //89    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //90    
  (key: key_none; shiftstate: [ss_none]; chars: ''; caption: ''),        //91    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //92    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //93    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //94    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //95    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //96    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //97    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),               //98    
  (key: key_none; shiftstate: []; chars: ''; caption: '')                //99     
 );

var
 keyboardlangs: array of keyboardlangty;
 keylang : keylangty;
 
procedure setitem(var item: keyboardlangty;
           const name: msestring;
           const qwertylowerpo: pkeybindingsty;
           const qwertyupperpo: pkeybindingsty);

procedure registerkeyboardlang(const name: msestring; const qwertylowerpo: pkeybindingsty; const qwertyupperpo: pkeybindingsty);
 
implementation

procedure setitem(var item: keyboardlangty;
           const name: msestring;
           const qwertylowerpo: pkeybindingsty;
           const qwertyupperpo: pkeybindingsty);
begin
 item.name:= name;
 item.lower:= qwertylowerpo;
 item.upper:= qwertyupperpo;
end;

procedure registerkeyboardlang(const name: msestring; const qwertylowerpo: pkeybindingsty; const qwertyupperpo: pkeybindingsty);
var
 int1: integer;
begin
 for int1:= 0 to high(keyboardlangs) do begin
  if keyboardlangs[int1].name = name then begin
   setitem(keyboardlangs[int1],name,qwertylowerpo,qwertyupperpo);
   exit;
  end;
 end;
 setlength(keyboardlangs,high(keyboardlangs)+2);
 setitem(keyboardlangs[high(keyboardlangs)],name,qwertylowerpo,qwertyupperpo);
end;

initialization
 registerkeyboardlang('English',@qwertylower,@qwertyupper);
 keylang:= kl_en;
end.
