clear, clc, close all;

f_ver = [697  770  852  941 ];
f_hor = [1209 1336 1477 1633];
ver_tol = 70/2;
hor_tol = 120/2;

symbols = ['1' '2' '3' 'A';
           '4' '5' '6' 'B';
           '7' '8' '9' 'C';
           '*' '0' '#' 'D'];

% Set up audio recording parameters
fs = 44100;
samples_per_digit = 9600;
chunkSize = samples_per_digit/2;

recObj = audiorecorder(fs, 16, 1);

% Set up the figure for real-time plotting
figure;
h = stem(nan(ceil(chunkSize/2),1),'Marker','*');
ylim([0,500]);
xlabel('Sample Index');
ylabel('Magnitude');
title('Real-time FFT of Recorded Sound');

% Continuously record and plot data until the user stops the recording
while isrecording(recObj)
    % Get the latest data and calculate the FFT
    data = getaudiodata(recObj);
    N = length(data);
    D = fft(data(end-chunkSize+1:end));
    %D = abs(D(1:ceil(length(D)/2)));
    f = fs*(0:chunkSize-1)/chunkSize;
    
    % Update the plot with the latest FFT data
    set(h, 'YData', abs(D));

    drawnow;
end


