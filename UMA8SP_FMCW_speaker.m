%% Code to generate FMCW chirps for speaker
% Author: Sanjib Sur
% Instituition: University of South Carolina
% Date: 03/13/2024

% Last update: 03/20/2024

% Output is the unmodified fmcw signal, 
% Modified blocks of random phase applied fmcw signals, applied random phases, and the
% corresponding scaling factors
function [fmcw_signal, random_phase_fmcw_signals, random_phase_offsets, scaling_factors] = ...
    UMA8SP_FMCW_speaker(total_duration)

% Define speaker parameters
total_duration = 8;
frame_duration = 0.1;
fs = 48000; % Sampling frequency in Hz
T_chirp = frame_duration; % Duration of the chirp in seconds
f_start = 6000; % Start frequency of the chirp in Hz
f_stop = 21000; % Stop frequency of the chirp in Hz
% TODO: Adjust scaling factor depending on the scenario
amplitude_scaling_factor = 0.02; % Amplitude scaling for real life

% % Generate a single chirp signal
% t_chirp = 0:1/fs:T_chirp-1/fs; % Time vector for chirp
% fmcw_signal = chirp(t_chirp, f_start, T_chirp, f_stop, 'linear');

% Generate multi-FMCW chirp
Nsubbands = 5;
fmcw_signal = generate_multi_fmcw_signal(fs, T_chirp, f_start, f_stop, Nsubbands);

% Prepare the audio device writer
% deviceWriter = audioDeviceWriter('Device', 'Speakers (Realtek(R) Audio)', 'SampleRate', fs);
deviceWriter = audioDeviceWriter('Device', 'Dell (2- Realtek(R) Audio)', 'SampleRate', fs);

% Save the newly generated fmcw signal with random offsets somewhere
random_phase_fmcw_signals = [];
random_phase_offsets = [];
scaling_factors = [];

tic
while toc < total_duration

    % Apply Mersenne Twister random phase offset for each fmcw block
    [new_fmcw_signal, random_phase_offset, scaling_factor] = ...
        apply_mtwister_random_phase(fmcw_signal);

    % Write the block to the device
    deviceWriter(amplitude_scaling_factor*new_fmcw_signal.');

    % Save the new fmcw signal and the corresponding random phases
    random_phase_fmcw_signals = [random_phase_fmcw_signals; new_fmcw_signal];
    random_phase_offsets = [random_phase_offsets; random_phase_offset];
    scaling_factors = [scaling_factors; scaling_factor];
end
release(deviceWriter);
    
% Plotting the final signal (optional, for visualization)
figure(1);
t_final = 0:1/fs:(length(fmcw_signal)-1)/fs; % Time vector for the final signal
plot(t_final, fmcw_signal);
ylim([-1.5 1.5])
xlabel('Time (s)');
ylabel('Amplitude');
title('FMCW Signal');

figure(2);
% Obtain and display the spectrogram
window = 256; % Size of the FFT window, adjust based on your requirements
noverlap = []; % Number of overlapping samples in adjacent segments (optional, can be empty for default)
nfft = 1024; % Number of FFT points, adjust for frequency resolution

% Use the spectrogram function
[s,f,t,p] = spectrogram(fmcw_signal, window, noverlap, nfft, fs, 'yaxis');

% Display the spectrogram
surf(t,f,10*log10(abs(p)),'EdgeColor','none');
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Spectrogram of the FMCW Signal');

% Optional: Colorbar to indicate power dB
colorbar;
end