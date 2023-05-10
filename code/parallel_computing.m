clear, clc, close all;

%% Criar um pool de trabalhadores com 2 trabalhadores
pool = parpool(2);

%% Iniciar a execução do primeiro script
tic
f1 = parfeval(@fm_receiver,1);

% Iniciar a execução do segundo script
f2 = parfeval(@fm_sender,1);

%% Aguardar até que ambos os scripts terminem
fetchOutputs(f2);
fetchOutputs(f1);
fprintf("Ended Comms\n");
toc

pluto_process_data;