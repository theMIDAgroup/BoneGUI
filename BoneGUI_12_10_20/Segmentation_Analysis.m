%% Segmentation_Analysis()
%% mida group http://mida.dima.unige.it - 2010/2015
%%%% this function computes the segmentation of the bone districts via Hough
%%%% Transform

%%%% called by: Start_Analysis()
%%%% call: Hough_Analysis(val)
%%%%       Projection_SUV(val,it_start)             (included in this file, row 60)
%%%%       [Isuv] = pt2suv(I,INFO)                    (included in this file, row 92)
%%%%       Projection_Hounsfield(val)               (included in this file, row 114)
%%%%       [IHounsfield]ct2Hounsfield(I,INFO_CT)    (included in this file, row 153)



function Segmentation_Analysis()

global ROI;
global Info;
global pet_gui;

str = [Info.InputPath, pet_gui.slash_pc_mac, Info.FileCT{pet_gui.SelectedCT}(1).name];

BedPixelIdxList = Find_BedPixelIdxList(str);
BedPixelIdxList = [];

Nval = length(ROI);
temp = false;
%% 30/08/2016 Get the voxel size
Info.PixelSizeCT = [];
Info.SizeCT = [];
Info.PixelSizePT = [];
Info.SizePT = [];
Info.PixelSizeNM = [];
Info.SizeNM = [];

INFO = dicominfo(str);
Info.PixelSizeCT = [INFO.PixelSpacing(1,1),INFO.PixelSpacing(2,1)];
Info.SizeCT = double([INFO.Rows, INFO.Columns]);
Info.ImagePositionCT = double(INFO.ImagePositionPatient);

if ~isempty(pet_gui.SelectedPT)
    str = [Info.InputPath, pet_gui.slash_pc_mac, Info.FilePT{pet_gui.SelectedPT}(1).name];
    INFO = dicominfo(str);
    Info.PixelSizePT = double([INFO.PixelSpacing(1,1),INFO.PixelSpacing(2,1)]);
    Info.SizePT = double([INFO.Rows, INFO.Columns]);
    
    resize_factor_rows = double(Info.SizeCT(1))/double(Info.SizePT(1));
    resize_factor_columns = double(Info.SizeCT(1,2))/double(Info.SizePT(1,2));
    if resize_factor_rows==resize_factor_columns % && resize_factor_rows == floor(resize_factor_rows) && resize_factor_columns == floor(resize_factor_columns)
        Info.resize_factor_CT2Funct = 1/double(resize_factor_rows);
    else
        error('the images are not squared')
    end
    
    resize_scale_rows = double(Info.PixelSizePT(1,1))/double(Info.PixelSizeCT(1,1));
    resize_scale_columns = Info.PixelSizePT(1,2)/Info.PixelSizeCT(1,2);
    if resize_scale_rows==resize_scale_columns
        if resize_scale_rows + 0.1>=resize_factor_rows && resize_factor_rows-0.1<=resize_factor_rows
            Info.resize_scale_CT2Funct = 1;
        else
            Info.resize_scale_CT2Funct = double(resize_factor_rows)/double(Info.PixelSizePT(1,1));
        end
    else
        error('the images is not scaled homogeneously')
    end
    
    Info.ImagePositionPT = INFO.ImagePositionPatient;
    if Info.ImagePositionPT(1) ~= Info.ImagePositionCT(1) || Info.ImagePositionPT(2) ~= Info.ImagePositionCT(2) 
       disp('the Image Position Patient is different in CT and PT series')
    end
    
