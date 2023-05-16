%
% Função para quantizar um sinal (usando a função round):
%	x: sinal a quantizar
%	b: número de bits da representação
%
%	Nota: caso o sinal tenha valores inferiores a -1, esses valores serão
%	convertidos em -1. Se existirem valores superiores a 1, eles serão
%	convertidos em 1.
%
%	Armando J. Pinho (ap@ua.pt)
%	Universidade de Aveiro
%	2020
%

function xq = xQuant(x, b)
	% Se necessário, limita a amplitude de x ao intervalo [-1, 1]
	x(x < -1) = -1;
	x(x > 1) = 1;

	% Número de níveis de quantização
	N = 2^b;

	% O sinal é inicialmente normalizado para o intervalo [0 1]
	xnorm = (x + 1) / 2;

	% Quantização para níveis inteiros
	% xnorm * N - 0.5 -> [-0.5 (N-0.5)]
	xqnorm =  round(xnorm * N - 0.5);

	% Evita gerar mais níveis nos extremos
	xqnorm(xqnorm == -1) = 0;
	xqnorm(xqnorm == N) = N-1;

	% O sinal é reposto no intervalo [0 1]
	xqnorm = (xqnorm + 0.5) / N;

	% Reposição da gama original de amplitudes do sinal
	xq = xqnorm * 2 - 1;