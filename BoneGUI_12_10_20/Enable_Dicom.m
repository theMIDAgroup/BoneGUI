%% Enable_Dicom()
%% mida group http://mida.dima.unige.it - 2010/2015
%%%% this function enables the saving of the results in Dicom format

%%%% called by main_gui(action,varargin) - panel 'ROI 4'


function Enable_Dicom()
global pet_gui;
global ROI;
val = pet_gui.PopupValue;
val_enable = get(pet_gui.PANELroi.PANEL4.CKBOX3,'value');
ROI{val}.OutputDicom = val_enable;
end

