%% Write_Dicom()
%% mida group http://mida.dima.unige.it - 2010/2015
%%%% this function writes the results in dicom files

%%%% called by: Start_Analysis()

function Write_Dicom()

global ROI;
global Info;
global pet_gui;

warning off;

Nval = length(ROI);

for val = 1 : Nval
    
    if ROI{val}.Enable %&& ROI{val}.OutputDicom && ~ROI{val}.DicomWrittenCT
        output_directory = [Info.OutputPathDICOM pet_gui.slash_pc_mac  'ROI_' regexprep(ROI{val}.Name,'[^\w'']','')];
        output_directory_CB = [Info.OutputPathDICOM pet_gui.slash_pc_mac  'CB_ROI_' regexprep(ROI{val}.Name,'[^\w'']','')];
        
        if ~exist(output_directory,'dir'), mkdir(output_directory); end
        if ~exist(output_directory_CB,'dir'), mkdir(output_directory_CB); end
        Nit = length(ROI{val}.RoiSlice);
        for it = 1 : Nit
            
            str = [Info.InputPath, pet_gui.slash_pc_mac, Info.FileCT{pet_gui.SelectedCT}(it+ ROI{val}.RoiSlice(1)-1).name];
            INFO_CT = dicominfo(str);
            I_CT = double(dicomread(str));
            
            I_CTmarrow = zeros(Info.SizeCT);
            I_CTmarrow(ROI{val}.RoiSegmentationPixelIdxList.Marrow{it})= I_CT(ROI{val}.RoiSegmentationPixelIdxList.Marrow{it});
            I_CTmarrow = uint16(I_CTmarrow);
            str_save = [output_directory pet_gui.slash_pc_mac Info.FileCT{pet_gui.SelectedCT}(it+ ROI{val}.RoiSlice(1)-1).name];
            dicomwrite(I_CTmarrow,str_save,INFO_CT,'CreateMode','copy');
            
            I_CTcompact = zeros(Info.SizeCT);
            PixelIdxList_CB   =  [];
            PixelIdxList_CB   = setdiff(ROI{val}.RoiSegmentationPixelIdxList.Bone{it},...
                ROI{val}.RoiSegmentationPixelIdxList.Marrow{it});
            I_CTcompact(PixelIdxList_CB  )= I_CT(PixelIdxList_CB  );
            I_CTcompact = uint16(I_CTcompact);
            str_save = [output_directory_CB pet_gui.slash_pc_mac 'CB_' Info.FileCT{pet_gui.SelectedCT}(it+ ROI{val}.RoiSlice(1)-1).name];
            dicomwrite(I_CTcompact,str_save,INFO_CT,'CreateMode','copy');
        end
        ROI{val}.DicomWrittenCT = true;
        
    end
    
    if ROI{val}.Enable %&& ROI{val}.OutputDicom && ~isempty(pet_gui.SelectedPT) % && ~ROI{val}.DicomWrittenPT
        %condroiout(val) = ROI{val}.OutputDicom
        %condisnotempty(val) = ~isempty(pet_gui.SelectedPT)
        output_directory = [Info.OutputPathDICOM pet_gui.slash_pc_mac  'ROI_' regexprep(ROI{val}.Name,'[^\w'']','')];
        output_directory_CB = [Info.OutputPathDICOM pet_gui.slash_pc_mac  'CB_ROI_' regexprep(ROI{val}.Name,'[^\w'']','')];
        
        Nit = length(ROI{val}.RoiSlicePT);
        for it =  1:Nit
            if ROI{val}.RoiSlicePTvsCTindex(it)>0
                
                str= [Info.InputPath, pet_gui.slash_pc_mac, Info.FilePT{pet_gui.SelectedPT}(it+ROI{val}.RoiSlicePT(1)-1).name];
                INFO_PT = dicominfo(str);
                I_PT = double(dicomread(str));
                
                I_PTmarrow = zeros(Info.SizePT);
                temp = ROI{val}.RoiSegmentationPixelIdxList.Marrow128{ROI{val}.RoiSlicePTvsCTindex(it)};
                I_PTmarrow(temp) = I_PT(temp);
                I_PTmarrow = int16(I_PTmarrow);
                
                str_save = [output_directory pet_gui.slash_pc_mac Info.FilePT{pet_gui.SelectedPT}(it+ROI{val}.RoiSlicePT(1)-1).name];
                dicomwrite(I_PTmarrow,str_save,INFO_PT,'CreateMode','copy');
                
                I_PTcompact= zeros(Info.SizePT);
                PixelIdxList_CB =  [];
                PixelIdxList_CB = setdiff(ROI{val}.RoiSegmentationPixelIdxList.Bone128{ROI{val}.RoiSlicePTvsCTindex(it)},...
                    ROI{val}.RoiSegmentationPixelIdxList.Marrow128{ROI{val}.RoiSlicePTvsCTindex(it)});
                I_PTcompact(PixelIdxList_CB) = I_PT(PixelIdxList_CB);
                I_PTcompact = uint16(I_PTcompact);
                str_save = [output_directory_CB pet_gui.slash_pc_mac 'CB_' Info.FilePT{pet_gui.SelectedPT}(it+ ROI{val}.RoiSlicePT(1)-1).name];
                dicomwrite(I_PTmarrow,str_save,INFO_PT,'CreateMode','copy');
                
            end
        end
        ROI{val}.DicomWrittenPT = true;
    end
    
    if ROI{val}.Enable && ROI{val}.OutputDicom && ~ROI{val}.DicomWrittenNM && ~isempty(pet_gui.SelectedNM)
        output_directory = [Info.OutputPathDICOM pet_gui.slash_pc_mac  'ROI_' regexprep(ROI{val}.Name,'[^\w'']','')];
        output_directory_CB = [Info.OutputPathDICOM pet_gui.slash_pc_mac  'CB_ROI_' regexprep(ROI{val}.Name,'[^\w'']','')];
        
        Nit = length(ROI{val}.RoiSliceNM);
        str = [Info.InputPath, pet_gui.slash_pc_mac, Info.FileNM{pet_gui.SelectedNM}(1).name];
        INFO_NM = dicominfo(str);
        Iaux = dicomread(str);
        Iaux_NMmarrow = Iaux;
        Iaux_NMcompact = Iaux;
        for it =  1 : Nit
            if ROI{val}.RoiSliceNMvsCTindex(it)>0
                
                I_NM = double(Iaux(:,:,1,it+ROI{val}.RoiSliceNM(1)-1));
                
                I_NMmarrow = zeros(Info.SizeNM);
                temp = ROI{val}.RoiSegmentationPixelIdxList.Marrow128{ROI{val}.RoiSliceNMvsCTindex(it)};
                I_NMmarrow(temp) = I_NM(temp);
                I_NMmarrow = int16(I_NMmarrow);
                Iaux_NMmarrow(:,:,1,it+ROI{val}.RoiSliceNM(1)-1) = I_NMmarrow;
                
                I_NMcompact= zeros(Info.SizeNM);
                PixelIdxList_CB =  [];
                PixelIdxList_CB = setdiff(ROI{val}.RoiSegmentationPixelIdxList.Bone128{ROI{val}.RoiSliceNMvsCTindex(it)},...
                    ROI{val}.RoiSegmentationPixelIdxList.Marrow128{ROI{val}.RoiSliceNMvsCTindex(it)});
                I_NMcompact(PixelIdxList_CB)= I_NM(PixelIdxList_CB);
                I_NMcompact = uint16(I_NMcompact);
                Iaux_NMcompact(:,:,1,it+ROI{val}.RoiSliceNM(1)-1) = I_NMcompact;
                
            end
        end
         
        str_save = [output_directory pet_gui.slash_pc_mac Info.FileNM{pet_gui.SelectedNM}(1).name];
        dicomwrite(Iaux_NMmarrow,str_save,INFO_NM,'CreateMode','copy');
        str_save = [output_directory_CB pet_gui.slash_pc_mac 'CB_' Info.FileNM{pet_gui.SelectedNM}(1).name];
        dicomwrite(Iaux_NMcompact,str_save,INFO_NM,'CreateMode','copy');
        
        ROI{val}.DicomWrittenNM = true;
    end
    
end

warning on;

save([Info.InputPathMAT pet_gui.slash_pc_mac 'ROI' num2str(Info.SeriesNumberCT(pet_gui.SelectedCT)) '.mat'],'ROI','-mat');

end