%% Code to receive FMCW signals from 8-channel microphone
% Author: Sanjib Sur
% Instituition: University of South Carolina
% Date: 03/13/2024

% Last update: 03/20/2024

% Function input filename and duration of recordings
% Outputs the time when recording started
function recording_timestamp = UMA8SP_FMCW_microphone(outputfilename, duration)

% Define the base filename
baseFilename = 'posture3';

% Concatenate the base filename with the audio file extension
%audioFile = sprintf('%s_UMA8SP_audio.wav', baseFilename);

% Display the resulting filename
%disp(audioFile);

audioFile = sprintf('%s_UMA8SP_audio.wav', baseFilename);
audiosamplingRate = 48000;
audiosamplesPerFrame = 2048;
audioNumChannels = 1;


%% Identify EMEET microphone
% Get the number of audio input devices
numInputDevices = audiodevinfo(1);

% Microphone info
uma8sp_mic_name = 'Microphone Array (Intel® Smart Sound Technology (Intel® SST))'; % Change this to the desired microphone name
uma8sp_mic_id = -1;

% Find a device with the name "miniDSP"
for i = 1:numInputDevices
    deviceName = audiodevinfo(1, i-1); % Device IDs start from 0
    if contains(deviceName, uma8sp_mic_name)
        uma8sp_mic_id = i-1;
        break; % Exit the loop once the match is found
    end
end

if uma8sp_mic_id > -1
    disp('microphone found');
else
    disp('microphone not found');
    recording_timestamp = 0;
    return;
end


%% Prepare a real-time audio device

deviceReader = audioDeviceReader(...
 'Device', 'Microphone Array (Intel® Smart Sound Technology (Intel® SST))',...
 'SampleRate', audiosamplingRate, ...
 'NumChannels', audioNumChannels,...
 'OutputDataType','double',...
 'SamplesPerFrame', audiosamplesPerFrame);

% Prepare a audio writer
fileWriter = dsp.AudioFileWriter(audioFile, 'SampleRate', audiosamplingRate, 'FileFormat', 'WAV');


%% Start recording and save it into file
totalOverrun = 0;
disp('Speak into microphone now.')

% Get the current date and time
currentTime = datetime('now');
% Convert to Unix timestamp
recording_timestamp = posixtime(currentTime);

tic
while toc < duration
    [input, numOverrun] = deviceReader();
    totalOverrun = totalOverrun + numOverrun;
    fileWriter(input);
end
disp('Recording complete.')

% release the audio writer and device
release(fileWriter);
release(deviceReader);

end