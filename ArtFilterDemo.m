function ArtFilterDemo()

addpath('func\')

%% 建立主界面
Fig = figure('Position',[200,150,1500,700],'menu','none',...
    'Color','white','NumberTitle','off','Name','ArtFilter');

%% 建立菜单栏
% 主菜单
MFile = uimenu(Fig,'Text','文件');
MFilter = uimenu(Fig,'Text','滤镜');

% 子菜单
uimenu(MFile,'Text','打开图片','MenuSelectedFcn',@openfile);
uimenu(MFile,'Text','保存图片','MenuSelectedFcn',@savefile);

types = {'油画','卡通','磨砂玻璃','铅笔','彩色铅笔'...
    '色彩段','超像素','十字绣','非真实渲染','吸血鬼'};
uimenu(MFilter,'Text',types{1},'MenuSelectedFcn',@type1);
uimenu(MFilter,'Text',types{2},'MenuSelectedFcn',@type2);
uimenu(MFilter,'Text',types{3},'MenuSelectedFcn',@type3);
uimenu(MFilter,'Text',types{4},'MenuSelectedFcn',@type4);
uimenu(MFilter,'Text',types{5},'MenuSelectedFcn',@type5);
uimenu(MFilter,'Text',types{6},'MenuSelectedFcn',@type6);
uimenu(MFilter,'Text',types{7},'MenuSelectedFcn',@type7);
uimenu(MFilter,'Text',types{8},'MenuSelectedFcn',@type8);
uimenu(MFilter,'Text',types{9},'MenuSelectedFcn',@type9);
uimenu(MFilter,'Text',types{10},'MenuSelectedFcn',@type10);

%% 参数组
Pnl1 = uipanel(Fig,'Tag','P1','Units','normalized','Position',[0,0,0.15,1]);
Ttm = uicontrol(Pnl1,'style','text','string','请选择图片','Unit','normalized',...
    'fontsize',24,'Position',[0,9/10,1,0.1]);
for n = 1:4
    Tt{n} = uicontrol(Pnl1,'style','text','string','','Unit','normalized',...
        'fontsize',16,'Position',[0,(9.5-n)/10,1,0.05],'visible','off');
    Lb{n} = uicontrol(Pnl1,'style','slider','Unit','normalized',...
        'Position',[0,(9-n)/10,1,0.05],...
        'Min',-1,'Max',1,'value',0,'Callback',@updata,'visible','off');
end

%% 图像组
Pnl2 = uipanel(Fig,'Tag','P1','Units','normalized','Position',[0.15,0,0.85,1]);
Axes1 = axes(Pnl2,'Units','normalized','Position',[0,0,0.5,1]);
Axes2 = axes(Pnl2,'Units','normalized','Position',[0.5,0,0.5,1]);


%% 参数

pathname = '';
filename = '';
srcimg = [];
desimg = [];

typeid = 1;

% 定义参数
paramList = getParamList();

%% 功能

    function openfile(~,~)
        [filename,pathname] = uigetfile({'*.jpg';'*.png';'*.jpeg'},'选择一张图片');
        srcimg = imread(fullfile(pathname,filename));
        srcimg = im2double(srcimg);
        imshow(srcimg,'Parent',Axes1)
    end

    function savefile(~,~)
        if ~isempty(desimg)
            [a,~] = split(filename,'.');
            imwrite(desimg,fullfile(pathname,[a{1},'_',types{typeid},'.',a{end}]))
        end
    end

% 切换滤镜
    function RefreshGUI(~,~)

        for i = 1:4
            set(Tt{i},'visible','off');
            set(Lb{i},'visible','off');
        end

        set(Ttm,'string',types{typeid})
        num = paramList{typeid}.pnum;
        param = paramList{typeid}.param;
        for i = 1:num
            set(Tt{i},'String',param{i}.name);
            set(Lb{i},'value',param{i}.value);
            set(Lb{i},'Min',param{i}.min);
            set(Lb{i},'Max',param{i}.max);
            set(Tt{i},'visible','on');
            set(Lb{i},'visible','on');
        end
        updata();
    end

% 滤镜
    function updata(~,~)
        tic
        switch typeid
            case 1
                rad = round(get(Lb{1},'value'));
                desimg = oilpaint(srcimg,rad);
            case 2
                quant_levels = round(get(Lb{1},'value'));
                desimg = cartoon(srcimg,quant_levels);
            case 3
                rad = round(get(Lb{1},'value'));
                desimg = glass(srcimg,rad);
            case 4
                p = get(Lb{1},'value');
                thresh = get(Lb{2},'value');
                w = 3;
                desimg = PencilSketch(srcimg,p,thresh,w);
            case 5
                p = get(Lb{1},'value');
                thresh = get(Lb{2},'value');
                w = 3;
                desimg = ColorPencilSketch(srcimg,p,thresh,w);
            case 6
                colors = round(get(Lb{1},'value'));
                desimg = color_segmentation(srcimg,colors);
            case 7
                block = round(get(Lb{1},'value'));
                desimg = superfilter(srcimg,block);
            case 8
                rad = round(get(Lb{1},'value'));
                w = get(Lb{2},'value');
                desimg = pointillism(srcimg,rad,w);
            case 9
                desimg = npr(srcimg);
            case 10
                w = get(Lb{2},'value');
                desimg = vampirize(srcimg,w);
        end
        toc
        imshow(desimg,'Parent',Axes2)
    end









    function type1(~,~)
        typeid = 1;
        RefreshGUI();
    end

    function type2(~,~)
        typeid = 2;
        RefreshGUI();
    end
    function type3(~,~)
        typeid = 3;
        RefreshGUI();
    end
    function type4(~,~)
        typeid = 4;
        RefreshGUI();
    end
    function type5(~,~)
        typeid = 5;
        RefreshGUI();
    end
    function type6(~,~)
        typeid = 6;
        RefreshGUI();
    end
    function type7(~,~)
        typeid = 7;
        RefreshGUI();
    end
    function type8(~,~)
        typeid = 8;
        RefreshGUI();
    end
    function type9(~,~)
        typeid = 9;
        RefreshGUI();
    end
    function type10(~,~)
        typeid = 10;
        RefreshGUI();
    end



end

% 定义参数
function paramList = getParamList()

% 油画
p.pnum = 1;
p.param{1} = struct('name','radius','value',3,'min',1,'max',7,'type',1);
paramList{1} = p;
% 卡通
p.pnum = 1;
p.param{1} = struct('name','quantization levels','value',8,'min',4,'max',32,'type',1);
paramList{2} = p;
% 玻璃
p.pnum = 1;
p.param{1} = struct('name','radius','value',3,'min',1,'max',8,'type',1);
paramList{3} = p;
% 铅笔
p.pnum = 2;
p.param{1} = struct('name','p','value',20,'min',10,'max',30,'type',0);
p.param{2} = struct('name','thresh','value',0.3,'min',0.1,'max',0.9,'type',0);
paramList{4} = p;
% 彩色铅笔
p.pnum = 2;
p.param{1} = struct('name','p','value',20,'min',10,'max',30,'type',0);
p.param{2} = struct('name','thresh','value',0.3,'min',0.1,'max',0.9,'type',0);
paramList{5} = p;
% 色彩段
p.pnum = 1;
p.param{1} = struct('name','colors','value',16,'min',8,'max',32,'type',1);
paramList{6} = p;
% 超像素
p.pnum = 1;
p.param{1} = struct('name','block','value',200,'min',64,'max',512,'type',1);
paramList{7} = p;
% 十字绣
p.pnum = 1;
p.param{1} = struct('name','radius','value',3,'min',2,'max',6,'type',1);
p.param{2} = struct('name','thresh','value',0.3,'min',0.1,'max',0.9,'type',0);
paramList{8} = p;

% 非真实渲染
p.pnum = 0;
p.param{1} = [];
paramList{9} = p;
% 吸血鬼
p.pnum = 1;
p.param{1} = struct('name','block','value',0.9,'min',0.5,'max',1,'type',0);
paramList{10} = p;

end













