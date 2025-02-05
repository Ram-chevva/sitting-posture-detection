% Function that takes input a random phase applied fmcw signal, known
% random phases, and scaling factor,
% and returns the original fmcw signal

function [fmcw_signal] = ....
    remove_mtwister_random_phase(fmcw_signal_modified, random_phase_offset, scaling_factor)

% Convert the modified signal back to the frequency domain
fmcw_signal_fft_modified = fft(fmcw_signal_modified);
    
% Remove the random phase offset from the frequency domain signal
fmcw_signal_fft_reconstructed = fmcw_signal_fft_modified ./ random_phase_offset;
    
% Convert the reconstructed signal back to the time domain
fmcw_signal = ifft(fmcw_signal_fft_reconstructed, 'symmetric');

% Apply scaling factor
fmcw_signal = fmcw_signal / scaling_factor;

end