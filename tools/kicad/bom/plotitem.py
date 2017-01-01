#plotitem
# will be moved to MSEgui Python-component later
#
from kicadcommon import *

def plotitem(apcbfilename,aoutputdir,aformat,alayer): 
                                  #alayer = element of layernames
 print '*Plot ',alayer,' Format:',aformat,' to'
 print aoutputdir

 layer = layerenums[layernames.index(alayer)]
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
 popt.SetScale(1)
 popt.SetUseAuxOrigin(True)
 popt.SetSubtractMaskFromSilk(False)

 pctl.SetLayer(layer)
 pctl.OpenPlotfile(alayer,format,'')
 pctl.PlotLayer()
 pctl.ClosePlot()

