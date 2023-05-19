function symbols = input_receiver2(audio)

    %  ========= Fuction Parameters ====================================

    fs = 20e3;                      % Sampling Fequency

    freqs = [ 250  500  750 1000;   % Frequencies in the 4D
             1250 1500 1750 2000;
             2250 2500 2750 3000;
             3250 3500 3750 4000];

    tol = 120;                      % Frequency tolerance
    min_samples = 100;              % Minimum samples per digit

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
    num_symbols = length(slot);
    symbols = zeros(4,num_symbols);
    

    for i = 1:length(slot)
        if((slot(2,i) - slot(1,i) + 1) < min_samples)   % Check dimension
            num_symbols = num_symbols - 1;
            fprintf("DEBUG: slot isn't big enough (%d)\n",i);
            continue;
        end
        s = audio(slot(1,i):slot(2,i));         % Isolate symbol

        S = abs(fft(s));                        % Fast Fourier Transform
        freq_res = fs/length(S);                % Frequency resolution
        Sf = (0:(length(S) - 1)) * freq_res;    % Frequency values

        %DEBUG
        %figure()
        %stem(Sf,S,'.');
        fprintf("Received %d samples and de freq_res is %d\n",length(S),freq_res);

        for j = 1:4
            min_pos = floor((freqs(j,1)-tol)/freq_res); % Separate
            max_pos = ceil((freqs(j,4)+tol)/freq_res);

            [~,pos] = max(S(min_pos:max_pos));      % Get max position
            est_freq = Sf(min_pos + pos - 1);       % Estimate frequency

            %DEBUG
            %xline([min_pos max_pos],'Color','red');
            %fprintf("%d    ",est_freq);

            symbols(j,i) = find(((est_freq - tol) < freqs(j,:)),1);
        end

        %DEBUG
        %fprintf('\n');

    end

    symbols = symbols(:,1:num_symbols);         % Delete unused positions

end