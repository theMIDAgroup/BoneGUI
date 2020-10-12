%% Write_Txt()
%% mida group http://mida.dima.unige.it - 2010/2015
%%%% this function writes the results in text file

%%%% called by: Start_Analysis()

function Write_Txt()

global ROI;
global Info;
global pet_gui;

if ~exist(Info.OutputPathTXT,'dir'), mkdir(Info.OutputPathTXT); end

str{1} = 'total'; str{2} = 'upper'; str{3} = 'lower';

VoxelVolume = Info.PixelSpacingCT{pet_gui.SelectedCT}(1)...
    *Info.PixelSpacingCT{pet_gui.SelectedCT}(2)*Info.SliceThicknessCT(pet_gui.SelectedCT);


%%%% write Hounsfields
fo_h = fopen([Info.OutputPathTXT pet_gui.slash_pc_mac 'Hounsfield.txt'],'w');

axial.AuxMin = []; axial.AuxMax = [];
axial.AuxMean = [];  axial.AuxVoxelNumber = [];
axial.AuxMin_CB = []; axial.AuxMax_CB = []; axial.AuxMean_CB = [];  axial.AuxVoxelNumber_CB = [];


app.AuxMin = []; app.AuxMax = []; app.AuxMean = []; app.AuxVoxelNumber = [];
app.AuxMin_CB = []; app.AuxMax_CB = []; app.AuxMean_CB = []; app.AuxVoxelNumber_CB = [];

fprintf(fo_h,'%-25s \t %-25s \t %-25s \t %-3s \t %-3s \t %-6s \t %-10s \t %-20s \t %-10s \t %-10s \t %-10s \t %-10s \t %-15s \t %-10s \t %-10s \t %-10s \t %-10s \t %-15s \t %-10s \t %-10s \t %-10s \t %-10s \t %-15s \t %-10s \t %-10s \t %-10s \t %-10s \t %-15s \n',...
    'Patient ID','Family_Name','Given_Name','Sex','Age','Weight','ACQ. DATE','REGION',...
    'HSF min','HSF max','HSF mean','HSF std','volume (cm3)',...
    'HSF CB min','HSF CB max','HSF CB mean','HSF CB std','volume CB (cm3)');
fprintf(fo_h,'\n')
Nval = length(ROI);
for val = 1 : Nval
    if ROI{val}.Enable
        [axial,app,fo_h] = write_aux(val, VoxelVolume, axial, app, 'HSF', fo_h,1,str);
    end
    
end

if isempty(axial.AuxMin) == 0
    [axial, fo_h] = compute(axial,VoxelVolume, fo_h,'axial');
end
if isempty(app.AuxMin) == 0
    [app, fo_h] = compute(app,VoxelVolume, fo_h,'appendicular');
end

fclose(fo_h);

