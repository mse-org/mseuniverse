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
 msestrings,msekeyboard,keybindings,mseguiglob;

const
 qwertylower: keybindingsty = (
  (key: key_q ; shiftstate: []; chars: #1081; caption: ''),                //0
  (key: key_w ; shiftstate: []; chars: #1094; caption: ''),                //1
  (key: key_e ; shiftstate: []; chars: #1091; caption: ''),                //2
  (key: key_r ; shiftstate: []; chars: #1082; caption: ''),                //3
  (key: key_t ; shiftstate: []; chars: #1077; caption: ''),                //4
  (key: key_y ; shiftstate: []; chars: #1085; caption: ''),                //5
  (key: key_u ; shiftstate: []; chars: #1075; caption: ''),                //6
  (key: key_i ; shiftstate: []; chars: #1096; caption: ''),                //7
  (key: key_o ; shiftstate: []; chars: #1097; caption: ''),                //8
  (key: key_p ; shiftstate: []; chars: #1079; caption: ''),                //9
  (key: key_backspace; shiftstate: [ss_none]; chars: '';
                                                     caption: 'Backspace'),//10     
  (key: key_delete; shiftstate: [ss_none]; chars: ''; caption: 'Del'),     //11     
  (key: key_a ; shiftstate: []; chars: #1092; caption: ''),                //12
  (key: key_s ; shiftstate: []; chars: #1099; caption: ''),                //13
  (key: key_d ; shiftstate: []; chars: #1074; caption: ''),                //14
  (key: key_f ; shiftstate: []; chars: #1072; caption: ''),                //15
  (key: key_g ; shiftstate: []; chars: #1087; caption: ''),                //16
  (key: key_h ; shiftstate: []; chars: #1088; caption: ''),                //17
  (key: key_j ; shiftstate: []; chars: #1086; caption: ''),                //18
  (key: key_k ; shiftstate: []; chars: #1083; caption: ''),                //19
  (key: key_l ; shiftstate: []; chars: #1076; caption: ''),                //20
  (key: key_apostrophe; shiftstate: []; chars: ''''; caption: ''),         //21     
  (key: key_return; shiftstate: [ss_none]; chars: ''; caption: 'Enter'),   //22    
  (key: key_shift; shiftstate: []; chars: ''; caption: 'Shift'),           //23    
  (key: key_z ; shiftstate: []; chars: #1103; caption: ''),                //24
  (key: key_x ; shiftstate: []; chars: #1095; caption: ''),                //25
  (key: key_c ; shiftstate: []; chars: #1089; caption: ''),                //26
  (key: key_v ; shiftstate: []; chars: #1084; caption: ''),                //27
  (key: key_b ; shiftstate: []; chars: #1080; caption: ''),                //28
  (key: key_n ; shiftstate: []; chars: #1090; caption: ''),                //29
  (key: key_m ; shiftstate: []; chars: #1100; caption: ''),                //30
  (key: key_comma; shiftstate: []; chars: ','; caption: ''),               //31     
  (key: key_period; shiftstate: []; chars: '.'; caption: ''),              //32     
  (key: key_question; shiftstate: []; chars: '?'; caption: ''),            //33    
  (key: key_up; shiftstate: []; chars: ''; caption: ''),                   //34    
  (key: key_control; shiftstate: []; chars: ''; caption: 'Ctrl'),          //35    
  (key: key_space; shiftstate: [ss_none]; chars: ' '; caption: 'Space'),   //36    
  (key: key_left; shiftstate: []; chars: ''; caption: ''),                 //37    
  (key: key_down; shiftstate: []; chars: ''; caption: ''),                 //38    
  (key: key_right; shiftstate: []; chars: ''; caption: ''),                //39    
  
  (key: key_1; shiftstate: []; chars: '1'; caption: ''),                   //40     
  (key: key_2; shiftstate: []; chars: '2'; caption: ''),                   //41     
  (key: key_3; shiftstate: []; chars: '3'; caption: ''),                   //42    
  (key: key_backspace; shiftstate: [ss_none]; chars: ''; caption: 'Back'), //43    
  (key: key_4; shiftstate: []; chars: '4'; caption: ''),                   //44    
  (key: key_5; shiftstate: []; chars: '5'; caption: ''),                   //45    
  (key: key_6; shiftstate: []; chars: '6'; caption: ''),                   //46    
  (key: key_delete; shiftstate: [ss_none]; chars: ''; caption: 'Del'),     //47    
  (key: key_7; shiftstate: []; chars: '7'; caption: ''),                   //48    
  (key: key_8; shiftstate: []; chars: '8'; caption: ''),                   //49    
  (key: key_9; shiftstate: []; chars: '9'; caption: ''),                   //50     
  (key: key_0; shiftstate: []; chars: '0'; caption: ''),                   //51     
  (key: key_decimal; shiftstate: []; chars: '.'; caption: ''),             //52    
  (key: key_return; shiftstate: [ss_none]; chars: ''; caption: 'Enter'),   //53    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //54    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //55    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //56    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //57    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //58    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //59
      
  (key: key_tab; shiftstate: []; chars: ''; caption: 'Tab'),               //60    
  (key: key_exclam; shiftstate: []; chars: '!'; caption: ''),              //61    
  (key: key_at; shiftstate: []; chars: '@'; caption: ''),                  //62    
  (key: key_numbersign; shiftstate: []; chars: '#'; caption: ''),          //63    
  (key: key_dollar; shiftstate: []; chars: '$'; caption: ''),              //64    
  (key: key_percent; shiftstate: []; chars: '%'; caption: ''),             //65    
  (key: key_ampersand; shiftstate: []; chars: '&'; caption: '&&'),         //66    
  (key: key_parenleft; shiftstate: []; chars: '('; caption: ''),           //67    
  (key: key_parenright; shiftstate: []; chars: ')'; caption: ''),          //68    
  (key: key_minus; shiftstate: []; chars: '-'; caption: ''),               //69    
  (key: key_underscore; shiftstate: []; chars: '_'; caption: ''),          //70    
  (key: key_equal; shiftstate: []; chars: '='; caption: ''),               //71    
  (key: key_plus; shiftstate: []; chars: '+'; caption: ''),                //72    
  (key: key_backslash; shiftstate: []; chars: '\'; caption: ''),           //73    
  (key: key_semicolon; shiftstate: []; chars: ';'; caption: ''),           //74    
  (key: key_colon; shiftstate: []; chars: ':'; caption: ''),               //75    
  (key: key_quotedbl; shiftstate: []; chars: '"'; caption: ''),            //76    
  (key: key_asterisk; shiftstate: []; chars: '*'; caption: ''),            //77    
  (key: key_slash; shiftstate: []; chars: '/'; caption: ''),               //78    
  (key: key_bracketleft; shiftstate: []; chars: '['; caption: ''),         //79    
  (key: key_bracketright; shiftstate: []; chars: ']'; caption: ''),        //80    
  (key: key_braceleft; shiftstate: []; chars: '{'; caption: ''),           //81    
  (key: key_braceright; shiftstate: []; chars: '}'; caption: ''),          //82  
  (key: key_bar; shiftstate: []; chars: '|'; caption: ''),                 //83  
  (key: key_asciitilde; shiftstate: []; chars: '~'; caption: ''),          //84  
    
  (key: key_asciicircum; shiftstate: []; chars: '^'; caption: ''),         //85    
  (key: key_section; shiftstate: []; chars: '`'; caption: ''),             //86    
  (key: key_less; shiftstate: []; chars: '<'; caption: ''),                //87    
  (key: key_greater; shiftstate: []; chars: '>'; caption: ''),             //88    
  (key: key_left; shiftstate: []; chars: ''; caption: ''),                 //89    
  (key: key_right; shiftstate: []; chars: ''; caption: ''),                //90    
  (key: key_space; shiftstate: [ss_none]; chars: ' '; caption: 'Space'),   //91    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //92    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //93    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //94    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //95    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //96    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //97    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //98    
  (key: key_none; shiftstate: []; chars: ''; caption: '')                  //99    
 );
 
 qwertyupper: keybindingsty = (
  (key: key_q ; shiftstate: []; chars: #1049; caption: ''),                //0
  (key: key_w ; shiftstate: []; chars: #1062; caption: ''),                //1
  (key: key_e ; shiftstate: []; chars: #1059; caption: ''),                //2
  (key: key_r ; shiftstate: []; chars: #1050; caption: ''),                //3
  (key: key_t ; shiftstate: []; chars: #1045; caption: ''),                //4
  (key: key_y ; shiftstate: []; chars: #1053; caption: ''),                //5
  (key: key_u ; shiftstate: []; chars: #1043; caption: ''),                //6
  (key: key_i ; shiftstate: []; chars: #1064; caption: ''),                //7
  (key: key_o ; shiftstate: []; chars: #1065; caption: ''),                //8
  (key: key_p ; shiftstate: []; chars: #1047; caption: ''),                //9
  (key: key_backspace; shiftstate: [ss_none]; chars: ''; 
                                                    caption: 'Backspace'), //10     
  (key: key_delete; shiftstate: [ss_none]; chars: ''; caption: 'Del'),     //11     
  (key: key_a ; shiftstate: []; chars: #1060; caption: ''),                //12
  (key: key_s ; shiftstate: []; chars: #1067; caption: ''),                //13
  (key: key_d ; shiftstate: []; chars: #1042; caption: ''),                //14
  (key: key_f ; shiftstate: []; chars: #1040; caption: ''),                //15
  (key: key_g ; shiftstate: []; chars: #1055; caption: ''),                //16
  (key: key_h ; shiftstate: []; chars: #1056; caption: ''),                //17
  (key: key_j ; shiftstate: []; chars: #1054; caption: ''),                //18
  (key: key_k ; shiftstate: []; chars: #1051; caption: ''),                //19
  (key: key_l ; shiftstate: []; chars: #1044; caption: ''),                //20
  (key: key_quotedbl; shiftstate: []; chars: '"'; caption: ''),            //21     
  (key: key_return; shiftstate: [ss_none]; chars: ''; caption: 'Enter'),   //22    
  (key: key_shift; shiftstate: []; chars: ''; caption: 'Shift'),           //23    
  (key: key_z ; shiftstate: []; chars: #1071; caption: ''),                //24
  (key: key_x ; shiftstate: []; chars: #1063; caption: ''),                //25
  (key: key_c ; shiftstate: []; chars: #1057; caption: ''),                //26
  (key: key_v ; shiftstate: []; chars: #1052; caption: ''),                //27
  (key: key_b ; shiftstate: []; chars: #1048; caption: ''),                //28
  (key: key_n ; shiftstate: []; chars: #1058; caption: ''),                //29
  (key: key_m ; shiftstate: []; chars: #1068; caption: ''),                //30
  (key: key_semicolon; shiftstate: []; chars: ';'; caption: ''),           //31     
  (key: key_division; shiftstate: []; chars: '/'; caption: ''),            //32     
  (key: key_exclam; shiftstate: []; chars: '!'; caption: ''),              //33    
  (key: key_up; shiftstate: []; chars: ''; caption: ''),                   //34    
  (key: key_control; shiftstate: []; chars: ''; caption: 'Ctrl'),          //35    
  (key: key_space; shiftstate: [ss_none]; chars: ' '; caption: 'Space'),   //36    
  (key: key_left; shiftstate: []; chars: ''; caption: ''),                 //37    
  (key: key_down; shiftstate: []; chars: ''; caption: ''),                 //38    
  (key: key_right; shiftstate: []; chars: ''; caption: ''),                //39    

  (key: key_1; shiftstate: []; chars: '1'; caption: ''),                   //40     
  (key: key_2; shiftstate: []; chars: '2'; caption: ''),                   //41     
  (key: key_3; shiftstate: []; chars: '3'; caption: ''),                   //42    
  (key: key_backspace; shiftstate: [ss_none]; chars: ''; caption: 'Back'), //43    
  (key: key_4; shiftstate: []; chars: '4'; caption: ''),                   //44    
  (key: key_5; shiftstate: []; chars: '5'; caption: ''),                   //45    
  (key: key_6; shiftstate: []; chars: '6'; caption: ''),                   //46    
  (key: key_delete; shiftstate: [ss_none]; chars: ''; caption: 'Del'),     //47    
  (key: key_7; shiftstate: []; chars: ''; caption: ''),                    //48    
  (key: key_8; shiftstate: []; chars: ''; caption: ''),                    //49    
  (key: key_9; shiftstate: []; chars: ''; caption: ''),                    //50     
  (key: key_0; shiftstate: []; chars: '0'; caption: ''),                   //51     
  (key: key_decimal; shiftstate: []; chars: '.'; caption: ''),             //52    
  (key: key_return; shiftstate: [ss_none]; chars: ''; caption: 'Enter'),   //53    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //54    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //55    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //56    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //57    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //58    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //59    

  (key: key_tab; shiftstate: []; chars: ''; caption: 'Tab'),               //60    
  (key: key_exclam; shiftstate: []; chars: '!'; caption: ''),              //61    
  (key: key_at; shiftstate: []; chars: '@'; caption: ''),                  //62    
  (key: key_numbersign; shiftstate: []; chars: '#'; caption: ''),          //63    
  (key: key_dollar; shiftstate: []; chars: '$'; caption: ''),              //64    
  (key: key_percent; shiftstate: []; chars: '%'; caption: ''),             //65    
  (key: key_ampersand; shiftstate: []; chars: '&'; caption: ''),           //66    
  (key: key_parenleft; shiftstate: []; chars: '('; caption: ''),           //67    
  (key: key_parenright; shiftstate: []; chars: ')'; caption: ''),          //68    
  (key: key_minus; shiftstate: []; chars: '-'; caption: ''),               //69    
  (key: key_underscore; shiftstate: []; chars: '_'; caption: ''),          //70    
  (key: key_equal; shiftstate: []; chars: '='; caption: ''),               //71    
  (key: key_plus; shiftstate: []; chars: '+'; caption: ''),                //72    
  (key: key_backslash; shiftstate: []; chars: '\'; caption: ''),           //73    
  (key: key_semicolon; shiftstate: []; chars: ';'; caption: ''),           //74    
  (key: key_colon; shiftstate: []; chars: ':'; caption: ''),               //75    
  (key: key_quotedbl; shiftstate: []; chars: '"'; caption: ''),            //76    
  (key: key_asterisk; shiftstate: []; chars: '*'; caption: ''),            //77    
  (key: key_slash; shiftstate: []; chars: '/'; caption: ''),               //78    
  (key: key_bracketleft; shiftstate: []; chars: '['; caption: ''),         //79    
  (key: key_bracketright; shiftstate: []; chars: ']'; caption: ''),        //80    
  (key: key_braceleft; shiftstate: []; chars: '{'; caption: ''),           //81    
  (key: key_braceright; shiftstate: []; chars: '}'; caption: ''),          //82    
  (key: key_asciicircum; shiftstate: []; chars: '^'; caption: ''),         //83    
  (key: key_section; shiftstate: []; chars: '`'; caption: ''),             //84    
  (key: key_less; shiftstate: []; chars: '<'; caption: ''),                //85    
  (key: key_greater; shiftstate: []; chars: '>'; caption: ''),             //86    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //87    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //88    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //89    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //90    
  (key: key_none; shiftstate: [ss_none]; chars: ''; caption: ''),          //91    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //92    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //93    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //94    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //95    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //96    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //97    
  (key: key_none; shiftstate: []; chars: ''; caption: ''),                 //98    
  (key: key_none; shiftstate: []; chars: ''; caption: '')                  //99     
 );
 
implementation

initialization
 registerkeyboardlang(#1056#1091#1089#1089#1082#1072#1103,@qwertylower,@qwertyupper);
end.
