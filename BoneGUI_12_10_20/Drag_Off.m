%% Drag_Off()
%% mida group http://mida.dima.unige.it - 2010/2015
%%%% Mouse-motion callback function

%%%% called by: Show_Image()


function Drag_Off()
global pet_gui;
set(pet_gui.fig,'WindowButtonMotionFcn','');
end

