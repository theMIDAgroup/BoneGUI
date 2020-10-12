function main_batch(action,varargin)

if nargin<1,
    
    action='batch';
    
end
feval(action,varargin{:});
end
%% ************************************************************************
%% ************************************************************************
function batch()
global batch_gui
global pet_gui
screen_x=.8;
screen_y=.8;
scrsz = get(0,'ScreenSize');

position(1,3)=round(scrsz(1,3)*screen_x); %-x
position(1,4)=round(scrsz(1,4)*screen_y); %-y
position(1,1)=round((scrsz(1,3)*.99-position(1,3)));
position(1,2)=round((scrsz(1,4)-position(1,4))/2);
position(1,3)=670;
position(1,4)=750;

if ispc
    pet_gui.slash_pc_mac = '\';
else
    pet_gui.slash_pc_mac = '/';
end
pet_gui.SelectedCT = 1;

batch_gui.numFile = 7;

batch_gui.fig=figure('HandleVisibility','Callback','Menubar','none',...
    'Name','Batch', 'NumberTitle','off', ...
    'Visible','on', 'BackingStore','off','position',position);

for t=1:batch_gui.numFile
    batch_gui.panel(t)=uipanel('parent',batch_gui.fig,'Title',strcat(['subject ',num2str(t)]),'units','pixel',...
        'Position',[10 650-(t-1)*100 645 90],'FontWeight','bold');   %[10 470 545 60]
    batch_gui.cmd_load_dicom(t) = uicontrol(batch_gui.panel(t),'style', 'pushbutton',...
        'units', 'pixel',...
        'string', strcat(['load dicom ',num2str(t)]),...
        'enable','on',...
        'position', [5 55 100 25],...
        'visible','on');
    
    batch_gui.cmd_load_mat(t) = uicontrol(batch_gui.panel(t),'style', 'pushbutton',...
        'units', 'pixel',...
        'string', strcat(['load mat ',num2str(t)]),...
        'enable','on',...
        'position', [5 30 100 25],...
        'visible','on');
    batch_gui.cmd_load_txt(t) = uicontrol(batch_gui.panel(t),'style', 'pushbutton',...
        'units', 'pixel',...
        'string', strcat(['load txt ',num2str(t)]),...
        'enable','on',...
        'position', [5 5 100 25],...
        'visible','on');
    if t == 1
        set(batch_gui.cmd_load_dicom(t),'callback', 'load_dicom(1)');
        set(batch_gui.cmd_load_mat(t),'callback', 'load_mat(1)');
        set(batch_gui.cmd_load_txt(t),'callback', 'load_txt(1)');
    elseif t == 2
        set(batch_gui.cmd_load_dicom(t),'callback', 'load_dicom(2)');
        set(batch_gui.cmd_load_mat(t),'callback', 'load_mat(2)');
        set(batch_gui.cmd_load_txt(t),'callback', 'load_txt(2)');
    elseif t == 3
        set(batch_gui.cmd_load_dicom(t),'callback', 'load_dicom(3)');
        set(batch_gui.cmd_load_mat(t),'callback', 'load_mat(3)');
        set(batch_gui.cmd_load_txt(t),'callback', 'load_txt(3)');
    elseif t == 4
        set(batch_gui.cmd_load_dicom(t),'callback', 'load_dicom(4)');
        set(batch_gui.cmd_load_mat(t),'callback', 'load_mat(4)');
        set(batch_gui.cmd_load_txt(t),'callback', 'load_txt(4)');
    elseif t == 5
        set(batch_gui.cmd_load_dicom(t),'callback', 'load_dicom(5)');
        set(batch_gui.cmd_load_mat(t),'callback', 'load_mat(5)');
        set(batch_gui.cmd_load_txt(t),'callback', 'load_txt(5)');
    elseif t == 6
        set(batch_gui.cmd_load_dicom(t),'callback', 'load_dicom(6)');
        set(batch_gui.cmd_load_mat(t),'callback', 'load_mat(6)');
        set(batch_gui.cmd_load_txt(t),'callback', 'load_txt(6)');
    elseif t == 7
        set(batch_gui.cmd_load_dicom(t),'callback', 'load_dicom(7)');
        set(batch_gui.cmd_load_mat(t),'callback', 'load_mat(7)');
        set(batch_gui.cmd_load_txt(t),'callback', 'load_txt(7)');
    end
    
    batch_gui.text_load_dicom(t)  = uicontrol(batch_gui.panel(t),'style', 'text',...
        'units', 'pixel',...
        'string', '',...
        'enable','off',...
        'position', [120 55 450 25],...
        'visible','on');
    batch_gui.flag_save_dicom(t)  = uicontrol(batch_gui.panel(t),'style', 'checkbox',...
        'units', 'pixel',...
        'enable','on',...
        'position', [600 55 20 20],...
        'visible','on');
    batch_gui.text_load_mat(t)  = uicontrol(batch_gui.panel(t),'style', 'text',...
        'units', 'pixel',...
        'string', '',...
        'enable','off',...
        'position', [120 30 480 25],...
        'visible','on');
    batch_gui.text_load_txt(t)  = uicontrol(batch_gui.panel(t),'style', 'text',...
        'units', 'pixel',...
        'string', '',...
        'enable','off',...
        'position', [120 5 480 25],...
        'visible','on');
