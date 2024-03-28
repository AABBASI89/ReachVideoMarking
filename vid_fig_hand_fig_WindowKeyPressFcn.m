function vid_fig_hand_fig_WindowKeyPressFcn(hObject, eventdata)

global vid_fig_hand

if strcmp(eventdata.Key,'rightarrow')
    if isempty(eventdata.Modifier)
        % set focus to the button
        uicontrol(vid_fig_hand.plusOneFrame);
        % call the callback
        plusOneFrame_Callback(vid_fig_hand.plusOneFrame,[]);
    elseif strcmp(eventdata.Modifier{:},'shift')
        % set focus to the button
        uicontrol(vid_fig_hand.plusTenFrame);
        % call the callback
        plusTenFrame_Callback(vid_fig_hand.plusTenFrame,[]);  
    elseif strcmp(eventdata.Modifier{:},'alt')
        % set focus to the button
        uicontrol(vid_fig_hand.plusHunderedFrame);
        % call the callback
        plusTenFrame_Callback(vid_fig_hand.plusHunderedFrame,[]);         
    end
end

if strcmp(eventdata.Key,'leftarrow')
    if isempty(eventdata.Modifier)
        % set focus to the button
        uicontrol(vid_fig_hand.minusOneFrame);
        % call the callback
        minusOneFrame_Callback(vid_fig_hand.minusOneFrame,[]);
    elseif strcmp(eventdata.Modifier{:},'shift')
        % set focus to the button
        uicontrol(vid_fig_hand.minusTenFrame);
        % call the callback
        minusTenFrame_Callback(vid_fig_hand.minusTenFrame,[]);   end
end

if strcmp(eventdata.Key,'z')
    % call the callback
    curr_frame = str2double(get(vid_fig_hand.frameEdithandle, 'String'));
    rch_onsets = str2num(get(vid_fig_hand.RowEditHdRCHONSET, 'String'));    
    if ismember(curr_frame, rch_onsets)
        rch_onsets(rch_onsets == curr_frame) = [];
    else
        rch_onsets = sort([rch_onsets curr_frame]);
    end
    set(vid_fig_hand.RowEditHdRCHONSET, 'String', char(strjoin(string(rch_onsets'),',')));
end

if strcmp(eventdata.Key,'x')
    if strcmp(get(vid_fig_hand.frameEdithandle, 'String'), get(vid_fig_hand.RowEditHdPLTTOUCH, 'String'))
        set(vid_fig_hand.RowEditHdPLTTOUCH, 'String', '');
    else
        set(vid_fig_hand.RowEditHdPLTTOUCH, 'String', get(vid_fig_hand.frameEdithandle, 'String'));
    end
end

if strcmp(eventdata.Key,'c')
    if strcmp(get(vid_fig_hand.frameEdithandle, 'String'), get(vid_fig_hand.RowEditHdRTRCTONSET, 'String'))
        set(vid_fig_hand.RowEditHdRTRCTONSET, 'String', '');
    else
        set(vid_fig_hand.RowEditHdRTRCTONSET, 'String', get(vid_fig_hand.frameEdithandle, 'String'));
    end
end

if strcmp(eventdata.Key,'s')
    if isempty(eventdata.Modifier)
        % do nothing
    elseif strcmp(eventdata.Modifier{:},'shift')
        % set focus to the button
        uicontrol(vid_fig_hand.logEventFrame);
        % call the callback
        logEventFrame_Callback(vid_fig_hand.logEventFrame,[]);   
    end
end

if strcmp(eventdata.Key,'q')
    if isempty(eventdata.Modifier)
        % do nothing
    elseif strcmp(eventdata.Modifier{:},'shift')
        % set focus to the button
        uicontrol(vid_fig_hand.logUnsuccTrials);
        % call the callback
        logUnsuccTrials_Callback(vid_fig_hand.logUnsuccTrials,[]);   
    end
end

if strcmp(eventdata.Key,'w')
    if isempty(eventdata.Modifier)
        % do nothing
    elseif strcmp(eventdata.Modifier{:},'shift')
        % set focus to the button
        uicontrol(vid_fig_hand.logSuccTrials);
        % call the callback
        logSuccTrials_Callback(vid_fig_hand.logSuccTrials,[]);   
    end
end

if strcmp(eventdata.Key,'e')
    if isempty(eventdata.Modifier)
        % do nothing
    elseif strcmp(eventdata.Modifier{:},'shift')
        % set focus to the button
        uicontrol(vid_fig_hand.logIgTrials);
        % call the callback
        logIgTrials_Callback(vid_fig_hand.logIgTrials,[]);   
    end
end

if strcmp(eventdata.Key,'r')
    if isempty(eventdata.Modifier)
        % do nothing
    elseif strcmp(eventdata.Modifier{:},'shift')
        % set focus to the button
        uicontrol(vid_fig_hand.logOut3Trials);
        % call the callback
        logOut3Trials_Callback(vid_fig_hand.logOut3Trials,[]);   
    end
end

if strcmp(eventdata.Key,'t')
    if isempty(eventdata.Modifier)
        % do nothing
    elseif strcmp(eventdata.Modifier{:},'shift')
        % set focus to the button
        uicontrol(vid_fig_hand.logOut4Trials);
        % call the callback
        logOut4Trials_Callback(vid_fig_hand.logOut4Trials,[]);   
    end
end

if strcmp(eventdata.Key,'y')
    if isempty(eventdata.Modifier)
        % do nothing
    elseif strcmp(eventdata.Modifier{:},'shift')
        % set focus to the button
        uicontrol(vid_fig_hand.logOut5Trials);
        % call the callback
        logOut5Trials_Callback(vid_fig_hand.logOut5Trials,[]);   
    end
end

if strcmp(eventdata.Key,'k')
    if isempty(eventdata.Modifier)
        % set focus to the button
        uicontrol(vid_fig_hand.markFrameReach);
        % call the callback
        markFrameReach_Callback(vid_fig_hand.markFrameReach,[]);
    elseif strcmp(eventdata.Modifier{:},'shift')
        % set focus to the button
        uicontrol(vid_fig_hand.markFullReach);
        % call the callback
        markFullReach_Callback(vid_fig_hand.markFullReach,[]);
    end
end

set(vid_fig_hand.vid_ax, 'XTick', []);
set(vid_fig_hand.vid_ax, 'YTick', []);

end

