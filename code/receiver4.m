function symbols = receiver4(audio,channel)

    %  ========= Fuction Parameters ====================================

    fs = 24e3;                      % Sampling Fequency

    freqs = [ 240  480  720 960;       % Frequencies in the 4D
             1200 1440 1680 1920;
             2160 2400 2640 2880;
             3120 3360 3600 3840];

    samples = [24 12 8 6 4.8 4 3 2.4 2 1.6 1.5 1.2 1 0.8 0.6 0.5 0.4 0.3 0.2] * 1e3;

    tol = 120;                      % Frequency tolerance

    [num, den] = butter(5,0.02,'low');
    filter_delay = 50;              % Filter delay in number of samples

    offset = 7920 * (channel - 1);

    %  ========= Symbol Detection ======================================

    audio = audio';

    an_detect = filter(num,den,abs(audio));     % Analog symbol detection

    trigger = mean([max(an_detect) min(an_detect)]);
    dg_detect = (an_detect > trigger);           % Conversion to Digital
    dg_detect = dg_detect((filter_delay+1):end);

    % DEBUG
    % plot(audio);
    % hold on;
    % plot(dg_detect);
    % hold off;

    %  ========= Symbol Positions Organization =========================

    inv = [dg_detect 0] - [0 dg_detect];    % Digit start and end
    slot = [find(inv == 1);find(inv == -1)];

    %  ========= Symbol Decoding =======================================
    num_symbols = length(slot);
    symbols = zeros(4,num_symbols);
    

    for i = 1:length(slot)
        if((slot(2,i) - slot(1,i) + 1) < samples(end))   % Check dimension
            num_symbols = num_symbols - 1;
            fprintf("DEBUG: slot isn't big enough (%d)\n",i);
            continue;
        end
        s = audio(slot(1,i):slot(2,i));         % Isolate symbol
        %s = s(1:samples(find(length(s) > samples,1)));  % Adapt samples to regular steps

        S = abs(fft(s));                        % Fast Fourier Transform
        freq_res = fs/length(S);                % Frequency resolution
        Sf = (0:(length(S) - 1)) * freq_res;    % Frequency values

        %DEBUG
        %figure()
        %stem(Sf,S,'.');
        %fprintf("Received %d samples and de freq_res is %d\n",length(S),freq_res);

        for j = 1:4
            min_pos = floor((freqs(j,1)+offset-tol)/freq_res); % Separate
            max_pos = ceil((freqs(j,4)+offset+tol)/freq_res);

            [~,pos] = max(S(min_pos:max_pos));         % Get max position
            est_freq = Sf(min_pos + pos - 1) - offset; % Estimate frequency

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