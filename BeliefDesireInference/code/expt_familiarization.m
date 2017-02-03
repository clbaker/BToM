function varargout = expt_familiarization(varargin)
% EXPT_FAMILIARIZATION M-file for expt_familiarization.fig
%      EXPT_FAMILIARIZATION, by itself, creates a new EXPT_FAMILIARIZATION or raises the existing
%      singleton*.
%
%      H = EXPT_FAMILIARIZATION returns the handle to a new EXPT_FAMILIARIZATION or the handle to
%      the existing singleton*.
%
%      EXPT_FAMILIARIZATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPT_FAMILIARIZATION.M with the given input arguments.
%
%      EXPT_FAMILIARIZATION('Property','Value',...) creates a new EXPT_FAMILIARIZATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before expt_familiarization_OpeningFcn gets called.
%      An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to expt_familiarization_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help expt_familiarization

% Last Modified by GUIDE v2.5 03-Feb-2017 11:17:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @expt_familiarization_OpeningFcn, ...
                   'gui_OutputFcn',  @expt_familiarization_OutputFcn, ...
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


% --- Executes just before expt_familiarization is made visible.
function expt_familiarization_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to expt_familiarization (see VARARGIN)

% Choose default command line output for expt_familiarization
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

userdata = [];

% current frame of familiarization slides
userdata.frame = 0;

% Proper names of agent in familiarization slides
userdata.name=varargin{1};

% food truck names
userdata.truck=varargin{2};

agent_img = varargin{3};
truck_img = varargin{4};

% open figure handle
userdata.h_fig = varargin{5};

% generate familiarization stimulus and display options
[userdata.scenario,userdata.path,userdata.options] = expt_familiarization_scenario(userdata.truck,agent_img,truck_img,userdata.h_fig);

% stores list of annotations to be cleared with each new slide
userdata.anno = [];

set(handles.figure1,'userdata',userdata);

display_frame(handles);

% UIWAIT makes expt_familiarization wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = expt_familiarization_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
userdata = get(handles.figure1,'userdata');

varargout{1} = userdata.frame;

close(handles.figure1);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

userdata = get(handles.figure1,'userdata');
userdata.frame = max(userdata.frame-1,0);
set(handles.figure1,'userdata',userdata);

