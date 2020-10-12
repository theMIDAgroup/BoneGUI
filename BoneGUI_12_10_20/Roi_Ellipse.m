%% Roi_Ellipse()
%% mida group http://mida.dima.unige.it - 2010/2015
%%%% this function plots an elliptic roi using Put_Roi(RoiKind,RoiPosition)
%%%% and sets command in the ROI panel

%%%% called by: main_gui(action,varargin) - panel 'ROI 2'
%%%% call: Put_Roi(RoiKind,RoiPosition)

function Roi_Ellipse()
global pet_gui;
RoiKind = 'imellipse';
RoiPosition = [236,236,40,40];
Put_Roi(RoiKind,RoiPosition);
set(pet_gui.PANELroi.PANEL3.PB2,'enable','on');
end
