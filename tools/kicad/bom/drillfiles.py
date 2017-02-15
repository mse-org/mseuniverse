#drillfiles
# will be moved to MSEgui Python-component later
#
from kicadcommon import *
def drillfiles(apcbfilename,aoutputdir,amakeexcellon,amakemap,amapformat):
 print '*Build drillfiles in'
 print aoutputdir
 board = LoadBoard(apcbfilename)
 drlwriter = EXCELLON_WRITER(board)
 if amapformat != '':
  print amapformat
  format = formatenums[formatnames.index(amapformat)]
  drlwriter.SetMapFileFormat(format);
 drlwriter.CreateDrillandMapFilesSet(aoutputdir,amakeexcellon == truesymbol,
                                                        amakemap == truesymbol)