%%%% write PET
if isempty(pet_gui.SelectedPT) == 0
    VoxelVolumePT = Info.PixelSpacingPT{pet_gui.SelectedPT}(1)...
    *Info.PixelSpacingPT{pet_gui.SelectedPT}(2)*Info.SliceThicknessPT(pet_gui.SelectedPT);

    fo(1) = fopen([Info.OutputPathTXT pet_gui.slash_pc_mac 'SUVtotal.txt'],'w');
    fo(2) = fopen([Info.OutputPathTXT pet_gui.slash_pc_mac 'SUVupper.txt'],'w');
    fo(3) = fopen([Info.OutputPathTXT pet_gui.slash_pc_mac 'SUVlower.txt'],'w');
    str{1} = 'total'; str{2} = 'upper'; str{3} = 'lower';
    
    for count = 1 : 3
        axial.AuxMin = []; axial.AuxMax = [];
        axial.AuxMean = [];  axial.AuxVoxelNumber = [];
        axial.AuxMin_CB = []; axial.AuxMax_CB = []; axial.AuxMean_CB = []; axial.AuxVoxelNumber_CB = [];
        
        app.AuxMin = []; app.AuxMax = []; app.AuxMean = []; app.AuxVoxelNumber = [];
        app.AuxMin_CB = []; app.AuxMax_CB = []; app.AuxMean_CB = []; app.AuxVoxelNumber_CB = [];
        
        fprintf(fo(count),'%-25s \t %-25s \t %-25s \t %-3s \t %-3s \t %-6s \t %-10s \t %-20s \t %-10s \t %-10s \t %-10s \t %-10s \t %-15s \t %-10s \t %-10s \t %-10s \t %-10s \t %-15s \t %-10s \t %-10s \t %-10s \t %-10s \t %-15s \t %-10s \t %-10s \t %-10s \t %-10s \t %-15s \n',...
            'Patient ID','Family_Name','Given_Name','Sex','Age','Weight','ACQ. DATE','REGION',...
            'SUV min','SUV max','SUV mean','SUV std','volume  (cm3)',...
            'SUV CB  min','SUV CB max','SUV CB mean','SUV CB std','volume CB (cm3)');
        fprintf(fo(count),'\n')
        Nval = length(ROI);
        for val = 1 : Nval
            if ROI{val}.Enable
                %voxelvolumept
                [axial,app,fo(count)] = write_aux(val, VoxelVolumePT, axial, app, 'PT', fo(count), count,str, VoxelVolumePT, count);
                
            end
        end
        if isempty(axial.AuxMin) == 0
            [axial, fo(count)] = compute(axial,VoxelVolumePT, fo(count),'axial');
        end
        if isempty(app.AuxMin) == 0
            [app, fo(count)] = compute(app,VoxelVolumePT, fo(count),'appendicular');
        end
        fclose(fo(count));
    end
    
end
%%%% write NM
if isempty(pet_gui.SelectedNM) == 0
    fo_h = fopen([Info.OutputPathTXT pet_gui.slash_pc_mac 'NM_Counts.txt'],'w');
    
    axial.AuxMin = []; axial.AuxMax = [];
    axial.AuxMean = [];  axial.AuxVoxelNumber = [];
    axial.AuxMin_CB = []; axial.AuxMax_CB = []; axial.AuxMean_CB = [];  axial.AuxVoxelNumber_CB = [];
    
    app.AuxMin = []; app.AuxMax = []; app.AuxMean = []; app.AuxVoxelNumber = [];
    app.AuxMin_CB = []; app.AuxMax_CB = []; app.AuxMean_CB = []; app.AuxVoxelNumber_CB = [];
    fprintf(fo_h,'%-25s \t %-25s \t %-25s \t %-3s \t %-3s \t %-6s \t %-10s \t %-20s \t %-10s \t %-10s \t %-10s \t %-10s \t %-15s \t %-10s \t %-10s \t %-10s \t %-10s \t %-15s \t %-10s \t %-10s \t %-10s \t %-10s \t %-15s \t %-10s \t %-10s \t %-10s \t %-10s \t %-15s \n',...
        'Patient ID','Family_Name','Given_Name','Sex','Age','Weight','ACQ. DATE','REGION',...
        'NM min','NM max','NM mean','NM std','volume (cm3)',...
        'NM CB min','NM CB max','NM CB mean','NM CB std','volume CB (cm3)');
    fprintf(fo_h,'\n')
    for val = 1 : Nval
        if ROI{val}.Enable
            [axial,app,fo_h] = write_aux(val, VoxelVolume, axial, app, 'NM', fo_h,1,str);
        end
    end
    
    if isempty(axial.AuxMin) == 0
        [axial, fo_h] = compute(axial,VoxelVolume, fo_h,'axial');
    end
    if isempty(app.AuxMin) == 0
        [app, fo_h] = compute(app,VoxelVolume, fo_h,'appendicular');
    end
    
    fclose(fo_h);
    
end

end




function[str_x] = Convert_Num2Str(x)
%%convert a number in a string, and it uses comma (,) as decimal separator
%%instead of the traditional dot (.)
minus = [];
if x<0, minus = '-'; end
x = abs(x);
str_x = [minus num2str(floor(x))];

