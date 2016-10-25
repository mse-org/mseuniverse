# will be moved to MSEgui Python-component later
#
from pcbnew import *

layerenums = (
 F_Cu,In1_Cu,In2_Cu,In3_Cu,In4_Cu,In5_Cu,In6_Cu,In7_Cu,
 In8_Cu,In9_Cu,In10_Cu,In11_Cu,In12_Cu,In13_Cu,In14_Cu,In15_Cu,In16_Cu,
 In17_Cu,In18_Cu,In19_Cu,In20_Cu,In21_Cu,In22_Cu,In23_Cu,
 In24_Cu,In25_Cu,In26_Cu,In27_Cu,In28_Cu,In29_Cu,In30_Cu,B_Cu,
 B_Adhes,F_Adhes,B_Paste,F_Paste,B_SilkS,F_SilkS,B_Mask,F_Mask,
 Dwgs_User,Cmts_User,Eco1_User,Eco2_User,Edge_Cuts,Margin,
 B_CrtYd,F_CrtYd,B_Fab,F_Fab)

layernames = (
 'F_Cu','In1_Cu','In2_Cu','In3_Cu','In4_Cu','In5_Cu','In6_Cu','In7_Cu','In8_Cu',
 'In9_Cu','In10_Cu','In11_Cu','In12_Cu','In13_Cu','In14_Cu','In15_Cu','In16_Cu',
 'In17_Cu','In18_Cu','In19_Cu','In20_Cu','In21_Cu','In22_Cu','In23_Cu',
 'In24_Cu','In25_Cu','In26_Cu','In27_Cu','In28_Cu','In29_Cu','In30_Cu','B_Cu',
 'B_Adhes','F_Adhes','B_Paste','F_Paste','B_SilkS','F_SilkS','B_Mask',
 'F_Mask','Dwgs_User','Cmts_User','Eco1_User','Eco2_User','Edge_Cuts','Margin',
 'B_CrtYd','F_CrtYd','B_Fab','F_Fab')

formatenums = (
 PLOT_FORMAT_HPGL,PLOT_FORMAT_GERBER,PLOT_FORMAT_POST,
 PLOT_FORMAT_DXF,PLOT_FORMAT_PDF,PLOT_FORMAT_SVG)

formatnames = ('HPGL','GERBER','POST','DXF','PDF','SVG')

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

