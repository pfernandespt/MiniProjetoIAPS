clear, clc, close all;

t1 = timer('TimerFcn',@(~,~)teste,'Period',1,'ExecutionMode','fixedRate');
t2 = timer('TimerFcn',@(~,~)teste2,'Period',0.5,'ExecutionMode','fixedRate');

start([t1 t2]);


num = 1;

function teste

    fprinft("OLA")
end


function teste2
    fprintf(num)
end
