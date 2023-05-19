clear, clc
%close all;

[num, den] = butter(5,0.02,'low');

h = ones(1,100) / 100;
[H1, w] = RespFreq(h,1000);
figure();
subplot(2,1,1);
hold on;
plot(w/pi,abs(H1));

[H, w] = freqz(num,den);

plot(w/pi,abs(H));

resp_imp = impz(num,den);
subplot(2,1,2);
plot(resp_imp);