end
if ~isempty(pet_gui.SelectedNM)
    str = [Info.InputPath, pet_gui.slash_pc_mac, Info.FileNM{1}(1).name];
    INFO = dicominfo(str);
    Info.PixelSizeNM = double([INFO.PixelSpacing(1,1),INFO.PixelSpacing(2,1)]);
    Info.SizeNM = double([INFO.Rows, INFO.Columns]);
    
    resize_factor_rows = Info.SizeCT(1)/Info.SizeNM(1);
    resize_factor_columns = Info.SizeCT(1,2)/Info.SizeNM(1,2);
    if resize_factor_rows==resize_factor_columns && resize_factor_rows == floor(resize_factor_rows) && resize_factor_columns == floor(resize_factor_columns)
        Info.resize_factor_CT2Funct = 1/double(resize_factor_rows);
    else
        error('the images are not squared')
    end
    
    resize_scale_rows = Info.PixelSizeNM(1,1)/Info.PixelSizeCT(1,1);
    resize_scale_columns = Info.PixelSizeNM(1,2)/Info.PixelSizeCT(1,2);
    if resize_scale_rows==resize_scale_columns
        if resize_scale_rows + 0.1>=resize_factor_rows && resize_factor_rows-0.1<=resize_factor_rows
            Info.resize_scale_CT2Funct = 1;
        else
            Info.resize_scale_CT2Funct = double(resize_factor_rows)/double(Info.PixelSizeNM(1,1));
        end
    else
        error('the images is not scaled homogeneously')
    end
    
    Info.ImagePositionNM = INFO.ImagePositionPatient;
    if Info.ImagePositionNM(1) ~= Info.ImagePositionCT(1) || Info.ImagePositionPT(2) ~= Info.ImagePositionCT(2) 
       error('the Image Position Patient is different in NM and CT series')
    end
    
end

for val = 2 : 18
    if ROI{val}.Enable
        
        SegmentationAuto_CT(val,BedPixelIdxList);
        
        ROI{val}.Segmented = true;
        temp = true;
    end
    
    VoxelNumber = 0;
    for it_vn = 1 : length(ROI{val}.RoiSegmentationPixelIdxList.Marrow)
        VoxelNumber = VoxelNumber+length(ROI{val}.RoiSegmentationPixelIdxList.Marrow{it_vn});
    end
    ROI{val}.VoxelNumberCT = VoxelNumber;
    
    
    if ROI{val}.Enable && ~isempty(pet_gui.SelectedPT)
        Projection_SUV(val);
        temp = true;
    end
    
    if ROI{val}.Enable && ~isempty(pet_gui.SelectedNM)
        Projection_NM(val);
        temp = true;
    end
    
end
%%% segmentazione del total body, solo dopo aver segmentato le vertebre!
val = 1;
if ROI{val}.Enable
    
    ROI{val}.Name
    it_start = 1;
    
    
    SegmentationAuto_CT(val,BedPixelIdxList,it_start);
    
    ROI{val}.Segmented = true;
    temp = true;
    
    VoxelNumber = 0;
    for it_vn = 1 : length(ROI{val}.RoiSegmentationPixelIdxList.Marrow)
        VoxelNumber = VoxelNumber+length(ROI{val}.RoiSegmentationPixelIdxList.Marrow{it_vn});
    end
    ROI{val}.VoxelNumberCT = VoxelNumber;
    
    
    if ROI{val}.Enable && ~isempty(pet_gui.SelectedPT)
        Projection_SUV(val,it_start);
        temp = true;
    end
    
    if ROI{val}.Enable && ~isempty(pet_gui.SelectedNM)
        Projection_NM(val,it_start);
        temp = true;
    end
end

if length(ROI) == 19
    val = 19;
    ROI{val}.Name
    if ROI{val}.Enable && ~ROI{val}.Segmented
        
        it_start = ROI{val}.RoiSlice(1);
        SegmentationAuto_CT(val,BedPixelIdxList,it_start);
        
        ROI{val}.Segmented = true;
        temp = true;
        
        VoxelNumber = 0;
        for it_vn = 1 : length(ROI{val}.RoiSegmentationPixelIdxList.Marrow)
            VoxelNumber = VoxelNumber+length(ROI{val}.RoiSegmentationPixelIdxList.Marrow{it_vn});
        end
        ROI{val}.VoxelNumberCT = VoxelNumber;
        
        if ROI{val}.Enable && ~isempty(pet_gui.SelectedPT)
            Projection_SUV(val,it_start);
            temp = true;
        end
        
        if ROI{val}.Enable && ~isempty(pet_gui.SelectedNM)
            Projection_NM(val,it_start);
            temp = true;
        end
    end
