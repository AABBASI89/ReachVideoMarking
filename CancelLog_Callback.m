function DoNotSave_Callback(hObject, eventdata)

global vid_fig_hand;

set(vid_fig_hand.ErrDispText,'Visible',false);
set(vid_fig_hand.ConfOverwrite,'Visible',false);
set(vid_fig_hand.CancelLog,'Visible',false);
set(vid_fig_hand.ChangeTrialNum,'Visible',false);
set(vid_fig_hand.AltTrialNum,'Visible',false);

uicontrol(vid_fig_hand.logEventFrame)

end