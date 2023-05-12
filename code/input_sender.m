function message_sender(str)

f_ver = [697  770  852  941 ];
f_hor = [1209 1336 1477 1633];

symbols = ['1' '2' '3' 'A';
           '4' '5' '6' 'B';
           '7' '8' '9' 'C';
           '*' '0' '#' 'D'];

fs = 48000; % sampling frequency for the audio
ts = 1/fs;

digit_dur = 0.2; % digit sound duration (s)
inter_dur = 0.001; % inter digit silence duration (s)

digit_smp = fs * digit_dur;
inter_smp = fs * inter_dur;

t = (0:digit_smp-1) * ts;

message = zeros(1,fs * digit_dur * length(str) + inter_smp * (length(str) +1));

for i = 1:length(str)
    [y,x] = ind2sub(size(symbols),find(symbols(:)' == str(i)));

    if((isempty(y)) || (isempty(x)))
        x = 3;
        y = 4;
    end

    digit = 0.5 * (sin(2*pi*f_ver(y) * t) + sin(2*pi*f_hor(x) * t));
    message((1:digit_smp) + (digit_smp * (i-1) + inter_smp * i)) = digit;
end

sound(message,fs);
fprintf("dur: %d ms\n",ts*length(message)*1e3);

end