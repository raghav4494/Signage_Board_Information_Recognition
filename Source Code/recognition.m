%To crop the segment from source Image
input = output;
values = unique(input(input~=0));
count = numel(values);
Area = zeros(count,1);
[row,col] = size(input);
%For all the idnetified segments
for indexing = 1:count

    
top_i = 0;
top_j = 0;
bottom_i = 0;
bottom_j = 0;
flag = 0;
%To identify, where the segment begins at the north (- top)
for i = 1:row
    for j = 1:col
    if(input(i,j) == values(indexing))
        top_i = i;
        top_j = j;
        flag = 1;
        break
    end
    end
    if(flag == 1)
        break
    end
end
flag = 0;

%To identify, where the segment ends at the south (- bottom)
for i = row:-1:1
    for j = 1:col
    if(input(i,j) == values(indexing))
        bottom_i = i;
        bottom_j = j;
        flag = 1;
        break
    end
    end
    if(flag == 1)
        break
    end
end

flag = 0;

%To identify, where the segment ends at from the east (-right)
for i = col:-1:1
    for j = 1:row
    if(input(j,i) == values(indexing))
        right_i = j;
        right_j = i;
        flag = 1;
        break
    end
    end
    if(flag == 1)
        break
    end
end

flag = 0;

%To identify, where the segment begins starts at the west (-left)
for j = 1:col
    for i = 1:row
    if(input(i,j) == values(indexing))
        left_i = i;
        left_j = j;
        flag = 1;
        break
    end
    end
    if(flag == 1)
        break
    end
end

%Borders of Square Calculation - To form square

square_right_row_top = top_i - 5;
square_right_col_top = right_j + 5;

square_left_row_top = square_right_row_top;
square_left_col_top = left_j - 5;

square_left_row_bottom = bottom_i + 5;
square_left_col_bottom = square_left_col_top;

square_right_row_bottom = square_left_row_bottom;
square_right_col_bottom = square_right_col_top;

%To plot the identified shape on the original image
width = square_right_col_top - square_left_col_top;
height = square_left_row_bottom - square_left_row_top;

Area(indexing) = width * height;

if(Area(indexing) > 2000)

figure
imshow(source)
rectangle('Position',[square_left_col_top,square_left_row_top,width,height],'LineWidth',5,'EdgeColor','r'),title('Identified Signage Information');
%To analyse the cropped Image
%Extracting the segment from the source
cropped_Image = source(square_left_row_top:square_right_row_bottom,square_left_col_top:square_right_col_bottom,:);
figure
imshow(cropped_Image),title('Extracted Image');

%To alarm, The sign has been identified
[y,fs] = audioread('Horn.wav');
sound = audioplayer(y,fs);
play(sound);

%Optical character Recognition
% text = ocr(cropped_Image);
end
end