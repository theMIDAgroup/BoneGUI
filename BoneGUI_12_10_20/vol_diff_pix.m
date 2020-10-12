clc
clear all

load ('ROI3.mat');
load('Info.mat');

num_vox_upper_total_body=ROI{1,1}.SUV3D.upper.VoxelNumber;
num_vox_lower_total_body=ROI{1,1}.SUV3D.lower.VoxelNumber;
num_vox_total_total_body=ROI{1,1}.SUV3D.total.VoxelNumber;

num_vox_upper_C1C7=ROI{1,2}.SUV3D.upper.VoxelNumber;
num_vox_lower_C1C7=ROI{1,2}.SUV3D.lower.VoxelNumber;
num_vox_total_C1C7=ROI{1,2}.SUV3D.total.VoxelNumber;

num_vox_upper_T1T12=ROI{1,3}.SUV3D.upper.VoxelNumber;
num_vox_lower_T1T12=ROI{1,3}.SUV3D.lower.VoxelNumber;
num_vox_total_T1T12=ROI{1,3}.SUV3D.total.VoxelNumber;

num_vox_upper_L1L5=ROI{1,4}.SUV3D.upper.VoxelNumber;
num_vox_lower_L1L5=ROI{1,4}.SUV3D.lower.VoxelNumber;
num_vox_total_L1L5=ROI{1,4}.SUV3D.total.VoxelNumber;

num_vox_upper_S1S5=ROI{1,5}.SUV3D.upper.VoxelNumber;
num_vox_lower_S1S5=ROI{1,5}.SUV3D.lower.VoxelNumber;
num_vox_total_S1S5=ROI{1,5}.SUV3D.total.VoxelNumber;

mean_upper_total_body=ROI{1,1}.SUV3D.upper.Mean;
mean_lower_total_body=ROI{1,1}.SUV3D.lower.Mean;
mean_total_total_body=ROI{1,1}.SUV3D.total.Mean;

mean_upper_C1C7=ROI{1,2}.SUV3D.upper.Mean;
mean_lower_C1C7=ROI{1,2}.SUV3D.lower.Mean;
mean_total_C1C7=ROI{1,2}.SUV3D.total.Mean;

mean_upper_T1T12=ROI{1,3}.SUV3D.upper.Mean;
mean_lower_T1T12=ROI{1,3}.SUV3D.lower.Mean;
mean_total_T1T12=ROI{1,3}.SUV3D.total.Mean;

mean_upper_L1L5=ROI{1,4}.SUV3D.upper.Mean;
mean_lower_L1L5=ROI{1,4}.SUV3D.lower.Mean;
mean_total_L1L5=ROI{1,4}.SUV3D.total.Mean;

mean_upper_S1S5=ROI{1,5}.SUV3D.upper.Mean;
mean_lower_S1S5=ROI{1,5}.SUV3D.lower.Mean;
mean_total_S1S5=ROI{1,5}.SUV3D.total.Mean;

%LocationCT=cell2mat(Info.LocationCT);
PixelSpacingCT=cell2mat(Info.PixelSpacingCT);
%LocationPT=cell2mat(Info.LocationPT);
PixelSpacingPT=cell2mat(Info.PixelSpacingPT);

volume_vox= (Info.SliceThicknessCT) * (PixelSpacingCT(1,1)) * (PixelSpacingCT(2,1));
volume_voxPT=(Info.SliceThicknessPT) * (PixelSpacingPT(1,1)) * (PixelSpacingPT(2,1));

volcm3_upper_total_body=num_vox_upper_total_body*volume_voxPT;
volcm3_lower_total_body=num_vox_lower_total_body*volume_voxPT;
volcm3_total_total_body=num_vox_total_total_body*volume_voxPT;

volcm3_upper_C1C7=num_vox_upper_C1C7*volume_voxPT;
volcm3_lower_C1C7=num_vox_lower_C1C7*volume_voxPT;
volcm3_total_C1C7=num_vox_total_C1C7*volume_voxPT;

volcm3_upper_T1T12=num_vox_upper_T1T12*volume_voxPT;
volcm3_lower_T1T12=num_vox_lower_T1T12*volume_voxPT;
volcm3_total_T1T12=num_vox_total_T1T12*volume_voxPT;