end

if temp
    save([Info.InputPathMAT pet_gui.slash_pc_mac 'ROI' num2str(Info.SeriesNumberCT(pet_gui.SelectedCT)) '.mat'],'ROI','-mat');
    
end
end
%%
%%- Find_BedPixelIdxList
%%-
function[BedPixelIdxList] = Find_BedPixelIdxList(str)
x1 = 191.57;
y1 = -38.65-3*1.3672;
x2 = 210.25;
y2 = -26.96-3*1.3672;

INFO_ct = dicominfo(str);

np = INFO_ct.Rows;
position = INFO_ct.ImagePositionPatient;
pixel_spacing = INFO_ct.PixelSpacing;
x = position(1)+(0:1:np-1)*pixel_spacing(1);
y = position(2)+(0:1:np-1)*pixel_spacing(2);

lettino = zeros(np);
for t = 1:np
    if abs(x(t))<= x1
        temp = (y1+3*1.3672)/x1^2*x(t)^2-3*1.3672;
        [~,ind] = min(abs(y-temp));
    elseif x(t)>x1
        temp = (y2-y1)/(x2-x1)*(x(t)-x1)+y1;
        [~,ind] = min(abs(y-temp));
    else
        temp = -(y2-y1)/(x2-x1)*(x(t)+x1)+y1;
        [~,ind] = min(abs(y-temp));
    end
    lettino(ind:end,t) = 1;
end

BedPixelIdxList = find(lettino);
end
%%
%%- SegmentationAuto_CT (vecchio processing_ct2)
%%-
function SegmentationAuto_CT(val,BedPixelIdxList,it_start)

global Info;
global pet_gui;
global ROI;

if nargin<3, it_start = 1; end

IT_MAX = 5000;%1000;
IT_MIN = 50;%150;
cutoff_pixel = 30;
resize_factor = 0.5;


soglia_lower_osso_HS = ROI{val}.HURange(1);
soglia_upper_osso_HS = ROI{val}.HURange(2);

