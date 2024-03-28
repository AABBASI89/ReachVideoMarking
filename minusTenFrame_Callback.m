function minusTenFrame_Callback(hObject, eventdata)

global vid_fig_hand;
global vid_obj;

curr_frame = get(vid_fig_hand.frameEdithandle, 'String');
curr_frame = str2num(curr_frame);

frameMinusTen = curr_frame -10;
if frameMinusTen > 1
    updateFrameFunction(frameMinusTen, vid_obj);
else
   msgbox('Step size is greater than the number of frame(s) available'); 
end

end