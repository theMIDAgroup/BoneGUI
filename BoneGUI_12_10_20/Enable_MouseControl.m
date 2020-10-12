%% Enable_MouseControl()
%% mida group http://mida.dima.unige.it - 2010/2015
%%%% her some commands to zooming with scrollwheel and panning with 
%%%% mouseclicks are defined

%%%% called by: Show_Image()


function Enable_MouseControl()

global pet_gui;
global Info;

MainFig = pet_gui.fig;
axs = pet_gui.PANELax.ax;
status = '';  previous_point = [];

%%%% define zooming with scrollwheel, and panning with mouseclicks
set(MainFig, ...
    'WindowScrollWheelFcn' , @scroll_slice,...
    'WindowButtonDownFcn'  , @pan_click,...
    'WindowButtonUpFcn'    , @pan_release,...
    'WindowButtonMotionFcn', @pan_motion);

%%%% zoom in to the current point with the mouse wheel
    function scroll_zoom(varargin)
        scrolls = varargin{2}.VerticalScrollCount;
        % get the axes' x- and y-limits
        xlim = get(axs, 'xlim');  ylim = get(axs, 'ylim');
        
        xlim_new = [xlim(1)+scrolls*5 , xlim(2)-scrolls*5];
        ylim_new = [ylim(1)+scrolls*5 , ylim(2)-scrolls*5];
        if xlim_new(2) - xlim_new(1) <=  1, return, end
        if ylim_new(2) - ylim_new(1) <=  1, return, end
        if xlim_new(2) - xlim_new(1) > 512, return, end
        if ylim_new(2) - ylim_new(1) > 512, return, end
        
        set(axs, 'xlim', xlim_new, 'ylim',ylim_new);
        
    end % scroll_zoom



    function scroll_slice(varargin)
        scrolls = -varargin{2}.VerticalScrollCount;
        SliceNumber = round(get(pet_gui.PANELax.SLIDERimage, 'Value')*(Info.NumberFileCT(pet_gui.SelectedCT)-1)+1);
        
        if scrolls>0
            if SliceNumber + scrolls < Info.NumberFileCT(pet_gui.SelectedCT)
                pet_gui.SliceNumber = SliceNumber+scrolls;
                set(pet_gui.PANELax.SLIDERimage, 'Value',(pet_gui.SliceNumber-1)/(Info.NumberFileCT(pet_gui.SelectedCT)-1));
            else
                pet_gui.SliceNumber = Info.NumberFileCT(pet_gui.SelectedCT);
                set(pet_gui.PANELax.SLIDERimage, 'Value',(pet_gui.SliceNumber-1)/(Info.NumberFileCT(pet_gui.SelectedCT)-1));
            end
            Slider_Image();
        else
            if SliceNumber+scrolls > 1
                pet_gui.SliceNumber = SliceNumber+scrolls;
                set(pet_gui.PANELax.SLIDERimage, 'Value',(pet_gui.SliceNumber-1)/(Info.NumberFileCT(pet_gui.SelectedCT)-1));
            else
                pet_gui.SliceNumber = 1;
                set(pet_gui.PANELax.SLIDERimage, 'Value',(pet_gui.SliceNumber-1)/(Info.NumberFileCT(pet_gui.SelectedCT)-1));
            end
            Slider_Image();
        end
        
        
    end % scroll_slice





% pan upon mouse click
    function pan_click(varargin)
        switch lower(get(MainFig, 'selectiontype'))
            %%%%%%%%%%%% modifica 22/02/2011  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % start panning on right click
            case 'alt'
                status = 'down';
                previous_point = get(axs, 'CurrentPoint');
                
                % start panning on left click
            case 'normal'
                Drag_Off;
                % reset view on double click
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 'open' % double click (left or right)
                set(axs, 'xlim', [0.5 512.5], 'ylim',[0.5 512.5]);
        end
    end

    function pan_release(varargin)
        % just reset status
        status = '';
        %%% modifica 22/02/2011 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %        Callback_DragOn;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end

% move the mouse (with button clicked)
    function pan_motion(varargin)
        
        % return if there isn't a previous point
        if isempty(previous_point), return, end
        % return if mouse hasn't been clicked
        if isempty(status), return, end
        % get current location (in pixels)
        current_point = get(axs, 'CurrentPoint');
        % get current XY-limits
        xlim = get(axs, 'xlim');  ylim = get(axs, 'ylim');
        % find change in position
        delta_points = current_point - previous_point;
        % adjust limits
        xlim_new = xlim - delta_points(1);
        ylim_new = ylim - delta_points(3);
        % set new limits
        if (xlim_new(2)>512 ||  xlim_new(1) <=  0), return, end
        if (ylim_new(2)>512 ||  ylim_new(1) <=  0), return, end
        set(axs, 'xlim', xlim_new, 'ylim',ylim_new);
        % save new position
        previous_point = get(axs, 'CurrentPoint');
    end
end
%%
