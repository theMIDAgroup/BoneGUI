%% Slider_WindowDown()
%% mida group http://mida.dima.unige.it - 2015
%%%% this function changes the CLim of the Hounsfield values

%%%% called by: main_gui(action,varargin) - panel 'CT Figure'

function Slider_WindowDown()

global pet_gui;
set(pet_gui.PANELax.SLIDERcontrast,'value',0.5);
aux_down = get(pet_gui.PANELax.SLIDERwindowDown_edit,'string');
aux_down = str2num(aux_down);
pet_gui.inf_hu = aux_down;
CLim_min = aux_down;
aux = get(pet_gui.PANELax.ax, 'CLim');
CLim_max = aux(2);
if CLim_min>CLim_max
    CLim_min = CLim_max-10;
end
set(pet_gui.PANELax.ax, 'CLim', [CLim_min CLim_max]);
%
set(pet_gui.PANELax.colorbar,'xtick',[round(CLim_min)+1,floor(CLim_max)]);
set(pet_gui.PANELax.colorbar,'xticklabel',{num2str(round(CLim_min)),num2str(floor(CLim_max))});
set(pet_gui.PANELax.colorbar,'Color',pet_gui.fgc);
set(pet_gui.PANELax.colorbar,'Fontsize', pet_gui.fs)
end