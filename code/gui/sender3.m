function sender3(str)

    tic

    %  ========= Fuction Parameters ====================================

    fs = 20e3;                          % Sampling Fequency
    ts = 1/fs;

    freqs = [ 240  480  720 960;       % Frequencies in the 4D
             1200 1440 1680 1920;
             2160 2400 2640 2880;
             3120 3360 3600 3840];

    phases = [-3/4 -1/4 1/4 3/4] * pi;  % Possible Phases

    digit_dur = 0.1;                    % digit sound duration (s)
    inter_dur = 0.005;                  % inter digit silence duration (s)
    digit_smp = fs * digit_dur;
    inter_smp = fs * inter_dur;

    t = (0:digit_smp-1) * ts;       % time definition for each digit

    %  ========= Digit Creation Handles ================================

    df = @(f,p) 0.25 * sin(2*pi*f.*t - p);       % digit fragment            % COLOQUEI MENOS AQUI!!!!!
    digit = @(s1,s2) df(freqs(1,s1(1)),phases(s2(1))) + ...
                     df(freqs(2,s1(2)),phases(s2(2))) + ...
                     df(freqs(3,s1(3)),phases(s2(3))) + ...
                     df(freqs(4,s1(4)),phases(s2(4)));  % digit

    %  ========= Audio Formation =======================================

    if(rem(length(str),2))
        str = [str '\0'];
    end

    sym = ascii_to_symbol(str);     % Conversion from ascii to symbols
    
    audio = zeros(1,fs * digit_dur * (length(str)/2) + inter_smp * (length(str)/2 +1));

    for i = 1:2:(length(str)-1)
        audio((1:digit_smp) + (digit_smp * ((i+1)/2-1) + inter_smp * (i+1)/2)) = digit(sym(:,i),sym(:,i+1));
    end
    
    toc

    %  ========= Audio Send ============================================

    sound(audio,fs);

    %  ========= Debug ================================================

    %plot(audio);
    fprintf("SENDER DEBUG ON!\n");
    audiowrite('audio.wav',audio,fs);
    fprintf("dur: %d ms\n",ts*length(audio)*1e3);

end