temp = x-floor(x);
temp_str = num2str(temp);
if temp~=  0
    str_x = [str_x ',' temp_str(3:end)];
end
end

function [axial,app,fo] = write_aux(val, VoxelVolume, axial, app, case_, fo, count,str,varargin)

global ROI;
global Info;

if strcmp(case_,'HSF')
    AuxMin = eval(['ROI{val}.Hounsfield3D.Min']);
    AuxMax = eval(['ROI{val}.Hounsfield3D.Max']);
    AuxMean = eval(['ROI{val}.Hounsfield3D.Mean']);
    AuxStd = eval(['ROI{val}.Hounsfield3D.Std']);
    AuxVoxelNumber = eval(['ROI{val}.Hounsfield3D.VoxelNumber']);
    AuxVolume = AuxVoxelNumber.*VoxelVolume;
    
    AuxMin_CB = eval(['ROI{val}.Hounsfield3D_CB.Min']);
    AuxMax_CB = eval(['ROI{val}.Hounsfield3D_CB.Max']);
    AuxMean_CB = eval(['ROI{val}.Hounsfield3D_CB.Mean']);
    AuxStd_CB = eval(['ROI{val}.Hounsfield3D_CB.Std']);
    AuxVoxelNumber_CB = eval(['ROI{val}.Hounsfield3D_CB.VoxelNumber']);
    AuxVolume_CB = AuxVoxelNumber_CB.*VoxelVolume;

    
elseif strcmp(case_,'NM')
    AuxMin = eval(['ROI{val}.NM3D.Min']);
    AuxMax = eval(['ROI{val}.NM3D.Max']);
    AuxMean = eval(['ROI{val}.NM3D.Mean']);
    AuxStd = eval(['ROI{val}.NM3D.Std']);
    AuxVoxelNumber = eval(['ROI{val}.Hounsfield3D.VoxelNumber']);
    AuxVolume = AuxVoxelNumber.*VoxelVolume;
    
    AuxMin_CB = eval(['ROI{val}.NM3D_CB.Min']);
    AuxMax_CB = eval(['ROI{val}.NM3D_CB.Max']);
    AuxMean_CB = eval(['ROI{val}.NM3D_CB.Mean']);
    AuxStd_CB = eval(['ROI{val}.NM3D_CB.Std']);
    AuxVoxelNumber_CB = eval(['ROI{val}.Hounsfield3D_CB.VoxelNumber']);
    AuxVolume_CB = AuxVoxelNumber_CB.*VoxelVolume;
    

    
elseif strcmp(case_,'PT')
    VoxelVolumePT = varargin{1}; 
    
    AuxMin = eval(['ROI{val}.SUV3D.' str{count} '.Min']);
    AuxMax = eval(['ROI{val}.SUV3D.' str{count} '.Max']);
    AuxMean = eval(['ROI{val}.SUV3D.' str{count} '.Mean']);
    AuxStd = eval(['ROI{val}.SUV3D.' str{count} '.Std']);
    % AuxVoxelNumber = eval(['ROI{val}.Hounsfield3D.VoxelNumber']);
    AuxVoxelNumber = eval(['ROI{val}.SUV3D.' str{count} '.VoxelNumber']); 
    AuxVolume = AuxVoxelNumber.*VoxelVolumePT;
    
