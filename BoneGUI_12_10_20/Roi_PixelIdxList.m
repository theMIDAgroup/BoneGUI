%% Roi_PixelIdxList()
%% mida group http://mida.dima.unige.it - 2010/2015
%%%% this function sets in the struct ROI the pixels associated to the 'val' roi

%%%% called by: Save_All()
%%%% call: Roi_Fill_PixelIdxList()


function Roi_PixelIdxList()
global ROI;

[xgrid,ygrid] = meshgrid(1:1:512);
Nval = length(ROI);
for val  =  1 : Nval
    if ~ROI{val}.RoiEmpty
        Nit = length(ROI{val}.RoiSlice);
        for it  =  1 : Nit
            RoiKind = ROI{val}.RoiKind{it};
            RoiPosition = ROI{val}.RoiPosition{it};
            temp = Roi_Fill_PixelIdxList(RoiKind,RoiPosition,xgrid,ygrid);
            
            tempRemove = [];
            %%%% if the roi is on a vertebra, we remove the spinal canal
            %%%% identify by the region enclosed in the red ellipse
            if ismember(ROI{val}.Id,[2,3,4,5])
                RoiRemoveKind = ROI{val}.RoiRemoveKind{it};
                RoiRemovePosition = ROI{val}.RoiRemovePosition{it};
                tempRemove = Roi_Fill_PixelIdxList(RoiRemoveKind,RoiRemovePosition,xgrid,ygrid);                
                ymin = min(ygrid(tempRemove));
                aux = zeros(512);
                aux(temp) = 1;
                aux = aux.*(ygrid<= ymin);
                ROI{val}.RoiVertebraPixelIdxList{it} = find(aux);
            end
            
            ROI{val}.RoiPixelIdxList{it} = setdiff(temp,tempRemove);
        end
    end
end
end
