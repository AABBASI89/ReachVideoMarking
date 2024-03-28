function getResults_Callback(hObject, eventdata)

global vid_fig_hand;
expected_blocks = 1;

days_path = vid_fig_hand.VID_DIR_handle.String;

if ~exist([days_path, '\Results'],'dir')
    mkdir([days_path, '\Results']);
end

data_names = dir([days_path, '\*man*.mat']);
all_time_strs = '';
all_times = nan(0,1);
for data_i = 1:length(data_names)
    time_idx = regexp(data_names(data_i).name,'\d\d?h\d?\dm');
    time_str = data_names(data_i).name(time_idx:time_idx+4);
    time = time_str;
    if time(5) == ')'
        time = ['0', time(1), '0', time(3)];
    elseif time(5) == 'm'
        if time(2) == 'h'
            time = ['0', time(1), time(3:4)];
        else
            time = [time(1:2), '0', time(4)];
        end
    else
        time = [time(1:2), time(4:5)];
    end
    time = str2double(time);
    new_time = true;
    for time_i = 1:size(all_time_strs,1)
        if time == all_times(time_i)
            new_time = false;
            continue
        end
    end
    if new_time
        all_time_strs = cat(1, all_time_strs, time_str);
        all_times = cat(1, all_times, time);
    end
end

if size(all_time_strs,1) ~= expected_blocks
    [all_times,sort_idx] = sort(all_times);
    all_time_strs = all_time_strs(sort_idx, :);
    all_times_new = zeros(size(all_times));
    for time_i = 1:size(all_time_strs,1)
        all_times_new(time_i) = input(['What block should ', all_time_strs(time_i,:), ' be part of? (Enter 0 to discard)', newline]);
        if all_times_new(time_i) > expected_blocks || all_times_new(time_i) < 0
            error('Group outside expected bounds.')
        end
        all_times_new(time_i) = all_times_new(time_i) * 10000;
        all_times_new(time_i) = all_times_new(time_i) + all_times(time_i);
    end
    [~,sort_idx] = sort(all_times(all_times_new < 10000));
    [~,sort_idx_new] = sort(all_times_new(all_times_new < 10000));
    if sum(sort_idx ~= sort_idx_new) > 0
        warning('Times are not grouped in order.')
        response = input('Proceed anyway? y/n');
        if strcmp(conf, 'y')
            
        elseif strcmp(conf, 'n')
            disp('Aborting.')
            return
        else
            disp('Unrecognised responce. Aborting.')
            return
        end
    end
    group = all_times_new/10000;
    group = floor(group);
    
else
    [all_times,sort_idx] = sort(all_times);
    all_time_strs = all_time_strs(sort_idx, :);
    group = 1:expected_blocks;
end

day_succ_count = 0;
day_reach_count = 0;
for cur_group = 1:expected_blocks
    if cur_group == 1
        out_filename = ['DCh_Vids_PreSleep_GUI.mat'];
    end
    comb_data = cell(0,4);
    comb_idx = 0;
    for time_i = 1:size(all_time_strs,1)
        if cur_group == group(time_i)
            comb_idx = size(comb_data,1);
            time_filename = dir([days_path, '\*', all_time_strs(time_i,:), '*.mat']);
            for data_i = 1:size(time_filename,1)
                load([days_path, '\', time_filename(data_i).name])
                for row_i = 1:size(data,1)
                    comb_data(str2double(data{row_i})+comb_idx,:) = data(row_i,:);
                end
            end
        end
    end
    data = comb_data;
    save([days_path, '\Results\', out_filename],'data');
    
    outcomes = cellfun(@str2double,data(:,3));
    data = data(outcomes < 2,:);
    outcomes = outcomes(outcomes < 2,:);
    
    day_succ_count = day_succ_count + sum(outcomes);
    day_reach_count = day_reach_count + length(outcomes);
end

fid = fopen([days_path, '\Results\success_rate.txt'],'w');
fprintf(fid,'%s',[ 'Successful Reaches ', num2str(day_succ_count)], newline);
fprintf(fid,'%s',[ 'Failed Reaches ',num2str(day_reach_count-day_succ_count)], newline);
fprintf(fid,'%s',[ 'Total Reaches ',num2str(day_reach_count)], newline);
fprintf(fid,'%s',[ 'Success Rate ',num2str(day_succ_count/day_reach_count)]);
fclose(fid);

message = [ 'Successful Reaches = ', num2str(day_succ_count), ' Failed Reaches = ',num2str(day_reach_count-day_succ_count) ' Total Reaches = ',num2str(day_reach_count), ' Success Rate = ',num2str(day_succ_count/day_reach_count)];
msgbox(message);

end