% clear, clc
% %close all;
% 
% [num, den] = butter(5,0.02,'low');
% 
% h = ones(1,100) / 100;
% [H1, w] = RespFreq(h,1000);
% figure();
% subplot(2,1,1);
% hold on;
% plot(w/pi,abs(H1));
% 
% [H, w] = freqz(num,den);
% 
% plot(w/pi,abs(H));
% 
% resp_imp = impz(num,den);
% subplot(2,1,2);
% plot(resp_imp);

%% Diferenciador de canais

close all;

[num_ch1, den_ch1] = butter(3,0.5,"low");
[num_ch2, den_ch2] = butter(3,0.5,"high");

figure()
%subplot(1,2,1);
[H,w] = freqz(num_ch1,den_ch1);
plot(w/pi * 12e3,abs(H));
xline([240 3840],'Color','green','LineWidth',1);
xline([8160 11760],'Color','red','LineWidth',1);
xlabel('Frequência [Hz]')
ylabel('Ganho');
title('Filtro CH1');
%subplot(1,2,2);
figure();
[H,w] = freqz(num_ch2,den_ch2);
plot(w/pi * 12e3,abs(H));
xline([240 3840],'Color','red','LineWidth',1);
xline([8160 11760],'Color','green','LineWidth',1);
xlabel('Frequência [Hz]');
ylabel('Ganho');
title('Filtro CH2');