function markFrameReach_Callback(hObject, eventdata)

global vid_fig_hand;
global vid_obj;

rch_onsets = str2num(get(vid_fig_hand.RowEditHdRCHONSET, 'String'));
rtrct_onset = str2double(get(vid_fig_hand.RowEditHdRTRCTONSET, 'String'));
curr_frame = str2double(get(vid_fig_hand.frameEdithandle, 'String'));

if isempty(rch_onsets)
    displayErrorMessage('Reach Onset empty or cannot be parsed. Set a reach onset before marking the reach trajectory.');
    return
end
if rch_onsets(length(rch_onsets)) > curr_frame
    displayErrorMessage('Last Reach Onset occurs after the current frame. Only mark the tracjectory of the final reach attempt.');
    return
end

if isempty(rtrct_onset)
    displayErrorMessage('Retract Onset empty or cannot be parsed. Set a retract onset before marking the reach trajectory.');
    return
end
if rtrct_onset < curr_frame
    displayErrorMessage('Retract Onset occurs before the current frame. Only mark the tracjectory until the start of retract.');
    return
end

vid_fig_hand.vid_ax
[x, y] = ginput(1);
vid_fig_hand.ReachMarks(curr_frame,:) = [x y];
updateFrameFunction(curr_frame, vid_obj);

end