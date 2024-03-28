function saveTable_Callback(hObject, eventdata)

global vid_fig_hand;
global s;

selected_file = get(vid_fig_hand.listFiles_handle,'Value');
vid_list = get(vid_fig_hand.listFiles_handle,'String');
vid_name = vid_list{selected_file};
fileFirstString = (vid_name(1:end-5));
todayDateString = date;
s = strcat(vid_fig_hand.vid_dir,'\',fileFirstString,'man_vid_outcomes',todayDateString ,'.mat');

data = get(vid_fig_hand.uit,'Data');
data(:,1) = cellfun(@num2str,data(:,1),'UniformOutput',false);
traj_cells = vid_fig_hand.logged_trajectories;
for i = 1:length(traj_cells)
    traj_cells{i}(isnan(traj_cells{i})) = [];
end
data(:,4) = traj_cells;

save(s,'data');

end