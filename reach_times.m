function [O_Pframes,O_Rframes,O_Pseconds,O_Rseconds] = reach_times (data)

clear O_Pframes O_Rframes O_Pseconds O_Rseconds
O_Pframes  = [];
O_Rframes  = [];
O_Pseconds = [];
O_Rseconds = [];

for i=1:length(data)
    clear framestr framenum f_onset f_pellet f_retract
    framestr  = data{i,2};
    framenum  = str2num(framestr);
    if data{i,3} ~= '1' & data{i,3} ~= '0'
        disp('Trial Ignored')
    elseif data{i,3} == '1'
        f_onset   = framenum(length(framenum)-2);
        f_pellet  = framenum(length(framenum)-1);
        f_retract = framenum(length(framenum));
        O_Pframes = [O_Pframes f_pellet  - f_onset];
        O_Rframes = [O_Rframes f_retract - f_onset];
    else
        if isempty(find(framenum==1)) == 0
            x = find(framenum == 1);
            f_onset   = framenum(x-4);
            f_pellet  = framenum(x-3);
            f_retract = framenum(x-1);
            O_Pframes = [O_Pframes f_pellet  - f_onset];
            O_Rframes = [O_Rframes f_retract - f_onset];
        else
            x = find(framenum == 0);
            f_onset  = framenum(x-2);
            f_pellet = framenum(x-1);
            O_Pframes = [O_Pframes f_pellet  - f_onset];
        end
    end
end


    
    %if isempty(framenum) == 1 || data{i,3} ~= '1'
    %    disp('trial ignored');
%         f_onset   = framenum(length(framenum)-2);
%         f_pellet  = framenum(length(framenum)-1);
%         f_retract = framenum(length(framenum));
%         O_Pframes = [O_Pframes f_pellet  - f_onset];
%         O_Rframes = [O_Rframes f_retract - f_onset];
%     end
O_Pseconds = O_Pframes * (1/30);
O_Rseconds = O_Rframes * (1/30);