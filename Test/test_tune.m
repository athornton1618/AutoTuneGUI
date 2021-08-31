% Still working file
% Main point of entry to model
% A. Thor 12/8/19

%% User Inputs
% Pick an audio file to autotune
[input,f_s] = audioread('middleC.mp3');
input = input(:,1)'; %Only want left stereo signal
% Choose a note to tune to (freq for now, will get tune table)
desired_freq = 277.2; %(Hz)     246.9->B    277.2->C#   293->D   

%% Autotune!
[tuned_sig,nb_input] = tune(input,desired_freq,f_s);

%% Plot!
plot_everything(input,nb_input,tuned_sig,f_s)

%% Listen!
scale = [input tuned_sig];
sound(scale,f_s);

