function ErrDispClear_Callback(hObject, eventdata)

global vid_fig_hand;

%set(vid_fig_hand.ErrDispClear,'String','');
%set(vid_fig_hand.ErrDispClear,'BackgroundColor', [.94 0.94 0.94]);
set(vid_fig_hand.ErrDispText,'Visible',false);
set(vid_fig_hand.ErrDispClear,'Visible',false);


end