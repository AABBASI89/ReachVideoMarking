function [successpct,failurepct,ignoredpct,reachedpct,success,failure,ignored] = pct_reaching_success (data)

clear success failure ignored nopellet successpct failurepct ignoredpct reachedpct
success  = [];
failure  = [];
ignored  = [];
nopellet = [];

for i=1:length(data)
    if data{i,3} == '1'
        success  = [success 1];
    elseif data {i,3} == '0'
        failure  = [failure 1];
    elseif data {i,3} == '2'
        ignored  = [ignored 1];
    else
        nopellet = [nopellet 1];
    end
end
successpct = (length(success)/(length(success)+length(failure)))*100;
failurepct = (length(failure)/(length(success)+length(failure)))*100;
reachedpct = ((length(success)+length(failure))/(length(data)-length(nopellet)))*100;
ignoredpct = (length(ignored)/(length(data)-length(nopellet)))*100;