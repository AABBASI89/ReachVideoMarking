function [attempts] = num_of_attempts (data)

clear attempts trialstr trialnum
attempts = [];

for i=1:length(data)
    clear trialstr trialnum
    trialstr = data{i,2};
    trialnum = str2num(trialstr);
    if data{i,3} ~= '1' & data{i,3} ~= '0' | isempty(data{i,3}) == 1
        disp('Trial Ignored')
    elseif data{i,3} == '1'
        attempts = [attempts length(trialnum)-2];
    else
        if isempty(find(trialnum==1)) == 0
            attempts = [attempts length(trialnum)-4];
        elseif isempty(find(trialnum==0)) == 0 & isempty(find(trialnum==1)) == 1
            attempts = [attempts length(trialnum)-2];
        %else
        %    attempts = [attempts length(trialnum)];
        end
    end
end
%     if isempty(trialnum) == 1 || data{i,3} ~= '1'
%         disp('trial ignored');
%     else
%         attempts = [attempts length(trialnum)-2];
%     end