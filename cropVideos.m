%% Crop and compress reach videos
% Author - Aamir Abbasi
%% ------------------------------------------------------------------------
clc; clear; close all;
hand = 1; % 1: Right Hand Cam 2; 2: Left Hand Cam 1 CHANGE ACCORDINGLY
RatID = {'I197'}; % CHANGE ANIMAL ID ACCORDINGLY
for a = 1:length(RatID)
    rootpath = ['Y:\M1_Stroke\',RatID{a},'\'];
    Days = dir([rootpath,'Day*']);
    for d = 1:length(Days)
        reach = dir([rootpath,Days(d).name,'\Reach_Vids\Reach*']);
        for r = 1:length(reach)
            if hand == 2
                videos = dir([rootpath,Days(d).name,'\Reach_Vids\',reach(r).name,'\*Cam1*.avi']);
            elseif hand == 1
                videos = dir([rootpath,Days(d).name,'\Reach_Vids\',reach(r).name,'\*Cam2*.avi']);
            end
            for v = 1:length(videos)
                disp(['Cropping Rat ',RatID{a},' Day ',num2str(d),' trial number ',num2str(v)]);
                vid = VideoReader([videos(v).folder,'\',videos(v).name]);
                vW = VideoWriter([videos(v).folder,'\Cropped_',videos(v).name],'Motion JPEG AVI');
                vW.FrameRate = 301;
                vW.Quality = 10;
                open(vW);
                while hasFrame(vid)
                    frame = readFrame(vid);
                    if hand == 2
                        croppedVid = frame(300:end,300:end,:);
                    elseif hand == 1
                        croppedVid = frame(300:end,1:500,:);
                    end
                    writeVideo(vW,croppedVid);
                end
                close(vW);
            end
        end
    end
end

%%