Nit = length(ROI{val}.RoiSlice);
str_wbar = [Info.PatientName.FamilyName ' ' Info.PatientName.GivenName ' segmenting roi: ' ROI{val}.Name];
%waitbar2a(0, pet_gui.PANELwaitbar.waitbar,str_wbar);
for it = it_start:Nit
    str_aux = sprintf('CT %s: %d di %d \n',ROI{val}.Name, it, Nit);
    disp(str_aux);
    %waitbar2a(it/Nit, pet_gui.PANELwaitbar.waitbar,str_wbar);
    
    str = [Info.InputPath, pet_gui.slash_pc_mac, Info.FileCT{pet_gui.SelectedCT}(it+ ROI{val}.RoiSlice(1)-1).name];
    INFO = dicominfo(str);
    I0 = double(dicomread(str));
    I0(BedPixelIdxList) = 0;
    
    % daniela
    if ROI{val}.RoiRegion(it,1)<1; ROI{val}.RoiRegion(it,1)=1;end
    % daniela end
    
    I = I0(ROI{val}.RoiRegion(it,3):ROI{val}.RoiRegion(it,4),...
        ROI{val}.RoiRegion(it,1):ROI{val}.RoiRegion(it,2));
    
    soglia_upper_osso_CT = (soglia_upper_osso_HS-INFO.RescaleIntercept)./INFO.RescaleSlope;
    soglia_lower_osso_CT = (soglia_lower_osso_HS-INFO.RescaleIntercept)./INFO.RescaleSlope;
    mask_osso_upper = I>soglia_upper_osso_CT;
    mask_osso_lower = I<soglia_lower_osso_CT;
    I(mask_osso_upper) = soglia_upper_osso_CT; clear mask_osso_upper;
    I(mask_osso_lower) = soglia_lower_osso_CT; clear mask_osso_lower;
    I = floor(255/(soglia_upper_osso_CT-soglia_lower_osso_CT)*(I-soglia_lower_osso_CT));
    
    m = zeros(size(I0));
    m(ROI{val}.RoiPixelIdxList{it}) = 1;
    m = m(ROI{val}.RoiRegion(it,3):ROI{val}.RoiRegion(it,4),...
        ROI{val}.RoiRegion(it,1):ROI{val}.RoiRegion(it,2));
    
    I = I.*m; %%% annullo tutto quanto fuori dalla ROI!!!
    
    if val  ==  1
        I = imresize(I,resize_factor);
        m = imresize(m,resize_factor);
    end
    
    [seg,iterazioni.level_set_vertebre{it}] = level_set_segmentation(I,m,IT_MAX,IT_MIN);
    %clear m;
    if val  ==  1
        seg = imresize(seg,1./resize_factor);
    end
    
    mask = zeros(size(I0));
    % daniela:
    sizemaskaux = size(mask(ROI{val}.RoiRegion(it,3):ROI{val}.RoiRegion(it,4),ROI{val}.RoiRegion(it,1):ROI{val}.RoiRegion(it,2)));
    seg = seg(1:sizemaskaux(1),1:sizemaskaux(2));
    % end daniela
    mask(ROI{val}.RoiRegion(it,3):ROI{val}.RoiRegion(it,4),ROI{val}.RoiRegion(it,1):ROI{val}.RoiRegion(it,2)) = seg;
    %clear seg;
    
    temp = zeros(size(I0));
    if ~isempty(ROI{val}.RoiVertebraPixelIdxList)
        temp(ROI{val}.RoiVertebraPixelIdxList{it}) = 1;
    else
        temp(ROI{val}.RoiPixelIdxList{it}) = 1;
    end
    mask = mask.*temp;
    
    CCMask = bwconncomp(mask);
    for it_CCMask = 1 : CCMask.NumObjects
        if (length(CCMask.PixelIdxList{it_CCMask}) < cutoff_pixel)
            mask(CCMask.PixelIdxList{it_CCMask}) = 0;
        end
    end
    
    
    ROI{val}.RoiSegmentationPixelIdxList.Bone{it} = find(mask);
    % daniela: fills HFValue_CB
    ROI{val}.HFValue_CB{it} = I0(ROI{val}.RoiSegmentationPixelIdxList.Bone{it});
    % end daniela
    
    %% devo rimpicciolire la mask
    if isfield(Info, 'resize_scale_CT2Funct') %% daniela
    mask_bone_scaled = imresize(mask,Info.resize_scale_CT2Funct);
    if mod(size(mask_bone_scaled,1),2) == 0
        pad_size = (Info.SizeCT(1,1)-size(mask_bone_scaled,1))/2;
        pad_size = double(pad_size);
        mask_bone_scaled = padarray(mask_bone_scaled,[pad_size,pad_size]);
    else
        pad_size = (Info.SizeCT(1,1)-size(mask_bone_scaled,1))/2;
        pad_size = double(pad_size);
        mask_bone_scaled = padarray(mask_bone_scaled,[pad_size,pad_size]);
        mask_bone_scaled = [mask_bone_scaled; zeros(1,Info.SizeCT(1,1)-1)];
        mask_bone_scaled = [mask_bone_scaled, zeros(Info.SizeCT(1,1),1)];
    end
    ROI{val}.RoiSegmentationPixelIdxList.Bone_scaled{it} = find(mask_bone_scaled);
    end
    
    if isfield(Info,'ImagePositionPT')
        ImagePositionMET = Info.ImagePositionPT;
        SizeMET = Info.SizePT;
        PixelSizeMET = Info.PixelSizePT;
    elseif isfield(Info,'ImagePositionNM')
        ImagePositionMET = Info.ImagePositionNM;
        SizeMET = Info.SizeNM;
        PixelSizeMET = Info.PixelSizeNM;
    else
        ImagePositionMET = [];
    end
    
    if isfield(Info, 'ImagePositionPT') %% daniela
    mask_bone128 = zeros(SizeMET);
    if isempty(ImagePositionMET) == 0
        linCTx = linspace(Info.ImagePositionCT(1),Info.ImagePositionCT(1)+ Info.PixelSizeCT(1)*(Info.SizeCT(1)-1),Info.SizeCT(1));
        linCTy = linspace(Info.ImagePositionCT(2),Info.ImagePositionCT(2)+ Info.PixelSizeCT(2)*(Info.SizeCT(2)-1),Info.SizeCT(2));
        linMETx = linspace(ImagePositionMET(1),ImagePositionMET(1)+ PixelSizeMET(1)*(SizeMET(1)-1),SizeMET(1));
        linMETy = linspace(ImagePositionMET(2),ImagePositionMET(2)+ PixelSizeMET(2)*(SizeMET(2)-1),SizeMET(2));
        
        %modo piu furbo di farlo ma non mi riesce al momento
        for itx = 1 : Info.SizeCT(1)
            [~, aux_x] = min(abs(linCTx(itx)-linMETx));
            ind_aux_x(itx) = aux_x + 1; %ho aggiunto il +1, daniela
        end
        for ity = 1 : Info.SizeCT(2)
            [~, aux_y] = min(abs(linCTy(ity)-linMETy));
            ind_aux_y(ity) = aux_y - 1; %ho aggiunto il -1, daniela
            if ind_aux_y(ity)==0; ind_aux_y(ity) = 1; end % daniela
        end
        % OLD
        for itx = 1 : Info.SizeCT(1)
            for ity = 1 : Info.SizeCT(2)
                if mask(itx,ity)> 0 
                   mask_bone128(ind_aux_x(itx),ind_aux_y(ity)) = 1;
                end
            end
        end
        % new
        %[itx,ity] = find(mask(1:Info.SizeCT(1),1:Info.SizeCT(2))>0);
        %mask_bone128(ind_aux_x(itx),ind_aux_y(ity)) = 1;
        
        %mask_bone128 = round(imresize(mask_bone_scaled,Info.resize_factor_CT2Funct));
        
    end
    ROI{val}.RoiSegmentationPixelIdxList.Bone128{it} = find(mask_bone128);
    end
    
    %%% marrow segmentation
    
    CCMask = bwconncomp(mask);
    mask_marrow = zeros(size(I0));
    for it_CCMask = 1 : CCMask.NumObjects
        aux = zeros(size(I0));
        aux(CCMask.PixelIdxList{it_CCMask}) = 1;
        aux_mask_boundary = double(bwperim(aux));
        aux_mask_boundary_large = (conv2(aux_mask_boundary,ones(9,9),'same')~= 0).*aux;
        soglia_midollo_CT = mean(nonzeros(I0.*aux_mask_boundary_large));
        clear aux_mask_boundary_allargato;
        temp = (I0<soglia_midollo_CT).*(aux-aux_mask_boundary);
        clear aux_mask_boundary;
        
        CC_temp = bwconncomp(temp);
        for it_CC_temp = 1 : CC_temp.NumObjects
            if (length(CC_temp.PixelIdxList{it_CC_temp}) < 6)
                temp(CC_temp.PixelIdxList{it_CC_temp}) = 0;
            end
        end
        
        mask_marrow = mask_marrow.*(~aux) + temp;
        clear aux soglia_midollo_CT;
        
        
    end
    
    
    
    %%%%%% per il total body sostituisco le regioni delle vertebre
    if val ==  1
        for it_val =  2:5
            
            [~,index_slice_aux] = ismember(it+ ROI{val}.RoiSlice(1)-1,ROI{it_val}.RoiSlice);
            if index_slice_aux
                mask_marrow(ROI{it_val}.RoiRegion(index_slice_aux,3):ROI{it_val}.RoiRegion(index_slice_aux,4),...
                    ROI{it_val}.RoiRegion(index_slice_aux,1):ROI{it_val}.RoiRegion(index_slice_aux,2)) = 0;
                mask_marrow(ROI{it_val}.RoiSegmentationPixelIdxList.Marrow{index_slice_aux}) = 1;
            end
        end
    end
    %%%%%%
    if isfield(Info, 'resize_scale_CT2Funct') %% daniela
    mask_marrow_scaled = imresize(mask_marrow,Info.resize_scale_CT2Funct);
    if mod(size(mask_marrow_scaled,1),2) == 0
        pad_size = (Info.SizeCT(1,1)-size(mask_marrow_scaled,1))/2;
        pad_size = double(pad_size);
        mask_marrow_scaled = padarray(mask_marrow_scaled,[pad_size,pad_size]);
    else
        pad_size = (Info.SizeCT(1,1)-size(mask_marrow_scaled,1))/2;
        pad_size = double(pad_size);
        mask_marrow_scaled = padarray(mask_marrow_scaled,[pad_size,pad_size]);
        mask_marrow_scaled = [mask_marrow_scaled; zeros(1,Info.SizeCT(1,1)-1)];
        mask_marrow_scaled = [mask_marrow_scaled, zeros(Info.SizeCT(1,1),1)];
    end
    end
    
    if isempty(ImagePositionMET) == 0
       mask_marrow128 =zeros(SizeMET);
       for itx = 1 : Info.SizeCT(1)
            for ity = 1 : Info.SizeCT(2)
                if mask_marrow(itx,ity)> 0 
                   mask_marrow128(ind_aux_x(itx),ind_aux_y(ity)) = 1;
                end
            end
        end
        %mask_marrow128 = round(imresize(mask_marrow_scaled,Info.resize_factor_CT2Funct));
        ROI{val}.RoiSegmentationPixelIdxList.Marrow128{it} = find(mask_marrow128);
    end
    ROI{val}.RoiSegmentationPixelIdxList.Marrow{it} = find(mask_marrow);
    % daniela: fills HFValue
    ROI{val}.HFValue{it} = I0(ROI{val}.RoiSegmentationPixelIdxList.Marrow{it});
    % end daniela
    if isfield(Info, 'resize_scale_CT2Funct') %% daniela
    ROI{val}.RoiSegmentationPixelIdxList.Marrow_scaled{it} = find(mask_marrow_scaled);
    end
    
   
