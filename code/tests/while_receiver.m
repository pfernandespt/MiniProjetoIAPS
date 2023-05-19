function while_receiver(index)

if nargin == 0
    index = 2;
end

close all;

f_ver = [697  770  852  941 ];
f_hor = [1209 1336 1477 1633];
ver_tol = 70/2;
hor_tol = 120/2;

symbols = ['1' '2' '3' 'A';
           '4' '5' '6' 'B';
           '7' '8' '9' 'C';
           '*' '0' '#' 'D'];

% Set the sampling frequency and duration of each recording chunk
fs = 48000; % sampling frequency (Hz)
chunkSize = 4800; % number of samples to record in each iteration

freq_res = fs/chunkSize;

% Create an audio recorder object
recObj = audiorecorder(fs, 16, 1,index);

% Start recording
disp('Start speaking.');
record(recObj);

% Set up the figure for real-time plotting
figure;
h = stem(nan(ceil(chunkSize/2),1),'x');
ylim([0,3000]); % adjust the y-axis limits as needed
xlabel('Sample Index');
ylabel('Magnitude');
title('Real-time FFT of Recorded Sound');

pause(1);

% Continuously record and plot data until the user stops the recording
while isrecording(recObj)
    % Get the latest data and calculate the FFT
    data = getaudiodata(recObj);
    N = length(data);
    D = fft(data(end-chunkSize+1:end));
    D = D(1:ceil(length(D)/2));
    f = fs*(0:chunkSize-1)/chunkSize;


    % Update the plot with the latest FFT data
    set(h, 'YData', abs(D));
    drawnow;

    % Search for the frequencies
    freqs = zeros(1,2);
    freqs(1) = find(D == max(D));
    D(freqs(1)) = 0;
    freqs(2) = find(D == max(D));
    freqs = sort(freqs);

    freqs = (freqs' -1) * freq_res;

    freqs = freqs + [-ver_tol +ver_tol;
                     -hor_tol +hor_tol];

    y = find((f_ver >= freqs(1,1)) & (f_ver <= freqs(1,2)));
    x = find((f_hor) >= freqs(2,1) & (f_hor <= freqs(2,2)));

    if(~isempty(x) && ~isempty(y))
        %fprintf("Freqs: (%d,%d)",freqs(1),freqs(2));
        %fprintf("   Coords: (%d,%d)",x,y);
        %fprintf("Digit:");
        fprintf(symbols(y,x));
        %fprintf('\n');
    end

    
end

end