%% SUV_Analysis()
%% mida group http://mida.dima.unige.it - 2010/2015
%%%% this function writes the SUV values in the fields of the struct ROI

%%%% called by: Start_Analysis()

function SUV_Analysis()
global ROI;
global Info;
global pet_gui;

Nval = length(ROI);
temp = false;
str_wbar=[Info.PatientName.FamilyName ' ' Info.PatientName.GivenName ' computing SUV 2/2'];

%waitbar2a(0, pet_gui.PANELwaitbar.waitbar,str_wbar);
for val = 1 : Nval
    % waitbar2a(val/Nval,pet_gui.PANELwaitbar.waitbar,str_wbar);
    if ROI{val}.Enable && ~isempty(ROI{val}.SUVValue)  
        
        ROI{val}.SUV2D.lower=Compute_SUV2D(ROI{val}.SUVValue,ROI{val}.SUVCutoff,'le');
        ROI{val}.SUV2D.upper=Compute_SUV2D(ROI{val}.SUVValue,ROI{val}.SUVCutoff,'ge');
        ROI{val}.SUV2D.total=Compute_SUV2D(ROI{val}.SUVValue,0,'ge');
                
        ROI{val}.SUV2D_CB.lower=Compute_SUV2D(ROI{val}.SUVValue_CB,ROI{val}.SUVCutoff,'le');
        ROI{val}.SUV2D_CB.upper=Compute_SUV2D(ROI{val}.SUVValue_CB,ROI{val}.SUVCutoff,'ge');
        ROI{val}.SUV2D_CB.total=Compute_SUV2D(ROI{val}.SUVValue_CB,0,'ge');
        
        ROI{val}.SUV3D.lower=Compute_SUV3D(ROI{val}.SUV2D.lower);
        ROI{val}.SUV3D.upper=Compute_SUV3D(ROI{val}.SUV2D.upper);
        ROI{val}.SUV3D.total=Compute_SUV3D(ROI{val}.SUV2D.total);
        
        ROI{val}.SUV3D_CB.lower=Compute_SUV3D(ROI{val}.SUV2D_CB.lower);
        ROI{val}.SUV3D_CB.upper=Compute_SUV3D(ROI{val}.SUV2D_CB.upper);
        ROI{val}.SUV3D_CB.total=Compute_SUV3D(ROI{val}.SUV2D_CB.total);
        

        temp=true;
    end
end
%waitbar2a(0, pet_gui.PANELwaitbar.waitbar,'');
if temp
    save([Info.InputPathMAT pet_gui.slash_pc_mac 'ROI' num2str(Info.SeriesNumberCT(pet_gui.SelectedCT)) '.mat'],'ROI','-mat');
    
end
end

function[out] = Compute_SUV2D(SUVValue,cutoff,flag)
%% flag = 'le' or flag = 'ge'

Nit = length(SUVValue);
for it = 1 : Nit
    index=feval(flag,SUVValue{it},cutoff);
    value=SUVValue{it}(index);
    
    if isempty(value)
        out.Max(it)=0;
        out.Min(it)=0;
        out.Mean(it)=0;
        out.Std(it)=0;
        out.PixelNumber(it)=0;
    else
        
        out.Max(it)=max(value);
        out.Min(it)=min(value);
        out.Mean(it)=mean(value);
        out.Std(it)=std(value);
        out.PixelNumber(it)=length(value);
    end
end
end


function[out] = Compute_SUV3D(SUV2D)

N=sum(SUV2D.PixelNumber);
out.VoxelNumber=N;
if N==0
    out.Max=0;
    out.Min=0;
    out.Mean=0;
    out.Std=0;
else
    out.Max=max(SUV2D.Max);
    temp=nonzeros(SUV2D.Min);
    out.Min=0;
    if ~isempty(temp), out.Min=min(temp); end
    out.Mean=(SUV2D.PixelNumber(:))'*SUV2D.Mean(:)./N;
    if N==1
        out.Std=0;
    else
        out.Std=sqrt(((SUV2D.PixelNumber(:)-1)'*(SUV2D.Std(:).^2)+(SUV2D.PixelNumber(:))'*(SUV2D.Mean(:)-out.Mean).^2)./(N-1));
    end
    out.VoxelNumber=N;
end

end