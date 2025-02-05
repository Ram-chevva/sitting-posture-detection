% Stream 8 channels audio data from UMA-8-SP from miniDSP
% Channel number 8 is disabled
% Audio properties: 48 kHz sampling; 24 bits per sample
% Author: Sanjib Sur
% Institute: University of South Carolina
% Date: 03/13/2024

% Last update: 03/20/2024

close all;
clear all;
clc;


% Play the birdsound to ensure the intended speaker is working well
[signal, Fs] = audioread('birdsound.wav');
sound(signal, Fs);

userinput = input('Did you hear the bird sound from dedicated speaker-microphone array? (Y/n)?', 's');
if (userinput == 'n' || userinput == 'N')
    disp('Check device manager for speaker configuration!')
    return;
end

% Output folderpath is sent to the recording function
outputfolderpath = '.\data'; % Specify the directory path

% Input parameters
filename = 'posture3';
outputaudiofilename = fullfile(outputfolderpath, filename);
fmcwfilename = fullfile(outputfolderpath, sprintf('%s_fmcw_signal.mat', filename));
% duration in second
duration = 10;

% Create a parallel pool to generate and record audio simulatenously
poolobj = gcp('nocreate'); % If no pool, do not create a new one.
if isempty(poolobj)
    poolobj = parpool('local', 2); % Creates a pool using default settings.
end

% Execute UMA8SP_FMCW_speaker in parallel without blocking
speaker_function = parfeval(poolobj, @UMA8SP_FMCW_speaker, 4, duration); % Assume it has four outputs

% Execute UMA8SP_FMCW_microphone in parallel without blocking
recorder_function = parfeval(poolobj, @UMA8SP_FMCW_microphone, 1, outputaudiofilename, duration); % Assuming it has one output, the recording timestamp

% Get the fmcw signal for speaker, and modified signals and other
% parameters
[fmcw_signal, random_phase_fmcw_signals, random_phase_offsets, scaling_factors] = fetchOutputs(speaker_function);

% Get the recording timestamp
recording_timestamp = fetchOutputs(recorder_function);

% Delete the parallel pool
delete(poolobj);

% save the all parameters of measurements transmitted signal as a mat file
save(fmcwfilename, 'fmcw_signal', 'random_phase_fmcw_signals', ...
    'random_phase_offsets', 'scaling_factors', 'recording_timestamp');
