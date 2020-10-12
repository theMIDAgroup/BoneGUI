%% [XMIN,XMAX,YMIN,YMAX]=Region_Mod4(XMIN,XMAX,YMIN,YMAX)
%% mida group http://mida.dima.unige.it - 2010/2015
%%%% check if the extreme of the roi are inside the limit of the figure [1,
%%%% 512] and if they are ok for the possible PT coregistration

%%%% called by: Draw_Roi(RoiKind,RoiPosition,aux_position)


function[XMIN,XMAX,YMIN,YMAX]=Region_Mod4(XMIN,XMAX,YMIN,YMAX)

mod4X=mod(XMAX-XMIN+1,4);
if mod4X>0
    if XMAX<=512-(4-mod4X)
        XMAX=XMAX+(4-mod4X);
    else
        XMAX=512;
        XMIN=XMIN-(XMAX+(4-mod4X)-512);
    end
end

mod4Y=mod(YMAX-YMIN+1,4);
if mod4Y>0
    if YMAX<=512-(4-mod4Y)
        YMAX=YMAX+(4-mod4Y);
    else
        YMAX=512;
        YMIN=YMIN-(YMAX+(4-mod4Y)-512);
    end
end
end
