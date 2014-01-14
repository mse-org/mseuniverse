{ MSEgui Copyright (c) 2014 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit keybindings_uzcyr;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msestrings,msekeyboard,keybindings;

const
 qwertylower: keybindingsty = (
  (key: key_q; chars: 'q'; caption: ''),                 //0     
  (key: key_w; chars: 'w'; caption: ''),                 //1
  (key: key_e; chars: 'e'; caption: ''),                 //2     
  (key: key_r; chars: 'r'; caption: ''),                 //3     
  (key: key_t; chars: 't'; caption: ''),                 //4     
  (key: key_y; chars: 'y'; caption: ''),                 //5     
  (key: key_u; chars: 'u'; caption: ''),                 //6     
  (key: key_i; chars: 'i'; caption: ''),                 //7     
  (key: key_o; chars: 'o'; caption: ''),                 //8     
  (key: key_p; chars: 'p'; caption: ''),                 //9     
  (key: key_backspace; chars: ''; caption: 'Backspace'), //10     
  (key: key_delete; chars: ''; caption: 'Del'),          //11     
  (key: key_a; chars: 'a'; caption: ''),                 //12    
  (key: key_s; chars: 's'; caption: ''),                 //13    
  (key: key_d; chars: 'd'; caption: ''),                 //14    
  (key: key_f; chars: 'f'; caption: ''),                 //15    
  (key: key_g; chars: 'g'; caption: ''),                 //16    
  (key: key_h; chars: 'h'; caption: ''),                 //17    
  (key: key_j; chars: 'j'; caption: ''),                 //18    
  (key: key_k; chars: 'k'; caption: ''),                 //19    
  (key: key_l; chars: 'l'; caption: ''),                 //20     
  (key: key_apostrophe; chars: ''''; caption: ''),       //21     
  (key: key_return; chars: ''; caption: 'Enter'),        //22    
  (key: key_shift; chars: ''; caption: 'Shift'),         //23    
  (key: key_z; chars: 'z'; caption: ''),                 //24    
  (key: key_x; chars: 'x'; caption: ''),                 //25    
  (key: key_c; chars: 'c'; caption: ''),                 //26    
  (key: key_v; chars: 'v'; caption: ''),                 //27    
  (key: key_b; chars: 'b'; caption: ''),                 //28    
  (key: key_n; chars: 'n'; caption: ''),                 //29    
  (key: key_m; chars: 'm'; caption: ''),                 //30    
  (key: key_comma; chars: ','; caption: ''),             //31     
  (key: key_period; chars: '.'; caption: ''),            //32     
  (key: key_question; chars: '?'; caption: ''),          //33    
  (key: key_up; chars: ''; caption: ''),                 //34    
  (key: key_control; chars: ''; caption: 'Ctrl'),        //35    
  (key: key_space; chars: ' '; caption: 'Space'),        //36    
  (key: key_left; chars: ''; caption: ''),               //37    
  (key: key_down; chars: ''; caption: ''),               //38    
  (key: key_right; chars: ''; caption: ''),              //39    
  
  (key: key_1; chars: '1'; caption: ''),                 //40     
  (key: key_2; chars: '2'; caption: ''),                 //41     
  (key: key_3; chars: '3'; caption: ''),                 //42    
  (key: key_backspace; chars: ''; caption: 'Back'),      //43    
  (key: key_4; chars: '4'; caption: ''),                 //44    
  (key: key_5; chars: '5'; caption: ''),                 //45    
  (key: key_6; chars: '6'; caption: ''),                 //46    
  (key: key_delete; chars: ''; caption: 'Del'),          //47    
  (key: key_7; chars: '7'; caption: ''),                 //48    
  (key: key_8; chars: '8'; caption: ''),                 //49    
  (key: key_9; chars: '9'; caption: ''),                 //50     
  (key: key_0; chars: '0'; caption: ''),                 //51     
  (key: key_decimal; chars: '.'; caption: ''),           //52    
  (key: key_return; chars: ''; caption: 'Enter'),        //53    
  (key: key_none; chars: ''; caption: ''),               //54    
  (key: key_none; chars: ''; caption: ''),               //55    
  (key: key_none; chars: ''; caption: ''),               //56    
  (key: key_none; chars: ''; caption: ''),               //57    
  (key: key_none; chars: ''; caption: ''),               //58    
  (key: key_none; chars: ''; caption: ''),               //59
      
  (key: key_tab; chars: ''; caption: 'Tab'),             //60    
  (key: key_exclam; chars: '!'; caption: ''),            //61    
  (key: key_at; chars: '@'; caption: ''),                //62    
  (key: key_numbersign; chars: '#'; caption: ''),        //63    
  (key: key_dollar; chars: '$'; caption: ''),            //64    
  (key: key_percent; chars: '%'; caption: ''),           //65    
  (key: key_ampersand; chars: '&'; caption: '&&'),       //66    
  (key: key_parenleft; chars: '('; caption: ''),         //67    
  (key: key_parenright; chars: ')'; caption: ''),        //68    
  (key: key_minus; chars: '-'; caption: ''),             //69    
  (key: key_underscore; chars: '_'; caption: ''),        //70    
  (key: key_equal; chars: '='; caption: ''),             //71    
  (key: key_plus; chars: '+'; caption: ''),              //72    
  (key: key_backslash; chars: '\'; caption: ''),         //73    
  (key: key_semicolon; chars: ';'; caption: ''),         //74    
  (key: key_colon; chars: ':'; caption: ''),             //75    
  (key: key_quotedbl; chars: '"'; caption: ''),          //76    
  (key: key_asterisk; chars: '*'; caption: ''),          //77    
  (key: key_slash; chars: '/'; caption: ''),             //78    
  (key: key_bracketleft; chars: '['; caption: ''),       //79    
  (key: key_bracketright; chars: ']'; caption: ''),      //80    
  (key: key_braceleft; chars: '{'; caption: ''),         //81    
  (key: key_braceright; chars: '}'; caption: ''),        //82  
  (key: key_bar; chars: '|'; caption: ''),               //83  
  (key: key_asciitilde; chars: '~'; caption: ''),        //84  
    
  (key: key_asciicircum; chars: '^'; caption: ''),       //85    
  (key: key_section; chars: '`'; caption: ''),           //86    
  (key: key_less; chars: '<'; caption: ''),              //87    
  (key: key_greater; chars: '>'; caption: ''),           //88    
  (key: key_left; chars: ''; caption: ''),               //89    
  (key: key_right; chars: ''; caption: ''),              //90    
  (key: key_space; chars: ' '; caption: 'Space'),        //91    
  (key: key_none; chars: ''; caption: ''),               //92    
  (key: key_none; chars: ''; caption: ''),               //93    
  (key: key_none; chars: ''; caption: ''),               //94    
  (key: key_none; chars: ''; caption: ''),               //95    
  (key: key_none; chars: ''; caption: ''),               //96    
  (key: key_none; chars: ''; caption: ''),               //97    
  (key: key_none; chars: ''; caption: ''),               //98    
  (key: key_none; chars: ''; caption: '')                //99    
 );
 
 qwertyupper: keybindingsty = (
  (key: key_q; chars: 'Q'; caption: ''),                 //0     
  (key: key_w; chars: 'W'; caption: ''),                 //1
  (key: key_e; chars: 'E'; caption: ''),                 //2     
  (key: key_r; chars: 'R'; caption: ''),                 //3     
  (key: key_t; chars: 'T'; caption: ''),                 //4     
  (key: key_y; chars: 'Y'; caption: ''),                 //5     
  (key: key_u; chars: 'U'; caption: ''),                 //6     
  (key: key_i; chars: 'I'; caption: ''),                 //7     
  (key: key_o; chars: 'O'; caption: ''),                 //8     
  (key: key_p; chars: 'P'; caption: ''),                 //9     
  (key: key_backspace; chars: ''; caption: 'Backspace'), //10     
  (key: key_delete; chars: ''; caption: 'Del'),          //11     
  (key: key_a; chars: 'A'; caption: ''),                 //12    
  (key: key_s; chars: 'S'; caption: ''),                 //13    
  (key: key_d; chars: 'D'; caption: ''),                 //14    
  (key: key_f; chars: 'F'; caption: ''),                 //15    
  (key: key_g; chars: 'G'; caption: ''),                 //16    
  (key: key_h; chars: 'H'; caption: ''),                 //17    
  (key: key_j; chars: 'J'; caption: ''),                 //18    
  (key: key_k; chars: 'K'; caption: ''),                 //19    
  (key: key_l; chars: 'L'; caption: ''),                 //20     
  (key: key_quotedbl; chars: '"'; caption: ''),          //21     
  (key: key_return; chars: ''; caption: 'Enter'),        //22    
  (key: key_shift; chars: ''; caption: 'Shift'),         //23    
  (key: key_z; chars: 'Z'; caption: ''),                 //24    
  (key: key_x; chars: 'X'; caption: ''),                 //25    
  (key: key_c; chars: 'C'; caption: ''),                 //26    
  (key: key_v; chars: 'V'; caption: ''),                 //27    
  (key: key_b; chars: 'B'; caption: ''),                 //28    
  (key: key_n; chars: 'N'; caption: ''),                 //29    
  (key: key_m; chars: 'M'; caption: ''),                 //20    
  (key: key_semicolon; chars: ';'; caption: ''),         //31     
  (key: key_division; chars: '/'; caption: ''),          //32     
  (key: key_exclam; chars: '!'; caption: ''),            //33    
  (key: key_up; chars: ''; caption: ''),                 //34    
  (key: key_control; chars: ''; caption: 'Ctrl'),        //35    
  (key: key_space; chars: ' '; caption: 'Space'),        //36    
  (key: key_left; chars: ''; caption: ''),               //37    
  (key: key_down; chars: ''; caption: ''),               //38    
  (key: key_right; chars: ''; caption: ''),              //39    

  (key: key_1; chars: '1'; caption: ''),                 //40     
  (key: key_2; chars: '2'; caption: ''),                 //41     
  (key: key_3; chars: '3'; caption: ''),                 //42    
  (key: key_backspace; chars: ''; caption: 'Back'),      //43    
  (key: key_4; chars: '4'; caption: ''),                 //44    
  (key: key_5; chars: '5'; caption: ''),                 //45    
  (key: key_6; chars: '6'; caption: ''),                 //46    
  (key: key_delete; chars: ''; caption: 'Del'),          //47    
  (key: key_7; chars: ''; caption: ''),                  //48    
  (key: key_8; chars: ''; caption: ''),                  //49    
  (key: key_9; chars: ''; caption: ''),                  //50     
  (key: key_0; chars: '0'; caption: ''),                 //51     
  (key: key_decimal; chars: '.'; caption: ''),           //52    
  (key: key_return; chars: ''; caption: 'Enter'),        //53    
  (key: key_none; chars: ''; caption: ''),               //54    
  (key: key_none; chars: ''; caption: ''),               //55    
  (key: key_none; chars: ''; caption: ''),               //56    
  (key: key_none; chars: ''; caption: ''),               //57    
  (key: key_none; chars: ''; caption: ''),               //58    
  (key: key_none; chars: ''; caption: ''),               //59    

  (key: key_tab; chars: ''; caption: 'Tab'),             //60    
  (key: key_exclam; chars: '!'; caption: ''),            //61    
  (key: key_at; chars: '@'; caption: ''),                //62    
  (key: key_numbersign; chars: '#'; caption: ''),        //63    
  (key: key_dollar; chars: '$'; caption: ''),            //64    
  (key: key_percent; chars: '%'; caption: ''),           //65    
  (key: key_ampersand; chars: '&'; caption: ''),         //66    
  (key: key_parenleft; chars: '('; caption: ''),         //67    
  (key: key_parenright; chars: ')'; caption: ''),        //68    
  (key: key_minus; chars: '-'; caption: ''),             //69    
  (key: key_underscore; chars: '_'; caption: ''),        //70    
  (key: key_equal; chars: '='; caption: ''),             //71    
  (key: key_plus; chars: '+'; caption: ''),              //72    
  (key: key_backslash; chars: '\'; caption: ''),         //73    
  (key: key_semicolon; chars: ';'; caption: ''),         //74    
  (key: key_colon; chars: ':'; caption: ''),             //75    
  (key: key_quotedbl; chars: '"'; caption: ''),          //76    
  (key: key_asterisk; chars: '*'; caption: ''),          //77    
  (key: key_slash; chars: '/'; caption: ''),             //78    
  (key: key_bracketleft; chars: '['; caption: ''),       //79    
  (key: key_bracketright; chars: ']'; caption: ''),      //80    
  (key: key_braceleft; chars: '{'; caption: ''),         //81    
  (key: key_braceright; chars: '}'; caption: ''),        //82    
  (key: key_asciicircum; chars: '^'; caption: ''),       //83    
  (key: key_section; chars: '`'; caption: ''),           //84    
  (key: key_less; chars: '<'; caption: ''),              //85    
  (key: key_greater; chars: '>'; caption: ''),           //86    
  (key: key_none; chars: ''; caption: ''),               //87    
  (key: key_none; chars: ''; caption: ''),               //88    
  (key: key_none; chars: ''; caption: ''),               //89    
  (key: key_none; chars: ''; caption: ''),               //90    
  (key: key_none; chars: ''; caption: ''),               //91    
  (key: key_none; chars: ''; caption: ''),               //92    
  (key: key_none; chars: ''; caption: ''),               //93    
  (key: key_none; chars: ''; caption: ''),               //94    
  (key: key_none; chars: ''; caption: ''),               //95    
  (key: key_none; chars: ''; caption: ''),               //96    
  (key: key_none; chars: ''; caption: ''),               //97    
  (key: key_none; chars: ''; caption: ''),               //98    
  (key: key_none; chars: ''; caption: '')                //99     
 );
 
implementation

initialization
 registerkeyboardlang('Uzbek-Cyrillic',@qwertylower,@qwertyupper);
end.
