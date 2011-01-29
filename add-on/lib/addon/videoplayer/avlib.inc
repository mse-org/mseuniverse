{$ifdef linux}
  av__codec = 'libavcodec.so.52';
  av__format = 'libavformat.so.52';
  av__util = 'libavutil.so.50';
  sw__scale = 'libswscale.so.0';
{$endif}

{$ifdef windows}
  av__codec = 'avcodec-52';
  av__format = 'avformat-52';
  av__util = 'avutil-50';
  sw__scale = 'swscale-0';
{$endif}
