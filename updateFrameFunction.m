function updateFrameFunction(FRAME, vid_obj)

global vid_fig_hand;


A = (vid_obj.structure(FRAME).cdata);

Aim = image(vid_fig_hand.vid_ax, A);
Aim.AlphaData = 0.90;

set(vid_fig_hand.frameEdithandle, 'String', num2str(FRAME));

title(vid_fig_hand.vid_ax, strcat('Frame Control: # ',num2str(FRAME)));

set(vid_fig_hand.vid_ax, 'XTick', []);
set(vid_fig_hand.vid_ax, 'YTick', []);

rchonset = get(vid_fig_hand.RowEditHdRCHONSET, 'String');
rchonset = num2str(rchonset);
rchonset_num = str2num(rchonset);

rtrctonset = get(vid_fig_hand.RowEditHdRTRCTONSET, 'String');
rtrctonset = num2str(rtrctonset);
rtrctonset_num = str2double(rtrctonset);


if ~isnan(vid_fig_hand.ReachMarks(FRAME,1)) && ~isempty(rchonset_num) && ~isnan(rtrctonset_num)
    rchonset_num = rchonset_num(length(rchonset_num));
    if FRAME >= rchonset_num && FRAME <= rtrctonset_num
        hold on
        plot(vid_fig_hand.ReachMarks(FRAME,1),vid_fig_hand.ReachMarks(FRAME,2),'g+')
        hold off
    end
end


end