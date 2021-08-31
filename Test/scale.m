%% User Inputs
% Pick an audio file to autotune
[input,f_s] = audioread('middleC.mp3');
input = input(:,1)'; %Only want left stereo signal
% Choose a note to tune to (freq for now, will get tune table)
desired_freq = [293.66 329.63 349.23 392 440 493.88 523.25];

tuned_sig = zeros(12,length(input));

%% Autotune!
for f = 1:length(desired_freq)
    [tuned_sig(f,:),~] = tune(input,desired_freq(f),f_s);
end

%% Make C Scale
start = 30000;
stop = 100000;
C_scale = zeros(1,15*(stop-start+1));
C_scale(1:(stop-start)+1) = input(start:stop);
last_idx = (stop-start)+1;

% Up scale
for f = 1:length(desired_freq)
    note = tuned_sig(f,:);
    C_scale(last_idx+1:(stop-start)+last_idx+1) = note(start:stop);
    last_idx = last_idx + (stop-start);
end
% Down scale
for f = 1:length(desired_freq)-1
    note = tuned_sig(length(desired_freq)-f,:);
    C_scale(last_idx+1:(stop-start)+last_idx+1) = note(start:stop);
    last_idx = last_idx + (stop-start);
end
% Back at C
C_scale(last_idx+1:(stop-start)+last_idx+1) = input(start:stop);

sound(C_scale,f_s)




