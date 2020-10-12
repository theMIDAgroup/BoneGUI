%% Enable_Roi()
%% mida group http://mida.dima.unige.it - 2010/2015
%%%% this function enables roi and the other checkboxes for output
%%%% selection

%%%% called by: PopUp_Districts()
%%%%            End_Roi()
%%%%            main_gui(action,varargin) - panel 'ROI 4'

function Enable_Roi()
global pet_gui;
global ROI;
val = pet_gui.PopupValue;
val_enable = get(pet_gui.PANELroi.PANEL4.CKBOX1,'value');
ROI{val}.Enable = val_enable;

if val_enable
    set(pet_gui.PANELroi.PANEL4.CKBOX2,'enable','on');
    set(pet_gui.PANELroi.PANEL4.CKBOX3,'enable','on');
else
    set(pet_gui.PANELroi.PANEL4.CKBOX2,'enable','off');
    set(pet_gui.PANELroi.PANEL4.CKBOX3,'enable','off');
end
end