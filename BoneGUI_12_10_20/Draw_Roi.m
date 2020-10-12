%% Draw_Roi(RoiKind,RoiPosition,index,color,RoiRemoveKind,RoiRemovePosition,colorRemove)
%% mida group http://mida.dima.unige.it - 2010/2015
%%%% this function draws rectangular roi
%%%% and stores RoiRegion in the struct ROI thorugh the functions
%%%% Store_roiRemove(q,varargin) and Store_roi(q,varargin)

%%%% called by: Slider_Image()
%%%%            PopUp_Districts()
%%%% call: Store_roi(p,varargin) (included in this file, from row 50)
%%%%       Store_roiRemove(p,varargin) (included in this file, from row 46)


function Draw_Roi(RoiKind,RoiPosition,index,color,RoiRemoveKind,RoiRemovePosition,colorRemove)
global pet_gui;
global ROI;

if nargin<4, color='green'; end
h = feval(RoiKind,pet_gui.PANELax.ax,RoiPosition);
setColor(h,color);
fcn = makeConstrainToRectFcn(RoiKind,[0.5 512.5],[0.5 512.5]);
setPositionConstraintFcn(h,fcn);
api = iptgetapi(h);

it = pet_gui.PopupValue;
ROI{it}.RoiSlice(index) = pet_gui.SliceNumber;
ROI{it}.RoiKind{index} = RoiKind;

Store_roi(RoiPosition);

if nargin>=6
    if nargin==6, colorRemove='red'; end
    hRemove = feval(RoiRemoveKind,pet_gui.PANELax.ax,RoiRemovePosition);
    setColor(hRemove,colorRemove);
    fcnRemove = makeConstrainToRectFcn(RoiRemoveKind,[0.5 512.5],[0.5 512.5]);
    setPositionConstraintFcn(hRemove,fcnRemove);
    apiRemove = iptgetapi(hRemove);
    ROI{it}.RoiRemoveKind{index}=RoiRemoveKind;
    ROI{it}.RoiRemovePosition{index}=RoiRemovePosition;
    
    apiRemove.addNewPositionCallback(@(q) Store_roiRemove(q));
end

api.addNewPositionCallback(@(p) Store_roi(p));

    function Store_roiRemove(q,varargin)
        ROI{it}.RoiRemovePosition{index}=q;
    end

    function Store_roi(p,varargin)
        
        ROI{it}.RoiPosition{index}=p;
        if ~strcmp(RoiKind,'impoly')
            aux1=max([ceil(p(1))-10,1]);
            aux3=max([ceil(p(2))-10,1]);
            aux2=min([floor(p(1)+p(3))+10,512]);
            aux4=min([floor(p(2)+p(4))+10,512]);
        else
            aux1=max([ceil(min(p(:,1)))-10,1]);
            aux3=max([ceil(min(p(:,2)))-10,1]);
            aux2=min([floor(max(p(:,1)))+10,512]);
            aux4=min([floor(max(p(:,2)))+10,512]);
        end
        [aux1,aux2,aux3,aux4]=Region_Mod4(aux1,aux2,aux3,aux4);
        ROI{it}.RoiRegion(index,:)=[aux1,aux2,aux3,aux4];
    end
end
