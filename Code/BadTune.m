%% Pick an audio file to autotune
[input,f_s] = audioread('middleC.mp3');
input = input(:,1)'; %Only want left stereo signal
% Choose a note to tune to (freq for now, will get tune table)
desired_freq = 320; %277.2; %(Hz)     246.9->B    277.2->C#   293->D   

%%  Preprocess Inputs   
N_in = length(input); %Length of input signal
N_out = N_in; %Desire output to be same length as input
desired_period = round(f_s/desired_freq); %in samples
t_in = (0:N_in-1)/f_s; %Calculate input time vector


%%  Perform Fourier Analysis on Input
nFFTin = 2^nextpow2(N_in); %Length of input FFT
input_fft = abs(fft(input,nFFTin)/nFFTin); %Compute input FFT

[~,fund_freq_idx] = max(input_fft); %Find indx of 'main' frequency of input
fund_freq = f_s*fund_freq_idx(1)/length(input_fft); %Calculate 'main' frequency

output = input.*cos(2*pi*(fund_freq-desired_freq)*t_in);

%%  Isolate Input Fundamental Frequency
bw_in = 25;
fpass_in = [(fund_freq-bw_in/2) (fund_freq+bw_in/2)]; %Passband of BPF
nb_input = bandpass(input,fpass_in,f_s); %Narrowband input around fund frequency

%% Plot!
%plot_everything(input,nb_input,output,f_s)
plot_bad(input,nb_input,output,f_s)
%% Listen!
scale = [input output];
sound(output,f_s);






