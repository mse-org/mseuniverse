# kicadcommon
# will be moved to MSEgui Python-component later
#
from pcbnew import *
truesymbol = 'True'
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

drillnames = ('Drill_Map','Excellon')
DRILL_MAP = 0
EXCELLON = 1
drillenums = (DRILL_MAP,EXCELLON,0)

formatenums = (
 PLOT_FORMAT_HPGL,PLOT_FORMAT_GERBER,PLOT_FORMAT_POST,
 PLOT_FORMAT_DXF,PLOT_FORMAT_PDF,PLOT_FORMAT_SVG)

formatnames = ('HPGL','GERBER','POST','DXF','PDF','SVG')

colorenums = (
 UNSPECIFIED_COLOR,
 BLACK,
 DARKDARKGRAY,
 DARKGRAY,
 LIGHTGRAY,
 WHITE,
 LIGHTYELLOW,
 DARKBLUE,
 DARKGREEN,
 DARKCYAN,
 DARKRED,
 DARKMAGENTA,
 DARKBROWN,
 BLUE,
 GREEN,
 CYAN,
 RED,
 MAGENTA,
 BROWN,
 LIGHTBLUE,
 LIGHTGREEN,
 LIGHTCYAN,
 LIGHTRED,
 LIGHTMAGENTA,
 YELLOW,
 PUREBLUE,
 PUREGREEN,
 PURECYAN,
 PURERED,
 PUREMAGENTA,
 PUREYELLOW)

colornames = (
 '',
 'BLACK',
 'DARKDARKGRAY',
 'DARKGRAY',
 'LIGHTGRAY',
 'WHITE',
 'LIGHTYELLOW',
 'DARKBLUE',
 'DARKGREEN',
 'DARKCYAN',
 'DARKRED',
 'DARKMAGENTA',
 'DARKBROWN',
 'BLUE',
 'GREEN',
 'CYAN',
 'RED',
 'MAGENTA',
 'BROWN',
 'LIGHTBLUE',
 'LIGHTGREEN',
 'LIGHTCYAN',
 'LIGHTRED',
 'LIGHTMAGENTA',
 'YELLOW',
 'PUREBLUE',
 'PUREGREEN',
 'PURECYAN',
 'PURERED',
 'PUREMAGENTA',
 'PUREYELLOW')

drillmarkenums = (
 0,
 1,
 2)

drillmarknames = (
 'None',
 'Small',
 'Full')
