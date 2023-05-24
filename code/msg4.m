clear, clc, close all;

addpath('gui\');    % include App GUI path

% ========= Script Parameters ============================================

fs = 24e3;          % Sampling frequency
chunk_dur = 0.1;    % Audio chunk duration to analyse in seconds
chunk = fs * chunk_dur;

max_fails = 3;      % Maximum number of fails to detect end of message
is_playing = 0;     % Flag

% ========= Initialization ===============================================

rec = audiorecorder(fs,16,1,selectMic());   % Create recording object

app = findobj(gui4);    % Open App GUI

[num_ch1, den_ch1] = butter(3,0.5,"low");  % LowPass  Butter Filter for CH1
[num_ch2, den_ch2] = butter(3,0.5,"high"); % HighPass Butter Filter for CH2

stop(rec);      % stop previous recording
record(rec);    % start recording

while(~isrecording(rec))    % Wait while mic is initializing
end

fprintf("Recording!\n");

% ========= Noise Measurement ============================================

pause(chunk_dur * 10);      % Read 1 second of noise
audio = getaudiodata(rec);
app.trigger.Value = max(sum(abs(audio).^2) * 10,5); % Set trigger

% ========= Monitoring Part ==============================================

while(isrecording(rec))

    trigger = app.trigger.Value;
    audio = getaudiodata(rec);
    audio_chunk = audio((end - chunk + 1):end);

    if(app.channel.Value == 1)  % Apply filter based on selected Channel
        audio_chunk = filter(num_ch1,den_ch1,audio_chunk);  % CH1
    else
        audio_chunk = filter(num_ch2,den_ch2,audio_chunk);  % CH2
    end

    E = sum(abs(audio_chunk).^2);   % Calculate Energy

    if(is_playing)  % If a message is already playing
        if(E < trigger)
            fails = fails + 1;
            
            if(fails > max_fails)
                fprintf("Ended\n")
                audio = audio(first_pos:end);

                symbols = receiver4(audio,app.channel.Value);   % Receive
                message = symbol_to_ascii(symbols);             % Convert
                message = decrypt(message,app.password.Value);  % Decrypt

                if(~isempty(message))
                    box = [app.msg_box.Value; '' ;strcat("[←] ",message)];
                    app.msg_box.Value = box;
                    plot(app.graph,audio);
                end

                is_playing = 0;
                reset(rec); % Reset audio buffer
                pause(chunk_dur*5);
            end
        end
    elseif(E > trigger) % When message is not already playing
        fprintf("Started ");
        fails = 0;
        first_pos = rec.CurrentSample - 2*chunk;    % Save start position
        is_playing = 1;
    end

    if(rec.TotalSamples >= fs * 300)    % If system is idle for 5 min
        reset(rec);     % Reset audio buffer
        pause(chunk_dur);
    end

    pause(chunk_dur);   % Wait for the next chunk
end

delete(rec);    % Stop recording
delete(app);    % Close App GUI

function reset(obj)
        %fprintf("DEBUG BEFORE: %d\n",obj.TotalSamples);
        stop(obj);
        record(obj);
        %fprintf("DEBUG AFTER: %d\n",obj.TotalSamples);
end