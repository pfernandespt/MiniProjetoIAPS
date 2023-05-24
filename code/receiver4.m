function symbols = receiver4(audio, channel)

% ========= Fuction Parameters ===========================================

    fs = 24e3;                      % Sampling Fequency

    freqs = [ 240  480  720 960;    % Frequencies in the 4D
             1200 1440 1680 1920;
             2160 2400 2640 2880;
             3120 3360 3600 3840];

    offset = 7920 * (channel - 1);

    min_samples = 200;              % Minimum number of samples
    tol = 110;                      % Frequency tolerance

    %[num, den] = butter(5,0.02,'low');

% ========= Symbol Detection =============================================

    audio = audio';

    %an_detect = filter(num,den,abs(audio));
    an_detect = conv(ones(1,100),abs(audio));   % Analog symbol detection
    
    an_detect_diff = conv(ones(1,100),diff(an_detect));

    [~,strt] = findpeaks(an_detect_diff .*  (an_detect_diff > 0),...
        'MinPeakProminence',10);    % Find positive peaks
    [~,stop] = findpeaks(an_detect_diff .* -(an_detect_diff < 0),...
        'MinPeakProminence',10);    % Find negative peaks
    
    if(length(strt) == length(stop))            % Normal situation
        slot = [strt;stop];
        slot = slot - 100;   % Correct causal systems delay

    elseif(length(strt) - length(stop) == 2)    % Discard sound board noise
        slot = [strt(2:end-1);stop];
        slot = slot - 100;   % Correct causal systems delay
    
    else                                        % Use alternative method
        fprintf("DEBUG: Using alternative detection method\n");

        %trigger = mean([max(an_detect) min(an_detect)]);
        trigger = 5/4 * mean([max(an_detect) min(an_detect)]);

        dg_detect = (an_detect > trigger);      % Conversion to Digital
        dg_detect = dg_detect((50+1):end);

        inv = [dg_detect 0] - [0 dg_detect];    % Digit start and end
        slot = [find(inv == 1);find(inv == -1)];
    end

    %DEBUG
    plot(audio);
    hold on;
    plot(an_detect/50,'Color','black');
    xline(slot(1,:),'Color','green');
    xline(slot(2,:),'Color','red');
    legend("audio","an_detect","symbol_start","symbol_end");
    hold off;

% ========= Symbol Decoding ==============================================
    
    current_symbol = 1;
    symbols = zeros(4,size(slot,2));
    

    for i = 1:size(slot,2)
        if((slot(2,i) - slot(1,i) + 1) < min_samples)   % Check dimension
            fprintf("DEBUG: slot isn't big enough (%d samples)\n",i);
            continue;
        end

        s = audio(slot(1,i):slot(2,i));         % Isolate symbol

        S = abs(fft(s));                        % Fast Fourier Transform
        freq_res = fs/length(S);                % Frequency resolution
        Sf = (0:(length(S) - 1)) * freq_res;    % Frequency values

        %DEBUG
        %figure()
        %stem(Sf,S,'.');
        %fprintf("%d samples -> freq_res: %d\n",length(S),freq_res);

        for j = 1:4
            min_pos = floor((freqs(j,1)+offset-tol)/freq_res); % Separate
            max_pos = ceil((freqs(j,4)+offset+tol)/freq_res);

            [~,pos] = max(S(min_pos:max_pos));         % Get max position
            est_freq = Sf(min_pos + pos - 1) - offset; % Estimate frequency

            %DEBUG
            %xline([min_pos max_pos],'Color','red');
            %fprintf("%d    ",est_freq);
            
            sub_symbol = find(((est_freq - tol) < freqs(j,:)),1);
            if(isempty(sub_symbol))
                sub_symbol = 0;
            end

            symbols(j,current_symbol) = sub_symbol;
            
        end

        if(isempty(find(symbols(:,current_symbol) == 0,1)))
            current_symbol = current_symbol +1;
        else
            fprintf("DEBUG: This is not a digit...\n")
        end

        %DEBUG
        %fprintf('\n');

    end

    symbols = symbols(:,1:(current_symbol-1));  % Delete unused positions

end