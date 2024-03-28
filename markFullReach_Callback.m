function markFullReach_Callback(hObject, eventdata)

global vid_fig_hand;
global vid_obj;

rch_onsets = str2num(get(vid_fig_hand.RowEditHdRCHONSET, 'String'));
rtrct_onset = str2double(get(vid_fig_hand.RowEditHdRTRCTONSET, 'String'));

if isempty(rch_onsets)
    displayErrorMessage('Reach Onset empty or cannot be parsed. Set a reach onset before marking the reach trajectory.');
    return
end
if isempty(rtrct_onset)
    displayErrorMessage('Retract Onset empty or cannot be parsed. Set a retract onset before marking the reach trajectory.');
    return
end
fnl_rch_onset = rch_onsets(length(rch_onsets));
if fnl_rch_onset >= rtrct_onset
    displayErrorMessage('Retract Onset Occurs berfore or at the same time as reach onset. The retract onset must occur after the reach onset.');
    return
end

next_frame = fnl_rch_onset - 1;
while rtrct_onset > next_frame
    next_frame = next_frame + 1;
    updateFrameFunction(next_frame, vid_obj);
    vid_fig_hand.vid_ax;
    [x, y] = ginput(1);
    vid_fig_hand.ReachMarks(next_frame,:) = [x y];
end
updateFrameFunction(next_frame, vid_obj);
