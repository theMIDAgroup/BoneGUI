%% Start_Analysis
%% mida group http://mida.dima.unige.it - 2010/2015
%%%% functions for the segmentation and outputs production

%%%% called by: main_gui(action,varargin) - panel 'Start Analysis'
%%%% call: Save_All()
%%%%       Segmentation_Analysis()
%%%%       SUV_Analysis
%%%%       Hounsfield_Analysis
%%%%       Write_Txt
%%%%       Write_Dicom


global pet_gui;

Save_All;
%%
%pet_gui.PANELwaitbar.waitbar=waitbar2a(0,pet_gui.PANELwaitbar.panel);
%%
Segmentation_Analysis;
%%
if isempty(pet_gui.SelectedPT)==0
    SUV_Analysis;
end
%%
if isempty(pet_gui.SelectedNM)==0
    NM_Analysis;
end
%%
Hounsfield_Analysis;
%%
Write_Txt; 

%%
%if get(pet_gui.PANELroi.PANEL4.CKBOX3,'Value') == get(pet_gui.PANELroi.PANEL4.CKBOX3,'Max')
Write_Dicom;
%end
%%
msgbox('Analysis Completed!');
