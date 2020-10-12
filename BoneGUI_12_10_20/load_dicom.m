function []=load_dicom(t)
global batch_gui
batch_gui.path_dicom_dir = uigetdir('Select the dicom directory');
set(batch_gui.text_load_dicom(t),'string',batch_gui.path_dicom_dir);
cd(batch_gui.path_dicom_dir)
cd ..
end
