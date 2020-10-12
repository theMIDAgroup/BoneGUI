%% Show_image()
%% mida group http://mida.dima.unige.it - 2010/2015
%%%% this function selects the CT image in the series to show: it reads the
%%%% associated DICOM file and shows the CT image
%%%% 
%%%% called by: Select_CTPT_Series()
%%%%            Slider_Image()
%%%%            PopUp_Districts()
%%%%            Put_Roi()
%%%% call: SliderContrast()
%%%%       Enable_MouseControl()
%%%%       DragOff()

function Show_Image()
global Info;
global pet_gui;

xlim = get(pet_gui.PANELax.ax,'xlim');
ylim = get(pet_gui.PANELax.ax,'ylim');

pet_gui.SliceNumber = round(get(pet_gui.PANELax.SLIDERimage, 'Value')*(Info.NumberFileCT(pet_gui.SelectedCT)-1)+1);
str = sprintf('slice number: %d / %d',pet_gui.SliceNumber,Info.NumberFileCT(pet_gui.SelectedCT));
set(pet_gui.PANELax.TXT,'string',str);

I_ct2 = dicomread([Info.InputPath, pet_gui.slash_pc_mac, Info.FileCT{pet_gui.SelectedCT}(pet_gui.SliceNumber).name]);

imshow(I_ct2,'parent',pet_gui.PANELax.ax);
set(pet_gui.PANELax.ax, 'xlim', xlim,'ylim', ylim);
if pet_gui.prima_apertura == 0
    pet_gui.prima_apertura = 1;
    pet_gui.PANELax.colorbar = colorbar('peer',pet_gui.PANELax.ax,'horiz');
    set(pet_gui.PANELax.colorbar,'Color',pet_gui.fgc);
    set(pet_gui.PANELax.colorbar,'Fontsize', pet_gui.fs);
    set(get(pet_gui.PANELax.colorbar, 'Title'), 'Fontsize', pet_gui.fs)
    pet_gui.sup_hu = max(max(I_ct2));
    pet_gui.inf_hu = min(min(I_ct2));
    CLim_max = pet_gui.sup_hu;
    CLim_min = pet_gui.inf_hu;
    set(pet_gui.PANELax.SLIDERwindowDown_edit,'string',CLim_min);
    set(pet_gui.PANELax.SLIDERwindowUp_edit,'string',CLim_max);
    set(pet_gui.PANELax.ax, 'CLim', [CLim_min CLim_max]);
    set(pet_gui.PANELax.colorbar,'xtick',[round(CLim_min)+1,floor(CLim_max)]);
    set(pet_gui.PANELax.colorbar,'xticklabel',{num2str(round(CLim_min)),num2str(floor(CLim_max))});
else
    pet_gui.PANELax.colorbar = colorbar('peer',pet_gui.PANELax.ax,'horiz');
    set(get(pet_gui.PANELax.colorbar, 'Title'), 'Fontsize', pet_gui.fs)
    set(pet_gui.PANELax.colorbar,'Color',pet_gui.fgc);
    set(pet_gui.PANELax.colorbar,'Fontsize', pet_gui.fs)
end

Slider_Contrast;
Enable_MouseControl;
Drag_Off;
end
