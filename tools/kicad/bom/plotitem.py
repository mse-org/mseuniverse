#plotitem
# will be moved to MSEgui Python-component later
#
from kicadcommon import *

def plotitem(apcbfilename,aoutputdir,aformat,alayer,acolor,
                   arefon,arefcolor,avalon,avalcolor,ashowinvis,adrillmarks): 
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
 popt.SetDrillMarksType(drillmarkenums[drillmarknames.index(adrillmarks)])
 popt.SetPlotReference(arefon == 'True')
 popt.SetReferenceColor(colorenums[colornames.index(arefcolor)])
 popt.SetPlotValue(avalon == 'True')
 popt.SetValueColor(colorenums[colornames.index(avalcolor)])
 popt.SetPlotInvisibleText(ashowinvis == 'True')
 pctl.OpenPlotfile(lnames[0],format,'')
# print popt.GetPlotReference()
# print popt.GetPlotValue()
# print popt.GetDrillMarksType()
# print popt.GetPlotInvisibleText()
 for i1 in range(0,len(layers)):
  """
  if True: #i1 == len(layers)-1:
   popt.SetPlotReference(arefon == 'True')
   popt.SetReferenceColor(colorenums[colornames.index(arefcolor)])
   popt.SetPlotValue(avalon == 'True')
   popt.SetValueColor(colorenums[colornames.index(avalcolor)])
   popt.SetPlotInvisibleText(ashowinvis == 'True')
  else:
   popt.SetPlotReference(False)
   popt.SetReferenceColor(UNSPECIFIED_COLOR)
   popt.SetPlotValue(False)
   popt.SetValueColor(UNSPECIFIED_COLOR)
   popt.SetPlotInvisibleText(False)
  """
  pctl.SetLayer(layers[i1])
  pctl.SetColorMode(colors[i1] != UNSPECIFIED_COLOR)
  popt.SetColor(colors[i1])
  pctl.PlotLayer()
 pctl.ClosePlot()
# print qweq