#plotitem
# will be moved to MSEgui Python-component later
#
from kicadcommon import *

def plotitem(apcbfilename,aoutputdir,aformat,alayer,acolor,
                   arefon,arefcolor,avalon,avalcolor,ainvison,adrillmarks): 
                         #alayer = commaseparated elements of layernames
                         #acolor = commaseparated elements of colornames
 print '*Plot ',alayer,' Format:',aformat,' to'
 print aoutputdir
 lnames = alayer.split(',');
 cnames = acolor.split(',');
 refons = arefon.split(',');
 refcolors = arefcolor.split(',');
 valons = avalon.split(',');
 valcolors = avalcolor.split(',');
 invisons = ainvison.split(',');
 drillmarks = adrillmarks.split(',');
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
# popt.SetDrillMarksType(drillmarkenums[drillmarknames.index(adrillmarks)])
 pctl.OpenPlotfile(lnames[0],format,'')
 for i1 in range(0,len(layers)):
  pctl.SetLayer(layers[i1])
  pctl.SetColorMode(colors[i1] != UNSPECIFIED_COLOR)
  popt.SetColor(colors[i1])
  popt.SetPlotReference(refons[i1] == 'True')
  popt.SetReferenceColor(colorenums[colornames.index(refcolors[i1])])
  popt.SetPlotValue(valons[i1] == 'True')
  popt.SetValueColor(colorenums[colornames.index(valcolors[i1])])
  popt.SetPlotInvisibleText(invisons[i1] == 'True')
  popt.SetDrillMarksType(drillmarkenums[drillmarknames.index(drillmarks[i1])])
#  pctl.SetLayer(layers[i1])
  pctl.PlotLayer()
 pctl.ClosePlot()
# print qweq