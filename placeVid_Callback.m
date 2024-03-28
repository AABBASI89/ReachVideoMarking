function placeVid_Callback(hObject, eventdata)

global vid_fig_hand;
global vid_obj;

selected_file = get(vid_fig_hand.listFiles_handle,'Value');
vid_list = get(vid_fig_hand.listFiles_handle,'String');
vid_name = vid_list{selected_file};
vid_name_no = vid_name;
vid_name_no = vid_name_no(end-4);
if vid_name(end-5) ~= '-'
    vid_name_no = strcat(vid_name(end-5), vid_name_no);
    if vid_name(end-6) ~= '-'
       vid_name_no = strcat(vid_name(end-6), vid_name_no);
    end
end

set(vid_fig_hand.RowEditHd, 'String', str2double(vid_name_no));
set(vid_fig_hand.RowEditHdRCHONSET, 'String', '');
set(vid_fig_hand.RowEditHdPLTTOUCH, 'String', '');
set(vid_fig_hand.RowEditHdRTRCTONSET, 'String', '');
set(vid_fig_hand.RowEditHdTRLOUTCOME, 'String', (2));

set(vid_fig_hand.ConfOverwrite,'Visible',false);
set(vid_fig_hand.CancelLog,'Visible',false);
set(vid_fig_hand.ChangeTrialNum,'Visible',false);
set(vid_fig_hand.AltTrialNum,'Visible',false);

logged_Data = get(vid_fig_hand.uit,'Data');
if isempty(logged_Data)
    logged_trials = [];
else
    logged_trials = logged_Data{:,1};
end

try
    if ispc
        vid_obj.obj = VideoReader([vid_fig_hand.vid_dir, '\', vid_name]);
    else
        vid_obj.obj = VideoReader([vid_fig_hand.vid_dir, '/', vid_name]);
    end
catch
    beep
    displayErrorMessage( 'File named in edit box does not appear to be a usable movie file.');
    return
end

%%% Useless peice of code. The Number of frames info is already there in the
%%% video obj. No need to go over the whole video to find it out!!!
%%% Changes made by AA.
% time_to_remember = vid_obj.obj.CurrentTime; 
% vidnumFrames = 0;
% while hasFrame(vid_obj.obj)
%     readFrame(vid_obj.obj);
%     vidnumFrames = vidnumFrames + 1;
% end
% vid_obj.obj.CurrentTime = time_to_remember;
% vid_obj.vidnumFrames = vid_obj.obj.NumFrames;
vid_obj.vidnumFrames = round(vid_obj.obj.FrameRate*vid_obj.obj.Duration);

vidHeight = vid_obj.obj.Height;
vidWidth = vid_obj.obj.Width;

trial_idx = find(logged_trials == str2double(vid_name_no), 1);
if isempty(trial_idx)
    vid_fig_hand.ReachMarks = nan(vid_obj.vidnumFrames,2);
else
    if size(vid_fig_hand.logged_trajectories{trial_idx},1) == vid_obj.vidnumFrames
        vid_fig_hand.ReachMarks = vid_fig_hand.logged_trajectories{trial_idx};
    else
        vid_fig_hand.ReachMarks = nan(vid_obj.vidnumFrames,2);
    end
end

% Create a MATLAB® movie structure array, s.
vid_obj.structure = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);

k = 1;
f = waitbar(0,'Reading Frames...');
tic;
while hasFrame(vid_obj.obj)
    vid_obj.structure(k).cdata = readFrame(vid_obj.obj);
    k = k+1;
    waitbar(k/vid_obj.vidnumFrames,f,['Reading Frames... Time Elasped: ', num2str(round(toc/60,2)), ' minutes']);
end

set(vid_fig_hand.frameEdithandle, 'String', 1);
set(vid_fig_hand.vid_ax, 'XTick', []);
set(vid_fig_hand.vid_ax, 'YTick', []);

updateFrameFunction(1, vid_obj);
pause(1);
delete(f);

end

