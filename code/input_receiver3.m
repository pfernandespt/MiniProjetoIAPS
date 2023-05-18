function symbols = input_receiver3(audio)

    %  ========= Fuction Parameters ====================================

    fs = 20e3;                          % Sampling Fequency

    freqs = [ 250  500  750 1000;       % Frequencies in the 4D
             1250 1500 1750 2000;
             2250 2500 2750 3000;
             3250 3500 3750 4000];

    phases = [-3/4 -1/4 1/4 3/4] * pi;  % Possible Phases

    freq_tol = 120;                     % Frequency tolerance
    phase_tol = pi/4;                   % Phase tolerance
    min_samples = 100;                  % Minimum samples per digit

    [num, den] = butter(5,0.02,'low');

    %  ========= Symbol Detection ======================================

    audio = audio';

    an_detect = filter(num,den,abs(audio));     % Analog symbol detection

    trigger = mean([max(an_detect) min(an_detect)]);
    dg_detect = (an_detect > trigger);          % Conversion to Digital

    %  ========= Symbol Positions Organization =========================

    inv = [dg_detect 0] - [0 dg_detect];    % Digit start and end
    slot = [find(inv == 1);find(inv == -1)];

    %  ========= Symbol Decoding =======================================
    num_symbols = 2*size(slot,2);
    symbols = zeros(4,num_symbols);
    

    for i = 1:2:(num_symbols-1)
        if((slot(2,(i+1)/2) - slot(1,(i+1)/2) + 1) < min_samples)   % Check dimension
            num_symbols = num_symbols - 1;
            fprintf("DEBUG: slot isn't big enough (%d)\n",i);
            continue;
        end
        s = audio(slot(1,(i+1)/2):slot(2,(i+1)/2));  % Isolate symbol

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

        for j = 1:4
            min_pos = floor((freqs(j,1)-freq_tol)/freq_res); % Separate
            max_pos = ceil((freqs(j,4)+freq_tol)/freq_res);

            [~,pos] = max(Smod(min_pos:max_pos));      % Get max position
            pos = pos + min_pos -1;
            est_freq = Sf(pos);             % Estimate frequency
            est_phase = Sphase(pos-1);        % Estimate phase          % COLOQUEI pos-1 AQUI

            %DEBUG
            %xline([min_pos max_pos],'Color','red');
            %fprintf("%d    ",est_freq);

            symbols(j,i) = find(((est_freq - freq_tol) < freqs(j,:)),1);
            symbols(j,i+1) = find(((est_phase - phase_tol) < phases),1);
        end

        %DEBUG
        %fprintf('\n');

    end

    symbols = symbols(:,1:num_symbols);         % Delete unused positions

end