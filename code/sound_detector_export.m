clear, clc, close all;

fs = 20e3;
chunk_dur = 0.1;
chunk = fs * chunk_dur;

audio_input_id = 2; % VB CABLE
rec = audiorecorder(fs,16,1,audio_input_id);

stop(rec);
record(rec);

% Calculo da energia de trigger
pause(chunk_dur * 2);
audio = getaudiodata(rec);
trigger = sum(abs(audio).^2) * 2;

is_playing = 0;

while(true)
    audio = getaudiodata(rec);
    audio_chunk = audio((end - chunk + 1):end);
    E = sum(abs(audio_chunk).^2);

    if(is_playing)
        if(E < trigger)
            fprintf("Ended\n")
            audio = audio(first_pos:end);
            input_receiver(audio);
            plot(audio);
            is_playing = 0;
            reset(rec);
            pause(chunk_dur);
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

function reset(obj)
        %fprintf("DEBUG BEFORE: %d\n",obj.TotalSamples);
        stop(obj);
        record(obj);
        %fprintf("DEBUG AFTER: %d\n",obj.TotalSamples);
end
