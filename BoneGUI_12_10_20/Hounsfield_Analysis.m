%% Hounsfield_Analysis()
%% mida group http://mida.dima.unige.it - 11/2015

%%%% Starting from the segmentation results, this function saves in the
%%%% ROI struct the Hounsfield values of trabecular and compact
%%%% bone

%%%% called by Start_Analysis()
%%%% call: [out] = Compute_Hounsfield2D(mask_trabecular) (row 53 in this file)
%%%%       [out] = Compute_Hounsfield3D(Hounsfield2D) (row 77 in this file)


function Hounsfield_Analysis()
global ROI;
global Info;
global pet_gui;

Nval=length(ROI);
temp = false;
str_wbar=[Info.PatientName.FamilyName ' ' Info.PatientName.GivenName ' computing Hounsfield'];

%waitbar2a(0, pet_gui.PANELwaitbar.waitbar,str_wbar);

for val = 1 : Nval
    aux_mask_trabecular=[]; 
    val
    %waitbar2a(val/Nval,pet_gui.PANELwaitbar.waitbar,str_wbar);
    if ROI{val}.Enable && ~isempty(ROI{val}.RoiSegmentationPixelIdxList.Marrow)
        
        %% July 15 2015: creo la maschera per il trabecolare per scrivere il file con gli Hounsfield
        Nit = length(ROI{val}.RoiSegmentationPixelIdxList.Marrow);
        ROI{val}.mask_CB = [];
        ROI{val}.mask_trabecular = [];
        ROI{val}.Hounsfield2D = [];
        ROI{val}.Hounsfield3D = [];
        for it = 1 : Nit
           
            str = [Info.InputPath, pet_gui.slash_pc_mac, Info.FileCT{pet_gui.SelectedCT}(it+ ROI{val}.RoiSlice(1)-1).name];
          	INFO_CT = dicominfo(str);
            I0 = double(dicomread(str));
                 
            IHounsfield = ct2Hounsfield(I0,INFO_CT);
            
            aux = [];
            aux = IHounsfield(ROI{val}.RoiSegmentationPixelIdxList.Marrow{it});
            aux2exclude = find(aux<-300);
            if isempty(aux2exclude)==0
                aux2exclude;
                it ;
                val;
            end
            aux(aux2exclude) = [];
            ROI{val}.mask_trabecular{it} = aux;
            
            aux_list = [];
            aux_list = setdiff(ROI{val}.RoiSegmentationPixelIdxList.Bone{it},...
                    ROI{val}.RoiSegmentationPixelIdxList.Marrow{it});
            aux = [];
            aux = IHounsfield(aux_list);
            aux2exclude = find(aux<-300);
            if isempty(aux2exclude)==0
                aux2exclude;
                it ;
                val;
            end
            aux(aux2exclude) = [];
            ROI{val}.mask_CB{it} = aux;
            
           
        end

        
        ROI{val}.Hounsfield2D = Compute_Hounsfield2D(ROI{val}.mask_trabecular);
        ROI{val}.Hounsfield2D_CB = Compute_Hounsfield2D(ROI{val}.mask_CB);

        ROI{val}.Hounsfield3D = Compute_Hounsfield3D(ROI{val}.Hounsfield2D);
        ROI{val}.Hounsfield3D_CB = Compute_Hounsfield3D(ROI{val}.Hounsfield2D_CB);
        temp=true;
    end
end
%waitbar2a(0, pet_gui.PANELwaitbar.waitbar,'');
if temp
	save([Info.InputPathMAT pet_gui.slash_pc_mac 'ROI' num2str(Info.SeriesNumberCT(pet_gui.SelectedCT)) '.mat'],'ROI','-mat');
end
end

function[IHounsfield]=ct2Hounsfield(I,INFO_CT)
IHounsfield = I*INFO_CT.RescaleSlope+INFO_CT.RescaleIntercept;
end

function[out] = Compute_Hounsfield2D(mask_trabecular)
Nit = length(mask_trabecular);
for it = 1 : Nit
    value = mask_trabecular{it};
    
    if isempty(value)
        out.Max(it) = 0;
        out.Min(it) = 0;
        out.Mean(it) = 0;
        out.Std(it) = 0;
        out.VoxelNumber(it) = 0;
    else
        
        out.Max(it) = max(value);
        out.Min(it) = min(value);
        out.Mean(it) = mean(value);
        out.Std(it) = std(value);
        out.VoxelNumber(it) = length(value);
    end
end
end


function[out] = Compute_Hounsfield3D(Hounsfield2D)
N=sum(Hounsfield2D.VoxelNumber);
out.VoxelNumber=N;
if N==0
    out.Max=0;
    out.Min=0;
    out.Mean=0;
    out.Std=0;
else
    out.Max=max(Hounsfield2D.Max);
    temp=nonzeros(Hounsfield2D.Min);
    out.Min=0;
    if ~isempty(temp), out.Min=min(temp); end
    out.Mean=(Hounsfield2D.VoxelNumber(:))'*Hounsfield2D.Mean(:)./N;
    if N==1
        out.Std=0;
    else
        out.Std=sqrt(((Hounsfield2D.VoxelNumber(:)-1)'*(Hounsfield2D.Std(:).^2)+(Hounsfield2D.VoxelNumber(:))'*(Hounsfield2D.Mean(:)-out.Mean).^2)./(N-1));
    end
    out.VoxelNumber=N;
end
end