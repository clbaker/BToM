function varargout = expt_bel_des_inf1(varargin)
% EXPT_BEL_DES_INF1 M-file for expt_bel_des_inf1.fig
%      EXPT_BEL_DES_INF1, by itself, creates a new EXPT_BEL_DES_INF1 or raises the existing
%      singleton*.
%
%      H = EXPT_BEL_DES_INF1 returns the handle to a new EXPT_BEL_DES_INF1 or the handle to
%      the existing singleton*.
%
%      EXPT_BEL_DES_INF1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPT_BEL_DES_INF1.M with the given input arguments.
%
%      EXPT_BEL_DES_INF1('Property','Value',...) creates a new EXPT_BEL_DES_INF1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before expt_bel_des_inf1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to expt_bel_des_inf1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help expt_bel_des_inf1

% Last Modified by GUIDE v2.5 03-Feb-2017 11:26:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @expt_bel_des_inf1_OpeningFcn, ...
                   'gui_OutputFcn',  @expt_bel_des_inf1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before expt_bel_des_inf1 is made visible.
function expt_bel_des_inf1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to expt_bel_des_inf1 (see VARARGIN)

% Update handles structure
guidata(hObject, handles);

pronouns = varargin{1};
truck_names = varargin{2};
truck_name_order = varargin{3};
truck_img_order = varargin{4};

userdata = [];
userdata.truck_name_order = truck_name_order;
userdata.truck_img_order = truck_img_order;

world = varargin{5};
path_sub = varargin{6};
options = varargin{7};

if strcmp(pronouns{1}(end),'s')
  set(handles.text1,'string',sprintf('Select the responses that provide the best explanation for %s'' behavior:',pronouns{1}));
else
  set(handles.text1,'string',sprintf('Select the responses that provide the best explanation for %s''s behavior:',pronouns{1}));
end


set(handles.text2,'string',sprintf('1. How much does %s like each truck?',pronouns{1}));
set(handles.text3,'string',sprintf('%s',truck_names{truck_name_order(1)}));
set(handles.text4,'string',sprintf('%s',truck_names{truck_name_order(2)}));
set(handles.text5,'string',sprintf('%s',truck_names{truck_name_order(3)}));

set(handles.radiobutton1,'value',0);
set(handles.radiobutton2,'value',0);
set(handles.radiobutton3,'value',0);
set(handles.radiobutton4,'value',0);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',0);
set(handles.radiobutton7,'value',0);
set(handles.radiobutton8,'value',0);
set(handles.radiobutton9,'value',0);
set(handles.radiobutton10,'value',0);
set(handles.radiobutton11,'value',0);
set(handles.radiobutton12,'value',0);
set(handles.radiobutton13,'value',0);
set(handles.radiobutton14,'value',0);
set(handles.radiobutton15,'value',0);
set(handles.radiobutton16,'value',0);
set(handles.radiobutton17,'value',0);
set(handles.radiobutton18,'value',0);
set(handles.radiobutton19,'value',0);
set(handles.radiobutton20,'value',0);
set(handles.radiobutton21,'value',0);

set(handles.radiobutton22,'value',0);
set(handles.radiobutton23,'value',0);
set(handles.radiobutton24,'value',0);
set(handles.radiobutton25,'value',0);
set(handles.radiobutton26,'value',0);
set(handles.radiobutton27,'value',0);
set(handles.radiobutton28,'value',0);
set(handles.radiobutton29,'value',0);
set(handles.radiobutton30,'value',0);
set(handles.radiobutton31,'value',0);
set(handles.radiobutton32,'value',0);
set(handles.radiobutton33,'value',0);
set(handles.radiobutton34,'value',0);
set(handles.radiobutton35,'value',0);
set(handles.radiobutton36,'value',0);
set(handles.radiobutton37,'value',0);
set(handles.radiobutton38,'value',0);
set(handles.radiobutton39,'value',0);
set(handles.radiobutton40,'value',0);
set(handles.radiobutton41,'value',0);
set(handles.radiobutton42,'value',0);

userdata.pref_sort_ind = [find(truck_name_order==truck_img_order(1)), ...
                          find(truck_name_order==truck_img_order(2)), ...
                          find(truck_name_order==truck_img_order(3))];

[bel_name_order,bel_sort_ind] = sort(userdata.pref_sort_ind(2:3));
userdata.bel_sort_ind = [bel_sort_ind 3];

set(handles.text36,'string',sprintf('2. At the beginning of the video, when %s was in the location shown below, what did %s think was in the spot marked with "?":',pronouns{1},pronouns{2}));
set(handles.text37,'string',sprintf('%s truck',truck_names{truck_name_order(bel_name_order(1))}));
set(handles.text38,'string',sprintf('%s truck',truck_names{truck_name_order(bel_name_order(2))}));
set(handles.text39,'string',sprintf('No truck'));

