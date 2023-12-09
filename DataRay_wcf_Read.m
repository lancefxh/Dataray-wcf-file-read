% this script is used to expert the sequence frame data from dataray .wcf file
% the file structure can be found in "dataray-wcf-file-structure.pdf"
% Code Copyrighted, 2023 by Xuhao Fan. All rights reserved.
%%
clc;clear;close all

% Open WCF file
filename = 'Sample.wcf';
iname=strrep(filename(1: find('.'==filename)-1),'_', '');
fileID = fopen(filename, 'rb');
% Read WC_IMAGE_DATA_HEADER_2, get the file information
header.Signature = fread(fileID, 1, 'uint32'); %DWORD is 4 bytes
header.Type = fread(fileID, 1, 'uint32');
header.Size = fread(fileID, 1, 'uint32');
header.Images = fread(fileID, 1, 'uint32');
header.ImagesSize = fread(fileID, 1, 'uint32');
header.Version = fread(fileID, 40, '*char')'; %A 40 byte character array
fprintf('Number of Frames %s \n',num2str(header.Images)); % Display the total number of frames
fclose(fileID);

% Read the actual image data
fileID = fopen(filename, 'rb'); 
image = {}; 
fseek(fileID, 5592, 'cof');  % skip the header WC_IMAGE_DATA_HEADER_2.(5592 byte)
Img_width=1024;Img_height=1024;  % set the imgage size
for i = 1:header.Images
    fseek(fileID,944, 'cof');  % Skip the header WC_IMAGE_DATA (944 bytes header)
    imageData = fread(fileID, Img_width*Img_height, 'uint16');
    image{i}=reshape(imageData,Img_width,Img_height)';
    string{i}=strcat(iname,'-',num2str(i,'%03d'));
end
fclose(fileID);

%%%%%% GIF image generation
figure(1)
numFrames=size(image,2);
% while true  % Set looping playback
    for i = 1:numFrames
        imagesc(image{i});
        axis off;axis image;colormap hot;title(string{i});
        pause(0.5);                    %Set the interval between frames
        % % use for gernate a gif file
        % Frame = getframe(gcf);         %Get the image of the current drawing window
        % Frames{i} = frame2im(Frame);   %Return image data related to frames
        % If the Figure window is closed, exit the loop
        if ~ishandle(gcf)
            break;
        end
    end
% end
