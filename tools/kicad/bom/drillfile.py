#drillfile
# will be moved to MSEgui Python-component later
#
from kicadcommon import *

def drillfile(apcbfilename,aoutputfile,akind,
                                    alayera,alayerb,anonplated,aformat):
 print '*Drill ',akind,'Layers:',alayera,':',alayerb,' nonplated:',anonplated,\
                ' Format:',aformat,' to'
 print aoutputfile

 kind = drillenums[drillnames.index(akind)]
 format = formatenums[formatnames.index(aformat)]
 layera = layerenums[layernames.index(alayera)]
 layerb = layerenums[layernames.index(alayerb)]
 board = LoadBoard(apcbfilename)
 drlwriter = EXCELLON_WRITER(board)
 drlwriter.SetMapFileFormat(format)
 if kind == DRILL_MAP:
  pair = base_seqVect()
#  pair.first = alayera;
#  pair.second = alayerb;
  print pair
  drlwriter.BuildHolesList(pair,anonplated)
  drlwriter.GenDrillMapFile(aoutputfile,format)