
% Function inputs an unmodified fmcw signal and apply random phase
% offsets
% Output is the new fmcw signal, the applied random phase, and the
% corresponding scaling factor
function [new_fmcw_signal, random_phase_offset, scaling_factor] = apply_mtwister_random_phase(fmcw_signal)

% Set the random number generator to use Mersenne Twister
% rng('default');
rng('shuffle', 'twister');

% Convert the FMCW signal to the frequency domain
fmcw_signal_fft = fft(fmcw_signal);

% Generate a random phase offset
N = length(fmcw_signal_fft);
random_phase_offset = exp(2i * pi * rand(N, 1, 'single')).';

% Apply the random phase offset to the frequency domain signal
fmcw_signal_fft_modified = fmcw_signal_fft .* random_phase_offset;

% Convert the modified signal back to the time domain
new_fmcw_signal = ifft(fmcw_signal_fft_modified, 'symmetric');

% Maintain peak-to-peak

% Calculate the peak-to-peak value of the original signal
original_p2p = max(fmcw_signal) - min(fmcw_signal);

% Calculate the peak-to-peak value of the modified signal
modified_p2p = max(new_fmcw_signal) - min(new_fmcw_signal);

% Calculate the scaling factor to maintain the original peak-to-peak value
scaling_factor = original_p2p / modified_p2p;

% Apply the scaling factor to the modified signal
new_fmcw_signal = new_fmcw_signal * scaling_factor;

end