end
%waitbar2a(0, pet_gui.PANELwaitbar.waitbar,'');
end

%%
%%- PROJECTION SUV (vecchio processing_pt)
%%-
function Projection_SUV(val,it_start)

global Info;
global pet_gui;
global ROI;

if nargin <2, it_start = 1; end

ROI{val}.SUVValue = [];
ROI{val}.SUVValue_CB = [];


Nit = length(ROI{val}.RoiSlicePT);
str_wbar = [Info.PatientName.FamilyName ' ' Info.PatientName.GivenName ' computing SUV 1/2 (roi: ' ROI{val}.Name ')'];
%waitbar2a(0, pet_gui.PANELwaitbar.waitbar,str_wbar);
for it = it_start:Nit
    
    if ~isempty(ROI{val}.RoiSlicePTvsCTindex) && ROI{val}.RoiSlicePTvsCTindex(it)>0
        sprintf('PET %s: %d di %d \n',ROI{val}.Name, it, Nit)
        %waitbar2a(it/Nit, pet_gui.PANELwaitbar.waitbar,str_wbar);
        str = [Info.InputPath, pet_gui.slash_pc_mac, Info.FilePT{pet_gui.SelectedPT}(it+ROI{val}.RoiSlicePT(1)-1).name];
        INFO = dicominfo(str);
        I = double(dicomread(str));
        
        %% ok per PET non per SPECT
        Isuv = pt2suv(I,INFO);
        %Isuv = kron(Isuv,ones(4));
        PixelIdxList = ROI{val}.RoiSegmentationPixelIdxList.Marrow128{ROI{val}.RoiSlicePTvsCTindex(it)};
        ROI{val}.SUVValue{it} = Isuv(PixelIdxList);
        
        PixelIdxList_CB = setdiff(ROI{val}.RoiSegmentationPixelIdxList.Bone128{ROI{val}.RoiSlicePTvsCTindex(it)},...
            ROI{val}.RoiSegmentationPixelIdxList.Marrow128{ROI{val}.RoiSlicePTvsCTindex(it)});
        ROI{val}.SUVValue_CB{it} = Isuv(PixelIdxList_CB);
       
    end
    %%%
    
