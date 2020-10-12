%% Save_All()
%% mida group http://mida.dima.unige.it - 2010/2015
%%%% this function saves the existing ROI

%%%% called by: Load_Data()
%%%%            main_gui(action,varargin) - panel 'Roi Save'
%%%% call: Roi_PixelIdxList()

function Save_All()
global ROI;
global Info;
global pet_gui;

h_msg = msgbox('Saving ROI...');

Roi_PixelIdxList;

save([Info.InputPathMAT pet_gui.slash_pc_mac 'ROI' num2str(Info.SeriesNumberCT(pet_gui.SelectedCT)) '.mat'],'ROI','-mat');
close(h_msg);
end

