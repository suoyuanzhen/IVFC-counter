function varargout = Counter(varargin)
% COUNTER MATLAB code for Counter.fig
%      COUNTER, by itself, creates a new COUNTER or raises the existing
%      singleton*.
%
% 
%  
% 
%      H = COUNTER returns the handle to a new COUNTER or the handle to
%      the existing singleton*.
%
%      COUNTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COUNTER.M with the given input arguments.
%
%      COUNTER('Property','Value',...) creates a new COUNTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Counter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Counter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Counter

% Last Modified by GUIDE v2.5 01-Feb-2016 16:36:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Counter_OpeningFcn, ...
                   'gui_OutputFcn',  @Counter_OutputFcn, ...
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


function Counter_OpeningFcn(hObject, eventdata, handles, varargin)
%% This function has no output args, see OutputFcn.
handles.output = hObject;
guidata(hObject, handles);




function varargout = Counter_OutputFcn(hObject, eventdata, handles) 
%% varargout  cell array for returning output args (see VARARGOUT);
varargout{1} = handles.output;



function Wavelength1_Callback(hObject, eventdata, handles)
%% 


function Wavelength1_CreateFcn(hObject, eventdata, handles)
%% 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Channel1_Select_Callback(hObject, eventdata, handles)
%% select if Channel 1 contains data
Ch1_a=get(hObject, 'Value');
switch Ch1_a
    case 1
        set(handles.Channel1_Filter, 'Enable', 'on');
        set(handles.Channel1_Cut, 'Enable', 'on');
    case 0
        set(handles.Channel1_Filter, 'Value', 0);
        set(handles.Channel1_Filter, 'Enable', 'off');
        set(handles.Channel1_Cut, 'Value', 0);
        set(handles.Channel1_Cut, 'Enable', 'off');       
end



function Channel1_Filter_Callback(hObject, eventdata, handles)
%% select if wavelet filter is used for plotting of Channel 1


function Channel1_Cut_Callback(hObject, eventdata, handles)
%% select if the baseline of channel 1 is corrected


function Wavelength2_Callback(hObject, eventdata, handles)
%% 


function Wavelength2_CreateFcn(hObject, eventdata, handles)
%%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Channel2_Select_Callback(hObject, eventdata, handles)
%% select if Channel 2 contains data
Ch2_a=get(hObject, 'Value');
switch Ch2_a
    case 1
        set(handles.Channel2_Filter, 'Enable', 'on');
        set(handles.Channel2_Cut, 'Enable', 'on');
    case 0 %if channel 1 is not selected, turn off the filter and baseline corrector
        set(handles.Channel2_Filter, 'Value', 0);
        set(handles.Channel2_Filter, 'Enable', 'off');
        set(handles.Channel2_Cut, 'Value', 0);
        set(handles.Channel2_Cut, 'Enable', 'off');       
end



function Channel2_Filter_Callback(hObject, eventdata, handles)
%% select if wavelet filter is used for plotting of Channel 2


function Channel2_Cut_Callback(hObject, eventdata, handles)
%% select if the baseline of channel 2 is corrected


function pushbutton1_Callback(hObject, eventdata, handles)
%% Select a file for plotting and cell counting
global X             %time
global Y             %data of channel 1
global YY            %data of channel 2
set(handles.num1,'String','');
set(handles.num2,'String','');
if isempty(handles.edit1) %if previous pathname does not exist, you need to select the path
    [filename,pathname]=uigetfile({'*.dcf','DCF files(*.dcf)'},'Data selector');
    str=[pathname filename];
else                      %if previous pathname exists, open it as default path
    old=get(handles.edit1, 'String');
    [filename,pathname]=uigetfile({'*.dcf','DCF files(*.dcf)'},'Data selector',...
        old);
    str=[pathname filename];
end
set(handles.edit1,'string',str); %edit1 is the tag for file path and name in the pre-precess group
data=readDcf2(str);
X=data(:,1);
Y=data(:,2);
if size(data,2)==3
    YY=data(:,3);
else
    YY=0;
end
clear data;


function pushbutton2_Callback(hObject, eventdata, handles)
%%for plotting
global X; 
global Y;
global YY;
Ch1_a=get(handles.Channel1_Select, 'Value');
Ch1_f=get(handles.Channel1_Filter, 'Value');
Ch1_c=get(handles.Channel1_Cut, 'Value');
Ch2_a=get(handles.Channel2_Select, 'Value');
Ch2_f=get(handles.Channel2_Filter, 'Value');
Ch2_c=get(handles.Channel2_Cut, 'Value');

