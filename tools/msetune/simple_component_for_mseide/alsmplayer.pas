{   alsmplayer Copyright (c) 2011 by Alexandre Minoshi

    version see in tmplayer.create procedure

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    minoshi@yandex.ru

    Analog TV support by Coyot.RusH
}

unit alsmplayer;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface

uses
 msegui, msestrings, mseterminal, mseclasses, sysutils,
 msetimer, classes, msewindowwidget, msewidgets, mseprocess, process;

type
 TerrorEvent = procedure(const Sender : TObject; errormsg : string) of object;
 TPauseEvent = procedure(const Sender : TObject; const apausing : boolean; msg : string) of object;
 TPlayingEvent = procedure(const Sender : TObject; position, length : integer; msg : string) of object;
 TStartPlayEvent = procedure(const Sender : TObject; videoW,videoH : integer; msg : string) of object;
 TEndOfTrackEvent = procedure(const Sender : TObject; msg : string) of object;
 TConnectingEvent = procedure(const Sender : TObject; msg : string) of object;
 TchangeVolumeEvent = procedure(const Sender : TObject; avolume: integer) of object;
 TDebugMessageEvent = procedure(const Sender :TObject; msg : AnsiString) of object;
 TTakeCdPlaylistEvent = procedure(const Sender :TObject; msg : string) of object;

 tplaymode=(__cd,__dvd,__dvb,__tv,__localfile,__inet,__webcamera, __null);
 tlang=(ru,en);

 tvideoresolution = record
       width  : integer;
       height : integer;
     end;

 tCurrentTrackInfo = record
       filename : msestring;
       name     : string; //extractfilename
       video    : tvideoresolution;
       (* to be continued ... *)
     end;

{ TV }
type tvnorm=(NTSC,NTSC_M,NTSC_M_JP,NTSC_M_KR,PAL,PAL_BG,
		PAL_H,PAL_I,PAL_DK,PAL_M,PAL_N,PAL_Nc,PAL_60,SECAM,SECAM_B,
		SECAM_G,SECAM_H,SECAM_DK,SECAM_L,SECAM_Lc);

type TvCannelName=(Ch_R1  ,Ch_R2  ,Ch_R3  ,Ch_R4  ,Ch_R5  ,Ch_R6  ,Ch_R7  ,Ch_R8  ,Ch_R9  ,Ch_R10 ,
		Ch_R11 ,Ch_R12 ,Ch_SR1 ,Ch_SR2 ,Ch_SR3 ,Ch_SR4 ,Ch_SR5 ,Ch_SR6 ,Ch_SR7 ,Ch_SR8 ,Ch_SR11 ,
		Ch_SR12,Ch_SR13,Ch_SR14,Ch_SR15,Ch_SR16,Ch_SR17,Ch_SR18,Ch_SR19,Ch_K1  ,Ch_K2  ,Ch_K3 ,
		Ch_K4  ,Ch_K5  ,Ch_K6  ,Ch_K7  ,Ch_K8  ,Ch_K9  ,Ch_K10 ,Ch_K11 ,Ch_K12 ,Ch_K21 ,Ch_K22 ,Ch_K23 ,
		Ch_K24 ,Ch_K25 ,Ch_K26 ,Ch_K27 ,Ch_K28 ,Ch_K29 ,Ch_K30 ,Ch_K31 ,Ch_K32 ,Ch_K33 ,Ch_K34 ,
		Ch_K35 ,Ch_K36 ,Ch_K37 ,Ch_K38 ,Ch_K39 ,Ch_K40 ,Ch_K41 ,Ch_K42 ,Ch_K43 ,Ch_K44 ,Ch_K45 ,Ch_K46 ,
		Ch_K47 ,Ch_K48 ,Ch_K49 ,Ch_K50 ,Ch_K51 ,Ch_K52 ,Ch_K53 ,Ch_K54 ,Ch_K55 ,Ch_K56 ,Ch_K57 ,Ch_K58 ,
		Ch_K59 ,Ch_K60 ,Ch_K61 ,Ch_K62 ,Ch_K63 ,Ch_K64 ,Ch_K65 ,Ch_K66 ,Ch_K67 ,Ch_K68 ,Ch_K69 ,Ch_S01 ,
		Ch_S02 ,Ch_S03 ,Ch_S1  ,Ch_S2  ,Ch_S3  ,Ch_S4  ,Ch_S5  ,Ch_S6  ,Ch_S7  ,Ch_S8  ,Ch_S9  ,Ch_S10 ,Ch_S11 ,
		Ch_S12 ,Ch_S13 ,Ch_S14 ,Ch_S15 ,Ch_S16 ,Ch_S17 ,Ch_S18 ,Ch_S19 ,Ch_S20 ,Ch_S21 ,Ch_S22 ,Ch_S23 ,
		Ch_S24 ,Ch_S25 ,Ch_S26 ,Ch_S27 ,Ch_S28 ,Ch_S29 ,Ch_S30 ,Ch_S31 ,Ch_S32 ,Ch_S33 ,Ch_S34 ,Ch_S35 ,
		Ch_S36 ,Ch_S37 ,Ch_S38 ,Ch_S39 ,Ch_S40 ,Ch_S41 );

const
tvCannelNameStr:array [TVCannelName] of String  =(
		'R1'   ,'R2'   ,'R3'   ,'R4'   ,'R5'   ,'R6'   ,'R7'   ,'R8'   ,'R9' ,'R10',
		'R11'  ,'R12'  ,'SR1'  ,'SR2'  ,'SR3'  ,'SR4'  ,'SR5'  ,'SR6'  ,'SR7'  ,'SR8'   ,'SR11'  ,
		'SR12' ,'SR13' ,'SR14' ,'SR15' ,'SR16' ,'SR17' ,'SR18' ,'SR19' ,'K1'   ,'K2'   ,'K3'  ,
		'K4'   ,'K5'   ,'K6'   ,'K7'   ,'K8'   ,'K9'   ,'K10'  ,'K11'  ,'K12'  ,'K21'  ,'K22'  ,'K23'  ,
		'K24'  ,'K25'  ,'K26'  ,'K27'  ,'K28'  ,'K29'  ,'K30'  ,'K31'  ,'K32'  ,'K33'  ,'K34'  ,
		'K35'  ,'K36'  ,'K37'  ,'K38'  ,'K39'  ,'K40'  ,'K41'  ,'K42'  ,'K43'  ,'K44'  ,'K45'  ,'K46'  ,
		'K47'  ,'K48'  ,'K49'  ,'K50'  ,'K51'  ,'K52'  ,'K53'  ,'K54'  ,'K55'  ,'K56'  ,'K57'  ,'K58'  ,
		'K59'  ,'K60'  ,'K61'  ,'K62'  ,'K63'  ,'K64'  ,'K65'  ,'K66'  ,'K67'  ,'K68'  ,'K69'  ,'S01'  ,
		'S02'  ,'S03'  ,'S1'   ,'S2'   ,'S3'   ,'S4'   ,'S5'   ,'S6'   ,'S7'   ,'S8'   ,'S9'   ,'S10'  ,'S11'  ,
		'S12'  ,'S13'  ,'S14'  ,'S15'  ,'S16'  ,'S17'  ,'S18'  ,'S19'  ,'S20'  ,'S21'  ,'S22'  ,'S23'  ,
		'S24'  ,'S25'  ,'S26'  ,'S27'  ,'S28'  ,'S29'  ,'S30'  ,'S31'  ,'S32'  ,'S33'  ,'S34'  ,'S35'  ,
		'S36'  ,'S37'  ,'S38'  ,'S39'  ,'S40'  ,'S41');

