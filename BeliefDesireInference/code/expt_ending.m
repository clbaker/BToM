function varargout = expt_ending(varargin)
% EXPT_ENDING M-file for expt_ending.fig
%      EXPT_ENDING, by itself, creates a new EXPT_ENDING or raises the existing
%      singleton*.
%
%      H = EXPT_ENDING returns the handle to a new EXPT_ENDING or the handle to
%      the existing singleton*.
%
%      EXPT_ENDING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPT_ENDING.M with the given input arguments.
%
%      EXPT_ENDING('Property','Value',...) creates a new EXPT_ENDING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before expt_ending_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to expt_ending_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help expt_ending

% Last Modified by GUIDE v2.5 03-Feb-2017 11:43:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @expt_ending_OpeningFcn, ...
                   'gui_OutputFcn',  @expt_ending_OutputFcn, ...
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


% --- Executes just before expt_ending is made visible.
function expt_ending_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to expt_ending (see VARARGIN)

% Choose default command line output for expt_ending
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes expt_ending wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = expt_ending_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = [];
