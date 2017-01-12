#drillfile
# will be moved to MSEgui Python-component later
#
from kicadcommon import *

class LAYER_PAIR:
 pass

def drillfile(apcbfilename,aoutputfile,akind,
                                    alayera,alayerb,anonplated,aformat):
 print '*Drill ',akind,'Layers:',alayera,':',alayerb,' nonplated:',anonplated,
 kind = drillenums[drillnames.index(akind)]
 if kind == DRILL_MAP:
  print ' Format:',aformat,' to'
 else:
  print ' to'
 print aoutputfile

 format = formatenums[formatnames.index(aformat)]
 layera = layerenums[layernames.index(alayera)]
 layerb = layerenums[layernames.index(alayerb)]
 board = LoadBoard(apcbfilename)
 drlwriter = EXCELLON_WRITER(board)
 drlwriter.SetMapFileFormat(format)
 pair = LAYER_PAIR()
 pair.first = alayera;
 pair.second = alayerb;
#  drlwriter.BuildHolesList(pair,anonplated)
 if kind == DRILL_MAP:
  drlwriter.GenDrillMapFile(aoutputfile,format)
 elif kind == EXCELLON:
  f1 = file(aoutputfile,'w')
#  drlwriter.CreateDrillFile(f1)
  f1.close()