end

batch_gui.run = uicontrol(batch_gui.fig,'style', 'pushbutton',...
    'units', 'pixel',...
    'string', 'run',...
    'position',[600 10 60 30],...
    'callback', 'main_batch(''run'');');%
batch_gui.exit = uicontrol(batch_gui.fig,'style', 'pushbutton',...
    'units', 'pixel',...
    'string', 'exit',...
    'position',[10 10 60 30],...
    'callback', 'close;');%


end



function []=run()
global batch_gui
global pet_gui
for t=1:batch_gui.numFile;
    aux_dicom = get(batch_gui.text_load_dicom(t),'string');
    aux_mat = get(batch_gui.text_load_mat(t),'string');
    aux_txt = get(batch_gui.text_load_txt(t),'string');
    if strcmp(aux_mat,'') && strcmp(aux_dicom,'')
    elseif (strcmp(aux_mat,'') && strcmp(aux_dicom,'')~=0 ) ||...
            (strcmp(aux_mat,'')~=0 && strcmp(aux_dicom,'') )
        msgbox('Something went wrong','Error!','error');
        return
    else
        clear Info
        clear ROI
        %clear pet_gui
        file_mat = dir(aux_mat);
        cd(aux_mat)
        for it_mat = 1:size(file_mat,1)
            if strcmp(file_mat(it_mat).name(min(abs([end-3,end])):end),'.mat')
                load(file_mat(it_mat).name)
            end
            
        end
        
        
        Info.InputPath = aux_dicom;
        Info.OutputPathDICOM = [aux_dicom,'_DICOM'];
        Info.InputPathMAT = aux_mat;
        Info.OutputPathTXT = aux_txt;
        if isfield(Info, {'FilePT'})
            pet_gui.SelectedPT = 1;
        else
            pet_gui.SelectedPT = [];
        end
        if isfield(Info, {'FileNM'})
            pet_gui.SelectedNM = 1;
        else
            pet_gui.SelectedNM = [];
        end
        
        
        
        Segmentation_Analysis;
        %%
        if isfield(Info, {'FilePT'})
            SUV_Analysis;
        end
        %%
        if isfield(Info, {'FileNM'})
            NM_Analysis;
        end
        %%
        disp('Hounsfield Analysis')
        Hounsfield_Analysis;
        %%
        disp('Write txt')
        Write_Txt;
        %%
        %disp('Write dicom')
        %Write_Dicom;
        %%
        %disp('Peeling')
        %Peeling;
        
        if get(batch_gui.flag_save_dicom(t),'Value') == get(batch_gui.flag_save_dicom(t),'Max')
           disp('Write Dicom')
           Write_Dicom;
        end
        msgbox('Analysis Completed!');
    end
end
end