TvStr : array [tvnorm] of String [20] =('NTSC','NTSC-M','NTSC-M-JP','NTSC-M-KR','PAL','PAL-BG',
		'PAL-H','PAL-I','PAL-DK','PAL-M','PAL-N','PAL-Nc','PAL-60','SECAM','SECAM-B',
		'SECAM-G','SECAM-H','SECAM-DK','SECAM-L','SECAM-Lc');

type PTVData = ^TTVData;
	TTVData = record
		Norm:tvnorm;
		Freq: integer;
		Name:msestring;
	end;

{ TTVDataList }
TTVDataList = class
 private
   FTVList: TList; // хранилище данных
 public
   constructor Create;
   destructor Destroy; override;
   function AddItem(Item: TTVData): Integer;
   procedure RemoveItem(ItemIndex: Integer);
   function GetData(Idx: integer): TTVData;
   procedure SetData(IDx:integer;Data:TTvdata);
   function Count: integer;
   procedure Exchange(idx1, idx2: integer);
end;

(* TMPLAYER CLASS *)
type tmplayer = class(tcomponent)
 private
  fversion : string;
  fmplayer : string;
  ftimer   : ttimer;
  fterm    : tterminal;
  flang    : tlang;
  fparams  : string;   // user mplayer params
  fcache    : string;
  findexing : boolean;
  fvolume      : integer;
  flengthsec   : integer;
  fpositionsec : integer;
  fhavevideostream : boolean;

  (* mplayer status *)
  fpausing : boolean;
  fmode    : tplaymode;

  (* play list *)
  ftracknum : integer;
  fplaylist : tstringlist;
  fcurrenttrack : tCurrentTrackInfo;

  FChannelList  : TTVDataList;  (* analog TV Channel List *)
  fplaynexttrackallow : boolean; (* if user want play only one track *)
  frepeatplaylist     : boolean;

  (* output *)
  faudiooutput : string;
  fvideooutput : string;

  faudiooutputlist : tstringlist;
  fvideooutputlist : tstringlist;
  faval_audiooutputlist : tstringlist;
  faval_videooutputlist : tstringlist;

  (* devices *)
  fdisplay : tcustomwindowwidget;
  fwebcameradevice : string;
  ftvtunerdevice   : string;
  fcdromdevice     : string;
  fDVDusenavigation : boolean;

  (* video parameters *)
  fbrightness   : integer;
  fcontrast     : integer;
  fgamma        : integer;
  fhue          : integer;
  fsaturation   : integer;
  fvideo_to_desktop : boolean; // :)) work fine if window with id=0 if visible (openbox, icewm, etc)

  (* internal *)
  prevvolume    : integer;
  prevvolumemute: integer;
  prevposition  : integer;
  beginplayback : boolean; //internal for timer
  playnexttrack : boolean; //internal for timer
  play_playlist : boolean; //true if play, false if play(source)
  connecttocddevice : boolean;
  stop_it       : boolean; //manual stop

  (* debug *)
  FwriteOutToConsole : boolean; (* external, mean write output to console *)
  fAddMplayerMessagesToDebug : boolean;

  (* class events *)
  fonStartplayEv    : tStartPlayEvent;
  fonEndOfTrackEv   : TEndOfTrackEvent;
  fonPlayingEv      : TPlayingEvent;
  fonPauseEv        : tpauseEvent;
  fonChangeVolumeEv : TchangeVolumeEvent;
  fonErrorEv        : TerrorEvent;
  fonConnectingEv   : TConnectingEvent;
  fgetdebugmessage  : TDebugMessageEvent;
  ftakecdplaylistEv : TTakeCdPlaylistEvent;

 protected

  (* terminal events*)
  procedure on_procfinished(const sender : TObject);
  procedure on_receivetext(const sender : TObject; var atext: AnsiString; const errorinput: Boolean);
  procedure on_pipebroken(const sender : TObject);

  procedure on_timer(const sender: tobject);
  function getWindowId : string;
  function cmdline(source : string) : string;
  procedure SetVolume(avalue : integer);
  procedure setposition(avalue : integer);
  procedure __play(source : string);
  procedure __openaudiocd(trucknum : integer);
  function checkmplayer : boolean;
  function checksource(source : string) : tplaymode;
  function termstatus : boolean;

  procedure setparam(vol: integer; var vparam : integer; capt : string; _start, _end : integer; _interval : integer);
  procedure setbrightness(const avalue : integer);
  procedure setcontrast(const avalue : integer);
  procedure setgamma(const avalue : integer);
  procedure sethue(const avalue : integer);
  procedure setsaturation(const avalue : integer);

  procedure dvdnav(navcommand : string);
  function lng(line : string) : string;
  procedure debug(line : string);
  procedure startdebug;

 public

  constructor create(aowner: tcomponent); override;//(const aowner: tobject = nil);
  destructor destroy; override;

  (* mplayer management *)

  procedure play(source : string);
  procedure play;
  procedure pause;
  procedure stop;
  procedure next;
  procedure prev;
  procedure mute;
  procedure screenshot;

  property version : string  read fversion;
  property pausing : boolean read fpausing;
  property playing : boolean read termstatus;

  property lengthsec : integer read flengthsec;
  property position  : integer read fpositionsec write setposition;
  procedure setpositionpersent(avalue : integer);
  property currenttrack : tCurrentTrackInfo read fcurrenttrack;

  (* Webcamera*)
  procedure OpenWebcamera;
  procedure OpenWebcamera_withpreload;

  (* DVD *)
  procedure OpenDVD;
  procedure dvdnavigation_up;
  procedure dvdnavigation_down;
  procedure dvdnavigation_left;
  procedure dvdnavigation_right;
  procedure dvdnavigation_menu;
  procedure dvdnavigation_select;
  procedure dvdnavigation_prev;
  procedure dvdnavigation_mouse;

  (* TV *)
  procedure OpenTV();
  procedure SetChannelByfreq(const Ch_freq:integer);
  procedure SetChannelByName(const Ch_name:TvCannelName);
  procedure SetChannelNorm(const __TVNorm:tvnorm);

  (* cdrom *)
  procedure ConnectToAudioCD;
  procedure OpenAudioCD;
  procedure OpenAudioCD(tracknum : integer);

  procedure SendCommandToMPlayer(cmd : string);

  property audiooutputlist : tstringlist read faudiooutputlist;
  property videooutputlist : tstringlist read fvideooutputlist;
  property aval_audiooutputlist : tstringlist read faval_audiooutputlist;
  property aval_videooutputlist : tstringlist read faval_videooutputlist;

 published

  property mplayer : string read fmplayer write fmplayer;
  property aditionalparams  : string read fparams write fparams;
  property lang    : tlang  read flang write flang;
  property volume  : integer read fvolume  write SetVolume;
  property cache   : string  read fcache write fcache;
  property mode    : tplaymode read fmode write fmode;
  property indexing : boolean read findexing write findexing default false; //indexing file

  (* playlist *)

  property tracknum : integer read ftracknum write ftracknum;
  property Playlist : tstringlist read fplaylist write fplaylist;
  property ListofChanell      : TTVDataList    read FChannelList write FChannelList;
  property PlayNextTrackAllow : boolean read fplaynexttrackallow write fplaynexttrackallow default true;
  property RepeatPlaylist     : boolean read frepeatplaylist     write frepeatplaylist default false;

  (* audio and video output *)

  property audiooutput : string read faudiooutput write faudiooutput;
  property videooutput : string read fvideooutput write fvideooutput;

  (* devices *)

  property device_webcamera : string read fwebcameradevice write fwebcameradevice;
  property device_tvtuner   : string read ftvtunerdevice   write ftvtunerdevice;
  property device_cdrom     : string read fcdromdevice     write fcdromdevice;
  property display : tcustomwindowwidget read fdisplay write fdisplay;
  property DVDusenavigation : boolean read fDVDusenavigation write fDVDusenavigation  default true;
  property videotodesktop : boolean read fvideo_to_desktop write fvideo_to_desktop  default false;

  (* video properties *)

  property video_brightness : integer read fbrightness write setbrightness;
  property video_contrast   : integer read fcontrast   write setcontrast;
  property video_gamma      : integer read fgamma      write setgamma;
  property video_hue        : integer read fhue        write sethue;
  property video_saturation : integer read fsaturation write setsaturation;
  property havevideostream : boolean read fhavevideostream default false;

  (* debug *)

  property debug_WriteOutToConsole  : boolean read fwriteOutToConsole  write fwriteOutToConsole default  {$ifdef mswindows}false{$endif}{$ifdef linux}true{$endif};
  property debug_AddMplayerOutputToDebug : boolean read fAddMplayerMessagesToDebug  write fAddMplayerMessagesToDebug default false;

  (* events *)

  property onStartPlay  : tStartPlayEvent  read fonStartPlayEv  write fonStartPlayEv;
  property onPlaying    : TPlayingEvent    read fonPlayingEv    write fonPlayingEv;
  property onPause      : TPauseEvent      read fonpauseEv      write fonpauseEv;
  property onEndOfTrack : TEndOfTrackEvent read fonEndOfTrackEv write fonendoftrackEv;
  property onError      : TErrorEvent      read fonErrorEv      write fonErrorEv;
  property onConnecting : TConnectingEvent read fonConnectingEv write fonConnectingEv;
  property onTakeCdPlaylistEvent : TTakeCdPlaylistEvent read ftakecdplaylistEv write ftakecdplaylistEv;
  property onChangeVolume : TchangeVolumeEvent read fonChangeVolumeEv write fonChangeVolumeEv;
  property onGetDebugMessage: TDebugMessageEvent read fgetdebugmessage write fgetdebugmessage;

