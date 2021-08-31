function varargout = autotune_gui(varargin)
% AUTOTUNE_GUI MATLAB code for autotune_gui.fig
%      AUTOTUNE_GUI, by itself, creates a new AUTOTUNE_GUI or raises the existing
%      singleton*.
%
%      H = AUTOTUNE_GUI returns the handle to a new AUTOTUNE_GUI or the handle to
%      the existing singleton*.
%
%      AUTOTUNE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AUTOTUNE_GUI.M with the given input arguments.
%
%      AUTOTUNE_GUI('Property','Value',...) creates a new AUTOTUNE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before autotune_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to autotune_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help autotune_gui

% Last Modified by GUIDE v2.5 12-Dec-2019 23:49:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @autotune_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @autotune_gui_OutputFcn, ...
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


% --- Executes just before autotune_gui is made visible.
function autotune_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to autotune_gui (see VARARGIN)

% Choose default command line output for autotune_gui
handles.output = hObject;
[x,f_s] = audioread('middleC.mp3');
handles.x = x(:,1)';
handles.f_s = f_s;
handles.desired_freq = 277.2;
handles.path = 'NoPath';
handles.file_name = 'middleC.mp3';
handles.name = 'middleC';
handles.loc_0_X = 1;
handles.y = 1;
handles.x_nb =1;
handles.songloaded = 0;

axes(handles.Columbia)
matlabImage = imread('Columbia_Logo.jpg');
image(matlabImage)
axis off
axis image

axes(handles.ColumbiaEngineering)
matlabImage = imread('Columbia_Engineering_Logo.jpg');
image(matlabImage)
axis off
axis image

axes(handles.SheetMusic)
matlabImage = imread('C_Chrom_Scale.png','png');
image(matlabImage)
axis off
axis image


load('TuneTable.mat')
handles.TuneFreq = TuneFreq;
handles.Octave = 0;
handles.whichplotstr = 'Input';
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes autotune_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = autotune_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function note_slider_Callback(hObject, eventdata, handles)
% hObject    handle to note_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Value = round(get(hObject, 'Value'));
set(hObject, 'Value', Value);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function note_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to note_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function file_name_Callback(hObject, eventdata, handles)
% hObject    handle to file_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file_name as text
%        str2double(get(hObject,'String')) returns contents of file_name as a double


% --- Executes during object creation, after setting all properties.
function file_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in run_autotune.
function run_autotune_Callback(hObject, eventdata, handles)
% hObject    handle to run_autotune (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
slider_pos = get(handles.note_slider,'Value');
freq_idx = 12*handles.Octave + slider_pos;
desired_freq = handles.TuneFreq(freq_idx);
[y,x_nb,loc_0_X] = tune(handles.x,desired_freq,handles.f_s);
handles.y = y; handles.x_nb = x_nb; handles.loc_0_X = loc_0_X;
MainPlot(hObject, eventdata, handles);
playautotune = get(handles.playautotune,'Value');
handles.songloaded = 1;
if playautotune == 1
    sound(y,handles.f_s);
end
write_name = strcat(handles.name,'_autotune.wav');
write_path = fullfile(handles.path,write_name);
audiowrite(write_path,y,handles.f_s);
guidata(hObject, handles);




% --- Executes on button press in select_audio_file.
function select_audio_file_Callback(hObject, eventdata, handles)
% hObject    handle to select_audio_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file_name,path] = uigetfile({'*.mp3';'*.wav'});handles.file_name = file_name;
[x,f_s] = audioread(fullfile(path,file_name));
handles.x = x(:,1)';
handles.f_s = f_s;
handles.path = path;
split = strsplit(file_name,'.');
handles.name = split{1};
playinput = get(handles.playinput,'Value');
if playinput == 1
    sound(x,f_s);
end
guidata(hObject, handles);


% --- Executes on selection change in Octave_Listbox.
function Octave_Listbox_Callback(hObject, eventdata, handles)
% hObject    handle to Octave_Listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index_selected = get(handles.Octave_Listbox,'Value');

handles.Octave = index_selected-1;
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns Octave_Listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Octave_Listbox


% --- Executes during object creation, after setting all properties.
function Octave_Listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Octave_Listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in whichplotpopup.
function whichplotpopup_Callback(hObject, eventdata, handles)
% hObject    handle to whichplotpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
whichplotstr = get(hObject,'String');
handles.whichplotstr = whichplotstr{get(hObject,'Value')};
if handles.songloaded == 1
    MainPlot(hObject, eventdata, handles)
end
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns whichplotpopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from whichplotpopup


