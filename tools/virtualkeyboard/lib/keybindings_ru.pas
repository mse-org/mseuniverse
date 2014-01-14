{ MSEgui Copyright (c) 2014 by Martin Schreiber

    See the file COPYING.MSE, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit keybindings_ru;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msestrings,msekeyboard,keybindings;

const
 qwertylower: keybindingsty = (
  (key: key_q ; chars: #1081; caption: ''),                 //0
  (key: key_w ; chars: #1094; caption: ''),                 //1
  (key: key_e ; chars: #1091; caption: ''),                 //2
  (key: key_r ; chars: #1082; caption: ''),                 //3
  (key: key_t ; chars: #1077; caption: ''),                 //4
  (key: key_y ; chars: #1085; caption: ''),                 //5
  (key: key_u ; chars: #1075; caption: ''),                 //6
  (key: key_i ; chars: #1096; caption: ''),                 //7
  (key: key_o ; chars: #1097; caption: ''),                 //8
  (key: key_p ; chars: #1079; caption: ''),                 //9
  (key: key_backspace; chars: ''; caption: 'Backspace'), //10     
  (key: key_delete; chars: ''; caption: 'Del'),          //11     
  (key: key_a ; chars: #1092; caption: ''),                 //12
  (key: key_s ; chars: #1099; caption: ''),                 //13
  (key: key_d ; chars: #1074; caption: ''),                 //14
  (key: key_f ; chars: #1072; caption: ''),                 //15
  (key: key_g ; chars: #1087; caption: ''),                 //16
  (key: key_h ; chars: #1088; caption: ''),                 //17
  (key: key_j ; chars: #1086; caption: ''),                 //18
  (key: key_k ; chars: #1083; caption: ''),                 //19
  (key: key_l ; chars: #1076; caption: ''),                 //20
  (key: key_apostrophe; chars: ''''; caption: ''),       //21     
  (key: key_return; chars: ''; caption: 'Enter'),        //22    
  (key: key_shift; chars: ''; caption: 'Shift'),         //23    
  (key: key_z ; chars: #1103; caption: ''),                 //24
  (key: key_x ; chars: #1095; caption: ''),                 //25
  (key: key_c ; chars: #1089; caption: ''),                 //26
  (key: key_v ; chars: #1084; caption: ''),                 //27
  (key: key_b ; chars: #1080; caption: ''),                 //28
  (key: key_n ; chars: #1090; caption: ''),                 //29
  (key: key_m ; chars: #1100; caption: ''),                 //30
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
  (key: key_q ; chars: #1049; caption: ''),                 //0
  (key: key_w ; chars: #1062; caption: ''),                 //1
  (key: key_e ; chars: #1059; caption: ''),                 //2
  (key: key_r ; chars: #1050; caption: ''),                 //3
  (key: key_t ; chars: #1045; caption: ''),                 //4
  (key: key_y ; chars: #1053; caption: ''),                 //5
  (key: key_u ; chars: #1043; caption: ''),                 //6
  (key: key_i ; chars: #1064; caption: ''),                 //7
  (key: key_o ; chars: #1065; caption: ''),                 //8
  (key: key_p ; chars: #1047; caption: ''),                 //9
  (key: key_backspace; chars: ''; caption: 'Backspace'), //10     
  (key: key_delete; chars: ''; caption: 'Del'),          //11     
  (key: key_a ; chars: #1060; caption: ''),                 //12
  (key: key_s ; chars: #1067; caption: ''),                 //13
  (key: key_d ; chars: #1042; caption: ''),                 //14
  (key: key_f ; chars: #1040; caption: ''),                 //15
  (key: key_g ; chars: #1055; caption: ''),                 //16
  (key: key_h ; chars: #1056; caption: ''),                 //17
  (key: key_j ; chars: #1054; caption: ''),                 //18
  (key: key_k ; chars: #1051; caption: ''),                 //19
  (key: key_l ; chars: #1044; caption: ''),                 //20
  (key: key_quotedbl; chars: '"'; caption: ''),          //21     
  (key: key_return; chars: ''; caption: 'Enter'),        //22    
  (key: key_shift; chars: ''; caption: 'Shift'),         //23    
  (key: key_z ; chars: #1071; caption: ''),                 //24
  (key: key_x ; chars: #1063; caption: ''),                 //25
  (key: key_c ; chars: #1057; caption: ''),                 //26
  (key: key_v ; chars: #1052; caption: ''),                 //27
  (key: key_b ; chars: #1048; caption: ''),                 //28
  (key: key_n ; chars: #1058; caption: ''),                 //29
  (key: key_m ; chars: #1068; caption: ''),                 //30
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
 registerkeyboardlang(#1056#1091#1089#1089#1082#1072#1103,@qwertylower,@qwertyupper);
end.