%     switch count 
%         case 1 % total: volume is taken from CT
%             AuxVoxelNumber = eval(['ROI{val}.SUV3D.' str{count} '.VoxelNumber']);
%             AuxVolume = AuxVoxelNumber.*VoxelVolumePT;
%         case 2 % upper 
%             AuxVoxelNumber = eval(['ROI{val}.SUV3D.' str{count} '.VoxelNumber']);
%             AuxVolume = AuxVoxelNumber.*VoxelVolumePT;
%         case 3 % lower
%              AuxVoxelNumber = eval(['ROI{val}.SUV3D.' str{count} '.VoxelNumber']);
%             AuxVolume = AuxVoxelNumber.*VoxelVolumePT;
%     end
%     
    AuxMin_CB  = eval(['ROI{val}.SUV3D_CB.' str{count} '.Min']);
    AuxMax_CB  = eval(['ROI{val}.SUV3D_CB.' str{count} '.Max']);
    AuxMean_CB  = eval(['ROI{val}.SUV3D_CB.' str{count} '.Mean']);
    AuxStd_CB  = eval(['ROI{val}.SUV3D_CB.' str{count} '.Std']);
    % AuxVoxelNumber_CB = eval(['ROI{val}.Hounsfield3D_CB.VoxelNumber']);
    AuxVoxelNumber_CB = eval(['ROI{val}.SUV3D_CB.' str{count} '.VoxelNumber']);
    AuxVolume_CB = AuxVoxelNumber_CB.*VoxelVolumePT;
%     switch count 
%         case 1 % total: volume is taken from CT
%             AuxVoxelNumber = eval(['ROI{val}.SUV3D_CB.' str{count} '.VoxelNumber']);
%             AuxVolume_CB = AuxVoxelNumber_CB.*VoxelVolumePT;
%         case 2 % upper 
%             AuxVoxelNumber_CB = eval(['ROI{val}.SUV3D_CB.' str{count} '.VoxelNumber']);
%             AuxVolume_CB = AuxVoxelNumber_CB.*VoxelVolumePT;
%         case 3 % lower
%              AuxVoxelNumber_CB = eval(['ROI{val}.SUV3D_CB.' str{count} '.VoxelNumber']);
%             AuxVolume_CB = AuxVoxelNumber_CB.*VoxelVolumePT;
%     end
end


AuxMin_str = Convert_Num2Str(AuxMin);
AuxMax_str = Convert_Num2Str(AuxMax);
AuxMean_str = Convert_Num2Str(AuxMean);
AuxStd_str = Convert_Num2Str(AuxStd);
AuxVolume_str = Convert_Num2Str(AuxVolume);

AuxMin_CB_str = Convert_Num2Str(AuxMin_CB);
AuxMax_CB_str = Convert_Num2Str(AuxMax_CB);
AuxMean_CB_str = Convert_Num2Str(AuxMean_CB);
AuxStd_CB_str = Convert_Num2Str(AuxStd_CB);
AuxVolume_CB_str = Convert_Num2Str(AuxVolume_CB);





fprintf(fo,'%-25s \t %-25s \t %-25s \t %-3s \t %-3s \t %-6s \t %-10s \t %-20s \t %-10s \t %-10s \t %-10s \t %-10s \t %-15s  \t %-10s \t %-10s \t %-10s \t %-10s \t %-15s \n',...
    Info.PatientID,... 
    Info.PatientName.FamilyName,...
    Info.PatientName.GivenName,...
    Info.PatientSex,...
    Info.PatientAge,...
    Info.PatientWeight,...
    Info.AcquisitionDate,...
    ROI{val}.Name,...
    AuxMin_str,...
    AuxMax_str,...
    AuxMean_str,...
    AuxStd_str,...
    AuxVolume_str,...
    AuxMin_CB_str,...
    AuxMax_CB_str,...
    AuxMean_CB_str,...
    AuxStd_CB_str,...
    AuxVolume_CB_str);

if val>= 2 && val<= 6
    axial.AuxMin = [axial.AuxMin, AuxMin];
    axial.AuxMax = [axial.AuxMax,  AuxMax];
    axial.AuxMean = [axial.AuxMean,AuxMean];
    axial.AuxVoxelNumber = [axial.AuxVoxelNumber,AuxVoxelNumber];
    
    axial.AuxMin_CB = [axial.AuxMin_CB, AuxMin_CB];
    axial.AuxMax_CB = [axial.AuxMax_CB,  AuxMax_CB];
    axial.AuxMean_CB = [axial.AuxMean_CB,AuxMean_CB];
    axial.AuxVoxelNumber_CB = [axial.AuxVoxelNumber_CB,AuxVoxelNumber_CB];
    