end
%waitbar2a(0, pet_gui.PANELwaitbar.waitbar,'');
end
%%
%%- PT2SUV
%%-
function[Isuv] = pt2suv(I,INFO)

InjectedDose = double(INFO.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideTotalDose)*10^-3;
InjectionTime_str = INFO.RadiopharmaceuticalInformationSequence.Item_1.RadiopharmaceuticalStartTime;
InjectionTime = [str2double(InjectionTime_str(1:2)),str2double(InjectionTime_str(3:4)),str2double(InjectionTime_str(5:6))];
HalfLife = double(INFO.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideHalfLife)/60;
PatientWeight = double(INFO.PatientWeight);
RescaleSlope = double(INFO.RescaleSlope);
RescaleIntercept = double(INFO.RescaleIntercept);
AcquisitionTime_str = INFO.AcquisitionTime;
AcquisitionTime = [str2double(AcquisitionTime_str(1:2)),str2double(AcquisitionTime_str(3:4)),str2double(AcquisitionTime_str(5:6))];

Time = (AcquisitionTime-InjectionTime)*[60;1;1/60]; %%tempo in minuti trascorso dall'iniezione all'acquisizione

ReductionFactor = (exp(-log(2)*Time/HalfLife));
CorrectedDose = InjectedDose*ReductionFactor;

