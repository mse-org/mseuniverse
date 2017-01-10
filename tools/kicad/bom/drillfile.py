#drillfile
# will be moved to MSEgui Python-component later
#
from kicadcommon import *

def drillfile(apcbfilename,aoutputfile,aformat,alayer): 
 print '*Drill ',alayer,' Format:',aformat,' to'
 print aoutputfile

 drill = drillenums[drillnames.index(alayer)]
 format = formatenums[formatnames.index(aformat)]
 
 board = LoadBoard(apcbfilename)
 drlwriter = EXCELLON_WRITER(board)
 drlwriter.SetMapFileFormat(format)
# f = open(aoutputfile,'w')
 print 'format:',format
 if drill == DRILL_MAP:
  drlwriter.GenDrillMapFile(aoutputfile,format)