volcm3_upper_L1L5=num_vox_upper_L1L5*volume_voxPT;
volcm3_lower_L1L5=num_vox_lower_L1L5*volume_voxPT;
volcm3_total_L1L5=num_vox_total_L1L5*volume_voxPT;

volcm3_upper_S1S5=num_vox_upper_S1S5*volume_voxPT;
volcm3_lower_S1S5=num_vox_lower_S1S5*volume_voxPT;
volcm3_total_S1S5=num_vox_total_S1S5*volume_voxPT;

volcm3_upper_axial=volcm3_upper_C1C7+volcm3_upper_T1T12+ ...
                   volcm3_upper_L1L5+volcm3_upper_S1S5;
volcm3_lower_axial=volcm3_lower_C1C7+volcm3_lower_T1T12+ ...
                   volcm3_lower_L1L5+volcm3_lower_S1S5;
volcm3_total_axial=volcm3_total_C1C7+volcm3_total_T1T12+ ...
                   volcm3_total_L1L5+volcm3_total_S1S5;

perc_upper_total_body=volcm3_upper_total_body/volcm3_total_total_body;
perc_lower_total_body=volcm3_lower_total_body/volcm3_total_total_body;

perc_upper_C1C7=volcm3_upper_C1C7/volcm3_total_C1C7;
perc_lower_C1C7=volcm3_lower_C1C7/volcm3_total_C1C7;

perc_upper_T1T12=volcm3_upper_T1T12/volcm3_total_T1T12;
perc_lower_T1T12=volcm3_lower_T1T12/volcm3_total_T1T12;

perc_upper_L1L5=volcm3_upper_L1L5/volcm3_total_L1L5;
perc_lower_L1L5=volcm3_lower_L1L5/volcm3_total_L1L5;

perc_upper_S1S5=volcm3_upper_S1S5/volcm3_total_S1S5;
perc_lower_S1S5=volcm3_lower_S1S5/volcm3_total_S1S5;

perc_upper_axial=volcm3_upper_axial/volcm3_total_axial;
perc_lower_axial=volcm3_lower_axial/volcm3_total_axial;

infopat=Info.PatientID;
Int_Table = {'infopat','volcm3_total_total_body', 'volcm3_total_C1C7', 'volcm_total_3T1T12', ...
             'volcm3_total_L1L5', 'volcm3_total_S1S5', 'volcm3_total_axial'...
             'volcm3_lower_total_body', 'volcm3_lower_C1C7', 'volcm3_lower_T1T12', ...
             'volcm3_lower_L1L5', 'volcm3_upper_S1S5', 'volcm3_upper_axial'...
             'volcm3_upper_total_body', 'volcm3_upper_C1C7', 'volcm3_upper_T1T12', ...
             'volcm3_upper_L1L5', 'volcm3_lower_S1S5', 'volcm3_upper_axial'...
             'perc_lower_totalbody', 'perc_lower_C1C7', 'perc_lower_T1T12',...
             'perc_lower_L1L5', 'perc_lower_SIS5', 'perc_lower_axial'...
             'perc_upper_totalbody', 'perc_upper_C1C7', 'perc_upper_T1T12',...
             'perc_upper_L1L5', 'perc_upper_S1S5', 'perc_upper_axial'};
             
Val_Table = [volcm3_total_total_body, volcm3_total_C1C7', volcm3_total_T1T12', ...
             volcm3_total_L1L5, volcm3_total_S1S5, volcm3_total_axial,...
             ...
             volcm3_lower_total_body, volcm3_lower_C1C7', volcm3_lower_T1T12', ...
             volcm3_lower_L1L5, volcm3_lower_S1S5, volcm3_lower_axial,...
             ...
             volcm3_upper_total_body, volcm3_upper_C1C7', volcm3_upper_T1T12', ...
             volcm3_upper_L1L5, volcm3_upper_S1S5, volcm3_upper_axial,...
             ...
             perc_lower_total_body, perc_lower_C1C7, perc_lower_T1T12,...
             perc_lower_L1L5, perc_lower_S1S5, perc_lower_axial,...
             ...
             perc_upper_total_body, perc_upper_C1C7, perc_upper_T1T12,...
             perc_upper_L1L5, perc_upper_S1S5, perc_upper_axial];



fid=fopen(infopat,'w');

fprintf(fid, ' %f   %f   %f     %f      %f      %f      \n', [ Val_Table] );
fclose(fid);