Isuv = (I.*RescaleSlope+RescaleIntercept).*PatientWeight./CorrectedDose;
end
%%

function Projection_NM(val,it_start)

global Info;
global pet_gui;
global ROI;

if nargin <2, it_start = 1; end

ROI{val}.NMValue = [];
ROI{val}.NMValue_CB = [];


Nit = length(ROI{val}.RoiSliceNM);
str_wbar = [Info.PatientName.FamilyName ' ' Info.PatientName.GivenName ' computing SUV 1/2 (roi: ' ROI{val}.Name ')'];
%waitbar2a(0, pet_gui.PANELwaitbar.waitbar,str_wbar);
for it = it_start:Nit
    
    if ROI{val}.RoiSliceNMvsCTindex(it)>0
        sprintf('NM %s: %d di %d \n',ROI{val}.Name, it, Nit)
        %waitbar2a(it/Nit, pet_gui.PANELwaitbar.waitbar,str_wbar);
        str = [Info.InputPath, pet_gui.slash_pc_mac, Info.FileNM{pet_gui.SelectedNM}(1).name];
        Iaux = dicomread(str);
        I = double(Iaux(:,:,it+ROI{val}.RoiSliceNM(1)-1));
        
        Isuv = I;
        PixelIdxList = ROI{val}.RoiSegmentationPixelIdxList.Marrow128{ROI{val}.RoiSliceNMvsCTindex(it)};
        
        ROI{val}.NMValue{it} = Isuv(PixelIdxList);
        PixelIdxList_CB = setdiff(ROI{val}.RoiSegmentationPixelIdxList.Bone128{ROI{val}.RoiSliceNMvsCTindex(it)},...
            ROI{val}.RoiSegmentationPixelIdxList.Marrow128{ROI{val}.RoiSliceNMvsCTindex(it)});
        ROI{val}.NMValue_CB{it} = Isuv(PixelIdxList_CB);
        
    end
    %%%
    
