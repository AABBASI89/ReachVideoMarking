function logTrialData(overwrite)

global vid_fig_hand;

trial_row = get(vid_fig_hand.RowEditHd, 'String');
trial_row = num2str(trial_row);
trial_row = str2double(trial_row);

rchonset = get(vid_fig_hand.RowEditHdRCHONSET, 'String');
rchonset = num2str(rchonset);
rchonset_num = str2num(rchonset);

plttouch = get(vid_fig_hand.RowEditHdPLTTOUCH, 'String');
plttouch = num2str(plttouch);
plttouch_num = str2double(plttouch);

rtrctonset = get(vid_fig_hand.RowEditHdRTRCTONSET, 'String');
rtrctonset = num2str(rtrctonset);
rtrctonset_num = str2double(rtrctonset);

trlOutcome = get(vid_fig_hand.RowEditHdTRLOUTCOME, 'String');
trlOutcome = num2str(trlOutcome);

rchTrajectory = [];

%Sanity Checks
if mod(trial_row,1) ~= 0
    displayErrorMessage('Trial number does not resolve into an integer. Trial not logged.');
    return
end
    
if isempty(str2num(rchonset)) && ~isempty(rchonset)
    displayErrorMessage('Reach Onset record cannot be parsed. Trial not logged.');
    return
elseif isempty(str2num(plttouch)) && ~isempty(plttouch)
    displayErrorMessage('Pellet Touch record cannot be parsed. Trial not logged.');
    return
elseif isempty(str2num(rtrctonset)) && ~isempty(rtrctonset)
    displayErrorMessage('Retract Onset record cannot be parsed. Trial not logged.');
    return
end

switch trlOutcome
    case '0' %Reach Failure
        if isempty(rchonset)
            displayErrorMessage( 'Trial outcome indicates reach was attempted but Reach Onset record is empty. Trial not logged.');
            return
        end 
    case '1' %Reach Success
        if isempty(rchonset)
            displayErrorMessage( 'Trial outcome indicates reach was succesful but Reach Onset record is empty. Trial not logged.');
            return
        elseif isempty(plttouch)
            displayErrorMessage( 'Trial outcome indicates reach was attempted but Pellet Touch record is empty. Trial not logged.');
            return
        elseif isempty(rtrctonset)
            displayErrorMessage( 'Trial outcome indicates reach was attempted but Retract Onset record is empty. Trial not logged.');
            return
        end 
    case '2' %Ignored Pellet
        if ~isempty(rchonset)
            displayErrorMessage( 'Trial outcome indicates pellet was ignored but Reach Onset record is not empty. Trial not logged.');
            return
        elseif ~isempty(plttouch)
            displayErrorMessage( 'Trial outcome indicates pellet was ignored but Pellet Touch record is not empty. Trial not logged.');
            return
        elseif ~isempty(rtrctonset)
            displayErrorMessage( 'Trial outcome indicates pellet was ignored but Retract Onset record is not empty. Trial not logged.');
            return
        end
    case '3' %Reached with no pellet on arm
        if isempty(rchonset)
            displayErrorMessage( 'Trial outcome indicates reach was attempted but Reach Onset record is empty. Trial not logged.');
            return
        elseif ~isempty(plttouch)
            displayErrorMessage( 'Trial outcome indicates no pellet on arm but Pellet Touch record not empty. Trial not logged.');
            return
        elseif ~isempty(rtrctonset)
            displayErrorMessage( 'Trial outcome indicates no pellet on arm but Retract Onset record not empty. Trial not logged.');
            return
        end
    case '4' %Forcep Reach Failure
        if isempty(rchonset)
            displayErrorMessage( 'Trial outcome indicates reach was attempted but Reach Onset record is empty. Trial not logged.');
            return
        end 
    case '5' %Forcep Reach Success
        if isempty(rchonset)
            displayErrorMessage( 'Trial outcome indicates reach was succesful but Reach Onset record is empty. Trial not logged.');
            return
        elseif isempty(plttouch)
            displayErrorMessage( 'Trial outcome indicates reach was attempted but Pellet Touch record is empty. Trial not logged.');
            return
        elseif isempty(rtrctonset)
            displayErrorMessage( 'Trial outcome indicates reach was attempted but Retract Onset record is empty. Trial not logged.');
            return
        end  
    otherwise %Unrecognised Trial Code
        displayErrorMessage( 'Unrecognized Trial Outcome. Trial not logged.');
        return
end

