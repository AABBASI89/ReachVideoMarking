%% Crop and compress reach videos
% Author - Aamir Abbasi
%% ------------------------------------------------------------------------
clc; clear; close all;
hand = 1; % 2: Right Hand Cam 2; 1: Left Hand Cam 1 CHANGE ACCORDINGLY
preStroke = 1; % 1: Crop videos in PreStroke Folder 2: Crop post-stroke videos CHANGE ACCORDINGLY
RatID = {'I206'}; % CHANGE ANIMAL ID ACCORDINGLY
for a = 1:length(RatID)
    rootpath = ['Y:\M1_Stroke\',RatID{a},'\PreStroke\'];
    Days = dir([rootpath,'Day*']);
    for d = length(Days)
        if preStroke == 1
            reach = 1; % For pre stroke or post stroke with only one reach session
        else
            reach = dir([rootpath,Days(d).name,'\Reach_Vids\Reach*']); % For post stroke
        end
        for r = 1:length(reach)
            if hand == 1 && preStroke == 1 % Pre Stroke
                videos = dir([rootpath,Days(d).name,'\I*Cam1*.avi']); % For pre stroke
            elseif hand == 2 && preStroke == 1 % Pre Stroke
                videos = dir([rootpath,Days(d).name,'\I*Cam2*.avi']); % For pre stroke
            elseif hand == 1 && preStroke == 2 % Post Stroke
                videos = dir([rootpath,Days(d).name,'\Reach_Vids\',reach(r).name,'\I*Cam1*.avi']); % For post stroke               
            elseif hand == 2 && preStroke == 2 % Post Stroke
                videos = dir([rootpath,Days(d).name,'\Reach_Vids\',reach(r).name,'\I*Cam2*.avi']); % For post stroke         
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
                    if hand == 1
                        croppedVid = frame_resized(100:end,110:end,:);
                    elseif hand == 2
                        croppedVid = frame_resized(100:end,20:140,:);
                    end
                    writeVideo(vW,croppedVid);
                end
                close(vW);
            end
        end
    end
end

%%