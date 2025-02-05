close all;
clear all;
clc;

% Load the received audio signals
audiofilename = 'C:\Users\Zoro\Desktop\code\data/posture3_UMA8SP_audio.wav';
% Load the fmcw signal, random phase offsets, scaling factors
matfilename = 'C:\Users\Zoro\Desktop\code\data/posture3_fmcw_signal.mat';

[audioData, sampleRate] = audioread(audiofilename);
load(matfilename);

% Function that takes input the captured audio signals, sample rate, original fmcw
% signal, random phases, and scaling factors introduced during transmission
% and output recovered fmcw signals

[~, rx_fmcw_signal_reconstructed] = ...
    recover_fmcw_blocks(audioData, sampleRate, fmcw_signal, ...
    random_phase_fmcw_signals, random_phase_offsets, scaling_factors);

% Initialize a matrix to store down-converted IF signals
num_rx_signals = size(rx_fmcw_signal_reconstructed, 1);
IF_signals = zeros(num_rx_signals, length(rx_fmcw_signal_reconstructed));

% Downconvert the received fmcw signals and store IF signals
for i = 1:num_rx_signals
    IF_signals(i, :) = rx_fmcw_signal_reconstructed(i, :) .* fmcw_signal;
end

% Combine multiple down-converted IF signals into a single composite IF signal
composite_IF_signal = sum(IF_signals, 1); % Sum along rows to combine signals

% Generate spectrogram for the composite IF signal
window = 256; % Adjust window size based on your requirements
noverlap = []; % Number of overlapping samples in adjacent segments (optional, can be empty for default)
nfft = 1024; % Number of FFT points, adjust for frequency resolution

% Use the spectrogram function to compute the spectrogram
[s,f,t,p] = spectrogram(composite_IF_signal, window, noverlap, nfft, sampleRate, 'yaxis');

% Visualize the spectrogram
figure;
surf(t, f, 10*log10(abs(p)), 'EdgeColor', 'none');
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Composite Spectrogram of Down-Converted IF Signals');
colorbar;


% figure(1);
% % Obtain and display the spectrogram
% window = 256; % Size of the FFT window, adjust based on your requirements
% noverlap = []; % Number of overlapping samples in adjacent segments (optional, can be empty for default)
% nfft = 1024; % Number of FFT points, adjust for frequency resolution
% 
% % Use the spectrogram function
% [s,f,t,p] = spectrogram(IF_signal, window, noverlap, nfft, sampleRate, 'yaxis');
% 
% % Display the spectrogram
% surf(t,f,10*log10(abs(p)),'EdgeColor','none');
% axis xy; axis tight; colormap(jet); view(0,90);
% xlabel('Time (s)');
% ylabel('Frequency (Hz)');
% title('Spectrogram of the original FMCW Signal');
% % Optional: Colorbar to indicate power dB
% colorbar;