set(handles.text40,'string',sprintf('Rate how likely %s thought each possibility was:',pronouns{2}));

options.animate = false;
options.click_advance = false;
options.delay = 0;
options.f_num = hObject;
options.clear_frame = false;

world.goal_pose{2} = world.goal_space(:,2);
world.goal_pose{3} = [];
options.goal_type([2 3]) = 1;
options.goal_text{2} = '?';
options.goal_text{3} = '?';
options.goal_color{2} = [1 0 0];
options.goal_color{3} = [1 0 0];
options.goal_sz{2} = 20;
options.goal_sz{3} = 20;
path_anim(world,path_sub{1}(:,1),[],options);

set(handles.pushbutton1,'string','Continue','enable','off');
set(handles.figure1,'userdata',userdata);

% UIWAIT makes expt_bel_des_inf1 wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = expt_bel_des_inf1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[pref_clicks,bel_clicks] = buttons_clicked(handles);

d = get(handles.figure1,'userdata');

varargout{1} = pref_clicks(d.pref_sort_ind,:);
varargout{2} = bel_clicks(d.bel_sort_ind,:);
varargout{3} = pref_clicks;
varargout{4} = bel_clicks;

close(handles.figure1);


function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume(handles.figure1);


function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton2,'value',0);
  set(handles.radiobutton3,'value',0);
  set(handles.radiobutton4,'value',0);
  set(handles.radiobutton5,'value',0);
  set(handles.radiobutton6,'value',0);
  set(handles.radiobutton7,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton1,'value',0);
  set(handles.radiobutton3,'value',0);
  set(handles.radiobutton4,'value',0);
  set(handles.radiobutton5,'value',0);
  set(handles.radiobutton6,'value',0);
  set(handles.radiobutton7,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton1,'value',0);
  set(handles.radiobutton2,'value',0);
  set(handles.radiobutton4,'value',0);
  set(handles.radiobutton5,'value',0);
  set(handles.radiobutton6,'value',0);
  set(handles.radiobutton7,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton1,'value',0);
  set(handles.radiobutton2,'value',0);
  set(handles.radiobutton3,'value',0);
  set(handles.radiobutton5,'value',0);
  set(handles.radiobutton6,'value',0);
  set(handles.radiobutton7,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end



function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton1,'value',0);
  set(handles.radiobutton2,'value',0);
  set(handles.radiobutton3,'value',0);
  set(handles.radiobutton4,'value',0);
  set(handles.radiobutton6,'value',0);
  set(handles.radiobutton7,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton1,'value',0);
  set(handles.radiobutton2,'value',0);
  set(handles.radiobutton3,'value',0);
  set(handles.radiobutton4,'value',0);
  set(handles.radiobutton5,'value',0);
  set(handles.radiobutton7,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton1,'value',0);
  set(handles.radiobutton2,'value',0);
  set(handles.radiobutton3,'value',0);
  set(handles.radiobutton4,'value',0);
  set(handles.radiobutton5,'value',0);
  set(handles.radiobutton6,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton9,'value',0);
  set(handles.radiobutton10,'value',0);
  set(handles.radiobutton11,'value',0);
  set(handles.radiobutton12,'value',0);
  set(handles.radiobutton13,'value',0);
  set(handles.radiobutton14,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton8,'value',0);
  set(handles.radiobutton10,'value',0);
  set(handles.radiobutton11,'value',0);
  set(handles.radiobutton12,'value',0);
  set(handles.radiobutton13,'value',0);
  set(handles.radiobutton14,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton10_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton8,'value',0);
  set(handles.radiobutton9,'value',0);
  set(handles.radiobutton11,'value',0);
  set(handles.radiobutton12,'value',0);
  set(handles.radiobutton13,'value',0);
  set(handles.radiobutton14,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton11_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton8,'value',0);
  set(handles.radiobutton9,'value',0);
  set(handles.radiobutton10,'value',0);
  set(handles.radiobutton12,'value',0);
  set(handles.radiobutton13,'value',0);
  set(handles.radiobutton14,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton12_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton8,'value',0);
  set(handles.radiobutton9,'value',0);
  set(handles.radiobutton10,'value',0);
  set(handles.radiobutton11,'value',0);
  set(handles.radiobutton13,'value',0);
  set(handles.radiobutton14,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton13_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton8,'value',0);
  set(handles.radiobutton9,'value',0);
  set(handles.radiobutton10,'value',0);
  set(handles.radiobutton11,'value',0);
  set(handles.radiobutton12,'value',0);
  set(handles.radiobutton14,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton14_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton8,'value',0);
  set(handles.radiobutton9,'value',0);
  set(handles.radiobutton10,'value',0);
  set(handles.radiobutton11,'value',0);
  set(handles.radiobutton12,'value',0);
  set(handles.radiobutton13,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton15_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton16,'value',0);
  set(handles.radiobutton17,'value',0);
  set(handles.radiobutton18,'value',0);
  set(handles.radiobutton19,'value',0);
  set(handles.radiobutton20,'value',0);
  set(handles.radiobutton21,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton16_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton15,'value',0);
  set(handles.radiobutton17,'value',0);
  set(handles.radiobutton18,'value',0);
  set(handles.radiobutton19,'value',0);
  set(handles.radiobutton20,'value',0);
  set(handles.radiobutton21,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton17_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton15,'value',0);
  set(handles.radiobutton16,'value',0);
  set(handles.radiobutton18,'value',0);
  set(handles.radiobutton19,'value',0);
  set(handles.radiobutton20,'value',0);
  set(handles.radiobutton21,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end



function radiobutton18_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton15,'value',0);
  set(handles.radiobutton16,'value',0);
  set(handles.radiobutton17,'value',0);
  set(handles.radiobutton19,'value',0);
  set(handles.radiobutton20,'value',0);
  set(handles.radiobutton21,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton19_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton15,'value',0);
  set(handles.radiobutton16,'value',0);
  set(handles.radiobutton17,'value',0);
  set(handles.radiobutton18,'value',0);
  set(handles.radiobutton20,'value',0);
  set(handles.radiobutton21,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton20_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton15,'value',0);
  set(handles.radiobutton16,'value',0);
  set(handles.radiobutton17,'value',0);
  set(handles.radiobutton18,'value',0);
  set(handles.radiobutton19,'value',0);
  set(handles.radiobutton21,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton21_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton15,'value',0);
  set(handles.radiobutton16,'value',0);
  set(handles.radiobutton17,'value',0);
  set(handles.radiobutton18,'value',0);
  set(handles.radiobutton19,'value',0);
  set(handles.radiobutton20,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton22_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton23,'value',0);
  set(handles.radiobutton24,'value',0);
  set(handles.radiobutton25,'value',0);
  set(handles.radiobutton26,'value',0);
  set(handles.radiobutton27,'value',0);
  set(handles.radiobutton28,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton23_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton22,'value',0);
  set(handles.radiobutton24,'value',0);
  set(handles.radiobutton25,'value',0);
  set(handles.radiobutton26,'value',0);
  set(handles.radiobutton27,'value',0);
  set(handles.radiobutton28,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton24_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton22,'value',0);
  set(handles.radiobutton23,'value',0);
  set(handles.radiobutton25,'value',0);
  set(handles.radiobutton26,'value',0);
  set(handles.radiobutton27,'value',0);
  set(handles.radiobutton28,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton25_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton22,'value',0);
  set(handles.radiobutton23,'value',0);
  set(handles.radiobutton24,'value',0);
  set(handles.radiobutton26,'value',0);
  set(handles.radiobutton27,'value',0);
  set(handles.radiobutton28,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton26_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton22,'value',0);
  set(handles.radiobutton23,'value',0);
  set(handles.radiobutton24,'value',0);
  set(handles.radiobutton25,'value',0);
  set(handles.radiobutton27,'value',0);
  set(handles.radiobutton28,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton27_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton22,'value',0);
  set(handles.radiobutton23,'value',0);
  set(handles.radiobutton24,'value',0);
  set(handles.radiobutton25,'value',0);
  set(handles.radiobutton26,'value',0);
  set(handles.radiobutton28,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton28_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton22,'value',0);
  set(handles.radiobutton23,'value',0);
  set(handles.radiobutton24,'value',0);
  set(handles.radiobutton25,'value',0);
  set(handles.radiobutton26,'value',0);
  set(handles.radiobutton27,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton29_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton30,'value',0);
  set(handles.radiobutton31,'value',0);
  set(handles.radiobutton32,'value',0);
  set(handles.radiobutton33,'value',0);
  set(handles.radiobutton34,'value',0);
  set(handles.radiobutton35,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton30_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton29,'value',0);
  set(handles.radiobutton31,'value',0);
  set(handles.radiobutton32,'value',0);
  set(handles.radiobutton33,'value',0);
  set(handles.radiobutton34,'value',0);
  set(handles.radiobutton35,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton31_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton29,'value',0);
  set(handles.radiobutton30,'value',0);
  set(handles.radiobutton32,'value',0);
  set(handles.radiobutton33,'value',0);
  set(handles.radiobutton34,'value',0);
  set(handles.radiobutton35,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton32_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton29,'value',0);
  set(handles.radiobutton30,'value',0);
  set(handles.radiobutton31,'value',0);
  set(handles.radiobutton33,'value',0);
  set(handles.radiobutton34,'value',0);
  set(handles.radiobutton35,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton33_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton29,'value',0);
  set(handles.radiobutton30,'value',0);
  set(handles.radiobutton31,'value',0);
  set(handles.radiobutton32,'value',0);
  set(handles.radiobutton34,'value',0);
  set(handles.radiobutton35,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton34_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton29,'value',0);
  set(handles.radiobutton30,'value',0);
  set(handles.radiobutton31,'value',0);
  set(handles.radiobutton32,'value',0);
  set(handles.radiobutton33,'value',0);
  set(handles.radiobutton35,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton35_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton29,'value',0);
  set(handles.radiobutton30,'value',0);
  set(handles.radiobutton31,'value',0);
  set(handles.radiobutton32,'value',0);
  set(handles.radiobutton33,'value',0);
  set(handles.radiobutton34,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton36_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton37,'value',0);
  set(handles.radiobutton38,'value',0);
  set(handles.radiobutton39,'value',0);
  set(handles.radiobutton40,'value',0);
  set(handles.radiobutton41,'value',0);
  set(handles.radiobutton42,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton37_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton36,'value',0);
  set(handles.radiobutton38,'value',0);
  set(handles.radiobutton39,'value',0);
  set(handles.radiobutton40,'value',0);
  set(handles.radiobutton41,'value',0);
  set(handles.radiobutton42,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton38_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton36,'value',0);
  set(handles.radiobutton37,'value',0);
  set(handles.radiobutton39,'value',0);
  set(handles.radiobutton40,'value',0);
  set(handles.radiobutton41,'value',0);
  set(handles.radiobutton42,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton39_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton36,'value',0);
  set(handles.radiobutton37,'value',0);
  set(handles.radiobutton38,'value',0);
  set(handles.radiobutton40,'value',0);
  set(handles.radiobutton41,'value',0);
  set(handles.radiobutton42,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton40_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton36,'value',0);
  set(handles.radiobutton37,'value',0);
  set(handles.radiobutton38,'value',0);
  set(handles.radiobutton39,'value',0);
  set(handles.radiobutton41,'value',0);
  set(handles.radiobutton42,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton41_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton36,'value',0);
  set(handles.radiobutton37,'value',0);
  set(handles.radiobutton38,'value',0);
  set(handles.radiobutton39,'value',0);
  set(handles.radiobutton40,'value',0);
  set(handles.radiobutton42,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end


function radiobutton42_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
  set(handles.radiobutton36,'value',0);
  set(handles.radiobutton37,'value',0);
  set(handles.radiobutton38,'value',0);
  set(handles.radiobutton39,'value',0);
  set(handles.radiobutton40,'value',0);
  set(handles.radiobutton41,'value',0);
end

if completed(handles)
  set(handles.pushbutton1,'enable','on');
else
  set(handles.pushbutton1,'enable','off');
end



function [r1,r2] = buttons_clicked(handles)
r1 = [get(handles.radiobutton1,'value') get(handles.radiobutton2,'value') get(handles.radiobutton3,'value') ...
  get(handles.radiobutton4,'value') get(handles.radiobutton5,'value') get(handles.radiobutton6,'value') ...
  get(handles.radiobutton7,'value');
  get(handles.radiobutton8,'value') get(handles.radiobutton9,'value') get(handles.radiobutton10,'value') ...
  get(handles.radiobutton11,'value') get(handles.radiobutton12,'value') get(handles.radiobutton13,'value') ...
  get(handles.radiobutton14,'value'); ...
  get(handles.radiobutton15,'value') get(handles.radiobutton16,'value') get(handles.radiobutton17,'value') ...
  get(handles.radiobutton18,'value') get(handles.radiobutton19,'value') get(handles.radiobutton20,'value') ...
  get(handles.radiobutton21,'value')];

r2 = [get(handles.radiobutton22,'value') get(handles.radiobutton23,'value') get(handles.radiobutton24,'value') ...
  get(handles.radiobutton25,'value') get(handles.radiobutton26,'value') get(handles.radiobutton27,'value') ...
  get(handles.radiobutton28,'value'); ...
  get(handles.radiobutton29,'value') get(handles.radiobutton30,'value') get(handles.radiobutton31,'value') ...
  get(handles.radiobutton32,'value') get(handles.radiobutton33,'value') get(handles.radiobutton34,'value') ...
  get(handles.radiobutton35,'value'); ...
  get(handles.radiobutton36,'value') get(handles.radiobutton37,'value') get(handles.radiobutton38,'value') ...
  get(handles.radiobutton39,'value') get(handles.radiobutton40,'value') get(handles.radiobutton41,'value') ...
  get(handles.radiobutton42,'value')];


function [is_complete] = completed(handles)
[r1,r2] = buttons_clicked(handles);
is_complete = all(sum(r1,2)==1) && all(sum(r2,2)==1);
