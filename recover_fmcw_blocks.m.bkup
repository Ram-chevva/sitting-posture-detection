
% Function that takes input the capture audio signals, original fmcw
% signal, random phases and scaling factors introduced during transmission
% and output recovered fmcw signals

function [tx_fmcw_signal_reconstructed, rx_fmcw_signal_reconstructed] = ...
    recover_fmcw_blocks(audioData, sampleRate, fmcw_signal, ...
    random_phase_fmcw_signals, random_phase_offsets, scaling_factors)

% Cross-correlation between transmitted (random phase) and received signal
% for block level synchronization
audioData_mic0 = audioData(:, 1);

% Check for at least 1 blocks
blockLength = size(random_phase_fmcw_signals, 2);
% Check if the vector length is smaller than the column size
if length(audioData_mic0) < blockLength
    error('Not enough sample received for one FMCW block!');
end

% Compute the cross-correlation between entire received signal with the
% first block of transmitted signal
[c, lags] = xcorr(audioData_mic0, random_phase_fmcw_signals(1, :));

% Find the index of the maximum correlation value
[~, I] = max(c);

% Find the starting index of B in A
startIndex = lags(I) + 1;

% Signal is now first block synchronized
% We need to synchronize once at the beginning as the speaker and 
% all microphones share the same sampling clock.
audioData_mic0_sync = audioData_mic0(startIndex:end);

% Extract all the blocks
% Calculate the number of complete rows that can be formed
numBlock = floor(length(audioData_mic0_sync) / blockLength);

% Reshape the vector into a matrix with the calculated number of rows
fmcw_signals_received = reshape(...
    audioData_mic0_sync(1:numBlock * blockLength), blockLength, numBlock).';

% From transmitted with random phases -- not needed, really
% Recover fmcw signals by removing the known random phases
% Example recovery for transmitted signals
tx_fmcw_signal_reconstructed = zeros(size(random_phase_fmcw_signals));
for tx_blockIdx = 1:size(random_phase_fmcw_signals, 1)
    tx_fmcw_signal_reconstructed(tx_blockIdx, :) = ...
        remove_mtwister_random_phase(random_phase_fmcw_signals(tx_blockIdx, :), ...
        random_phase_offsets(tx_blockIdx, :), scaling_factors(tx_blockIdx, :));
end

% From received with random phases
% Recover fmcw signals by removing the known random phases
rx_fmcw_signal_reconstructed = zeros(size(fmcw_signals_received));
for rx_blockIdx = 1:size(fmcw_signals_received, 1)
    rx_fmcw_signal_reconstructed(rx_blockIdx, :) = ...
        remove_mtwister_random_phase(fmcw_signals_received(rx_blockIdx, :), ...
        random_phase_offsets(rx_blockIdx, :), scaling_factors(rx_blockIdx, :));
end

%%{
figure(1);
% Obtain and display the spectrogram
window = 256; % Size of the FFT window, adjust based on your requirements
noverlap = []; % Number of overlapping samples in adjacent segments (optional, can be empty for default)
nfft = 1024; % Number of FFT points, adjust for frequency resolution

% Use the spectrogram function
[s,f,t,p] = spectrogram(fmcw_signal, window, noverlap, nfft, sampleRate, 'yaxis');

% Display the spectrogram
surf(t,f,10*log10(abs(p)),'EdgeColor','none');
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Spectrogram of the original FMCW Signal');
% Optional: Colorbar to indicate power dB
colorbar;

figure(2);
% Use the spectrogram function
[s,f,t,p] = spectrogram(tx_fmcw_signal_reconstructed(1, :), window, noverlap, nfft, sampleRate, 'yaxis');

% Display the spectrogram
surf(t,f,10*log10(abs(p)),'EdgeColor','none');
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Spectrogram of the transmitted (recovered) FMCW Signal');
% Optional: Colorbar to indicate power dB
colorbar;

for rx_blockIdx = 1:size(rx_fmcw_signal_reconstructed, 1)

figure(3);
% Use the spectrogram function
[s,f,t,p] = spectrogram(rx_fmcw_signal_reconstructed(rx_blockIdx, :), window, noverlap, nfft, sampleRate, 'yaxis');

% Display the spectrogram
surf(t,f,10*log10(abs(p)),'EdgeColor','none');
axis xy; axis tight; colormap(jet); view(0,90);
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title(sprintf('Spectrogram of the received FMCW Signal - Block %d', rx_blockIdx));
% Optional: Colorbar to indicate power dB
colorbar;
drawnow;
end
%%}

end