end
%waitbar2a(0, pet_gui.PANELwaitbar.waitbar,'');
end

%%- Segmentation_HeadRegion
%%-
function Segmentation_HeadRegion(val,BedPixelIdxList)

global Info;
global pet_gui;
global ROI;

soglia_lower_osso_HS = ROI{val}.HURange(1);

Nit = ROI{2}.RoiSlice(1)-1;

str_wbar = [Info.PatientName.FamilyName ' ' Info.PatientName.GivenName ' segmenting roi: head'];
%waitbar2a(0, pet_gui.PANELwaitbar.waitbar,str_wbar);
for it = 1:Nit
    %  waitbar2a(it/Nit,pet_gui.PANELwaitbar.waitbar,str_wbar);
    str = [Info.InputPath, pet_gui.slash_pc_mac, Info.FileCT{pet_gui.SelectedCT}(it+ ROI{val}.RoiSlice(1)-1).name];
    INFO = dicominfo(str);
    I0 = double(dicomread(str));
    I0(BedPixelIdxList) = 0;
    
    soglia_lower_osso_CT = (soglia_lower_osso_HS-INFO.RescaleIntercept)./INFO.RescaleSlope;
    mask = (I0>= soglia_lower_osso_CT);
    
    mask_bone_scaled = imresize(mask,Info.resize_scale_CT2Funct);
    if mod(size(mask_bone_scaled,1),2) == 0
        pad_size = (Info.SizeCT(1,1)-size(mask_bone_scaled,1))/2;
        pad_size = double(pad_size); 
        mask_bone_scaled = padarray(mask_bone_scaled,[pad_size,pad_size]);
    else
        pad_size = (Info.SizeCT(1,1)-size(mask_bone_scaled,1))/2;
        pad_size = double(pad_size); 
        mask_bone_scaled = padarray(mask_bone_scaled,[pad_size,pad_size]);
        mask_bone_scaled = [mask_bone_scaled; zeros(1,Info.SizeCT(1,1)-1)];
        mask_bone_scaled = [mask_bone_scaled, zeros(Info.SizeCT(1,1),1)];
    end
    
    mask_bone128 = round(imresize(mask_bone_scaled,Info.resize_factor_CT2Funct));
    
    ROI{val}.RoiSegmentationPixelIdxList.Bone{it} = find(mask);
    ROI{val}.RoiSegmentationPixelIdxList.Bone128{it} = find(mask_bone128);
    mask_marrow = double(mask);
    
    mask_marrow_scaled = imresize(mask_marrow,Info.resize_scale_CT2Funct);
    if mod(size(mask_marrow_scaled,1),2) == 0
        pad_size = (Info.SizeCT(1,1)-size(mask_marrow_scaled,1))/2;
        pad_size = double(pad_size); 
        mask_marrow_scaled = padarray(mask_marrow_scaled,[pad_size,pad_size]);
    else
        pad_size = (Info.SizeCT(1,1)-size(mask_marrow_scaled,1))/2;
        pad_size = double(pad_size); 
        mask_marrow_scaled = padarray(mask_marrow_scaled,[pad_size,pad_size]);
        mask_marrow_scaled = [mask_marrow_scaled; zeros(1,Info.SizeCT(1,1)-1)];
        mask_marrow_scaled = [mask_marrow_scaled, zeros(Info.SizeCT(1,1),1)];
    end
    mask_marrow128 = round(imresize(mask_marrow_scaled,Info.resize_factor_CT2Funct));
    ROI{val}.RoiSegmentationPixelIdxList.Marrow{it} = find(mask_marrow);
    ROI{val}.RoiSegmentationPixelIdxList.Marrow128{it} = find(mask_marrow128);
end
end