end;

implementation
var PAUSETIME : INTEGER;

//==========================================================
//                TMPLAYER CLASS
//==========================================================
procedure tmplayer.startdebug;
begin
  debug('========================================================');
  debug('ALSMPLAYER VERSION ' + fversion);
  debug('NOTE: strings with <***> is output of alsmmplayer class,');
  debug('      without is output of mplayer');
  debug('========================================================');
end;
//==========================================================
//                DEBUG OUT
//==========================================================
procedure tmplayer.debug(line : AnsiString);
begin
  if FwriteOutToConsole then writeln(line);
  if assigned(fgetdebugmessage) then fgetdebugmessage(self, line);
end;
//==========================================================
//                CREATE
//==========================================================
constructor tmplayer.create(aowner: tcomponent);//(const aowner: tobject);
var p : tprocess;
   sl : tstringlist;
    i : integer;
    s : string;
begin
 fversion :=  '0.12.15 beta';
 debug('WELLCOME TO ALSMPLAYER version ' + fversion);

 fterm := tterminal.create(nil);
 //fterm.optionsprocess := [pro_input, pro_output]; ===== !!!! ======
 flang := ru;

 {$ifdef mswindows}
 fterm.optionsprocess := fterm.optionsprocess + [pro_inactive]; // pro_inactive hide cmd.exe window in mswindows
 {$endif}

 fterm.onprocfinished := @on_procfinished;
 fterm.onreceivetext  := @on_receivetext;
 fterm.onerrorpipebroken := @on_pipebroken;
 fterm.oninputpipebroken := @on_pipebroken;

 ftimer := ttimer.create(nil);
 ftimer.ontimer := @on_timer;
 ftimer.interval := 1000000;
 ftimer.enabled := true;

 {$ifdef mswindows}fmplayer := 'mplayer_portable\Mplayer.exe'; {$endif}
 {$ifdef linux}    fmplayer := '/usr/bin/mplayer'; {$endif}

 fvolume := 50;
 prevvolume := fvolume;
 fmode := __localfile;
 pausetime := 0;

 fplaylist := tstringlist.create;
 FChannelList:= TTVDataList.Create;
 ftrackNum := -1;

 faudiooutput := 'default';
 fvideooutput := 'default';

 faudiooutputlist := tstringlist.create;
 faudiooutputlist.add('default');   faudiooutputlist.add('alsa');
 faudiooutputlist.add('alsa5');     faudiooutputlist.add('oss');
 faudiooutputlist.add('sdl');       faudiooutputlist.add('arts');
 faudiooutputlist.add('esd');       faudiooutputlist.add('jack');
 faudiooutputlist.add('nas');       faudiooutputlist.add('coreaudio');
 faudiooutputlist.add('openal');    faudiooutputlist.add('pulse');
 faudiooutputlist.add('sgi');       faudiooutputlist.add('sun');
 faudiooutputlist.add('win32'); 	faudiooutputlist.add('dsound');
 faudiooutputlist.add('dart');      faudiooutputlist.add('dxr2');
 faudiooutputlist.add('ivtv');      faudiooutputlist.add('v4l2');
 faudiooutputlist.add('mpegpes');

 fvideooutputlist := tstringlist.create;
 fvideooutputlist.add('default');   fvideooutputlist.add('x11');
 fvideooutputlist.add('xover');     fvideooutputlist.add('vdpau');
 fvideooutputlist.add('xvmc');      fvideooutputlist.add('dga');
 fvideooutputlist.add('sdl');       fvideooutputlist.add('vidix');
 fvideooutputlist.add('xvidix');    fvideooutputlist.add('cvidix');
 fvideooutputlist.add('winvidix');  fvideooutputlist.add('direct3d');
 fvideooutputlist.add('directx');   fvideooutputlist.add('kva');
 fvideooutputlist.add('quartz');    fvideooutputlist.add('corevideo');
 fvideooutputlist.add('fbdev');     fvideooutputlist.add('fbdev2');
 fvideooutputlist.add('vesa');      fvideooutputlist.add('svga');
 fvideooutputlist.add('gl');        fvideooutputlist.add('gl2');
 fvideooutputlist.add('aa');        fvideooutputlist.add('caca');
 fvideooutputlist.add('bl');        fvideooutputlist.add('ggi');
 fvideooutputlist.add('directfb');  fvideooutputlist.add('dfbmga');
 fvideooutputlist.add('mga');       fvideooutputlist.add('xmga');
 fvideooutputlist.add('s3fb');      fvideooutputlist.add('wii');
 fvideooutputlist.add('3dfx');      fvideooutputlist.add('tdfxfb');
 fvideooutputlist.add('tdfx_vid');  fvideooutputlist.add('dxr2');
 fvideooutputlist.add('dxr3');      fvideooutputlist.add('ivtv');
 fvideooutputlist.add('v4l2');      fvideooutputlist.add('mpegpes');
 fvideooutputlist.add('zr');        fvideooutputlist.add('zr2');
 fvideooutputlist.add('yuv4mpeg');  fvideooutputlist.add('gif89a');
 fvideooutputlist.add('jpeg');      fvideooutputlist.add('pnm');
 fvideooutputlist.add('png');       fvideooutputlist.add('tga');
 fvideooutputlist.add('null');      fvideooutputlist.add('matrixview');
 fvideooutputlist.add('xv');


 faval_videooutputlist := tstringlist.create;
 faval_videooutputlist.add('default');

 if fileexists(fmplayer) then
 begin
 sl := tstringlist.create;
 p := tprocess.create(nil);
 p.options := p.Options + [powaitonexit, pousepipes];

 p.commandline := fmplayer + ' -vo help';
 p.execute;
 sl.loadfromstream(p.output);
 if sl.count > 0 then
  for i := 3 to sl.count - 1 do
   begin
     s := trim(sl[i]);
     if s = '' then continue;
     faval_videooutputlist.add(copy(s, 1, system.pos('	',s) - 1 ));//don`t touch this ' ' !!!
   end;

 sl.clear;

 faval_audiooutputlist := tstringlist.create;
 faval_audiooutputlist.add('default');
 p.commandline := fmplayer + ' -ao help';
 p.execute;
 sl.loadfromstream(p.output);

 if sl.count > 0 then
  for i := 3 to sl.count - 1 do
   begin
     s := trim(sl[i]);
     if s = '' then continue;
     faval_audiooutputlist.add(copy(s, 1, system.pos('	',s) - 1 )) ; //don`t touch this ' ' !!!
   end;

 sl.free;
 p.free;
 end;

 inherited;
