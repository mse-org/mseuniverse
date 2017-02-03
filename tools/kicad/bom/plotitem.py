#plotitem
# will be moved to MSEgui Python-component later
#
from kicadcommon import *

def plotitem(apcbfilename,aoutputdir,aformat,alayer,acolor): 
                         #alayer = commaseparated elements of layernames
                         #acolor = commaseparated elements of colornames
 print '*Plot ',alayer,' Format:',aformat,' to'
 print aoutputdir
 lnames = alayer.split(',');
 cnames = acolor.split(',');
 layers = []
 colors = []
 hascolor = False
 for lname in lnames:
  layers.append(layerenums[layernames.index(lname)]);
 for cname in cnames:
  if cname != '':
   hascolor = True
  colors.append(colorenums[colornames.index(cname)]);
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
 for i1 in range(0,len(layers)):
  pctl.SetColorMode(colors[i1] != UNSPECIFIED_COLOR)
  popt.SetColor(colors[i1])
  pctl.SetLayer(layers[i1])
  pctl.PlotLayer()
 pctl.ClosePlot()