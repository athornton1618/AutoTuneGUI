function [output,nb_input,loc_0_X] = tune(input,desired_freq,f_s)
%%  File Information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       AUTHOR INFORMATION                                               %
%       Columbia University - Fall 2019                                  %
%       ELEN E4810 Digital Signal Processing                             %
%       Alex Thornton, Joe Wihbey                                        %
%       apt2141@columbia.edu; jgw2132@columbia.edu                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       FILE DESCRIPTORS                                                 %
%       Name: tune.m                                                     %
%       Description:                                                     %
%               Modulates input digital signal to desired frequency      %
%       Inputs:                                                          %
%               input:= (1xN) Vector, digital signal to be tuned         %
%               desired_freq:= Scalar, frequency to tune input to (Hz)   %
%               f_s:= sampling frequency of input (Hz)                   %
%       Outputs:                                                         %
%               output:= input signal tuned to desired frequency         %
%               nb_input:= narrowband input sig to only fund freq        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Preprocess Inputs   
N_in = length(input); %Length of input signal
N_out = N_in; %Desire output to be same length as input
desired_period = round(f_s/desired_freq); %in samples

%%  Perform Fourier Analysis on Input
nFFTin = 2^nextpow2(N_in); %Length of input FFT
input_fft = abs(fft(input,nFFTin)/nFFTin); %Compute input FFT

[~,fund_freq_idx] = max(input_fft); %Find indx of 'main' frequency of input
fund_freq = f_s*fund_freq_idx(1)/length(input_fft); %Calculate 'main' frequency

%%  Isolate Input Fundamental Frequency
bw_in = 25;
fpass_in = [(fund_freq-bw_in/2) (fund_freq+bw_in/2)]; %Passband of BPF
nb_input = bandpass(input,fpass_in,f_s); %Narrowband input around fund frequency

%% Initialize Variables / Output
input_idx = 1; output_idx = 1;
last_0_X = 1; x = 0;
output = zeros(1,N_out);
loc_0_X = NaN(1,N_out); loc_idx = 1;
 
%% Perform Autotune Algorithm
while input_idx < N_in
    last_x = x;
    x = nb_input(input_idx);
    if ((last_x > 0) && (x<=0)) %Check for Zero Crossing
        input_period = input_idx - last_0_X;
        period_shift_ratio = desired_period/input_period;
        last_0_X = input_idx;
        loc_0_X(loc_idx) = input_idx; loc_idx = loc_idx+1; % Save off location of Zero X'ing
        if output_idx/N_out < input_idx/N_in %Compression/ Expansion Decision
            % Move output index to desired pitch
            output_idx = output_idx + round((input_period*period_shift_ratio)); 
            windowfunc = hamming(input_period); %Compute window
            % Process new 'chunk' of input
            for n = -input_period:-1 %Add windowed input to corresponding location in output
                if n+output_idx <1 || n+output_idx > N_out || n+input_idx > N_in
                    continue;
                else
                    output(n+output_idx) = output(n+output_idx)...
                        +(input(n+input_idx)*windowfunc(input_period +1 +n));
                end
            end    
        end
    end
    input_idx = input_idx+1;
end
%%  Modify Outputs
loc_0_X = loc_0_X(~isnan(loc_0_X));


end 