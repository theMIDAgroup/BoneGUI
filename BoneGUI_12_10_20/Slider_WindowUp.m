%% Slider_WindowUp()
%% mida group http://mida.dima.unige.it - 2015
%%%% this function changes the CLim of the Hounsfield values

%%%% called by: main_gui(action,varargin) - panel 'CT Figure'

function Slider_WindowUp()
global pet_gui;


set(pet_gui.PANELax.SLIDERcontrast,'value',0.5);
aux_up = get(pet_gui.PANELax.SLIDERwindowUp_edit,'string');
aux_up = str2num(aux_up);
pet_gui.sup_hu = aux_up;
CLim_max = aux_up;
aux = get(pet_gui.PANELax.ax, 'CLim');
CLim_min = aux(1);
if CLim_min>CLim_max
    CLim_min = CLim_max-10;
end
set(pet_gui.PANELax.ax, 'CLim', [CLim_min CLim_max]);
get(pet_gui.PANELax.ax, 'CLim')

set(pet_gui.PANELax.colorbar,'xtick',[round(CLim_min)+1,floor(CLim_max)]);
set(pet_gui.PANELax.colorbar,'xticklabel',{num2str(round(CLim_min)),num2str(floor(CLim_max))});
set(pet_gui.PANELax.colorbar,'Color',pet_gui.fgc);
set(pet_gui.PANELax.colorbar,'Fontsize', pet_gui.fs)
end
