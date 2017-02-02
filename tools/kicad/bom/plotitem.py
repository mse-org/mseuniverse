#plotitem
# will be moved to MSEgui Python-component later
#
from kicadcommon import *

def plotitem(apcbfilename,aoutputdir,aformat,alayer): 
                         #alayer = commaseparated elements of layernames
 print '*Plot ',alayer,' Format:',aformat,' to'
 print aoutputdir
 lnames = alayer.split(',');
 layers = []
 for lname in lnames:
  layers.append(layerenums[layernames.index(lname)]);
# layer = layerenums[layernames.index(alayer)]
 format = formatenums[formatnames.index(aformat)]
 
 board = LoadBoard(apcbfilename)
 pctl = PLOT_CONTROLLER(board)
 popt = pctl.GetPlotOptions()
 popt.SetOutputDirectory(aoutputdir)
 popt.SetPlotFrameRef(False)
 popt.SetLineWidth(FromMM(0.35))

 popt.SetAutoScale(False)
 popt.SetScale(1)
 popt.SetMirror(False)
 popt.SetUseGerberAttributes(True)
 popt.SetExcludeEdgeLayer(True);
 popt.SetUseAuxOrigin(True)
 popt.SetSubtractMaskFromSilk(False)

 pctl.OpenPlotfile(lnames[0],format,'')
 for la in layers:
  pctl.SetLayer(la)
  pctl.PlotLayer()
 pctl.ClosePlot()
