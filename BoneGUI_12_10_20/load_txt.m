function []=load_txt(t)
global batch_gui
batch_gui.path_txt_dir = uigetdir('Select the .txt directory');
set(batch_gui.text_load_txt(t),'string',batch_gui.path_txt_dir);
end