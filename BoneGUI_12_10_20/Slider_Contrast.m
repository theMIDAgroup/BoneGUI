%% Slider_Contrast()
%% mida group http://mida.dima.unige.it - 2010/2015
%%%% this function sets the CLim values of the contrast, 
%%%% based on the maximum and minimum Hounsfield values

%%%% called by: Show_Image()
%%%%            main_gui(action,varargin) - panel 'CT Figure'

function Slider_Contrast()
global pet_gui;

t = get(pet_gui.PANELax.SLIDERcontrast,'value');
  
CLim_min = double(pet_gui.sup_hu)*(t-.5)+double(pet_gui.inf_hu);
CLim_max = double(pet_gui.sup_hu)*(t-.5)+double(pet_gui.sup_hu);

if CLim_min>CLim_max
    CLim_min = CLim_max-10;
end
set(pet_gui.PANELax.ax, 'CLim', [CLim_min CLim_max]);

set(pet_gui.PANELax.colorbar,'xtick',[round(CLim_min)+1,floor(CLim_max)]);
set(pet_gui.PANELax.colorbar,'xticklabel',{num2str(round(CLim_min)),num2str(floor(CLim_max))});
end
