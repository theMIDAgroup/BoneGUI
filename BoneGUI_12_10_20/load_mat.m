function []=load_mat(t)
global batch_gui
batch_gui.path_mat_dir = uigetdir('Select the .mat directory');
set(batch_gui.text_load_mat(t),'string',batch_gui.path_mat_dir);
end