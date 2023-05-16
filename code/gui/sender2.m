function sender2(str)

    tic

    %  ========= Fuction Parameters ====================================

    fs = 20e3;                      % Sampling Fequency
    ts = 1/fs;

    freqs = [ 250  500  750 1000;   % Frequencies in the 4D
             1250 1500 1750 2000;
             2250 2500 2750 3000;
             3250 3500 3750 4000];

    digit_dur = 0.02;               % digit sound duration (s)
    inter_dur = 0.005;              % inter digit silence duration (s)
    digit_smp = fs * digit_dur;
    inter_smp = fs * inter_dur;

    t = (0:digit_smp-1) * ts;       % time definition for each digit

    %  ========= Digit Creation Handles ================================

    df = @(f) 0.25 * sin(2*pi*f.*t);       % digit fragment
    digit = @(s) df(freqs(1,s(1))) + df(freqs(2,s(2))) +...
                 df(freqs(3,s(3))) + df(freqs(4,s(4)));  % digit

    %  ========= Audio Formation =======================================

    sym = ascii_to_symbol(str);     % Conversion from ascii to symbols
    
    audio = zeros(1,fs * digit_dur * length(str) + inter_smp * (length(str) +1));

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

