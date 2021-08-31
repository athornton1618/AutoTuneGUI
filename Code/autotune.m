function [y,nb_input,loc_0_X] = autotune(input,f_s,TuneFreq)
%%  File Information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       AUTHOR INFORMATION                                               %
%       Columbia University - Fall 2019                                  %
%       ELEN E4810 Digital Signal Processing                             %
%       Alex Thornton, Joe Wihbey                                        %
%       apt2141@columbia.edu; jgw2132@columbia.edu                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       FILE DESCRIPTORS                                                 %
%       Name: autotune.m                                                 %
%       Description:                                                     %
%               Modulates input digital signal to closest note via STFT  %
%       Inputs:                                                          %
%               input:= (1xN) Vector, digital signal to be tuned         %
%               desired_freq:= Scalar, frequency to tune input to (Hz)   %
%               f_s:= sampling frequency of input (Hz)                   %
%       Outputs:                                                         %
%               output:= input signal tuned to desired frequency         %
%               nb_input:= narrowband input sig to only fund freq        %
%               loc_0_X:= indexees of input with zero crossing           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Preprocess Inputs   
N_in = length(input);
N_out = N_in;


seg_length = f_s; % number of samples per 'autotune chunk'
N_segments = ceil(N_in/seg_length);

%% Initialize Variables / Output
input_idx = 1; output_idx = 1; 
y = NaN(1,N_out);
nb_input = NaN(1,N_out);
loc_0_X = 1;

%% Run tune.m For Every 'Chunk'
for seg_idx = 1:N_segments
    if (N_in - input_idx)>seg_length
        x_seg = input(input_idx:input_idx+seg_length-1);
    else
        x_seg = input(input_idx:end);
    end
    
    %  Perform Fourier Analysis on Input
    nFFTin = 2^nextpow2(seg_length); %Length of input FFT
    input_fft = abs(fft(x_seg,nFFTin)/nFFTin); %Compute input FFT

    [~,fund_freq_idx] = max(input_fft); %Find indx of 'main' frequency of input
    fund_freq = f_s*fund_freq_idx(1)/length(input_fft); %Calculate 'main' frequency
    
    % Find Closest Freq to Fund Freq
    [~,desired_freq_idx] = min(abs(fund_freq-TuneFreq));
    desired_freq = TuneFreq(desired_freq_idx);
    
    % AutoTune Chunk
    [y_seg,nb_input_seg,loc_0_X_seg] = tune(x_seg,desired_freq,f_s);
    y(output_idx:output_idx+length(y_seg)-1) = y_seg;
    nb_input(input_idx:input_idx + length(nb_input_seg)-1) = nb_input_seg;
    loc_0_X = [loc_0_X loc_0_X_seg];
    


    output_idx = output_idx + length(y_seg)+1;
    input_idx = input_idx+seg_length+1;
end


%% Fix Output Data
y = y(~isnan(y));
nb_input = nb_input(~isnan(nb_input));

end

