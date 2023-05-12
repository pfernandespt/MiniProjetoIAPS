function input_receiver(audio)

f_ver = [697  770  852  941 ];
f_hor = [1209 1336 1477 1633];
filter_num = 60;
min_digit_dim = 100;
ver_tol = 70/2;
hor_tol = 120/2;
fs = 20e3;

symbols = ['1' '2' '3' 'A';
           '4' '5' '6' 'B';
           '7' '8' '9' 'C';
           '*' '0' '#' 'D'];

h1 = ones(1,filter_num) * 10 / filter_num;

x = conv(abs(audio),h1);
trigger = (max(x) + min(x(filter_num + 10 : length(x) - filter_num - 10))) / 2;
is_digit = (x > trigger)';

inversion = [is_digit 0] - [0 is_digit];

slot = [find(inversion == 1);find(inversion == -1)];

message = '';
for i = 1:length(slot)
    digit = audio(slot(1,i):slot(2,i));
    if(length(digit) < min_digit_dim)
        continue
    end
    D = fft(digit);
    D = abs(D(1:ceil(length(D)/2)));
    
    freqs = zeros(1,2);
    freqs(1) = find(D == max(D));
    D(freqs(1)) = 0;
    freqs(2) = find(D == max(D));
    freqs = sort(freqs);

    freq_res = fs/length(digit);

    freqs = (freqs' -1) * freq_res;

    %freqs = [freqs - freq_res/2 freqs + freq_res/2];
    
    freqs = freqs + [-ver_tol +ver_tol;
                     -hor_tol +hor_tol];

    y = find((f_ver >= freqs(1,1)) & (f_ver <= freqs(1,2)));
    x = find((f_hor) >= freqs(2,1) & (f_hor <= freqs(2,2)));

    if(isempty(x))
        %fprintf("Unable to recognise x frequency. Interval is [%d,%d]\n",freqs(2,1),freqs(2,2));
        message =  [message '?'];
    elseif(isempty(y))
        %fprintf("Unable to recognise y frequency. Interval is [%d,%d]\n",freqs(1,1),freqs(1,2));
        message = [message '?'];
    else
        %fprintf("X:%d Y:%d - S:%s\n",x,y,symbols(y,x));
        message = [message symbols(y,x)];
    end
end
    fprintf("msg: %s\n",message);
end