paras=[num2str(Ch1_a) num2str(Ch1_f) num2str(Ch1_c) num2str(Ch2_a) num2str(Ch2_f) num2str(Ch2_c)];
switch paras       %check the status of channel 1 and 2
 
    %No channals are selected, output error information.
    case '000000'  
        errordlg('No channel is selected','Input Error');
        return;
    
    %Channel 1: no wavelet filter and baseline correction.    
    case '100000'
        figure;
        plot(X,Y);
    
    %Channel 1: wavelet filter, no baseline correction.
    case '110000'
       Y_filter=wden(Y,'heursure','s','mln',3,'sym7');
       figure;
       plot(X,Y_filter);
    
    %Channel 1: baseline correction, no wavelet filter.
    case '101000'
        [Y_cut, yb, l]=basecor(Y);
        figure;
        plot(X(1:l),Y_cut);        
     
    %Channel 1: wavelet filter and baseline correction.
    case '111000'
        [Y_cut, yb, l]=basecor(Y);
        Y_cut_filter=wden(Y_cut,'heursure','s','mln',3,'sym7');
        figure;
        plot(X(1:l),Y_cut_filter);
    
    %Channel 2: no wavelet filter and baseline correction. 
    case '000100'
        figure;
        plot(X,YY,'Color',[0 0.5 0]);
        
    %Channel 2: wavelet filter, no baseline correction.
    case '000110'
        YY_filter=wden(YY,'heursure','s','mln',3,'sym7');
        figure;
        plot(X,YY_filter,'Color',[0 0.5 0]);
        
    %Channel 2: baseline correction, no wavelet filter.
    case '000101'
       [YY_cut, yb, l]=basecor(YY);
        figure;
        plot(X(1:l),YY_cut,'Color',[0 0.5 0]);
    
    %Channel 2: wavelet filter and baseline correction.
    case '000111'
        [YY_cut, yb, l]=basecor(YY);
        YY_cut_filter=wden(YY_cut,'heursure','s','mln',3,'sym7');
        figure;
        plot(X(1:l),YY_cut_filter,'Color',[0 0.5 0]);
    otherwise
        errordlg('Please select only one channel','Input Error');
        return;
 %fuction of two-channel plotting is reserved       
%     case '100100'
%     case '110100'
%     case '101100'
%     case '111100'
%         
%     case '100101'
%     case '101101'
%     case '110101'
%     case '111101'
%         
%     case '100110'
%     case '101110'
%     case '110110'
%     case '111110'
%         
%     case '100111'
%     case '101111'
%     case '110111'
%     case '111111'
end

function pushbutton3_Callback(hObject, eventdata, handles)
%% This function can find peaks, plot them in figure and out the results in the gui and excel
global X; 
global Y;
global YY;

Ch1_a=get(handles.Channel1_Select, 'Value');
Ch2_a=get(handles.Channel2_Select, 'Value');
str=get(handles.edit1,'String'); %get the file path
newstrch1=[str(1:(end-4)) '_ch1.xlsx']; %set the path and name for output results of channel 1
newstrch2=[str(1:(end-4)) '_ch2.xlsx'];  %set the path and name for output results of channel 1

if exist(newstrch1,'file') %if previous result file exist, delete it.
    delete(newstrch1);