elseif (val>= 9 && val <=  10) || (val>= 15 && val<= 18)
    
    app.AuxMin = [app.AuxMin, AuxMin];
    app.AuxMax = [app.AuxMax,  AuxMax];
    app.AuxMean = [app.AuxMean, AuxMean];
    app.AuxVoxelNumber = [app.AuxVoxelNumber, AuxVoxelNumber];
    
    app.AuxMin_CB = [app.AuxMin_CB, AuxMin_CB];
    app.AuxMax_CB = [app.AuxMax_CB,  AuxMax_CB];
    app.AuxMean_CB = [app.AuxMean_CB,AuxMean_CB];
    app.AuxVoxelNumber_CB = [app.AuxVoxelNumber_CB,AuxVoxelNumber_CB];
   
end

end

function [aaa, fo] = compute(aaa, VoxelVolume, fo, case_)

global Info;

aaa.aux_AMin = aaa.AuxMin(aaa.AuxMin~=  0);
aaa.AuxMin = min(aaa.aux_AMin);
aaa.aux_AMax = aaa.AuxMax(aaa.AuxMax~=  0);
aaa.AuxMax = max(aaa.aux_AMax);
aaa.aux_AMean = aaa.AuxMean(aaa.AuxMean~=  0);
aaa.AuxMean = mean(aaa.aux_AMean);
aaa.AuxStd = std(aaa.aux_AMean);
aaa.AuxVolume = sum(aaa.AuxVoxelNumber).*VoxelVolume;

aaa.aux_AMin_CB = aaa.AuxMin_CB(aaa.AuxMin_CB~=  0);
aaa.AuxMin_CB = min(aaa.aux_AMin_CB);
aaa.aux_AMax_CB = aaa.AuxMax_CB(aaa.AuxMax_CB~=  0);
aaa.AuxMax_CB = max(aaa.aux_AMax_CB);
aaa.aux_AMean_CB = aaa.AuxMean_CB(aaa.AuxMean_CB~=  0);
aaa.AuxMean_CB = mean(aaa.aux_AMean_CB);
aaa.AuxStd_CB = std(aaa.aux_AMean_CB);
aaa.AuxVolume_CB = sum(aaa.AuxVoxelNumber_CB).*VoxelVolume;

AuxMin_str = Convert_Num2Str(aaa.AuxMin);
AuxMax_str = Convert_Num2Str(aaa.AuxMax);
AuxMean_str = Convert_Num2Str(aaa.AuxMean);
AuxStd_str = Convert_Num2Str(aaa.AuxStd);
AuxVolume_str = Convert_Num2Str(aaa.AuxVolume);

AuxMin_CB_str = Convert_Num2Str(aaa.AuxMin_CB);
AuxMax_CB_str = Convert_Num2Str(aaa.AuxMax_CB);
AuxMean_CB_str = Convert_Num2Str(aaa.AuxMean_CB);
AuxStd_CB_str = Convert_Num2Str(aaa.AuxStd_CB);
AuxVolume_CB_str = Convert_Num2Str(aaa.AuxVolume_CB);

fprintf(fo,'%-25s \t %-25s \t %-25s \t %-3s \t %-3s \t %-6s \t %-10s \t %-20s \t %-10s \t %-10s \t %-10s \t %-10s \t %-15s \t %-10s \t %-10s \t %-10s \t %-10s \t %-15s  \n',...
    Info.PatientID,...
    Info.PatientName.FamilyName,...
    Info.PatientName.GivenName,...
    Info.PatientSex,...
    Info.PatientAge,...
    Info.PatientWeight,...
    Info.AcquisitionDate,...
    case_,...
    AuxMin_str,...
    AuxMax_str,...
    AuxMean_str,...
    AuxStd_str,...
    AuxVolume_str,...
    AuxMin_CB_str,...
    AuxMax_CB_str,...
    AuxMean_CB_str,...
    AuxStd_CB_str,...
    AuxVolume_CB_str);
end