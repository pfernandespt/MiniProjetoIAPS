% ========================================================================
% Funcao que permite selecionar um dos metodos de saida de audio
% disponiveis no computador
%
%   index = selectSpeaker()
%
% por: Paulo Fernandes (108678 UA)
% ========================================================================

function index = selectSpeaker()
    devices = audiodevinfo; % Get information about all audio interfaces

    % Enumerate all the available devices

    if(isempty(devices.output))
        fprintf("there are no output audio devices...")
        index = nan;
        return;
    end

    if(length(devices.output) == 1)
        fprintf("there's only one output audio device: %s",devices.output(1).Name);
        index = 0;
        return;
    end

    fprintf("===== Audio Output Devices =========================================================\n");

    for i = 1:length(devices.output)
        fprintf('  %d. %s\n', i, devices.output(i).Name);
    end

    fprintf("====================================================================================\n");

    % Select the desired device
    while(true)
        index = input(" Enter Device ID: ");
        if((index < 1) || (index > length(devices.output)))
            fprintf(" Invalid ID...");
        else
            index = index -1;
            break;
        end
    end
end