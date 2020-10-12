%% Reset_Roi()
%% mida group http://mida.dima.unige.it - 2010/2015
%%%% this function removes an existing roi using Initialize_ROI(pet_gui.PopupValue)
%%%% and goes back to roi menu calling Popup_Districts

%%%% called by: Put_Roi()
%%%%            main_gui(action,varargin) - panel 'Roi Save'
%%%% call: Initialize_ROI(it)
%%%%       PopUp_Districts()


function Reset_Roi()
global pet_gui;

Initialize_ROI(pet_gui.PopupValue);
PopUp_Districts;

end