display_frame(handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

userdata = get(handles.figure1,'userdata');
userdata.frame = userdata.frame+1;
set(handles.figure1,'userdata',userdata);

display_frame(handles);


function display_frame(handles)

d = get(handles.figure1,'userdata');
% for ni=1:length(d.anno)
%   delete(d.anno(ni));
% end
%d.anno = [];

anno = [];


switch d.frame
  case 0
    % slide 1
    s1 = sprintf('At the Manitoba Institute of Technology (MIT), the food trucks are the most popular places to eat lunch on campus.');
    s2 = sprintf('You are going to watch a series of videos of MIT students walking around campus as they decide where to eat lunch.');

    s3 = sprintf(['The Institute has set aside several parking spaces for the food trucks, ' ...
                  'which all of the different trucks must compete over each day.']);
    s4 = sprintf(['The campus is large, and the students must decide which part of campus to walk to for lunch, '...
                  'in spite of the fact that some trucks might end up parking in different spots on different days, or not show up at all.']);

    set(handles.text2,'string',{[s1,' ',s2],'',[s3,' ',s4]});
    set(handles.pushbutton1,'enable','off');
    
  case 1
    s1 = sprintf('At the Manitoba Institute of Technology (MIT), the food trucks are the most popular places to eat lunch on campus.');
    s2 = sprintf('You are going to watch a series of videos of MIT students walking around campus as they decide where to eat lunch.');

    s3 = sprintf(['The Institute has set aside several parking spaces for the food trucks, ' ...
                  'which all of the different trucks must compete over each day.']);
    s4 = sprintf(['The campus is large, and the students must decide which part of campus to walk to for lunch, '...
                  'in spite of the fact that some trucks might end up parking in different spots on different days, or not show up at all.']);

    s5 = sprintf(['Your task in this experiment will be to watch a series of videos displaying different students'' movements around campus on different days, ' ...
                   'and then answer questions about what each student was thinking and what they like to eat based on their actions.']);
                
    s6 = sprintf('Next, we will show examples of a student''s actions on different days.');
    s7 = sprintf(['The examples will explain all of the details of our videos, ' ...
                  'including how the students and their movements will appear, and how the food trucks, ' ...
                  'the parking spaces, and the buildings on campus will be displayed.']);

    set(handles.text2,'string',{[s1,' ',s2],'',[s3,' ',s4],'',s5,'',[s6 ' ' s7]});
    set(handles.pushbutton1,'enable','off');
    
  case 2
    % slide 2
    s1 = sprintf('%s is working in %s laboratory at MIT when %s feels hungry.', d.name{1}, d.name{3}, d.name{2});
    s2 = sprintf('When %s is really hungry, there''s nothing %s loves more than eating truck-food.', d.name{1}, d.name{2});
    s3 = sprintf('%s decides to walk to the food trucks to eat.', d.name{1});
    
    s4 = sprintf('%s is very hungry and wants to eat soon, but would walk farther for more delicious food.',d.name{1});

    set(handles.text2,'string',{[s1,' ',s2,' ',s3],'',s4});
    set(handles.pushbutton1,'enable','on')

    clf(d.h_fig);

  case 3
    s1 = sprintf('%s is working in %s laboratory at MIT when %s feels hungry.', d.name{1}, d.name{3}, d.name{2});
    s2 = sprintf('When %s is really hungry, there''s nothing %s loves more than eating truck-food.', d.name{1}, d.name{2});
    s3 = sprintf('%s decides to walk to the food trucks to eat.', d.name{1});
    
    s4 = sprintf('%s is very hungry and wants to eat soon, but would walk farther for more delicious food.',d.name{1});
    
    s5 = sprintf('The picture to the right shows %s''s situation.',d.name{1});

    set(handles.text2,'string',{[s1,' ',s2,' ',s3],'',s4,'',s5});

    si=1;
    path_anim(d.scenario{si},ind2subv(d.scenario{si}.graph_sz,d.path(1))',[],d.options);

  case 4
    s1 = sprintf('%s is working in %s laboratory at MIT when %s feels hungry.', d.name{1}, d.name{3}, d.name{2});
    s2 = sprintf('When %s is really hungry, there''s nothing %s loves more than eating truck-food.', d.name{1}, d.name{2});
    s3 = sprintf('%s decides to walk to the food trucks to eat.', d.name{1});
    
    s4 = sprintf('%s is very hungry and wants to eat soon, but would walk farther for more delicious food.',d.name{1});
    
    s5 = sprintf('The picture to the right shows %s''s situation.',d.name{1});
    
    s6 = sprintf('%s''s location is marked with a small face.',d.name{1});
    
    set(handles.text2,'string',{[s1,' ',s2,' ',s3],'',s4,'',s5,'',s6});
    
    si=1;
    path_anim(d.scenario{si},ind2subv(d.scenario{si}.graph_sz,d.path(1))',[],d.options);

    anno(end+1) = annotation(d.h_fig,'textarrow',[0.3268 0.48],[0.368 0.381],'TextEdgeColor','none','fontsize',14,'String',{d.name{1}});
        
  case 5
    s1 = sprintf('%s is working in %s laboratory at MIT when %s feels hungry.', d.name{1}, d.name{3}, d.name{2});
    s2 = sprintf('When %s is really hungry, there''s nothing %s loves more than eating truck-food.', d.name{1}, d.name{2});
    s3 = sprintf('%s decides to walk to the food trucks to eat.', d.name{1});
    
    s4 = sprintf('%s is very hungry and wants to eat soon, but would walk farther for more delicious food.',d.name{1});
    
    s5 = sprintf('The picture to the right shows %s''s situation.',d.name{1});
    
    s6 = sprintf('%s''s location is marked with a small face.',d.name{1});
    
    s7 = sprintf('Parking spots for food trucks are marked with a yellow background.');
    s8 = sprintf('You should assume that students always know the location of every parking spot on campus (but not necessarily where each truck is parked on each day).');
    
    set(handles.text2,'string',{[s1,' ',s2,' ',s3],'',s4,'',s5,'',s6,'',[s7 ' ' s8]});
    
    si=1;
    path_anim(d.scenario{si},ind2subv(d.scenario{si}.graph_sz,d.path(1))',[],d.options);

    anno(end+1) = annotation(d.h_fig,'textarrow',[0.3732 0.4411],[0.6881 0.7833],'TextEdgeColor','none','fontsize',14,'String',{'Parking spot'});
    anno(end+1) = annotation(d.h_fig,'textarrow',[0.3625 0.4375],[0.3381 0.2452],'TextEdgeColor','none','fontsize',14,'String',{'Parking spot'});
    
  case 6
    % slide 3
    s1 = sprintf('Trucks are labeled with their first letter. There are three trucks that come to the MIT campus:');
    s2 = sprintf('          -%s (%s),',d.truck{1},d.truck{1}(1));
    s3 = sprintf('          -%s (%s), and',d.truck{2},d.truck{2}(1));
    s4 = sprintf('          -%s (%s).',d.truck{3},d.truck{3}(1));
    
    s5 = sprintf('Different trucks can park in different spots on different days.');
    s6 = sprintf('          -On this day, the %s and %s trucks were there,',d.truck{2},d.truck{1});
    s7 = sprintf('           and there were no empty parking spots.');

    set(handles.text2,'string',{s1,s2,s3,s4,'',s5,s6,s7});

    si=1;
    path_anim(d.scenario{si},ind2subv(d.scenario{si}.graph_sz,d.path(1))',[],d.options);

    anno(end+1) = annotation(d.h_fig,'textarrow',[0.4 0.4643],[0.6905 0.7524],'TextEdgeColor','none','fontsize',14,'String',{sprintf('%s truck',d.truck{2})});
    anno(end+1) = annotation(d.h_fig,'textarrow',[0.4 0.4643],[0.3381 0.2619],'TextEdgeColor','none','fontsize',14,'String',{sprintf('%s truck',d.truck{1})});
    
  case 7
    s1 = sprintf('Trucks are labeled with their first letter. There are three trucks that come to the MIT campus:');
    s2 = sprintf('          -%s (%s),',d.truck{1},d.truck{1}(1));
    s3 = sprintf('          -%s (%s), and',d.truck{2},d.truck{2}(1));
    s4 = sprintf('          -%s (%s).',d.truck{3},d.truck{3}(1));
    
    s5 = sprintf('Different trucks can park in different spots on different days.');
    s6 = sprintf('          -On this day, the %s and %s trucks were there,',d.truck{2},d.truck{1});
    s7 = sprintf('           and there were no empty parking spots.');
    s8 = sprintf('          -On another day, only the %s truck was there,',d.truck{3});
    s9 = sprintf('           and there was one empty parking spot.');

    set(handles.text2,'string',{s1,s2,s3,s4,'',s5,s6,s7,s8,s9});

    si=4;
    path_anim(d.scenario{si},ind2subv(d.scenario{si}.graph_sz,d.path(1))',[],d.options);

    anno(end+1) = annotation(d.h_fig,'textarrow',[0.4 0.4643],[0.6905 0.7524],'TextEdgeColor','none','fontsize',14,'String',{sprintf('%s truck',d.truck{3})});

  case 8
    s1 = sprintf('Trucks are labeled with their first letter. There are three trucks that come to the MIT campus:');
    s2 = sprintf('          -%s (%s),',d.truck{1},d.truck{1}(1));
    s3 = sprintf('          -%s (%s), and',d.truck{2},d.truck{2}(1));
    s4 = sprintf('          -%s (%s).',d.truck{3},d.truck{3}(1));
    
    s5 = sprintf('Different trucks can park in different spots on different days.');
    s6 = sprintf('          -On this day, the %s and %s trucks were there,',d.truck{2},d.truck{1});
    s7 = sprintf('           and there were no empty parking spots.');
    s8 = sprintf('          -On another day, only the %s truck was there,',d.truck{3});
    s9 = sprintf('           and there was one empty parking spot.');

    s10 = sprintf('...and so on. Remember: any of the three trucks (%s,%s,%s) can park in any spot.',d.truck{1}(1),d.truck{2}(1),d.truck{3}(1));
 
    set(handles.text2,'string',{s1,s2,s3,s4,'',s5,s6,s7,s8,s9,'',s10});

    si=4;
    path_anim(d.scenario{si},ind2subv(d.scenario{si}.graph_sz,d.path(1))',[],d.options);

  case 9
    % slide 4
    s1 = sprintf('Buildings are marked by solid black rectangles.');
    s2 = sprintf('You should assume that students always know the location of all buildings on campus.');

    set(handles.text2,'string',{[s1 ' ' s2]});

    si=1;
    path_anim(d.scenario{si},ind2subv(d.scenario{si}.graph_sz,d.path(1))',[],d.options);

    anno(end+1) = annotation(d.h_fig,'textarrow',[0.6804 0.6464],[0.3514 0.4357],'TextEdgeColor','none','fontsize',14,'String',{'Building'});
    
  case 10
    s1 = sprintf('Buildings are marked by solid black rectangles.');
    s2 = sprintf('You should assume that students always know the location of all buildings on campus.');
    
    s3 = sprintf('Buildings block %s''s view of the opposite side.',d.name{1});
    s4 = sprintf('From %s current location, %s cannot see which truck is in the parking spot on the other side of the building (or whether any truck is there at all).',d.name{3},d.name{1});

    set(handles.text2,'string',{[s1 ' ' s2],'',[s3,' ',s4]});
    
    % CB: handle the case where subject goes "Back"
    d.options.isovist = false;
    
    si=1;
    path_anim(d.scenario{si},ind2subv(d.scenario{si}.graph_sz,d.path(1))',[],d.options);

    anno(end+1) = annotation(d.h_fig,'textbox',[0.565 0.5524 0.1507 0.3357],'String',{'?'},'FitBoxToText','off', ...
      'fontsize',80,'fontweight','bold','linestyle','none');

  case 11
    s1 = sprintf('Buildings are marked by solid black rectangles.');
    s2 = sprintf('You should assume that students always know the location of all buildings on campus.');
    
    s3 = sprintf('Buildings block %s''s view of the opposite side.',d.name{1});
    s4 = sprintf('From %s current location, %s cannot see which truck is in the parking spot on the other side of the building (or whether any truck is there at all).',d.name{3},d.name{1});
    
    s5 = sprintf('To illustrate what the students can and cannot see, we will shade the non-visible areas of the environment.');
    
    s6 = sprintf('In this situation, the shading indicates that all points below the building are visible to %s,',d.name{1});
    s7 = sprintf('but %s cannot see any points above the building from where %s stands.',d.name{2},d.name{2});
    
    set(handles.text2,'string',{[s1 ' ' s2],'',[s3 ' ' s4],'',[s5 ' ' s6 ' ' s7]});

    d.options.isovist = true;
    
    si=1;
    path_anim(d.scenario{si},ind2subv(d.scenario{si}.graph_sz,d.path(1))',[],d.options);

  case 12
    s1 = sprintf('Buildings are marked by solid black rectangles.');
    s2 = sprintf('You should assume that students always know the location of all buildings on campus.');
    
    s3 = sprintf('Buildings block %s''s view of the opposite side.',d.name{1});
    s4 = sprintf('From %s current location, %s cannot see which truck is in the parking spot on the other side of the building (or whether any truck is there at all).',d.name{3},d.name{1});
    
    s5 = sprintf('To illustrate what the students can and cannot see, we will shade the non-visible areas of the environment.');
    
    s6 = sprintf('In this situation, the shading indicates that all points below the building are visible to %s,',d.name{1});
    s7 = sprintf('but %s cannot see any points above the building from where %s stands.',d.name{2},d.name{2});
    
    s8 = sprintf('For instance, from %s current location, %s cannot see whether the %s truck is there:',d.name{3},d.name{1},d.truck{2});
    
    set(handles.text2,'string',{[s1 ' ' s2],'',[s3 ' ' s4],'',[s5 ' ' s6 ' ' s7],'',s8});
    
    si=1;
    path_anim(d.scenario{si},ind2subv(d.scenario{si}.graph_sz,d.path(1))',[],d.options);

  case 13
    s1 = sprintf('Buildings are marked by solid black rectangles.');
    s2 = sprintf('You should assume that students always know the location of all buildings on campus.');
    
    s3 = sprintf('Buildings block %s''s view of the opposite side.',d.name{1});
    s4 = sprintf('From %s current location, %s cannot see which truck is in the parking spot on the other side of the building (or whether any truck is there at all).',d.name{3},d.name{1});
    
    s5 = sprintf('To illustrate what the students can and cannot see, we will shade the non-visible areas of the environment.');
    
    s6 = sprintf('In this situation, the shading indicates that all points below the building are visible to %s,',d.name{1});
    s7 = sprintf('but %s cannot see any points above the building from where %s stands.',d.name{2},d.name{2});
    
    s8 = sprintf('For instance, from %s current location, %s cannot see whether the %s truck is there:',d.name{3},d.name{1},d.truck{2});
    
    s9 = sprintf('...whether the %s truck is there:',d.truck{3});
    
    set(handles.text2,'string',{[s1 ' ' s2],'',[s3 ' ' s4],'',[s5 ' ' s6 ' ' s7],'',s8,s9});
        
    si=2;
    path_anim(d.scenario{si},ind2subv(d.scenario{si}.graph_sz,d.path(1))',[],d.options);

  case 14
    s1 = sprintf('Buildings are marked by solid black rectangles.');
    s2 = sprintf('You should assume that students always know the location of all buildings on campus.');
    
    s3 = sprintf('Buildings block %s''s view of the opposite side.',d.name{1});
    s4 = sprintf('From %s current location, %s cannot see which truck is in the parking spot on the other side of the building (or whether any truck is there at all).',d.name{3},d.name{1});
    
    s5 = sprintf('To illustrate what the students can and cannot see, we will shade the non-visible areas of the environment.');
    
    s6 = sprintf('In this situation, the shading indicates that all points below the building are visible to %s,',d.name{1});
    s7 = sprintf('but %s cannot see any points above the building from where %s stands.',d.name{2},d.name{2});
    
    s8 = sprintf('For instance, from %s current location, %s cannot see whether the %s truck is there:',d.name{3},d.name{1},d.truck{2});
    
    s9 = sprintf('...whether the %s truck is there:',d.truck{3});
    
    s10 = sprintf('...or whether no truck is there.');
    
    set(handles.text2,'string',{[s1 ' ' s2],'',[s3 ' ' s4],'',[s5 ' ' s6 ' ' s7],'',s8,s9,s10});

    si=3;
    path_anim(d.scenario{si},ind2subv(d.scenario{si}.graph_sz,d.path(1))',[],d.options);

  case 15
    s1 = sprintf('Buildings are marked by solid black rectangles.');
    s2 = sprintf('You should assume that students always know the location of all buildings on campus.');
    
    s3 = sprintf('Buildings block %s''s view of the opposite side.',d.name{1});
    s4 = sprintf('From %s current location, %s cannot see which truck is in the parking spot on the other side of the building (or whether any truck is there at all).',d.name{3},d.name{1});
    
    s5 = sprintf('To illustrate what the students can and cannot see, we will shade the non-visible areas of the environment.');
    
    s6 = sprintf('In this situation, the shading indicates that all points below the building are visible to %s,',d.name{1});
    s7 = sprintf('but %s cannot see any points above the building from where %s stands.',d.name{2},d.name{2});
    
    s8 = sprintf('For instance, from %s current location, %s cannot see whether the %s truck is there:',d.name{3},d.name{1},d.truck{2});
    
    s9 = sprintf('...whether the %s truck is there:',d.truck{3});
    
    s10 = sprintf('...or whether no truck is there.');
    
    s11 = sprintf('%s can also walk to a place where %s can see which truck is in the other parking spot.',d.name{1},d.name{2});
    
    s12 = sprintf('Press "Next" to begin an animation of %s''s path.',d.name{1});

    set(handles.text2,'string',{[s1 ' ' s2],'',[s3 ' ' s4],'',[s5 ' ' s6 ' ' s7],'',s8,s9,s10,'',s11,'',s12});
    
    options_tmp = d.options;
    options_tmp.goal_text{3} = '?';
    options_tmp.goal_type(3) = 1;
    options_tmp.goal_color{3} = [1 0 0];
    options_tmp.goal_sz{3} = 30;

    si=2;
    path_anim(d.scenario{si},ind2subv(d.scenario{si}.graph_sz,d.path(1))',[],options_tmp);
 
  case 16
    s1 = sprintf('Buildings are marked by solid black rectangles.');
    s2 = sprintf('You should assume that students always know the location of all buildings on campus.');
    
    s3 = sprintf('Buildings block %s''s view of the opposite side.',d.name{1});
    s4 = sprintf('From %s current location, %s cannot see which truck is in the parking spot on the other side of the building (or whether any truck is there at all).',d.name{3},d.name{1});
    
    s5 = sprintf('To illustrate what the students can and cannot see, we will shade the non-visible areas of the environment.');
    
    s6 = sprintf('In this situation, the shading indicates that all points below the building are visible to %s,',d.name{1});
    s7 = sprintf('but %s cannot see any points above the building from where %s stands.',d.name{2},d.name{2});
    
    s8 = sprintf('For instance, from %s current location, %s cannot see whether the %s truck is there:',d.name{3},d.name{1},d.truck{2});
    
    s9 = sprintf('...whether the %s truck is there:',d.truck{3});
    
    s10 = sprintf('...or whether no truck is there.');
    
    s11 = sprintf('%s can also walk to a place where %s can see which truck is in the other parking spot.',d.name{1},d.name{2});
    
    s12 = sprintf('Press "Next" to begin an animation of %s''s path.',d.name{1});

    s13 = sprintf('................................. Animation started.');
    
    set(handles.text2,'string',{[s1 ' ' s2],'',[s3 ' ' s4],'',[s5 ' ' s6 ' ' s7],'',s8,s9,s10,'',s11,'',s12,s13});
    
    set(handles.pushbutton1,'enable','off')
    set(handles.pushbutton2,'enable','off')

    options_tmp = d.options;
    options_tmp.goal_text{3} = '?';
    options_tmp.goal_type(3) = 1;
    options_tmp.goal_color{3} = [1 0 0];
    options_tmp.goal_sz{3} = 30;
    options_tmp.animate = true;
    options_tmp.delay = 0;
    options_tmp.click_advance = true;
    
    si=2;
    path_anim(d.scenario{si},ind2subv(d.scenario{si}.graph_sz,d.path)',[],options_tmp);
    
    options_tmp2 = d.options;
    options_tmp2.click_advance = true;
    
    si=1;
    path_anim(d.scenario{si},ind2subv(d.scenario{si}.graph_sz,d.path)',[],options_tmp2);

    anno(end+1) = annotation(d.h_fig,'line',[0.7107 0.7286],[0.6823 0.6738]);
    anno(end+1) = annotation(d.h_fig,'textbox',[0.651 0.6762 0.08829 0.05238],'String',{'Aha!'},'FitBoxToText','off','fontsize',14,'fontweight','bold','linestyle','none');
    
    s14 = sprintf('................................. Animation finished.');
    set(handles.text2,'string',{[s1 ' ' s2],'',[s3 ' ' s4],'',[s5 ' ' s6 ' ' s7],'',s8,s9,s10,'',s11,'',s12,s13,s14});
    
    set(handles.pushbutton1,'enable','on');
    set(handles.pushbutton2,'enable','on');

  case 17
    % slide 6
    s1 = sprintf('Even if %s can''t see a certain parking spot at first, it''s possible that %s could still know (or think %s knows) which truck is there.',d.name{1},d.name{2},d.name{2});
    
    s2 = sprintf(['For instance, %s could have found out that the %s truck is there from a friend, ' ...
      'or %s could have passed within view of the spot earlier in the day and seen the %s truck parked there.'],d.name{2},d.truck{2},d.name{2},d.truck{2});

    set(handles.text2,'string',{s1,'',s2});
    
    si=1;
    path_anim(d.scenario{si},ind2subv(d.scenario{si}.graph_sz,d.path(1))',[],d.options);

    anno(end+1) = annotation(d.h_fig,'textarrow',[0.7304 0.5607],[0.6476 0.7786],'TextEdgeColor','none','fontsize',14,'String',{d.name{1},'thinks...'});

  case 18
    s1 = sprintf('Even if %s can''t see a certain parking spot at first, it''s possible that %s could still know (or think %s knows) which truck is there.',d.name{1},d.name{2},d.name{2});
    
    s2 = sprintf(['For instance, %s could have found out that the %s truck is there from a friend, ' ...
      'or %s could have passed within view of the spot earlier in the day and seen the %s truck parked there.'],d.name{2},d.truck{2},d.name{2},d.truck{2});

    s3 = sprintf(['Or, %s might have a guess -- thinking that a certain truck is or isn''t there based on knowing how often it usually parks there, ' ...
      'or based on seeing someone eating food from a particular truck near a particular parking spot and inferring that it is likely to be parked there.'],d.name{2});

    set(handles.text2,'string',{s1,'',s2,'',s3});

    si=2;
    path_anim(d.scenario{si},ind2subv(d.scenario{si}.graph_sz,d.path(1))',[],d.options);

    anno(end+1) = annotation(d.h_fig,'textarrow',[0.7304 0.5607],[0.6476 0.7786],'TextEdgeColor','none','fontsize',14,'String',{d.name{1},'thinks...'});

 case 19
   s1 = sprintf('Even if %s can''t see a certain parking spot at first, it''s possible that %s could still know (or think %s knows) which truck is there.',d.name{1},d.name{2},d.name{2});
    
   s2 = sprintf(['For instance, %s could have found out that the %s truck is there from a friend, ' ...
     'or %s could have passed within view of the spot earlier in the day and seen the %s truck parked there.'],d.name{2},d.truck{2},d.name{2},d.truck{2});

   s3 = sprintf(['Or, %s might have a guess -- thinking that a certain truck is or isn''t there based on knowing how often it usually parks there, ' ...
     'or based on seeing someone eating food from a particular truck near a particular parking spot and inferring that it is likely to be parked there.'],d.name{2});
   
   s4 = sprintf('Before a student has eaten, their face will appear as shown to the right.');
    
   s5 = sprintf('Once a student has eaten, their cheeks will puff out to indicate that they are full.');
    
   s6 = sprintf('For example, click "Next" to see %s eating lunch one day.',d.name{1});
 
   set(handles.text2,'string',{s1,'',s2,'',s3,'',[s4 ' ' s5],'',s6});

   si=1;
   path_anim(d.scenario{si},ind2subv(d.scenario{si}.graph_sz,[d.path(1)])',[],d.options);

  case 20
   s1 = sprintf('Even if %s can''t see a certain parking spot at first, it''s possible that %s could still know (or think %s knows) which truck is there.',d.name{1},d.name{2},d.name{2});
    
   s2 = sprintf(['For instance, %s could have found out that the %s truck is there from a friend, ' ...
     'or %s could have passed within view of the spot earlier in the day and seen the %s truck parked there.'],d.name{2},d.truck{2},d.name{2},d.truck{2});

   s3 = sprintf(['Or, %s might have a guess -- thinking that a certain truck is or isn''t there based on knowing how often it usually parks there, ' ...
     'or based on seeing someone eating food from a particular truck near a particular parking spot and inferring that it is likely to be parked there.'],d.name{2});
   
   s4 = sprintf('Before a student has eaten, their face will appear as shown to the right.');
    
   s5 = sprintf('Once a student has eaten, their cheeks will puff out to indicate that they are full.');
    
   s6 = sprintf('For example, click "Next" to see %s eating lunch one day.',d.name{1});
   s7 = sprintf('................................. Animation started.');
   
   set(handles.text2,'string',{s1,'',s2,'',s3,'',[s4 ' ' s5],'',s6,s7});
   
   options_tmp = d.options;
   options_tmp.animate = true;
   options_tmp.delay = 0;
   options_tmp.click_advance = true;
   
   set(handles.pushbutton1,'enable','off')
   set(handles.pushbutton2,'enable','off')
   
   si=1;
   path_anim(d.scenario{si},ind2subv(d.scenario{si}.graph_sz,[d.path 20 15 10 9 4 3 3])',[],options_tmp);
   %path_anim(d.scenario{si},ind2subv(d.scenario{si}.graph_sz,[d.path(1) 3 3])',[],options_tmp);
   
   s8 = sprintf('................................. Animation finished.');
   set(handles.text2,'string',{s1,'',s2,'',s3,'',[s4 ' ' s5],'',s6,s7,s8});
   
   set(handles.pushbutton1,'enable','on')
   set(handles.pushbutton2,'enable','on')
   
  case 21
    % slide 7
    s1 = sprintf('Now we will show you videos of other MIT students at lunchtime.');
    
    set(handles.text2,'string',{s1});
    
    clf(d.h_fig);

  case 22
    s1 = sprintf('Now we will show you videos of other MIT students at lunchtime.');
    
    s2 = sprintf('Each video will show a different student. Different videos may change the area of campus shown, or the arrangement of the buildings or parking spaces, but you should assume that students always know where all of the buildings and parking spots are.');
        
    s3 = sprintf('As in the previous examples, YOU will always be able to see which trucks are in each parking spot.');
    s4 = sprintf('However, what the STUDENTS in the videos can see will depend on their location and the location of buildings on campus, and they will only be able to see trucks that are within view.');
    
    set(handles.text2,'string',{s1,'',s2,'',[s3 ' ' s4]});

  case 23
    s1 = sprintf('Now we will show you videos of other MIT students at lunchtime.');
    
    s2 = sprintf('Each video will show a different student. Different videos may change the area of campus shown, or the arrangement of the buildings or parking spaces, but you should assume that students always know where all of the buildings and parking spots are.');
        
    s3 = sprintf('As in the previous examples, YOU will always be able to see which trucks are in each parking spot.');
    s4 = sprintf('However, what the STUDENTS in the videos can see will depend on their location and the location of buildings on campus, and they will only be able to see trucks that are within view.');    
    
    s5 = sprintf('Your task will be to explain each student''s behavior in terms of the preferences and beliefs that could have led them to act the way they did.');
    
    set(handles.text2,'string',{s1,'',s2,'',[s3 ' ' s4],'',s5});
    
  case 24
    s1 = sprintf('Now we will show you videos of other MIT students at lunchtime.');
    
    s2 = sprintf('Each video will show a different student. Different videos may change the area of campus shown, or the arrangement of the buildings or parking spaces, but you should assume that students always know where all of the buildings and parking spots are.');
        
    s3 = sprintf('As in the previous examples, YOU will always be able to see which trucks are in each parking spot.');
    s4 = sprintf('However, what the STUDENTS in the videos can see will depend on their location and the location of buildings on campus, and they will only be able to see trucks that are within view.');    
    
    s5 = sprintf('Your task will be to explain each student''s behavior in terms of the preferences and beliefs that could have led them to act the way they did.');
    
    s6 = sprintf('Some videos will "pause" partway through the student''s movement, before they have eaten. In these cases, base your judgments on the information from the student''s actions so far.');
    
    set(handles.text2,'string',{s1,'',s2,'',[s3 ' ' s4],'',s5,'',s6});

  case 25
    s1 = sprintf('Now we will show you videos of other MIT students at lunchtime.');
    
    s2 = sprintf('Each video will show a different student. Different videos may change the area of campus shown, or the arrangement of the buildings or parking spaces, but you should assume that students always know where all of the buildings and parking spots are.');
        
    s3 = sprintf('As in the previous examples, YOU will always be able to see which trucks are in each parking spot.');
    s4 = sprintf('However, what the STUDENTS in the videos can see will depend on their location and the location of buildings on campus, and they will only be able to see trucks that are within view.');    
    
    s5 = sprintf('Your task will be to explain each student''s behavior in terms of the preferences and beliefs that could have led them to act the way they did.');
    
    s6 = sprintf('Some videos will "pause" partway through the student''s movement, before they have eaten. In these cases, base your judgments on the information from the student''s actions so far.');
    
    s7 = sprintf('Press the "Next" button to begin.');

    set(handles.text2,'string',{s1,'',s2,'',[s3 ' ' s4],'',s5,'',s6,'',s7});
    
  otherwise
    uiresume(handles.figure1);

end

set(handles.figure1,'userdata',d);
