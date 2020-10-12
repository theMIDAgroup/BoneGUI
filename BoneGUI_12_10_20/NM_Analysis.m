function NM_Analysis()
global ROI;
global Info;
global pet_gui;

Nval = length(ROI);
temp = false;
str_wbar = [Info.PatientName.FamilyName ' ' Info.PatientName.GivenName ' computing NM 2/2'];

%waitbar2a(0, pet_gui.PANELwaitbar.waitbar,str_wbar);
for val = 1 : Nval
    % waitbar2a(val/Nval,pet_gui.PANELwaitbar.waitbar,str_wbar);
    if ROI{val}.Enable && ~isempty(ROI{val}.NMValue)
        
        
        ROI{val}.NM2D = Compute_NM2D(ROI{val}.NMValue,'IBV');
        ROI{val}.NM2D_CB = Compute_NM2D(ROI{val}.NMValue_CB,'CBV');
     
        ROI{val}.NM3D = Compute_NM3D(ROI{val}.NM2D);
        ROI{val}.NM3D_CB = Compute_NM3D(ROI{val}.NM2D_CB);

        
        temp = true;
    end
end
%waitbar2a(0, pet_gui.PANELwaitbar.waitbar,'');
if temp
    save([Info.InputPathMAT pet_gui.slash_pc_mac 'ROI' num2str(Info.SeriesNumberCT(pet_gui.SelectedCT)) '.mat'],'ROI','-mat');
    
end
end

function[out] = Compute_NM2D(NMValue,str_bv)
%% flag = 'le' or flag = 'ge'

Nit = length(NMValue);
for it = 1 : Nit
    
    value = NMValue{it};
    
    if isempty(value)
        out.Max(it) = 0;
        out.Min(it) = 0;
        out.Mean(it) = 0;
        out.Std(it) = 0;
        out.VoxelNumber(it) = 0;
    else
        
        
        
        %% modifica del 23/09/2016, calcolo media e std solo sopra 100 counts
        
        if strcmp(str_bv,'CBV') || strcmp(str_bv,'TBV')
            aux_100 = value(value>300);
            if isempty(aux_100)
                out.Max(it) = 0;
                out.Min(it) = 0;
                out.Mean(it) = 0;
                out.Std(it) = 0;
                out.VoxelNumber(it) = 0;
            else
                out.Max(it) = max(aux_100);
                out.Min(it) = min(aux_100);
                out.Mean(it) = mean(aux_100);
                out.Std(it) = std(aux_100);
                out.VoxelNumber(it) = length(aux_100);
            end
        else
            out.Max(it) = max(value);
            out.Min(it) = min(value);
            out.Mean(it) = mean(value);
            out.Std(it) = std(value);
            out.VoxelNumber(it) = length(value);
        end
    end
end
end


function[out] = Compute_NM3D(NM2D)

N = sum(NM2D.VoxelNumber);
out.VoxelNumber = N;
NM2D.Mean(isnan(NM2D.Mean)) = 0;
NM2D.Std(isnan(NM2D.Std)) = 0;


if N == 0
    out.Max = 0;
    out.Min = 0;
    out.Mean = 0;
    out.Std = 0;
else
    out.Max = max(NM2D.Max);
    temp = nonzeros(NM2D.Min);
    out.Min = 0;
    if ~isempty(temp), out.Min = min(temp); end
    out.Mean = (NM2D.VoxelNumber(:))'*NM2D.Mean(:)./N;
    if N == 1
        out.Std = 0;
    else
        out.Std = sqrt(((NM2D.VoxelNumber(:)-1)'*(NM2D.Std(:).^2)+(NM2D.VoxelNumber(:))'*(NM2D.Mean(:)-out.Mean).^2)./(N-1));
    end
    out.VoxelNumber = N;
end

end