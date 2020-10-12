%% Reset_All()
%% mida group http://mida.dima.unige.it - 2010/2015
%%%% this function removes all the roi using Initialize_ROI(pet_gui.PopupValue)
%%%% and goes back to roi menu calling Popup_Districts

%%%% called by: main_gui(action,varargin) - panel 'Roi Save'
%%%% call: Initialize_ROI(it)
%%%%       Popup_Districts()


function Reset_All()

global pet_gui;

choice = questdlg('Do you want to clear ALL the existing ROI?', ...
    '!!Warning!!', 'Yes','No','No');
switch choice
    case 'Yes'
        for it = 1 : length(pet_gui.PANELroi.ROIName)-2;
            Initialize_ROI(it);
        end
        PopUp_Districts;
    case 'No'
        return;
end
end
%%