end
if Ch1_a
    set(handles.Channel1_Filter, 'Value', 0);
    set(handles.Channel1_Cut, 'Value', 1);
   
    n1=str2num(get(handles.n1, 'string'));
    [ph,px,w,p,tl] = fpeak(X,Y,n1);   %find peaks, output peak height(ph), location(px),width,etc
    set(handles.num1, 'String', length(ph));   %display the number of cells in the GUI 
    if ~isempty(ph)      % if the number of peaks is not 0
        header={'Height(V)','Location(s)','width(ms)','p'}; 
        endindex1=num2str(2+length(ph));
        xlswrite(newstrch1,header); %output head line
        xlswrite(newstrch1,[ph;px/5000;w/5;p]',1,'A2');  %output detailed information  
        xlswrite(newstrch1,{'END'},1,['A' endindex1]);  %output end line    
    else
        xlswrite(newstrch1,{'No peaks'}); % if the number of peaks is 0, output 'No peaks'
    end
else
    set(handles.num1, 'String', ''); %if channel1 is not selected, set the result as blank
end

if exist(newstrch2,'file')%if previous result file exist, delete it.
    delete(newstrch2);
end
if Ch2_a   % the same for channel 2
    set(handles.Channel2_Filter, 'Value', 0);
    set(handles.Channel2_Cut, 'Value', 1);
    
    n2=str2num(get(handles.n2, 'string'));
    [ph,px,w,p,tl] = fpeak(X,YY,n2);
    set(handles.num2, 'String', length(ph));
    if ~isempty(ph)
        header={'Height(V)','Location(s)','width(ms)','p'};
        endindex2=num2str(2+length(ph));
        xlswrite(newstrch2,header);
        xlswrite(newstrch2,[ph;px/5000;w/5;p]',1,'A2');   
        xlswrite(newstrch2,{'END'},1,['A' endindex2]);
    else
        xlswrite(newstrch2,{'No peaks'});
    end  
else
    set(handles.num1, 'String', '');
end

ttl=[num2str(tl) ' min'];
set(handles.edit16, 'String',ttl); %display the time of data



function pushbutton4_Callback(hObject, eventdata, handles)
%% To select multi-files
if isempty(handles.edit11)
    [filename,pathname]=uigetfile({'*.dcf','DCF files(*.dcf)'},'Data selector',...
        'MultiSelect','on');
    str=[pathname filename];
    set(handles.edit11,'string',pathname);
    set(handles.listbox1,'string',filename);
else
    old=get(handles.edit11, 'String');
    [filename,pathname]=uigetfile({'*.dcf','DCF files(*.dcf)'},'Data selector',...
        old,'MultiSelect','on');
    str=[pathname filename];
    set(handles.edit11,'string',pathname);
    set(handles.listbox1,'string',filename);    
end

handles.filename=filename;
handles.pathname=pathname;
guidata(hObject,handles);



function edit11_Callback(hObject, eventdata, handles)
%%The pathname of multi-files



function edit11_CreateFcn(hObject, eventdata, handles)
%%Edit11 is the pathname of multi-files

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function listbox1_Callback(hObject, eventdata, handles)
%% To display the selected files


function listbox1_CreateFcn(hObject, eventdata, handles)
%%list filenames
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton5_Callback(hObject, eventdata, handles)
%%



function edit12_Callback(hObject, eventdata, handles)
%%


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
%%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1_Callback(hObject, eventdata, handles)
%%


function edit1_CreateFcn(hObject, eventdata, handles)
%%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function n1_Callback(hObject, eventdata, handles)
%%set the number of fold of channel 1 


function n1_CreateFcn(hObject, eventdata, handles)
%%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit6_Callback(hObject, eventdata, handles)
%%parameter of wavelet for channel 1


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
%%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function n2_Callback(hObject, eventdata, handles)
%%set the number of fold of channel 


function n2_CreateFcn(hObject, eventdata, handles)
%%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
%%parameter of wavelet for channel 2


function edit8_CreateFcn(hObject, eventdata, handles)
%%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
%%


function edit9_CreateFcn(hObject, eventdata, handles)
%%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
%%


function edit10_CreateFcn(hObject, eventdata, handles)
%%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
%%

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
%%
close all;



function edit13_Callback(hObject, eventdata, handles)
%%


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
%%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uipanel2_ButtonDownFcn(hObject, eventdata, handles)
%%


% --- Executes during object creation, after setting all properties.
function Channel1_Select_CreateFcn(hObject, eventdata, handles)
%%


function Channel2_Select_CreateFcn(hObject, eventdata, handles)
%%



% --- Executes during object creation, after setting all properties.
function uipanel2_CreateFcn(hObject, eventdata, handles)
%%



% --- Executes on key press with focus on Channel1_Select and none of its controls.
function Channel1_Select_KeyPressFcn(hObject, eventdata, handles)
%%



function num1_Callback(hObject, eventdata, handles)
%% display the cell number of channel 1


% --- Executes during object creation, after setting all properties.
function num1_CreateFcn(hObject, eventdata, handles)
%%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function num2_Callback(hObject, eventdata, handles)
%%display the cell number of channel 2


% --- Executes during object creation, after setting all properties.
function num2_CreateFcn(hObject, eventdata, handles)
%%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
%%display the time duration


function edit16_CreateFcn(hObject, eventdata, handles)
%%
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
%%
