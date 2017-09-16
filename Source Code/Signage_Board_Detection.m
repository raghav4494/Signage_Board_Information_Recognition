close all
%Read Source Image
source = imread('traffic3.jpg');

figure;
imshow(source),title('Source Image');

%Extract R,G and B portions of the image
red = source(:,:,1);
green = source(:,:,2);
blue = source(:,:,3);

%Stop and yield signs are always red in colour
%Extracting only the red portion from the source image
final = red - blue - green;

figure;
imshow(final),title('After R portion Extraction');

%To analyse Connected Components, we are converting extracted image into
%binary image
binary_image = imbinarize(final);

figure;
imshow(binary_image),title('After converting to Binary Image');

%To remove noises, and tiny portions
noiseless_image = bwareaopen(binary_image, 400);

figure
imshow(noiseless_image),title('After removing smaller areas');

%Connected Components Analysis
%using 4 connectivity
connected = bwlabel(noiseless_image, 4);    
Major_axis = regionprops(connected, 'MajorAxisLength');
Minor_axis = regionprops(connected, 'MinorAxisLength');

%No of connected Components
uniques = unique(connected);
count = max(uniques);

output = connected; 

%Removing portions of image that are not fit to be signage board
for i = 1:count
    fill_numerator = Major_axis(i).MajorAxisLength;
    fill_denominator = Minor_axis(i).MinorAxisLength;
    fill_ratio = fill_numerator/fill_denominator;
    %To avoid dividing by zero
    if (Minor_axis(i).MinorAxisLength==0)
        output(connected==i) = 0;
    %Filing ratio
    %1.6 - Set value for a standard stop sign board
    elseif (fill_ratio > 1.6)
        output(connected==i) = 0;
    end
end

figure;
imshow(output);title('Removing filling ratio > 1.6');

%To determine Areas eliminating segments with small area
BW2 = bwareaopen(output, 500);
subplot(1,3,2),
imshow(BW2),title('Eliminating the segments other than signage');

%Mapping the existing areas on the connected components image
output(BW2 == 0) = 0;
figure;
imshow(output),title('Segmented Image');
recognition();