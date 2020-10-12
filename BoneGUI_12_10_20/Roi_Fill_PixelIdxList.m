%% Roi_Fill_PixelIdxList(RoiKind,RoiPosition,xgrid,ygrid)
%% mida group http://mida.dima.unige.it - 2010/2015
%%%% this function fills the interior part of the roi, representing the
%%%% spinal canal that needs to be removed in the vertebrae

%%%% called by: Roi_PixelIdxList()


function[PixelIdxList] = Roi_Fill_PixelIdxList(RoiKind,RoiPosition,xgrid,ygrid)

switch RoiKind
    case 'imrect'
        xm = RoiPosition(1);
        xM = RoiPosition(1)+RoiPosition(3);
        ym = RoiPosition(2);
        yM = RoiPosition(2)+RoiPosition(4);
        roifill = (xgrid>= xm).*(xgrid<= xM).*(ygrid>= ym).*(ygrid<= yM);
    case 'imellipse'
        a = RoiPosition(3)/2;
        b = RoiPosition(4)/2;
        x0 = RoiPosition(1)+a;
        y0 = RoiPosition(2)+b;        
        roifill = (((xgrid-x0)./a).^2+((ygrid-y0)./b).^2)<= 1;
    case 'impoly'
        roifill = inpolygon(xgrid,ygrid,RoiPosition(:,1),RoiPosition(:,2));
end
PixelIdxList = find(roifill);
end