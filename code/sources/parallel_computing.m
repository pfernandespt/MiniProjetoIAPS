clear, clc, close all;

pool = parpool('local');

%%
fprintf("Parallel Computing: Starting Program\n");


f1 = parfeval(@microfone_test, 0,selectMic());

fprintf("Enter Messages to Send\n");

    while(true)
        while true
            str = input(">>>>",'s');
        if(str == "close_app")
            break;
        end
            message_sender(str);
            %f2 = parfeval(@message_sender,0,str);
        end
    end