end;
//==========================================================
//                DESTROY
//==========================================================
destructor tmplayer.destroy;
begin
  stop;

  fterm.free;
  faval_audiooutputlist.free;
  faval_videooutputlist.free;
  fplaylist.free;
  fvideooutputlist.free;
  faudiooutputlist.free;
  ftimer.free;

  debug('*** Exit alsmplayer. Bye!');
  inherited;
end;
//==========================================================
//                LANGUAGE SUPPORT
//==========================================================
function tmplayer.lng(line : string) : string;
begin
 result := line;
 case flang of
 en : ;
 ru : begin
       if line = 'Webcamera' then result := 'Вебкамера' else
       if line = 'Webcamera is switch on' then result := 'Вебкамера включена' else
       if line = 'Webcamera is switch off' then result := 'Вебкамера выключена' else
       if line = 'TV Tuner' then result := 'ТВ-тюнер' else
       if line = 'TV Tuner is switch on' then result := 'ТВ-тюнер включен' else
       if line = 'TV Tuner is switch off' then result := 'ТВ-тюнер выключен' else
       if line = 'DVD is power on' then result := 'DVD включен' else
       if line = 'DVD is power off' then result := 'DVD выключен' else
       if line = 'Connecting ...' then result := 'Подключение ...' else
       if line = 'Connecting to server ...' then result := 'Подключение к серверу ...' else
       if line = 'Сonnected' then result := 'Подключен' else
       if line = 'Cache fill:' then result := 'Заполнение кэша:' else
       if line = 'Generated index table' then result := 'Генерация индекса' else
       if line = 'Playing' then result := 'Воспроизведение' else
       if line = 'Playlist is empty' then result := 'Плей-лист пуст' else
       if line = 'End of playlist' then result := 'Конец плей-листа' else
       if line = 'End of track' then result := 'Конец трека' else
       if line = 'Mplayer not found' then result := 'Mplayer не найден' else
       if line = 'Incomplete stream? Trying resync' then result := 'Ресинхронизация' else
       if line = 'Cache not filling' then result := 'Не хватает кэша' else
       if line = 'Pause for caching, please, wait ... ' then result := 'Пауза для заполнения кеша ... ' else
       if line = 'Audio only file format detected' then result := 'Обнаружен аудио формат' else
       if line = 'Pause' then result := 'Пауза' else
       if line = 'CD track' then result := 'CD трек' else
       if line = 'Audio CD is started' then result := 'Аудио CD (воспроизведение)' else
       if line = 'End of CD track' then result := 'Конец Аудио CD трека' else
       if line = 'Connecting to CD device ...' then result := 'Подключение к CD устройству ...' else
       if line = 'End of audio CD' then result := 'Конец аудио CD диска' else
      end;
 end; //case
end;
//==========================================================
//                TMPLAYER EVENTS
//==========================================================
//==========================================================
//                terminal status
//==========================================================
function tmplayer.termstatus : boolean;
begin
  result := fterm.running;
end;
//==========================================================
//       on finished terminal work (track is finished)
//==========================================================
procedure tmplayer.on_procfinished(const sender: TObject);
var msg : string;
begin
  case fmode of
   __cd : begin
            if connecttocddevice then
             begin
                connecttocddevice := false;
                if assigned(ftakecdplaylistEv) then ftakecdplaylistEv(self, 'audio CD playlist (' + inttostr(fplaylist.count) + ' track(s).');
             end else  msg := 'End of CD track';
           end;
   __webcamera : msg := 'Webcamera is switch off';
   __tv : msg := 'TV Tuner is switch off';
   __dvd : msg := 'DVD is power off';
   else msg := 'End of track';
  end; //case
  debug('*** ' + msg);

  if assigned(fonEndOfTrackEv) then fonEndOfTrackEv(self, lng(msg));

  if not stop_it                                   //if we call STOP manually
     then if play_playlist and fplaynexttrackallow
             then playnexttrack := true;
end;
//==========================================================
//                on pipe broken
//==========================================================
procedure tmplayer.on_pipebroken(const sender: TObject);
begin
  debug('*** pipe is broken');
end;
//==========================================================
//                read output
//==========================================================
procedure tmplayer.on_receivetext(const sender: TObject; var atext: AnsiString; const errorinput: Boolean);
var s : string;
    i : integer;
