function plot_everything(input,nb_input,tuned_sig,f_s)
%%  File Information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       AUTHOR INFORMATION                                               %
%       Columbia University - Fall 2019                                  %
%       ELEN E4810 Digital Signal Processing                             %
%       Alex Thornton, Joe Wihbey                                        %
%       apt2141@columbia.edu; jgw2132@columbia.edu                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       FILE DESCRIPTORS                                                 %
%       Name: plot_everything.m                                          %
%       Description:                                                     %
%               Plots input, narrowband input, output, and their DFTs    %
%       Inputs:                                                          %
%               input:= (1xN) Vector, digital signal to be tuned         %
%               nb_input:= (1xN) Vector, narrowband of input signal      %
%               tuned_sig:= input signal tuned to desired frequency      %
%               f_s:= sampling frequency of input signal (Hz)            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Preprocess Inputs
N_in = length(input); %Length of input signal
t_in = (0:N_in-1)/f_s; %Calculate input time vector
N_out = N_in; %Desire output to be same length as input

nFFTin = 2^nextpow2(N_in); %Length of input FFT
input_fft = abs(fft(input,nFFTin)/nFFTin); %Compute input FFT
nb_input_fft = abs(fft(nb_input,nFFTin)/nFFTin); %Compute Narrowband input FFT

nFFTout = 2^nextpow2(N_out);
output_fft = abs(fft(tuned_sig,nFFTout)/nFFTout);


f_in = f_s*(0:round(5000*nFFTin/f_s))/nFFTin;
f_out = f_s*(0:round(5000*nFFTout/f_s))/nFFTout;
t_out = (1/f_s)*(0:(N_out-1));

%% Plot
figure
subplot(2,3,1)
plot(t_in,input)
xlabel('Time (s)')
ylabel('Amplitude')
title('Input')
 
subplot(2,3,4)
plot(f_in,input_fft(1:round(5000*nFFTin/f_s+1)))
xlabel('Freq (Hz)')
ylabel('Amplitude')
title('Raw Audio Spectrum')

subplot(2,3,2)
plot(t_in,nb_input)
xlabel('Time (s)')
ylabel('Amplitude')
title('Bandpassed Input (Fundamental Frequency)')
 
subplot(2,3,5)
plot(f_in,nb_input_fft(1:round(5000*nFFTin/f_s+1)))
xlabel('Freq (Hz)')
ylabel('Amplitude')
title('Bandpassed Input Spectrum')

subplot(2,3,3)
plot(t_out,tuned_sig)
xlabel('Time (s)')
ylabel('Amplitude')
title('Autotuned Signal')
 
subplot(2,3,6)
plot(f_out,output_fft(1:round(5000*nFFTout/f_s+1)))
xlabel('Freq (Hz)')
ylabel('Amplitude')
title('Autotuned Signal Spectrum')

end