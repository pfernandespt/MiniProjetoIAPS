function sender4(sym, channel, digit_smp, inter_smp)
% sender4 synthesizes and plays the audio when given a symbol matrix
%   receiver4(sym, channel, digit_smp, inter_smp)
%       'sym': matriz of symbols
%       'channel': specifies the channel of the data
%       'digit_smp': number of samples per symbol
%       'inter_smp': number of samples per interval between symbols
%
%   by: Paulo Fernandes, 108678 (UAveiro)

% ========= Fuction Parameters ===========================================

    fs = 24e3;                      % Sampling Fequency
    ts = 1/fs;

    freqs = [ 240  480  720 960;    % Frequencies in the 4D
             1200 1440 1680 1920;
             2160 2400 2640 2880;
             3120 3360 3600 3840];

    t = (0:digit_smp-1) * ts;       % Time definition for each digit

    offset = 7920 * (channel -1);   % Channel Offset

% ========= Digit Creation Handles =======================================

    df = @(f) 0.25 * sin(2*pi*(f + offset).*t);       % digit fragment
    digit = @(s) df(freqs(1,s(1))) + df(freqs(2,s(2))) +...
                 df(freqs(3,s(3))) + df(freqs(4,s(4)));  % digit

% ========= Audio Formation ==============================================
    
    audio = zeros(1,digit_smp *size(sym,2) + inter_smp *(size(sym,2) +1));

    for i = 1:size(sym,2)
        d = digit(sym(:,i));
        d = 0.95 * d/max(d);
        audio((1:digit_smp) + (digit_smp * (i-1) + inter_smp * i)) = d;
    end

% ========= Audio Send ===================================================

    sound(audio,fs);

% ========= Debug ========================================================

    %plot(audio);
    %audiowrite('audio.wav',audio,fs);
    fprintf("DEBUG: message duration: %d ms\n",ts*length(audio)*1e3);

end