begin
 if fAddMplayerMessagesToDebug then debug(trim(atext));

 if (system.pos('Starting playback',atext) > 0)or(system.pos('Начало воспроизведения...',atext) > 0)
   then begin
         debug('*** RECEIVE TEXT: Starting playback');
         fpausing := false; (*** DON'T TOUCH IT, IT'S WORK ***)
         flengthsec := 0;
         case fmode of
          __webcamera : begin
                          fcurrenttrack.video.Width := 640;
                          fcurrenttrack.video.height := 480;
                          if assigned(fonstartplayEv) then fonstartplayEv(self, fcurrenttrack.video.Width, fcurrenttrack.video.height,lng('Webcamera is switch on'));
                        end;
          __dvd : begin
                    fcurrenttrack.video.Width := 640;
                    fcurrenttrack.video.height := 480;
                    if assigned(fonstartplayEv) then fonstartplayEv(self, fcurrenttrack.video.Width, fcurrenttrack.video.height,lng('DVD is power on'));
                  end;
          __tv : begin
                   fcurrenttrack.video.Width := 640;
                   fcurrenttrack.video.height := 480;
                   if assigned(fonstartplayEv) then fonstartplayEv(self, fcurrenttrack.video.Width, fcurrenttrack.video.height,lng('TV Tuner is switch on'));
                 end;
          __cd : begin
                   fcurrenttrack.video.Width := 0;
                   fcurrenttrack.video.height := 0;
                   if assigned(fonstartplayEv) then fonstartplayEv(self, fcurrenttrack.video.Width, fcurrenttrack.video.height,lng('Audio CD is started'));
                 end;
          else begin
                debug('*** RECEIVE TEXT: Try get video resolution ...');
                fterm.writestrln('get_video_resolution');
               end;
         end;  //case
        end;

 if system.pos('ANS_VIDEO_RESOLUTION=', atext) > 0 then
   begin
     s := atext;
     delete(s,1,system.pos('=''',s) + 1);
     if s <> ''
     then begin
            fcurrenttrack.video.Width := strtoint(copy(s,1,system.pos('x',s) - 2));
            delete(s,1,system.pos('x',s) + 1);
            fcurrenttrack.video.height := strtoint(copy(s,1,system.pos('''',s) - 1));
          end
     else begin
            fcurrenttrack.video.Width := 0;
            fcurrenttrack.video.height := 0;
          end;
     beginplayback := true;
     debug('*** RECEIVE TEXT: video resolution : '
             + inttostr(fcurrenttrack.video.Width) + ' x '
             + inttostr(fcurrenttrack.video.height) );
   end;

 if (system.pos('ANS_TIME_POSITION=', atext) > 0) then
    begin
      s := atext;
      delete( s,1,length('ANS_TIME_POSITION=') + system.pos('ANS_TIME_POSITION=',s) - 1);
      s := copy(s,1,system.pos('.',s) - 1);
      fpositionsec := strtoint(trim(s));
      prevposition := fpositionsec;
      debug('*** RECEIVE TEXT: position(sec) : ' + inttostr(fpositionsec) );
      if assigned(fonPlayingEv) then fonPlayingEv(self, fpositionsec, flengthsec, lng('Playing'));
    end;

 if system.pos('ANS_LENGTH=', atext) > 0  then
    begin
      s := atext;
      delete( s,1, system.pos('ANS_LENGTH=',s) + length('ANS_LENGTH=') - 1);
      s := copy(s,1,system.pos('.',s) - 1);
      flengthsec := strtoint(trim(s));
      debug('*** RECEIVE TEXT: length(sec)   : ' + inttostr(flengthsec) );
    end;

  if (system.pos('Found audio CD with', atext) > 0)  then //if audioCD
   begin
     s := atext;
     delete(s,1,system.pos('Found audio CD with',s) + length('Found audio CD with'));
     debug('*** RECEIVE TEXT: Found audio CD with ' + copy(s,1,system.pos(' ',s) - 1) + ' track(s).');
     if connecttocddevice
     then begin
            fplaylist.clear;
            debug(atext);
            for i := 0 to strtoint(copy(s,1,system.pos(' ',s) - 1)) - 1 do
              begin
               fplaylist.add(lng('CD track') + ' ' + inttostr(i + 1));
               debug(lng('CD track') + ' ' + inttostr(i + 1));
              end;
            debug('*** RECEIVE TEXT: Format audio CD playlist (' + inttostr(fplaylist.count) + ' track(s). )');
            ftracknum := 0;
            fterm.writestrln('quit');
          end;
   end
  else
  if (system.pos('Connecting to server', atext) > 0)or(system.pos('Соединяюсь с сервером', atext) > 0)  then
    begin
      debug('*** RECEIVE TEXT: Connecting to server');
      if assigned(fonConnectingEv) then fonConnectingEv(self, lng('Connecting to server ...'));
    end
  else
  if (system.pos('Connected', atext) > 0)  then
    begin
      debug('*** RECEIVE TEXT: Connected');
      if assigned(fonConnectingEv) then fonConnectingEv(self, lng('Сonnected'));
    end
  else
  if (system.pos('Cache fill:', atext) > 0) or ((system.pos('Заполнение кэша:', atext) > 0)) then
    begin
      s := atext;
      delete(s,1,system.pos(':',s));
      debug('*** RECEIVE TEXT: Cache fill:' + s);
      if assigned(fonConnectingEv) then fonConnectingEv(self, lng('Cache fill:') + s);
    end
  else
  if (system.pos('Generated index table', atext) > 0)  then
    begin
      debug('*** RECEIVE TEXT: Generated index table');
      if assigned(fonConnectingEv) then fonConnectingEv(self, lng('Generated index table'));
    end
  else
  if (system.pos('Audio only file format detected', atext) > 0)  then
    begin
      fhavevideostream := false;
      debug('*** RECEIVE TEXT: Audio only file format detected');
      if assigned(fonConnectingEv) then fonConnectingEv(self, lng('Audio only file format detected'));
    end
  else
  if (system.pos('Incomplete stream? Trying resync.', atext) > 0)  then
    begin
      debug('*** RECEIVE TEXT: Incomplete stream? Trying resync.');
      if assigned(fonConnectingEv) then fonConnectingEv(self, lng('Incomplete stream? Trying resync'));
    end
  else
  if (system.pos('Cache not filling', atext) > 0)  then
    begin
      debug('*** RECEIVE TEXT: Cache not filling !');
      pausetime := 20;
      if assigned(fonPlayingEv) then fonPlayingEv(self, fpositionsec, flengthsec, lng('Cache not filling'));
    end;
end;
//==========================================================
//                MPLAYER MANAGEMENT
//==========================================================
//==========================================================
//                check if mplayer is exists
//==========================================================
function tmplayer.checkmplayer : boolean;
begin
  if not fileexists(fmplayer)
     then begin
            result := false;
            debug('*** CHECK PLAYER: mplayer not found');
            if assigned(fonErrorEv) then fonErrorEv(self, lng('Mplayer not found'));
          end
     else begin
            result := true;
            debug('*** CHECK PLAYER: mplayer found : ' + fmplayer);
          end;
end;
//==========================================================
//                check source (url, local file, analog tv, etc ...)
//==========================================================
function tmplayer.checksource(source : string) : tplaymode;
begin
 fmode := __localfile;
 if (system.pos('mms://'  , source) > 0) or
    (system.pos('http://' , source) > 0) or
    (system.pos('rtsp://' , source) > 0) then fmode := __inet;

 if ((system.pos('tv://' , source) > 0) and (system.pos('driver=v4l2',source) > 0)) or
    (source = 'webcamera') then fmode := __webcamera;

 if (system.pos('tv://' , source) > 0)  then fmode := __tv;

 if (system.pos('dvd://' , source) > 0) or
    (system.pos('dvdnav://', source) > 0)  then fmode := __dvd;

 if (system.pos(' cdd' , source) > 0) then fmode := __cd;
 (* add dvb, etc ... *)
 result := fmode;
 case fmode of
 __localfile : debug('*** CHECKSOUCE: source is local file');
 __inet : debug('*** CHECKSOUCE: source is internet source');
 __tv   : debug('*** CHECKSOUCE: source is TV-tuner');
 __webcamera   : debug('*** CHECKSOUCE: source is webcamera');
 __dvd  : debug('*** CHECKSOUCE: source is DVD');
 __cd   : debug('*** CHECKSOUCE: source is AUDIO CD');
 end;
end;
//==========================================================
//                get Window Id
//==========================================================
function tmplayer.getWindowId : string;
begin
  try   if assigned(fdisplay) then
        if fvideo_to_desktop
        then result := '-wid 0'
        else result := '-wid ' + inttostr(fdisplay.clientwinid);
  except result := '';
  end;
end;
//==========================================================
//                mplayer cmd line
//==========================================================
function tmplayer.cmdline(source : string) : string;
var  vo, ao : string;
       cach : string;
       indx : string;
begin
  if fvideooutputlist.indexof(fvideooutput) < 0 then fvideooutput := 'default';
  if faudiooutputlist.indexof(faudiooutput) < 0 then faudiooutput := 'default';
  if (fvideooutput = 'default') or (fvideooutput = '')
     then vo := ''
     else vo := ' -vo ' + fvideooutput;

  if (faudiooutput = 'default') or (faudiooutput = '')
     then ao := ''
     else ao := ' -ao ' + faudiooutput;

  if (fcache > '')
     then begin
            if (strtoint(fcache) < 32) then fcache := '32'; //from mplayer manual
            cach := ' -cache ' + fcache
          end
     else cach := '';

  if findexing then indx := ' -idx' else indx := '';

  result := fmplayer + ' -slave -softvol -quiet ' // noquiet is nessesary !
      		+ '-volume ' + inttostr(fvolume) + ' '
            + getwindowId + ' '
            + vo + ' '
            + ao + ' '
            + indx + ' '
            + cach + ' '
            + '-brightness ' + inttostr(fbrightness) + ' '
            + '-contrast ' + inttostr(fcontrast) + ' '
            {+ '-gamma ' + inttostr(fgamma) + ' '} // not work in windows
            + '-hue ' + inttostr(fhue) + ' '
            + '-saturation ' + inttostr(fsaturation) + ' '
      		+ '-vf screenshot '
            + fparams + ' '
            + '"' + source + '"';
end;
//==========================================================
//                PLAY  MANAGEMENT
//==========================================================
//==========================================================
//                play source
//==========================================================
procedure tmplayer.play(source : string);
begin
  play_playlist := false;
  __play(source);
end;
//==========================================================
//                play playlist
//==========================================================
procedure tmplayer.play;
begin
  if fplaylist.count = 0
    then begin
           if assigned(fonErrorEv) then fonErrorEv(self, lng('Playlist is empty'));
           debug('*** PLAY: Playlist is empty');
           exit;
         end;
  if ftracknum < 0 then ftracknum := 0;
  if ftracknum > fplaylist.count - 1 then ftracknum := fplaylist.count - 1;

  play_playlist := true;
  __play(fplaylist[ftracknum]);
end;
//==========================================================
//                play
//==========================================================
procedure tmplayer.__play(source : string);
begin
  startdebug;
  debug('*** PLAY ***');
  stop;
  if not checkmplayer then exit;
  fcurrenttrack.filename := source;
  fcurrenttrack.name := extractfilename(source);
  checksource(source);
  stop_it := false;
  fhavevideostream := true;  //showmessage(cmdline(source));
  debug('*** PLAY: ' + cmdline(source) );
  fterm.execprog( cmdline(source) );
  if assigned(fonConnectingEv) then fonConnectingEv(self, lng('Connecting ...'));
end;
//==========================================================
//                pause
//==========================================================
procedure tmplayer.pause;
begin
  if not fterm.running then exit;
  if fpausing then
     begin
       pausetime := 0;
       fpausing := false;
       if prevvolume <> fvolume then setvolume(fvolume);  //if volume has changed
       if fmode = __localfile
          then
            begin
              if prevposition <> fpositionsec then setposition(fpositionsec);  //setting position switch pause off
            end
          else fterm.writestrln('pause');
       debug('*** PAUSE: off');
       if assigned(fonPauseEv) then fonPauseEv(self, false, Lng('Playing'));
       exit;
     end;
  fpausing := true;
  debug('*** PAUSE: on');
  fterm.writestrln('pause');
  if assigned(fonPauseEv) then fonPauseEv(self, true, lng('Pause'));
end;
//==========================================================
//                stop
//==========================================================
procedure tmplayer.stop;
begin
  fpausing := true;  (*** DON`T TOUCH IT, ITS WORK ***)
  pausetime := 0;
  stop_it := true;
  if fterm.running
  then begin
         debug('*** STOP');
         fterm.writestrln('quit');
         fterm.waitforprocess;
         if fmode = __inet then
            begin
			   sleep(200);                               // when mplayer in connect stage
			   if fterm.running then                     // it don`t response
			      begin                                   // so we need to kill process
			        fterm.killprocess();
			        debug('*** STOP: send kill signal');
			        sleep(1000);
			        if fterm.running then debug('*** STOP: can`t stop process, maybe zomby');
			        if assigned(fonEndOfTrackEv) then fonEndOfTrackEv(self, lng('End of track'));
			      end;
		    end;
       end;
end;
//==========================================================
//                next
//==========================================================
procedure tmplayer.next;
begin
 if ftrackNum < fplaylist.count - 1
   then begin
          inc(ftrackNum);
          debug('*** NEXT: Next track is ' + inttostr(ftrackNum));
          if fmode = __cd then OpenAudioCD(ftrackNum + 1) else play;
        end
   else begin
          debug('*** NEXT: End of playlist');
          if fmode = __cd
             then if assigned(fonErrorEv) then fonErrorEv(self, lng('End of audio CD'))
             else if assigned(fonErrorEv) then fonErrorEv(self, lng('End of playlist'));
          if not frepeatplaylist
             then begin
                    stop;
                    debug('*** NEXT: Repeat playlist not allowed');
                  end
             else begin
                    ftrackNum := 0;
                    debug('*** NEXT: Repeat playlist. Next track is ' + inttostr(ftrackNum));
                    if fmode = __cd then OpenAudioCD(ftrackNum + 1) else play;
                  end;
         end;
end;
//==========================================================
//                prev
//==========================================================
procedure tmplayer.prev;
begin
 if ftrackNum > 0
    then begin
           dec(ftrackNum);
           debug('*** PREV: Prev track is ' + inttostr(ftrackNum));
           if fmode = __cd then OpenAudioCD(ftrackNum + 1) else play;
         end;
end;
//==========================================================
//                VOLUME MANAGEMENT
//==========================================================
//==========================================================
//                set volume
//==========================================================
procedure tmplayer.setvolume(avalue : integer);
begin
 if avalue < 0 then
      begin
        debug('*** VOLUME: Autocorrect volume from "' + inttostr(avalue) + '" to "0"');
        avalue := 0;
      end;

 if avalue > 100 then
      begin
        debug('*** VOLUME: Autocorrect volume from "' + inttostr(avalue) + '" to "100"');
        avalue := 100;
      end;

  fvolume := avalue;
  if fterm.running and not fpausing then
     begin
       fterm.writestrln('volume ' + inttostr(avalue) + ' 1');
       prevvolume := fvolume;
     end;
  debug('*** VOLUME: ' + inttostr(fvolume));
  if assigned(fonchangevolumeEv) then fonchangevolumeEv(self, fvolume);
end;
//==========================================================
//                mute
//==========================================================
procedure tmplayer.mute;
begin
  if fvolume <> 0
	 then begin
	        prevvolumemute := fvolume;
	        fvolume := 0;
	        debug('*** MUTE: on');
	      end
	 else begin
 	        fvolume := prevvolumemute;
 	        debug('*** MUTE: off');
	      end;
  setvolume(fvolume);
end;
//==========================================================
//                set position
//==========================================================
procedure tmplayer.setposition(avalue : integer);
begin
  ftimer.enabled := false;

   if avalue < 0 then
      begin
        debug('*** SETPOSITION: Autocorrect position from "' + inttostr(avalue) + '" to "0"');
        avalue := 0;
      end;

   if avalue > flengthsec then
      begin
        debug('*** SETPOSITION: Autocorrect position from "' + inttostr(avalue) + '" to "'+ inttostr(flengthsec) + '"');
        avalue := flengthsec;
      end;

  fpositionsec := avalue;
  if fterm.running and not fpausing then
   begin
     debug('*** SETPOSITION: ' + inttostr(fpositionsec));
     fterm.writestrln('seek ' + inttostr(avalue) + ' 2');
   end;
  ftimer.enabled := true;
end;
//==========================================================
//                set position in persent
//==========================================================
procedure tmplayer.setpositionpersent(avalue : integer);
begin
  if avalue < 0 then avalue := 0;
  if avalue > 100 then avalue := 100;
   if avalue < 0 then
      begin
        debug('*** SETPOSITIONPERSENT: Autocorrect position from "' + inttostr(avalue) + '" to "0"');
        avalue := 0;
      end;

   if avalue > 100 then
      begin
        debug('*** SETPOSITIONPERSENT: Autocorrect position from "' + inttostr(avalue) + '" to "100"');
        avalue := 100;
      end;
  fpositionsec := avalue;
  if fterm.running and not fpausing then
   begin
     debug('*** SETPOSITIONPERSENT: ' + inttostr(fpositionsec));
     fterm.writestrln('seek ' + inttostr(avalue) + ' 1');
   end;
end;
//==========================================================
//                VIDEO MANAGEMENT
//==========================================================
//==========================================================
//                Main procedure for settings params
//==========================================================
procedure tmplayer.setparam(vol: integer; var vparam : integer; capt : string; _start, _end : integer; _interval : integer);
begin
   if vol < _start then
      begin
        debug('*** '+ uppercase(capt) + ': Autocorrect from "' + inttostr(vol) + '" to "' + inttostr(_start)+ '"');
        vol := _start;
      end;

   if vol > _end then
      begin
        debug('*** '+ uppercase(capt) + ': Autocorrect from "' + inttostr(vol) + '" to "' + inttostr(_end)+ '"');
        vol := _end;
      end;

   if fterm.running then
     begin
       debug('*** '+ uppercase(capt) + ': ' + inttostr(vparam));
       fterm.writestrln(capt + ' ' + inttostr(vol) + ' ' + inttostr(_interval));
     end;
   vparam := vol;
end;
//==========================================================
//                brightness
//==========================================================
procedure tmplayer.setbrightness(const avalue : integer);
begin
  setparam(avalue, fbrightness, 'brightness', -100, 100, 1);
end;
//==========================================================
//                contrast
//==========================================================
procedure tmplayer.setcontrast(const avalue : integer);
begin
  setparam(avalue, fcontrast, 'contrast', -100, 100, 1);
end;
//==========================================================
//                gamma
//==========================================================
procedure tmplayer.setgamma(const avalue : integer);
begin
  setparam(avalue, fgamma, 'gamma', -100, 100, 1);
end;
//==========================================================
//                hue
//==========================================================
procedure tmplayer.sethue(const avalue : integer);
begin
  setparam(avalue, fhue, 'hue', -100, 100, 1);
end;
//==========================================================
//                saturation
//==========================================================
procedure tmplayer.setsaturation(const avalue : integer);
begin
  setparam(avalue, fsaturation, 'saturation', -100, 100, 1);
end;
// =======================================================
//               SCREENSHOTS
// =======================================================
// =======================================================
//               take screenshot
// =======================================================
procedure tmplayer.screenshot;
begin
  if fterm.running then
    begin
      debug('*** SCREENSHOT');
      fterm.writestrln('screenshot 0');
    end;
end;
//==========================================================
//                WEBCAMERA
//==========================================================
//==========================================================
//                open webcamera
//==========================================================
procedure tmplayer.openwebcamera;
var     cmd : string;
begin
  startdebug;
  debug('*** WEBCAMERA ***');
  if not checkmplayer then exit;
  fmode := __webcamera;
  stop;
  fcurrenttrack.filename := lng('Webcamera');
  fcurrenttrack.name := lng('Webcamera');
  fhavevideostream := true;
  if assigned(fonConnectingEv) then fonConnectingEv(self, lng('Connecting ...'));

  {$ifdef linux}
  cmd :=  cmdline('') + ' tv:// -tv driver=v4l2:width=640:height=480:device=/dev/'
           + fwebcameradevice;
  {$endif}
  {$ifdef mswindows}
  cmd :=  cmdline('') + ' tv://';
  {$endif}
  debug('*** WEBCAMERA: ' + cmd);
  fterm.execprog(cmd);
end;
//==========================================================
//                open webcamera with preload v4l2convert.so
//==========================================================
procedure tmplayer.openwebcamera_withpreload;
var     cmd : string;
begin
  startdebug;
  debug('*** WEBCAMERA (with preload) ***');
  if not checkmplayer then exit;
  fmode := __webcamera;
  stop;
  fcurrenttrack.filename := lng('Webcamera');
  fcurrenttrack.name := lng('Webcamera');
  fhavevideostream := true;
  if assigned(fonConnectingEv) then fonConnectingEv(self, lng('Connecting ...'));
  cmd :=  ' env LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so '
          + cmdline('') + ' tv:// -tv driver=v4l2:width=640:height=480:device=/dev/'
          + fwebcameradevice;
  debug('*** WEBCAMERA (with preload): ' + cmd);
  fterm.execprog(cmd);
end;
//==========================================================
//                AUDIO CD
//==========================================================
//==========================================================
//                connecting to cd device for takeing playlist
//==========================================================
procedure tmplayer.ConnectToAudioCD;
begin
  startdebug;
  fmode := __cd;
  debug('*** AUDIO CD ***');
  debug('*** AUDIO CD: Connecting to CD device ...');
  connecttocddevice := true;
  __openaudiocd(0);
end;
//==========================================================
//                Open audioCD
//==========================================================
procedure tmplayer.OpenAudioCD;
begin
  play_playlist := false;
  __openaudiocd(0);
end;
//==========================================================
//                Open audioCD (truck)
//==========================================================
procedure tmplayer.OpenAudioCD(tracknum : integer);
begin
  play_playlist := true;
  __openaudiocd(tracknum);
end;
//==========================================================
//                Open audioCD - main
//==========================================================
procedure tmplayer.__openaudiocd(trucknum : integer);
var cmd, dev, tr  : string;
begin
  startdebug;
  debug('*** AUDIO CD ***');
  stop;
  if not checkmplayer then exit;
  fmode := __cd;
  fcurrenttrack.filename := lng('AudioCD');
  fcurrenttrack.name := lng('AudioCD');
  fhavevideostream := false;
  if connecttocddevice
     then begin
          if assigned(fonConnectingEv) then fonConnectingEv(self, lng('Connecting to CD device ...'));
          end
     else if assigned(fonConnectingEv) then fonConnectingEv(self, lng('Connecting ...'));
  if trucknum = 0 then tr := '' else tr := inttostr(trucknum);
  if (fcdromdevice = 'default')or(fcdromdevice = '')
     then dev := ''
     else dev := ' -cdrom-device ' + fcdromdevice;
  cmd := cmdline('') + ' cdda://' + tr + dev;
  stop_it := false;
  debug('*** AUDIO CD: ' + cmd);
  fterm.execprog(cmd);
end;
//==========================================================
//                DVD
//==========================================================
//==========================================================
//                open DVD
//==========================================================
procedure tmplayer.OpenDVD;
var cmd : string;
begin
  startdebug;
  debug('*** DVD ***');
  if not checkmplayer then exit;
  stop;
  fmode := __dvd;
  fcurrenttrack.filename := lng('DVD');
  fcurrenttrack.name := lng('DVD');
  fhavevideostream := true;
  if assigned(fonConnectingEv) then fonConnectingEv(self, lng('Connecting ...'));
  if fDVDusenavigation
     then cmd := cmdline('') + ' dvdnav://'
     else cmd := cmdline('') + ' dvd://';
  debug('*** DVD : ' + cmd);
  fterm.execprog(cmd);
end;
//==========================================================
//                DVD navigation
//==========================================================
procedure tmplayer.dvdnav(navcommand : string);
begin
  if fterm.running then
     begin
       debug('*** DVD MENU NAVIGATION: ' + navcommand);
       fterm.writestrln('dvdnav ' + navcommand);
     end;
end;
//==========================================================
//                DVD navigation in menu : up
//==========================================================
procedure tmplayer.dvdnavigation_up;
begin
  dvdnav('up');
end;
//==========================================================
//                DVD navigation in menu : down
//==========================================================
procedure tmplayer.dvdnavigation_down;
begin
  dvdnav('down');
end;
//==========================================================
//                DVD navigation in menu : left
//==========================================================
procedure tmplayer.dvdnavigation_left;
begin
  dvdnav('left');
end;
//==========================================================
//                DVD navigation in menu : right
//==========================================================
procedure tmplayer.dvdnavigation_right;
begin
  dvdnav('right');
end;
//==========================================================
//                DVD navigation : go to menu
//==========================================================
procedure tmplayer.dvdnavigation_menu;
begin
  dvdnav('menu');
end;
//==========================================================
//                DVD navigation in menu : select
//==========================================================
procedure tmplayer.dvdnavigation_select;
begin
  dvdnav('select');
end;
//==========================================================
//                DVD navigation in menu : prev
//==========================================================
procedure tmplayer.dvdnavigation_prev;
begin
  dvdnav('prev');
end;
//==========================================================
//                DVD navigation : === ??? ===
//==========================================================
procedure tmplayer.dvdnavigation_mouse;
begin
  dvdnav('mouse'); // == ??? ==
end;
//==========================================================
//                SEND OWN COMMAND TO MPLAYER
//==========================================================
procedure tmplayer.SendCommandToMPlayer(cmd : string);
begin
 if fterm.running then
   begin
     fterm.writestrln(cmd);
     debug('*** SENDING USER COMMAND TO MPLAYER :' + cmd);
   end;
end;
//==========================================================
//          Open TV
//==========================================================
procedure tmplayer.OpenTV();
var     cmd : string;
begin
  startdebug;
  debug('*** TV tuner ***');
  if not checkmplayer then exit;
  stop;
  fcurrenttrack.filename := lng('TV Tuner');
  fcurrenttrack.name := lng('TV Tuner');
  if assigned(fonConnectingEv) then fonConnectingEv(self, lng('Connecting ...'));
  fmode:=__tv;
  {$ifdef linux}
  cmd := cmdline('') + ' tv:// -tv device=/dev/' + ftvtunerdevice;
  {$endif}
  {$ifdef mswindows}
  cmd := cmdline('') + ' tv://';
  {$endif}
  fhavevideostream := true;
  debug('*** TV tuner:' + cmd);
  fterm.execprog(cmd);
end;
//==========================================================
//                TTVDataList class
//==========================================================
function TTVDataList.AddItem(Item: TTVData): Integer;
var p: PTVData;
begin
  New(p);
  p^:=Item;
  Result := FTVList.Add(p); // просто перенаправляем вызов
end;

function TTVDataList.Count: integer;
begin
  Result := FTVList.Count; // просто перенаправляем вызов
end;

constructor TTVDataList.Create;
begin
  inherited Create;
  FTVList := TList.Create; // не забываем создать объект
end;

destructor TTVDataList.Destroy;
begin
  FTVList.Free; // уничтожаем объект
  inherited Destroy;
end;

procedure TTVDataList.Exchange(idx1, idx2: integer);
begin
  FTVList.Exchange(idx1, idx2); // просто перенаправляем вызов
end;

function TTVDataList.GetData(Idx: integer): TTVData;
begin
  FillChar(Result, SizeOf(TTVData), #0);
  Result :=TTVData(FTVList.Items[Idx]^); // перенаправляем вызов и приводим к TTVData
end;

procedure TTVDataList.SetData(IDx:integer;Data:TTvdata);
begin
  TTVData(FTVList.Items[Idx]^):=Data;
end;

procedure TTVDataList.RemoveItem(ItemIndex: Integer);
begin
  dispose(Ptvdata(FTVList[ItemIndex]));
  //FreeMem(FTVList[ItemIndex]); // освобождаем память тоже сами
  FTVList.Delete(ItemIndex);
end;
//==========================================================
//                tv chanels management
//==========================================================
procedure tmplayer.SetChannelByfreq(const Ch_freq: integer);
begin
if fterm.running then
   fterm.writestrln('tv_set_freq ' + IntToStr(Ch_freq));
end;

procedure tmplayer.SetChannelByName(const Ch_name: TvCannelName);
begin
if fterm.running then
   fterm.writestrln('tv_set_channel ' + tvCannelNameStr[Ch_name]);
end;

procedure tmplayer.SetChannelNorm(const __TVNorm: tvnorm);
begin
if fterm.running then
   fterm.writestrln('tv_set_norm ' + TvStr[__TVNorm]);
end;

//==========================================================
//         TIMER :  send length and position request
//==========================================================
procedure tmplayer.on_timer(const sender : tobject);
begin
  if playnexttrack then
	 begin
	   playnexttrack := false;
	   next;
	   exit;
	 end;

  if beginplayback then
     begin
       beginplayback := false;
       if assigned(fonstartplayEv) then fonstartplayEv(self, fcurrenttrack.video.Width, fcurrenttrack.video.height, Lng('Playing'));
       exit;
     end;

  if pausetime > 0 then   // pause if "Cache not filling"
     begin
       if pausetime = 20
          then begin
                 debug('*** TIMER : try pause for caching ...');
                 fterm.writestrln('pause');
               end
          else begin
                 debug('*** TIMER : Pause for caching, please, wait ... ' + inttostr(pausetime));
                 if assigned(fonErrorEv) then fonErrorEv(self, lng('Pause for caching, please, wait ... ') + inttostr(pausetime));
               end;

       dec(pausetime);

       if pausetime = 0 then
          begin
           fterm.writestrln('pause');
           fpausing := false;
          end;
       exit;
     end;

   if fterm.running and not fpausing then
     begin
      fterm.writestrln('get_time_length');
      fterm.writestrln('get_time_pos');
      //if assigned(fonPlayingEv) then fonPlayingEv(self, fpositionsec, flengthsec, lng('Playing'));
      //debug('*** TIMER : time and length request');
     end;
end;

end.
// revision 24/08/2001 - 1482 strings (aval vo and ao, lang support)
// revision 31/05/2011 - 1209 strings (update pause system)
// revision 31/05/2011 - 1212 strings (add cd, rebuild pause system)
// revision 25/04/2011 - 998 strings
// revision 24/04/2011 - 535 strings
// REVISION 13/03/2011 - 1251 STRINGS
// revision 25/02/2011 - 1191 strings
// revision 20/02/2011 - 1230 strings
// revision 02/02/2011 - 1363 strings
// revision 21/12/2010 - 1335 strings
// revision 01/12/2010 - 1000 strings (add dvd)
// revision 18/11/2010 - 818 strings
// revision 18/10/2010 - 881 strings
// revision 13/10/2010 - 691 strings
// revision 14/09/2010 - 685 strings
// revision 29/08/2010 - 1038 strings