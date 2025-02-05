% Function that takes input the sampling rate, chirp duration, start and
% stop frequencies, and the number of sub-band, and outputs an FMCW signal


function fmcw_signal = generate_multi_fmcw_signal(fs, T_chirp, f_start, f_stop, Nsubbands)

% Generate a single chirp signal
t_chirp = 0:1/fs:T_chirp-1/fs; % Time vector for chirp
if Nsubbands == 1
    fmcw_signal = chirp(t_chirp, f_start, T_chirp, f_stop, 'linear');
else
    % Clean out the fmcw_signal array
    fmcw_signal = zeros(1, length(t_chirp));
    subbandwidth = (f_stop - f_start)/Nsubbands;
    for subIdx = 1:Nsubbands
        fmcw_signal = fmcw_signal + ...
            chirp(t_chirp, f_start + subbandwidth*(subIdx-1), T_chirp, f_start + subbandwidth*subIdx, 'linear');
    end
end

% Normalize the FMCW signal
fmcw_signal = fmcw_signal / max(fmcw_signal);
end