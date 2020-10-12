%% Roi_End()
%% mida group http://mida.dima.unige.it - 2010/2015
%%%% this function ends the current roi

%%%% called by: main_gui(action,varargin) - panel 'ROI 3'
%%%% call: Enable_Roi() 
%%%%       Enable_Txt()


function Roi_End()
global Info;
global pet_gui;
global ROI;


val = pet_gui.PopupValue;

if pet_gui.SliceNumber<ROI{val}.StartCt
    errordlg('ROI ends before its beginning!','!! Warning !!')
else
    ROI{val}.RoiEnd = true;
    
    ROI{val}.EndCt = pet_gui.SliceNumber;
    
    set(pet_gui.PANELroi.PANEL3.PB2,'enable','off');
    set(pet_gui.PANELroi.PANEL3.TXT2b,'string',num2str(ROI{val}.EndCt));
    
    [~,aux_position] = ismember(pet_gui.SliceNumber,ROI{val}.RoiSlice);
    max_position = length(ROI{val}.RoiSlice);
    ROI{val}.RoiSlice(aux_position+1 : max_position) = [];
    ROI{val}.RoiKind(aux_position+1 : max_position) = [];
    ROI{val}.RoiPosition(aux_position+1 : max_position) = [];
    if ismember(ROI{val}.Id,[2,3,4,5])
        ROI{val}.RoiRemoveKind(aux_position+1 : max_position) = [];
        ROI{val}.RoiRemovePosition(aux_position+1 : max_position) = [];
    end
    
    if ~isempty(pet_gui.SelectedPT)
        AuxPTStart = round((Info.LocationCT{pet_gui.SelectedCT}(ROI{val}.StartCt) ...
            - Info.InterceptPT(pet_gui.SelectedPT))./Info.SlopePT(pet_gui.SelectedPT));
        AuxPTEnd = round((Info.LocationCT{pet_gui.SelectedCT}(ROI{val}.EndCt) - Info.InterceptPT(pet_gui.SelectedPT))...
            ./Info.SlopePT(pet_gui.SelectedPT));
        if AuxPTEnd<1, AuxPTEnd = 1; warndlg('The selected ROI has not PT correspondance', '!!warining!!', 'modal'); end
        
        ROI{val}.RoiSlicePT = (AuxPTStart:1:AuxPTEnd);
        ROI{val}.RoiSlicePTvsCT = ...
            round((Info.LocationPT{pet_gui.SelectedPT}(ROI{val}.RoiSlicePT) ...
            - Info.InterceptCT(pet_gui.SelectedCT))./Info.SlopeCT(pet_gui.SelectedCT));
        
        [~,ROI{val}.RoiSlicePTvsCTindex] = ismember(ROI{val}.RoiSlicePTvsCT,ROI{val}.RoiSlice);
    end
    
    if ~isempty(pet_gui.SelectedNM)
        AuxNMStart = round((Info.LocationCT{pet_gui.SelectedCT}(ROI{val}.StartCt) ...
            - Info.InterceptNM(pet_gui.SelectedNM))./Info.SlopeNM(pet_gui.SelectedNM));
        AuxNMEnd = round((Info.LocationCT{pet_gui.SelectedCT}(ROI{val}.EndCt) - Info.InterceptNM(pet_gui.SelectedNM))...
            ./Info.SlopeNM(pet_gui.SelectedNM));
        if AuxNMStart<1, AuxNMStart = 1; end
        if AuxNMEnd<1, AuxNMEnd = 1; warndlg('The selected ROI has not NM correspondance', '!!warining!!', 'modal'); end
        
        ROI{val}.RoiSliceNM = (AuxNMStart:1:AuxNMEnd);
        ROI{val}.RoiSliceNMvsCT = round((Info.LocationNM{pet_gui.SelectedNM}(ROI{val}.RoiSliceNM) - Info.InterceptCT(pet_gui.SelectedCT))./Info.SlopeCT(pet_gui.SelectedCT));
        
        [~,ROI{val}.RoiSliceNMvsCTindex] = ismember(ROI{val}.RoiSliceNMvsCT,ROI{val}.RoiSlice);
    end
    set(pet_gui.PANELroi.PANEL4.CKBOX1,'value',1); Enable_Roi();
    set(pet_gui.PANELroi.PANEL4.CKBOX2,'value',1); Enable_Txt();
    
end
end
