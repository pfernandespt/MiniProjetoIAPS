clear, clc, close all;

f_ver = [697  770  852  941 ];
f_hor = [1209 1336 1477 1633];

symbols = ['1' '2' '3' 'A';
           '4' '5' '6' 'B';
           '7' '8' '9' 'C';
           '*' '0' '#' 'D'];

fs = 48000; % sampling frequency for the audio

digit_dur = 0.1; % digit sound duration (s)
inter_dur = 0; % inter digit silence duration (s)

digit_smp = fs * digit_dur;
inter_smp = fs * inter_dur;

t = (0:digit_smp-1) / fs;

noise_int = 0; % noise intensity

seq = '12345678901234567890123456789012345678901234567890123456789012345678901234567890';

digits = zeros(length(seq),digit_smp);
audio = zeros(1,fs * digit_dur * length(seq) + inter_smp * (length(seq) +1));

for i = 1:length(seq)
    [y,x] = ind2sub(size(symbols),find(symbols == seq(i)));

    digits(i,:) = 0.5 * (sin(2*pi*f_ver(y) * t) + sin(2*pi*f_hor(x) * t));

    audio((1:digit_smp) + (digit_smp * (i-1) + inter_smp * i)) = digits(i,:);
end

noise = noise_int * randn(length(audio), 1)';

audio = audio + noise;
audio = audio / max(abs(audio));

audiowrite('audio.wav',audio,fs);

plot(audio);
title("Audio");