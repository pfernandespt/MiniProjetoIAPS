clear, clc, close all;

addpath('gui\');
cleanupObj = onCleanup(@endProgram);

fs = 24e3;
chunk_dur = 0.1;
chunk = fs * chunk_dur;

rec = audiorecorder(fs,16,1,selectMic());

app = findobj(gui4);

[num_ch1, den_ch1] = butter(3,0.5,"low");
[num_ch2, den_ch2] = butter(3,0.5,"high");

stop(rec);
record(rec);

while(~isrecording(rec))
end

fprintf("Recording!\n");

% Calculo da energia de trigger
pause(chunk_dur * 10);
audio = getaudiodata(rec);
app.trigger.Value = max(sum(abs(audio).^2) * 10,5);

is_playing = 0;

while(isrecording(rec))
    trigger = app.trigger.Value;
    audio = getaudiodata(rec);
    audio_chunk = audio((end - chunk + 1):end);

    if(app.channel.Value == 1)
        audio_chunk = filter(num_ch1,den_ch1,audio_chunk);
    else
        audio_chunk = filter(num_ch2,den_ch2,audio_chunk);
    end

    E = sum(abs(audio_chunk).^2);

    if(is_playing)
        if(E < trigger)
            fprintf("Ended\n")
            audio = audio(first_pos:end);
            message = decrypt(symbol_to_ascii(receiver4(audio,app.channel.Value)),app.password.Value);
            if(~isempty(message))
                app.msg_box.Value = [app.msg_box.Value; '' ;strcat("[←] ",message)];
                plot(app.graph,audio);
            end
            is_playing = 0;
            reset(rec);
            pause(chunk_dur*5);
        end
    elseif(E > trigger)
        fprintf("Started ");
        first_pos = rec.CurrentSample - 2*chunk;
        is_playing = 1;
    end
    if(rec.TotalSamples >= fs * 300)
        reset(rec);
        pause(chunk_dur);
    end
    pause(chunk_dur);
end

delete(rec);
delete(app);

function reset(obj)
        %fprintf("DEBUG BEFORE: %d\n",obj.TotalSamples);
        stop(obj);
        record(obj);
        %fprintf("DEBUG AFTER: %d\n",obj.TotalSamples);
end

function endProgram()
    delete(rec);
    delete(app);
end