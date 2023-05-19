function symbols = input_receiver3(audio)

    %  ========= Fuction Parameters ====================================

    fs = 20e3;                          % Sampling Fequency

    freqs = [ 240  480  720 960;       % Frequencies in the 4D
             1200 1440 1680 1920;
             2160 2400 2640 2880;
             3120 3360 3600 3840];

    phases = [-3/4 -1/4 1/4 3/4] * pi;  % Possible Phases

    samples = [24 12 8 6 4.8 4 3 2.4 2 1.6 1.5 1.2 1 0.8 0.6 0.5 0.25 0.3 0.2] * 1e3;

    freq_tol = 120;                     % Frequency tolerance
    phase_tol = pi/4 * 0.95;                   % Phase tolerance
    
    [num, den] = butter(5,0.02,'low');

    %  ========= Symbol Detection ======================================
    audio = audio';

    an_detect = filter(num,den,abs(audio));     % Analog symbol detection

    trigger = mean([max(an_detect) min(an_detect)]);
    dg_detect = (an_detect > trigger);          % Conversion to Digital

%     figure()
%     hold on;
%     plot(audio);
%     plot(dg_detect);

    %  ========= Symbol Positions Organization =========================

    inv = [dg_detect 0] - [0 dg_detect];    % Digit start and end
    slot = [find(inv == 1);find(inv == -1)];

    %  ========= Symbol Decoding =======================================
    num_symbols = 2*size(slot,2);
    symbols = zeros(4,num_symbols);
    

    for i = 1:2:(num_symbols-1)
        if((slot(2,(i+1)/2) - slot(1,(i+1)/2) + 1) < samples(end))   % Check dimension
            num_symbols = num_symbols - 2;
            fprintf("DEBUG: slot isn't big enough (%d)\n",i);
            continue;
        end
        s = audio((slot(1,(i+1)/2)-50):(slot(2,(i+1)/2)-50));  % Isolate symbol

        fprintf("was: %d",length(s));

        s = s(1:samples(find(length(s) > samples,1)));  % Adapt samples to the minimum required

        fprintf("  is: %d",length(s));

%         figure()
%         plot(s);

        S = fft(s);                             % Fast Fourier Transform
        Smod = abs(S);                          % FFT module
        Sphase = angle(S);                      % FFT angle
        freq_res = fs/length(S);                % Frequency resolution
        Sf = (0:(length(S) - 1)) * freq_res;    % Frequency values

        %DEBUG
        figure()
        stem(Smod,'.');
        hold on;
        stem(Sphase,'.');
        yline(phases);
        yline(phases-phase_tol,'Color','red');

        for j = 1:4
            min_pos = floor((freqs(j,1)-freq_tol)/freq_res); % Separate
            max_pos = ceil((freqs(j,4)+freq_tol)/freq_res);

            [~,pos] = max(Smod(min_pos:max_pos));      % Get max position
            pos = pos + min_pos -1;
            est_freq = Sf(pos);             % Estimate frequency
            est_phase = Sphase(pos);        % Estimate phase

            %DEBUG
            %xline([min_pos max_pos],'Color','red');
            %fprintf("%d    ",est_freq);

            symbols(j,i) = find(((est_freq - freq_tol) < freqs(j,:)),1);
            symbols(j,i+1) = find(((est_phase - phase_tol) < phases),1);
        end

        %DEBUG
        %fprintf('\n');

    end

    symbols = symbols(:,1:num_symbols)          % Delete unused positions

end