if trlOutcome ~= '2'
    if ~isempty(plttouch)
        if rchonset_num(length(rchonset_num)) >= plttouch_num
            displayErrorMessage( 'Pellet Touch occurs before final reach attempt. Trial not logged.');
            return
        end
        if ~isempty(rtrctonset)
            if rchonset_num(length(rchonset_num)) >= rtrctonset_num
                displayErrorMessage( 'Retract Onset occurs before final reach attempt. Trial not logged.');
                return
            end
            if plttouch_num >= rtrctonset_num
                displayErrorMessage( 'Retract Onset occurs before Pellet Touch. Trial not logged.');
                return
            end
        else
            %Should there ever be a trial with a touch but no retract?
            %warning( 'Pellet was touched but no retract recorded. Trial not logged.');
            %return
        end
        
        trajectory_window = rchonset_num(length(rchonset_num)):rtrctonset_num;
        rchTrajectory_snapshot = vid_fig_hand.ReachMarks(trajectory_window,:);
        rchTrajectory = nan(size(vid_fig_hand.ReachMarks));
        rchTrajectory(trajectory_window,:) = rchTrajectory_snapshot;
        if vid_fig_hand.TRAJCHECKBOX.Value
            if sum(isnan(rchTrajectory_snapshot(:)))
                %Should there be a way to bypass the trajectory recording? Maybe throw the warning but let the trial get logged?
                displayErrorMessage( 'Reach Trajectory has unrecorded frames. Be sure to mark a position for both the Reach Onset frame and the Retract Onset frame. Trial not logged.');
                return
            end
        else
            if sum(~isnan(rchTrajectory_snapshot(:)))
                displayErrorMessage( 'Reach Trajectory is not required but has been partially recorded. If you wanted to save the trajectory check the ''Trajectory Required'' Box and log the trial again. Trial logged without trajectory data.');
                set(vid_fig_hand.ErrDispText,'BackgroundColor', [1.0 0.95 0.6 ]);
            end
            rchTrajectory = nan(size(vid_fig_hand.ReachMarks));
        end
        
    else
        if ~isempty(rtrctonset)
            displayErrorMessage( 'Retract Onset recorded without coresponding pellet touch record. Trial not logged.');
            return
        end
    end
end

%Event coding
if trlOutcome == '1' || trlOutcome == '5'
    events = [rchonset_num plttouch_num rtrctonset_num];
    events = char(strjoin(string(events),','));
elseif ~isempty(plttouch)
    events = [rchonset_num plttouch_num 0];
    if ~isempty(rtrctonset)
        events = [events rtrctonset_num 1];
    end
    events = char(strjoin(string(events),','));
else
    events = rchonset;
end

if isempty(rtrctonset)
    traj_out = 'No trajectory data saved';
else
    if vid_fig_hand.TRAJCHECKBOX.Value
        traj_out = 'Trajectory saved';
    else
        traj_out = 'No trajectory data saved';
    end
end



oldData = get(vid_fig_hand.uit,'Data');
newRow = {trial_row, events, trlOutcome, traj_out};
if isempty(oldData)
    ins_idx = [];
else
    ins_idx = find([oldData{:,1}] >= trial_row, 1);
end
if isempty(ins_idx)
    newData = [oldData; newRow];
    vid_fig_hand.logged_trajectories = [vid_fig_hand.logged_trajectories; {rchTrajectory}];

elseif oldData{ins_idx,1} == trial_row
    if(overwrite)
        %replace
        newData = oldData;
        newData(ins_idx,:) = newRow;
        vid_fig_hand.logged_trajectories(ins_idx) = {rchTrajectory};
    
    else
        %confirm replace
        beep;
        set(vid_fig_hand.ErrDispText,'String','Data log already exists for current trial number. Select ''Overwrite'' below to overwrite the data of the current trial number. Or enter a new trial number to use for this trial. Note that changing the trial number to a previously logged number will load the trajectory recorded in that log');
        set(vid_fig_hand.ErrDispText,'BackgroundColor', [1.0 0.95 0.6 ]);
        set(vid_fig_hand.ErrDispText,'Visible',true);
        set(vid_fig_hand.ErrDispClear,'Visible',false);
        
        set(vid_fig_hand.ConfOverwrite,'Visible',true);
        set(vid_fig_hand.CancelLog,'Visible',true);
        set(vid_fig_hand.ChangeTrialNum,'Visible',true);
        set(vid_fig_hand.AltTrialNum,'Visible',true);
        set(vid_fig_hand.AltTrialNum,'String', '##');
        return
    end
    
else
    %insert
    newData = [oldData(1:ins_idx-1,:); newRow; oldData(ins_idx:size(oldData,1),:)];
    vid_fig_hand.logged_trajectories = [vid_fig_hand.logged_trajectories(1:ins_idx-1,:); {rchTrajectory}; vid_fig_hand.logged_trajectories(ins_idx:size(oldData,1),:)];
end

set(vid_fig_hand.uit,'Data',newData)


end