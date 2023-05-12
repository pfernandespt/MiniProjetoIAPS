% Set up the audio device reader
fs = 48000; % Sample rate
bufferSize = 4800; % Buffer size
adr = audioDeviceReader('SampleRate', fs, 'SamplesPerFrame',bufferSize);
adr.SampleRate = fs;
adr.SamplesPerFrame = bufferSize;
adr.Device = "Virtual Cable (VB-Audio Virtual Cable)";


% Set up the plot
% figure;
% ax = axes;
% h = plot(ax, zeros(bufferSize, 1));
% ylim([-1 1]);

treshold = sum(abs(adr()).^2) * 2;
sound_playing = 0;

% Loop to continuously record and plot audio
while true
    % Read audio data from the audio device reader
    audioData = adr();
    
    E = sum(abs(audioData).^2);
    trigger = E > treshold;

    %disp(E);
    
    if(sound_playing)
        if(~trigger)
            fprintf("Sound Stopped");
            toc
            sound_playing = 0;
        end
    elseif(trigger)
        sound_playing = 1;
        fprintf("Sound Playing\n");
        tic
    end

    % Pause for 0.1 seconds
    pause(0.1);
end