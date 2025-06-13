function findFiles_Callback(hObject, eventdata)

global vid_fig_hand;

[filename, pathname] = uigetfile('*.avi','Select a video file','Y:\');

% vid_fig_hand.VID_DIR_handle = pathname;
% vid_fig_hand.NAME_handle = filename(1:4);
% vid_fig_hand.dateEditBoxHandle = filename(22:30);

set(vid_fig_hand.VID_DIR_handle,'String',pathname);
set(vid_fig_hand.NAME_handle,'String',filename(1:4));
set(vid_fig_hand.dateEditBoxHandle,'String',filename(22:28));

vid_fig_hand.vid_dir = get(vid_fig_hand.VID_DIR_handle, 'String');
% get what is inside the folder
% cd(vid_dir);
Infolder = dir(vid_fig_hand.vid_dir);
video_files_cellArr = {Infolder(~[Infolder.isdir]).name}.';

indexed_by_movies = contains(video_files_cellArr, '.avi');
video_files_cellArr = video_files_cellArr(indexed_by_movies);

% shortlisting by rat ID
vid_ratID = get(vid_fig_hand.NAME_handle, 'String');
indexed_by_ratID = contains(video_files_cellArr, vid_ratID);
video_files_cellArr = video_files_cellArr(indexed_by_ratID);

% shortlisting by date
vid_date = get(vid_fig_hand.dateEditBoxHandle, 'String');
% [y,m,d]=ymd(datetime(vid_date));
% vid_date = [num2str(y),...
%     '_',num2str(m),...
%     '_',num2str(d)];

indexed_by_date = contains(video_files_cellArr, vid_date);
video_files_cellArr = video_files_cellArr(indexed_by_date);
vid_index = [];

% shortlisting by time
vid_hr = get(vid_fig_hand.timeEditBoxHandle, 'String');
if ~strcmp(vid_hr,'00h00m')
    indexed_by_time = contains(video_files_cellArr, vid_hr);
    video_files_cellArr = video_files_cellArr(indexed_by_time); 
end

for filename = 1:length(video_files_cellArr)
    vid_name_no = char(video_files_cellArr(filename));
    vid_name = vid_name_no;
    vid_name_no = vid_name_no(end-4);
    if vid_name(end-5) ~= '-'
        vid_name_no = strcat(vid_name(end-5), vid_name_no);
        if vid_name(end-6) ~= '-'
            vid_name_no = strcat(vid_name(end-6),vid_name(end-5), vid_name_no);
        end
    end
   vid_index(filename) =  str2double(vid_name_no);
end
[~, i] = sort(vid_index);

% update the listbox with the result
set(vid_fig_hand.listFiles_handle,'Value',1); % Add this line so that the list can be changed
set(vid_fig_hand.listFiles_handle,'String',video_files_cellArr(i))
vid_fig_hand.logged_trajectories = {};
set(vid_fig_hand.uit,'Data',{});
set(vid_fig_hand.TRAJCHECKBOX,'Value',false);

% % Check for the previously saved table
% expected_blocks = 1;
% days_path = vid_fig_hand.VID_DIR_handle.String;
% data_names = dir([days_path, '\*man*.mat']);
% if ~isempty(data_names)
%     all_time_strs = '';
%     all_times = nan(0,1);
%     for data_i = 1:length(data_names)
%         time_idx = regexp(data_names(data_i).name,'\d\d?h\d?\dm');
%         time_str = data_names(data_i).name(time_idx:time_idx+4);
%         time = time_str;
%         if time(5) == ')'
%             time = ['0', time(1), '0', time(3)];
%         elseif time(5) == 'm'
%             if time(2) == 'h'
%                 time = ['0', time(1), time(3:4)];
%             else
%                 time = [time(1:2), '0', time(4)];
%             end
%         else
%             time = [time(1:2), time(4:5)];
%         end
%         time = str2double(time);
%         new_time = true;
%         for time_i = 1:size(all_time_strs,1)
%             if time == all_times(time_i)
%                 new_time = false;
%                 continue
%             end
%         end
%         if new_time
%             all_time_strs = cat(1, all_time_strs, time_str);
%             all_times = cat(1, all_times, time);
%         end
%     end
%     
%     if size(all_time_strs,1) ~= expected_blocks
%         [all_times,sort_idx] = sort(all_times);
%         all_time_strs = all_time_strs(sort_idx, :);
%         all_times_new = zeros(size(all_times));
%         for time_i = 1:size(all_time_strs,1)
%             all_times_new(time_i) = input(['What block should ', all_time_strs(time_i,:), ' be part of? (Enter 0 to discard)', newline]);
%             if all_times_new(time_i) > expected_blocks || all_times_new(time_i) < 0
%                 error('Group outside expected bounds.')
%             end
%             all_times_new(time_i) = all_times_new(time_i) * 10000;
%             all_times_new(time_i) = all_times_new(time_i) + all_times(time_i);
%         end
%         [~,sort_idx] = sort(all_times(all_times_new < 10000));
%         [~,sort_idx_new] = sort(all_times_new(all_times_new < 10000));
%         if sum(sort_idx ~= sort_idx_new) > 0
%             warning('Times are not grouped in order.')
%             response = input('Proceed anyway? y/n');
%             if strcmp(conf, 'y')
%                 
%             elseif strcmp(conf, 'n')
%                 disp('Aborting.')
%                 return
%             else
%                 disp('Unrecognised responce. Aborting.')
%                 return
%             end
%         end
%         group = all_times_new/10000;
%         group = floor(group);
%         
%     else
%         [all_times,sort_idx] = sort(all_times);
%         all_time_strs = all_time_strs(sort_idx, :);
%         group = 1:expected_blocks;
%     end
% end
% 
% day_succ_count = 0;
% day_reach_count = 0;
% for cur_group = 1:expected_blocks
%     comb_data = cell(0,4);
%     comb_idx = 0;
%     for time_i = 1:size(all_time_strs,1)
%         if cur_group == group(time_i)
%             comb_idx = size(comb_data,1);
%             time_filename = dir([days_path, '\*', all_time_strs(time_i,:), '*.mat']);
%             for data_i = 1:size(time_filename,1)
%                 load([days_path, '\', time_filename(data_i).name])
%                 for row_i = 1:size(data,1)
%                     comb_data(str2double(data{row_i})+comb_idx,:) = data(row_i,:);
%                 end
%             end
%         end
%     end
%     data = comb_data;
% end

end