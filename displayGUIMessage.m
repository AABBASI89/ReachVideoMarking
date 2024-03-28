function displayGUIMessage(message)

global vid_fig_hand;

uicontrol(vid_fig_hand.ErrDispText);
set(vid_fig_hand.ErrDispText,'String',message);
set(vid_fig_hand.ErrDispText,'BackgroundColor', [.7 0.8 1.0]);
set(vid_fig_hand.ErrDispText,'Visible',true);
set(vid_fig_hand.ErrDispClear,'Visible',true);

set(vid_fig_hand.ConfOverwrite,'Visible',false);
set(vid_fig_hand.CancelLog,'Visible',false);
set(vid_fig_hand.ChangeTrialNum,'Visible',false);
set(vid_fig_hand.AltTrialNum,'Visible',false);

beep

end