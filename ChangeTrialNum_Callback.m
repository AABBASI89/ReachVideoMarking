function ChangeTrialNum_Callback(hObject, eventdata)

global vid_fig_hand;

newTrialNum = str2double(get(vid_fig_hand.AltTrialNum,'String'));

set(vid_fig_hand.ErrDispText,'Visible',false);
set(vid_fig_hand.ConfOverwrite,'Visible',false);
set(vid_fig_hand.CancelLog,'Visible',false);
set(vid_fig_hand.ChangeTrialNum,'Visible',false);
set(vid_fig_hand.AltTrialNum,'Visible',false);

if  newTrialNum > 0 && mod(newTrialNum,1) == 0
    logged_Data = get(vid_fig_hand.uit,'Data');
    logged_trials = [logged_Data{:,1}];
    set(vid_fig_hand.RowEditHd,'String',num2str(newTrialNum));
    trial_idx = find(logged_trials == newTrialNum, 1);
    if ~isempty(trial_idx)
        displayGUIMessage('Trajectory data replaced with data from previous log of this trial number.')
        vid_fig_hand.ReachMarks = vid_fig_hand.logged_trajectories{trial_idx};
    end
    
else
    displayErrorMessage('New trial number does not resolve into an integer. Trial not logged.')
end
uicontrol(vid_fig_hand.logEventFrame)
end