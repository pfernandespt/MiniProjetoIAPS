% ========================================================================
% Funcao que permite selecionar um dos metodos de entrada de audio
% disponiveis no computador
%
%   index = selectMic()
%
% por: Paulo Fernandes (108678 UA)
% ========================================================================

function index = selectMic()
    devices = audiodevinfo; % Get information about all audio interfaces

    % Enumerate all the available devices

    if(isempty(devices.input))
        fprintf("there are no input audio devices...")
        index = nan;
        return;
    end

    if(length(devices.input) == 1)
        fprintf("there's only one input audio device: %s",devices.input(1).Name);
        index = 0;
        return;
    end

    fprintf("===== Audio Input Devices ===========================================================\n");

    for i = 1:length(devices.input)
        fprintf('  %d. %s\n', i, devices.input(i).Name);
    end

    fprintf("====================================================================================\n");

    % Select the desired device
    while(true)
        index = input(" Enter Device ID: ");
        if((index < 1) || (index > length(devices.input)))
            fprintf(" Invalid ID...");
        else
            index = index -1;
            break;
        end
    end
    
    
end

