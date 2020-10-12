%% Enable_Txt()
%% mida group http://mida.dima.unige.it - 2010/2015
%%%% this function enables the saving of the results in text format

%%%% called by: End_Roi()
%%%%            main_gui(action,varargin) - panel 'ROI 4'


function Enable_Txt()
global pet_gui;
global ROI;
val = pet_gui.PopupValue;
val_enable = get(pet_gui.PANELroi.PANEL4.CKBOX2,'value');
ROI{val}.OutputTxt = val_enable;
end
