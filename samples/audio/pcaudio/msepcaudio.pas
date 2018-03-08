{/* Audio API.
 *
 * Copyright (C) 2016 Reece H. Dunn
 *
 * This file is part of pcaudiolib.
 *
 * pcaudiolib is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * pcaudiolib is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with pcaudiolib.  If not, see <http://www.gnu.org/licenses/>.
 */}
 
unit msepcaudio;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msectypes,msetypes,sysutils,msestrings;
 {$packrecords c}
 
const
{$ifdef mswindows}
// {$define wincall}
 pcaudiolib: array[0..0] of filenamety = (
   'pcaudio.dll');
{$else}
 pcaudiolib: array[0..1] of filenamety = 
    ('libpcaudio.so.0','libpcaudio.so'); 
{$endif}

type
 audio_object_format = (
  AUDIO_OBJECT_FORMAT_S8,
  AUDIO_OBJECT_FORMAT_U8,
  
  AUDIO_OBJECT_FORMAT_S16LE,
  AUDIO_OBJECT_FORMAT_S16BE,
  AUDIO_OBJECT_FORMAT_U16LE,
  AUDIO_OBJECT_FORMAT_U16BE,
  
  AUDIO_OBJECT_FORMAT_S18LE,
  AUDIO_OBJECT_FORMAT_S18BE,
  AUDIO_OBJECT_FORMAT_U18LE,
  AUDIO_OBJECT_FORMAT_U18BE,
  
  AUDIO_OBJECT_FORMAT_S20LE,
  AUDIO_OBJECT_FORMAT_S20BE,
  AUDIO_OBJECT_FORMAT_U20LE,
  AUDIO_OBJECT_FORMAT_U20BE,
  
  AUDIO_OBJECT_FORMAT_S24LE,
  AUDIO_OBJECT_FORMAT_S24BE,
  AUDIO_OBJECT_FORMAT_U24LE,
  AUDIO_OBJECT_FORMAT_U24BE,
  
  AUDIO_OBJECT_FORMAT_S24_32LE,
  AUDIO_OBJECT_FORMAT_S24_32BE,
  AUDIO_OBJECT_FORMAT_U24_32LE,
  AUDIO_OBJECT_FORMAT_U24_32BE,
  
  AUDIO_OBJECT_FORMAT_S32LE,
  AUDIO_OBJECT_FORMAT_S32BE,
  AUDIO_OBJECT_FORMAT_U32LE,
  AUDIO_OBJECT_FORMAT_U32BE,
  
  AUDIO_OBJECT_FORMAT_FLOAT32LE,
  AUDIO_OBJECT_FORMAT_FLOAT32BE,
  AUDIO_OBJECT_FORMAT_FLOAT64LE,
  AUDIO_OBJECT_FORMAT_FLOAT64BE,
  
  AUDIO_OBJECT_FORMAT_IEC958LE,
  AUDIO_OBJECT_FORMAT_IEC958BE,
  
  AUDIO_OBJECT_FORMAT_ALAW,
  AUDIO_OBJECT_FORMAT_ULAW,
  AUDIO_OBJECT_FORMAT_ADPCM,
  AUDIO_OBJECT_FORMAT_MPEG,
  AUDIO_OBJECT_FORMAT_GSM,
  AUDIO_OBJECT_FORMAT_AC3
);

 audio_object = record
 end;
 paudio_object = ^audio_object;

var
 audio_object_open:
  function(_object: paudio_object; format: audio_object_format;
                            rate: cuint32; channels: cuint8): cint 
                                   {$ifdef wincall}stdcall{$else}cdecl{$endif};
 audio_object_close:
  procedure(_object: paudio_object){$ifdef wincall}stdcall{$else}cdecl{$endif};
 audio_object_destroy:
  procedure(_object: paudio_object){$ifdef wincall}stdcall{$else}cdecl{$endif};

 audio_object_write:
  function(_object: paudio_object; data: pointer; bytes: size_t): cint
                                   {$ifdef wincall}stdcall{$else}cdecl{$endif};
 audio_object_drain:
  function (_object: paudio_object): cint
                                   {$ifdef wincall}stdcall{$else}cdecl{$endif};
 audio_object_flush:
  function (_object: paudio_object): cint
                                   {$ifdef wincall}stdcall{$else}cdecl{$endif};
 audio_object_strerror:
  function(_object: paudio_object; error: cint): pcchar
                                   {$ifdef wincall}stdcall{$else}cdecl{$endif};
 create_audio_device_object:
  function(device: pcchar; application_name: pcchar;
                           description: pcchar): paudio_object
                                   {$ifdef wincall}stdcall{$else}cdecl{$endif};

procedure initializepcaudio(const sonames: array of filenamety); 
                                  //[],'' = default
procedure releasepcaudio();

implementation
uses
 msedynload;
var
 libinfo: dynlibinfoty;

procedure initializepcaudio(const sonames: array of filenamety);

const
 funcs: array[0..7] of funcinfoty = (
  (n: 'audio_object_open'; d: @audio_object_open),
  (n: 'audio_object_close'; d: @audio_object_close),
  (n: 'audio_object_destroy'; d: @audio_object_destroy),
  (n: 'audio_object_write'; d: @audio_object_write),
  (n: 'audio_object_drain'; d: @audio_object_drain),
  (n: 'audio_object_flush'; d: @audio_object_flush),
  (n: 'audio_object_strerror'; d: @audio_object_strerror),
  (n: 'create_audio_device_object'; d: @create_audio_device_object)
 );
 errormessage = 'Can not load pcaudio library. ';
begin
 initializedynlib(libinfo,sonames,pcaudiolib,funcs,[],errormessage);
end;

procedure releasepcaudio();
begin
 releasedynlib(libinfo);
end;

initialization
 initializelibinfo(libinfo);
finalization
 finalizelibinfo(libinfo);
end.
