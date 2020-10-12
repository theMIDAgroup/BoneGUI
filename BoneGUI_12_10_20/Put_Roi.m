%% Put_Roi(RoiKind,RoiPosition)
%% mida group http://mida.dima.unige.it - 2010/2015
%%%% this function plots a roi 
%%%% and removes existing roi using ResetRoi()

%%%% called by: Callback_RoiRectangle()  
%%%%            Callback_RoiEllipse()
%%%% call: Show_Image()
%%%%       Draw_Roi(RoiKind,RoiPosition,aux_position)
%%%%       Reset_Roi()


function Put_Roi(RoiKind,RoiPosition)
global pet_gui;
global ROI;



val = pet_gui.PopupValue;
RoiRemoveKind = 'imellipse';
RoiRemovePosition = [246,246,20,20];

if ROI{val}.RoiEmpty
    aux_position = 1;
    set(pet_gui.PANELroi.PANEL3.PB2,'enable','on');
    ROI{val}.RoiEmpty = false;
    ROI{val}.StartCt = pet_gui.SliceNumber;
    ROI{val}.CenterCt = [];
    ROI{val}.RoiKind{1} = RoiKind;
    ROI{val}.RoiPosition{1} = RoiPosition;
    ROI{val}.RoiSlice(1) = pet_gui.SliceNumber;
    
    set(pet_gui.PANELroi.PANEL3.TXT1b,'string',num2str(ROI{val}.StartCt));
%    set(pet_gui.PANELroi.PANEL3.TXT3b,'string','');
    
    if ~ismember(ROI{val}.Id,[2,3,4,5])
        Draw_Roi(RoiKind,RoiPosition,aux_position);
    else
        Draw_Roi(RoiKind,RoiPosition,aux_position,'green',RoiRemoveKind,RoiRemovePosition,'red');
    end
    
else
    if ~ROI{val}.RoiEnd
        Show_Image;
        [~,aux_position] = ismember(pet_gui.SliceNumber,ROI{val}.RoiSlice);
        if ~ismember(ROI{val}.Id,[2,3,4,5])
            Draw_Roi(RoiKind,RoiPosition,aux_position);
        else
            Draw_Roi(RoiKind,RoiPosition,aux_position,'green',RoiRemoveKind,RoiRemovePosition,'red');
        end
    else
        choice = questdlg('A ROI already exists. Do you want to clear the existing ROI?', ...
            '!!Warning!!', 'Yes','No','No');
        switch choice
            case 'Yes'
                Reset_Roi;
                aux_position = 1;
                set(pet_gui.PANELroi.PANEL3.PB2,'enable','on');
                ROI{val}.RoiEmpty = false;
                ROI{val}.StartCt = pet_gui.SliceNumber;
                ROI{val}.CenterCt = [];
                ROI{val}.RoiKind{1} = RoiKind;
                ROI{val}.RoiPosition{1} = RoiPosition;
                ROI{val}.RoiSlice(1) = pet_gui.SliceNumber;
                
                set(pet_gui.PANELroi.PANEL3.TXT1b,'string',num2str(ROI{val}.StartCt));
%                set(pet_gui.PANELroi.PANEL3.TXT3b,'string','');
                
                if ~ismember(ROI{val}.Id,[2,3,4,5])
                    Draw_Roi(RoiKind,RoiPosition,aux_position);
                else
                    Draw_Roi(RoiKind,RoiPosition,aux_position,'green',RoiRemoveKind,RoiRemovePosition,'red');
                end
            case 'No'
                return;
        end
    end
    
end
end