% --- Executes during object creation, after setting all properties.
function whichplotpopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to whichplotpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MainPlot(hObject, eventdata, handles)
% Special function for plotting the main axes
whichplotstr = handles.whichplotstr;
axes(handles.MainAxes)
x = handles.x;
x_nb = handles.x_nb;
f_s = handles.f_s;
tuned_sig = handles.y;
N_in = length(x); %Length of input signal
t_in = (0:N_in-1)/f_s; %Calculate input time vector
N_out = N_in; %Desire output to be same length as input

nFFTin = 2^nextpow2(N_in); %Length of input FFT
input_fft = abs(fft(x,nFFTin)/nFFTin); %Compute input FFT
nb_input_fft = abs(fft(x_nb,nFFTin)/nFFTin); %Compute Narrowband input FFT

nFFTout = 2^nextpow2(N_out);
output_fft = abs(fft(tuned_sig,nFFTout)/nFFTout);


f_in = f_s*(0:round(5000*nFFTin/f_s))/nFFTin;
f_out = f_s*(0:round(5000*nFFTout/f_s))/nFFTout;
t_out = (1/f_s)*(0:(N_out-1));

loc_0_X = handles.loc_0_X;
first_0_X_idx = round(.14*length(loc_0_X));
x_pulse = x(loc_0_X(first_0_X_idx):loc_0_X(first_0_X_idx+2));
x_nb_pulse = x_nb(loc_0_X(first_0_X_idx):loc_0_X(first_0_X_idx+2));
tuned_sig_pulse = tuned_sig(loc_0_X(first_0_X_idx):loc_0_X(first_0_X_idx+2));
t_in_pulse = t_in(loc_0_X(first_0_X_idx):loc_0_X(first_0_X_idx+2));
t_out_pulse = t_out(loc_0_X(first_0_X_idx):loc_0_X(first_0_X_idx+2));

switch whichplotstr
    case 'Input'
        plot(t_in,x)
        xlabel('Time (s)')
        ylabel('Amplitude')
        title('Input')
        grid on
    case 'NarrowBand Input'
        plot(t_in,x_nb)
        xlabel('Time (s)')
        ylabel('Amplitude')
        title('NarrowBand Input')
        grid on
    case 'Post AutoTune'
        plot(t_out,tuned_sig)
        xlabel('Time (s)')
        ylabel('Amplitude')
        title('Post AutoTune')
        grid on
    case 'Input Pulse'
        stem(t_in_pulse,x_pulse)
        xlabel('Time (s)')
        ylabel('Amplitude')
        title('2 Input Periods')
        grid on
    case 'NarrowBand Input Pulse'
        stem(t_in_pulse,x_nb_pulse)
        xlabel('Time (s)')
        ylabel('Amplitude')
        title('2 NarrowBand Input Periods')
        grid on
    case 'Post AutoTune Pulse'
        stem(t_out_pulse,tuned_sig_pulse)
        xlabel('Time (s)')
        ylabel('Amplitude')
        title('Post AutoTune Periods')
        grid on
    case 'Input DFT'
        plot(f_in,input_fft(1:round(5000*nFFTin/f_s+1)))
        xlabel('Freq (Hz)')
        ylabel('Amplitude')
        title('Raw Audio Spectrum')
        grid on
    case 'NarrowBand Input DFT'
        plot(f_in,nb_input_fft(1:round(5000*nFFTin/f_s+1)))
        xlabel('Freq (Hz)')
        ylabel('Amplitude')
        title('Bandpassed Input Spectrum')
        grid on
    case 'Post AutoTune DFT'
        plot(f_out,output_fft(1:round(5000*nFFTout/f_s+1)))
        xlabel('Freq (Hz)')
        ylabel('Amplitude')
        title('Autotuned Signal Spectrum')
        grid on
    case 'Overlay Input & Output DFT'
        plot(f_in,input_fft(1:round(5000*nFFTin/f_s+1)),'-b')
        xlabel('Freq (Hz)')
        ylabel('Amplitude')
        title('Input & Output Signal Spectrums')
        grid on
        hold on
        plot(f_out,output_fft(1:round(5000*nFFTout/f_s+1)),'-r')
        legend('Input FFT','AutoTune FFT')
        hold off
end


% --- Executes on button press in playautotune.
function playautotune_Callback(hObject, eventdata, handles)
% hObject    handle to playautotune (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of playautotune


% --- Executes on button press in playinput.
function playinput_Callback(hObject, eventdata, handles)
% hObject    handle to playinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of playinput
