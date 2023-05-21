function sender4(str, channel,digit_smp)

    tic

    %  ========= Fuction Parameters ====================================

    fs = 24e3;                      % Sampling Fequency
    ts = 1/fs;

    freqs = [ 240  480  720 960;       % Frequencies in the 4D
             1200 1440 1680 1920;
             2160 2400 2640 2880;
             3120 3360 3600 3840];

    %digit_dur = 0.0104;                % digit sound duration (s)
    %inter_dur = 0.005;                 % inter digit silence duration (s)
    %digit_smp = fs * digit_dur;
    %digit_smp = 500;
    %inter_smp = fs * inter_dur;
    inter_smp = 80;

    t = (0:digit_smp-1) * ts;       % time definition for each digit

    offset = 7920 * (channel -1);

    %  ========= Digit Creation Handles ================================

    df = @(f) 0.25 * sin(2*pi*(f + offset).*t);       % digit fragment
    digit = @(s) df(freqs(1,s(1))) + df(freqs(2,s(2))) +...
                 df(freqs(3,s(3))) + df(freqs(4,s(4)));  % digit

    %  ========= Audio Formation =======================================

    sym = ascii_to_symbol(str);     % Conversion from ascii to symbols
    
    audio = zeros(1,digit_smp * length(str) + inter_smp * (length(str) +1));

    for i = 1:length(str)
        audio((1:digit_smp) + (digit_smp * (i-1) + inter_smp * i)) = digit(sym(:,i));
    end
    
    toc

    %  ========= Audio Send ============================================

    sound(audio,fs);

    %  ========= Debug ================================================

    %plot(audio);
    %audiowrite('audio.wav',audio,fs);
    fprintf("dur: %d ms\n",ts*length(audio)*1e3);

end

