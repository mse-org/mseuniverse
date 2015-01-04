unit dark;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseapplication,mseclasses,msedatamodules,mseskin,msegui,
 msegraphics,msegraphutils,mseguiglob,msemenus,msesimplewidgets,msewidgets;

type
 tdarkmo = class(tmsedatamodule)
   tskincontroller1: tskincontroller;
   buttonface: tfacecomp;
   buttonframe: tframecomp;
   EditFace: tfacecomp;
   EditFrame: tframecomp;
   ContainerFace: tfacecomp;
   GroupBoxFrame: tframecomp;
   GroupBoxFace: tfacecomp;
   DispWidgetFrame: tframecomp;
   ToolBarFace: tfacecomp;
   ToolBarFrame: tframecomp;
   ToolBarButtonFace: tfacecomp;
   BooleanEditFace: tfacecomp;
   BooleanEditFrame: tframecomp;
   GridDataColFace: tfacecomp;
   GridFace: tfacecomp;
   GridFixedColFace: tfacecomp;
   GridFixedRowFace: tfacecomp;
   GridFrame: tframecomp;
   GridFixedColFrame: tframecomp;
   GridFixedRowFrame: tframecomp;
   GridDataColFrame: tframecomp;
   SliderFaceButtonHoriz: tfacecomp;
   SliderFaceEndButtonHoriz: tfacecomp;
   SliderFrameButtonHoriz: tframecomp;
   SliderFrameEndButton1Horiz: tframecomp;
   SliderFrameEndButton2Horiz: tframecomp;
   SliderFace: tfacecomp;
   SliderFrame: tframecomp;
   SliderFaceButtonVertical: tfacecomp;
   SliderFaceEndButtonVertical: tfacecomp;
   SliderFrameButtonVertical: tframecomp;
   SliderFrameEndBUtton1Vertical: tframecomp;
   SliderFrameEndBUtton2Vertical: tframecomp;
   MenuFace: tfacecomp;
   MenuFrame: tframecomp;
   MenuItemFace: tfacecomp;
   MenuItemFaceActive: tfacecomp;
   MenuItemFrame: tframecomp;
   MenuItemFrameActive: tframecomp;
   MenuPopupCheckBxFrame: tframecomp;
   MenuPopupFace: tfacecomp;
   MenuPopupFrame: tframecomp;
   MenuPopupItemFace: tfacecomp;
   MenuPopupItemFaceActive: tfacecomp;
   MenuPopupItemFrame: tframecomp;
   MenuPopupItemFrameActive: tframecomp;
   MenuPopupSeparatorFrame: tframecomp;
   MenuSeparatorFrame: tframecomp;
   StepButtonFace: tfacecomp;
   StepButtonFrame: tframecomp;
   FrameButton: tframecomp;
   FaceButton: tfacecomp;
   TabFace: tfacecomp;
   TabFrame: tframecomp;
   TabBarHorizFace: tfacecomp;
   TabBarHorizFrame: tframecomp;
   TabBarTabFace: tfacecomp;
   TabBarTabFaceActive: tfacecomp;
   TabBarTabFrame: tframecomp;
   procedure onactivate(const sender: TObject);
 end;
var
 darkmo: tdarkmo;
implementation
uses
 dark_mfm;
procedure tdarkmo.onactivate(const sender: TObject);
begin
  // empty method
  
end;

end.
