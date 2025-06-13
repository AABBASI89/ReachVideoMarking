%% Crop and compress reach videos
% Author - Aamir Abbasi
%% ------------------------------------------------------------------------
clc; clear; close all;
hand = 2; % 1: Right Hand Cam 2; 2: Left Hand Cam 1 CHANGE ACCORDINGLY
RatID = {'I197'}; % CHANGE ANIMAL ID ACCORDINGLY
for a = 1:length(RatID)
    rootpath = ['Y:\M1_Stroke\',RatID{a},'\'];
    Days = dir([rootpath,'Day*']);
    for d = 1:length(Days)
        reach = dir([rootpath,Days(d).name,'\Reach_Vids\Reach*']);
        for r = 1:length(reach)
            if hand == 2
                videos = dir([rootpath,Days(d).name,'\Reach_Vids\',reach(r).name,'\I*Cam1*.avi']);
            elseif hand == 1
                videos = dir([rootpath,Days(d).name,'\Reach_Vids\',reach(r).name,'\I*Cam2*.avi']);
            end
            for v = 1:length(videos)
                disp(['Cropping Rat ',RatID{a},' Day ',num2str(d),' Trial ',num2str(v)]);
                vid = VideoReader([videos(v).folder,'\',videos(v).name]);
                vW = VideoWriter([videos(v).folder,'\Cropped_',videos(v).name],'Motion JPEG AVI');
                vW.FrameRate = 301;
                vW.Quality = 75;
                open(vW);
                while hasFrame(vid)
                    frame = readFrame(vid);
                    frame_resized = imresize(frame, 1/3);
                    if hand == 2
                        croppedVid = frame_resized(100:end,100:end,:);
                    elseif hand == 1
                        croppedVid = frame_resized(100:end,1:160,:);
                    end
                    writeVideo(vW,croppedVid);
                end
                close(vW);
            end
        end
    end
end

%%