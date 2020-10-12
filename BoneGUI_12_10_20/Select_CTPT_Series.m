%% Select_CTPT_Series()
%% mida group http://mida.dima.unige.it - 2010/2015
%%%% this function manages the data series loaded with
%%%% Table_CTPT_Series():
%%%% first, it deals with CT images, enabling some commands in the gui and
%%%% showing the first dicom in the ct series with the function Show_Image(). 
%%%% This function show also existing roi, if any.
%%%% Then, if PT series are selected, information about correspondance 
%%%% between PT and CT series are stored in the global variable ROI

%%%% called by: Table_CTPT_Series()
%%%% call: Show_Image()


function Select_CTPT_Series()

global f;
global pet_gui;
global Info;
global ROI;

pet_gui.SelectedCT = [];
if isfield(f,'tCT')
    DataCT = get(f.tCT,'Data');
    SelectionColumn = cell2mat(DataCT(:,5));
    pet_gui.SelectedCT = find(SelectionColumn); %%pu??? dare problemi con selezioni multiple .... mettere warning/error
end

pet_gui.SelectedPT = [];
if isfield(f,'tPT') && isvalid(f.tPT) %%% isvalid by Daniela
    DataPT = get(f.tPT,'Data');
    SelectionColumn = cell2mat(DataPT(:,5));
    pet_gui.SelectedPT = find(SelectionColumn); %%pu??? dare problemi con selezioni multiple .... mettere warning/error
end

pet_gui.SelectedNM = [];
if isfield(f,'tNM')
    DataNM = get(f.tNM,'Data');
    SelectionColumn = cell2mat(DataNM(:,5));
    pet_gui.SelectedNM = find(SelectionColumn); %%pu??? dare problemi con selezioni multiple .... mettere warning/error
end
%%------
close(f.fig);
%%------
if ~isempty(pet_gui.SelectedCT)
    %%%% enable some stuff in the gui
    set(pet_gui.PANELroi.popup,'enable','on');
    set(pet_gui.PANELroi.PANEL5.PB2,'enable','on');
    set(pet_gui.PANELroi.PANEL5.PB3,'enable','on');
    set(pet_gui.PBstart,'enable','on');
    set(pet_gui.PANELax.SLIDERimage,'SliderStep',[1/(Info.NumberFileCT(pet_gui.SelectedCT)-1) 10/(Info.NumberFileCT(pet_gui.SelectedCT)-1)]);
    set(pet_gui.PANELax.panel,'visible','on');
    
    
    %%%% load the existing roi
    ROI_mat_file = [Info.InputPath '_MAT' pet_gui.slash_pc_mac, 'ROI' num2str(Info.SeriesNumberCT(pet_gui.SelectedCT)) '.mat'];
    if exist(ROI_mat_file,'file')
        load(ROI_mat_file);
        
        pet_gui.PANELroi.ROIName = [];
        pet_gui.PANELroi.ROIId = [];
        NitROI = length(ROI);
        pet_gui.PANELroi.ROIName{1} = '-----------------';
        pet_gui.PANELroi.ROIId(1) = 0;
        for itROI = 1:NitROI
            pet_gui.PANELroi.ROIName{itROI+1} = ROI{itROI}.Name;
            pet_gui.PANELroi.ROIId(itROI+1) = ROI{itROI}.Id;
        end
        set(pet_gui.PANELroi.popup,'string',pet_gui.PANELroi.ROIName);
    end
        
    %%******************** callback script  *********************************%%
    Show_Image;
    %%********************    end script    *********************************%%
    
    
    if isempty(pet_gui.SelectedPT) && isempty(pet_gui.SelectedNM)
        warndlg('No functional series selected!', '!!Warning!!', 'modal');
    elseif isempty(pet_gui.SelectedPT)==0
        if exist('ROI','var')
            Nval = length(ROI);
            for val  =  1 : Nval
                if ~isempty(ROI{val}.StartCt) && ~isempty(ROI{val}.EndCt) && isempty(ROI{val}.RoiSlicePTvsCTindex) %% daniela: modificato prima era RoiSlicePT
                    AuxPTStart = round((Info.LocationCT{pet_gui.SelectedCT}(ROI{val}.StartCt) - Info.InterceptPT(pet_gui.SelectedPT))./Info.SlopePT(pet_gui.SelectedPT));
                    AuxPTEnd = round((Info.LocationCT{pet_gui.SelectedCT}(ROI{val}.EndCt) - Info.InterceptPT(pet_gui.SelectedPT))./Info.SlopePT(pet_gui.SelectedPT));
                    %daniela
                    if ~isempty(ROI{val}.RoiSlicePT) && ~isempty(Info.LocationPT{pet_gui.SelectedPT}) && AuxPTEnd > size(Info.LocationPT{pet_gui.SelectedPT},1)
                        AuxPTEnd = size(Info.LocationPT{pet_gui.SelectedPT},1);
                    end
                    if AuxPTStart<1, AuxPTStart=1; end % end daniela
                    if AuxPTStart<AuxPTEnd
                        ROI{val}.RoiSlicePT = (AuxPTStart:1:AuxPTEnd);
                    else
                        ROI{val}.RoiSlicePT = (AuxPTEnd:1:AuxPTStart);
                    end
                    
                    ROI{val}.RoiSlicePTvsCT = round((Info.LocationPT{pet_gui.SelectedPT}(ROI{val}.RoiSlicePT) - Info.InterceptCT(pet_gui.SelectedCT))./Info.SlopeCT(pet_gui.SelectedCT));
                    
                    [~,ROI{val}.RoiSlicePTvsCTindex] = ismember(ROI{val}.RoiSlicePTvsCT,ROI{val}.RoiSlice);
                end
            end           
        end
    elseif isempty(pet_gui.SelectedNM)==0
        if exist('ROI','var')
            Nval = length(ROI);
            for val  =  1 : Nval
                if ~isempty(ROI{val}.StartCt) && ~isempty(ROI{val}.EndCt) && isempty(ROI{val}.RoiSliceNM)
                    AuxNMStart = round((Info.LocationCT{pet_gui.SelectedCT}(ROI{val}.StartCt) - Info.InterceptNM(pet_gui.SelectedNM))./Info.SlopeNM(pet_gui.SelectedNM));
                    AuxNMEnd = round((Info.LocationCT{pet_gui.SelectedCT}(ROI{val}.EndCt) - Info.InterceptNM(pet_gui.SelectedNM))./Info.SlopeNM(pet_gui.SelectedNM));
                    ROI{val}.RoiSliceNM = (AuxNMStart:1:AuxNMEnd);
                    ROI{val}.RoiSliceNMvsCT = round((Info.LocationNM{pet_gui.SelectedNM}(ROI{val}.RoiSliceNM) - Info.InterceptCT(pet_gui.SelectedCT))./Info.SlopeCT(pet_gui.SelectedCT));
                    
                    [~,ROI{val}.RoiSliceNMvsCTindex] = ismember(ROI{val}.RoiSliceNMvsCT,ROI{val}.RoiSlice);
                end
            end           
        end    
    end
else
    errordlg('No CT series selected!','!!Error!!', 'modal');
end

end


