%
% Função para calcular a resposta em frequência a partir da resposta impulsional
%
%     h: resposta impulsional
%     N: número de frequências (entre 0 e pi) em que a resposta em frequência é calculada
%
%     H: resposta em frequência
%     w: frequências usadas (normalizadas, em radianos) 
%
%     Armando J. Pinho (ap@ua.pt)
%     Universidade de Aveiro
%     2022
%
function [H, w] = RespFreq(h, N)
	w = linspace(0, pi, N);
	H = zeros(1, N);
	for n = 1:N
		for k = 1:length(h)
			H(n) = H(n) + h(k) * exp(-j * w(n) * (k-1));
		end
	end