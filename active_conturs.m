%  Doron Gusenberg 
% Q1 
clc;clear;
brain = imread("MR_brain.jpg");
brain1 = rgb2gray(brain);
figure(1)
imshow(brain1)
title("original image")
figure(2)
[x, y, cropped, rect] = imcrop(brain1); % Crop malignent image please
cropped = round(cropped);
rect = round(rect);

brain1(rect(2):(rect(2)+rect(4)),rect(1):(rect(1)+rect(3)))=255;
brain1(brain1~=255)=0;

%1 c
figure(1)
subplot(3,2,1)
imshow(brain)
title("original image")
subplot(3,2,2)
imshow(brain)
hold on 
visboundaries(brain1)
title("original image with initial curve")


%mask = (rect(2):(rect(2)+rect(4)),rect(1):(rect(1)+rect(3)) = 1;
mask = brain1;
mask(mask==255)=1;
mask = logical(mask);

tumor_chan = activecontour(rgb2gray(brain),mask,415,'Chan-vese', ContractionBias=0.61);
subplot(3,2,3)
imshow(tumor_chan)
title("The tumor")


brain_chan = activecontour(rgb2gray(brain),mask,400,'Chan-vese');
subplot(3,2,4)
imshow(brain_chan)
title("The whole brain")

Mx = [-1 0 1; -1 0 1; -1 0 1];
My = [-1 -1 -1; 0 0 0; 1 1 1];
%perwit for edge detction
Y = conv2(tumor_chan ,Mx,"same");
Y1 = conv2(tumor_chan ,My,"same");
Y3 = conv2(brain_chan ,Mx,"same");
Y4 = conv2(brain_chan ,My,"same");
 
% The same keeps the dimensions of the figure the same after convulotion
Y2 = abs(Y1)+abs(Y);
Y5 = abs(Y3)+abs(Y4);
edgi = Y2~=0;
edgi2 = find(Y5~=0);
tumor_c = tumor_chan;
tumor_c(edgi)=255;
tumor_c = tumor_c -tumor_chan; 

brain_c = brain_chan;
brain_c(edgi2)=255;
brain_c = brain_c -brain_chan; 
bound_im = brain_c+tumor_c; 
subplot(3,2,5)
se1 = [0 1 0;1 1 1;0 1 0];
bound_im1 = imdilate(bound_im,se1);
bound_index = find(bound_im1~=0);
imshow(bound_im1)
title("boundries of brain and tumor")
subplot(3,2,6)
brain_tumor_boundries = brain;
red_brain =brain(:,:,1);
green_brain =brain(:,:,2);
blue_brain=brain(:,:,3) ;
red_brain(bound_index) = 255;
green_brain(bound_index) = 0;
blue_brain(bound_index) = 0 ;
brain_tumor_boundries(:,:,1) = red_brain;
brain_tumor_boundries(:,:,2) = green_brain;
brain_tumor_boundries(:,:,3) = blue_brain;
imshow(brain_tumor_boundries)
title("original image with boundries")

tresh = multithresh(rgb2gray(brain),2);
brain2 = rgb2gray(brain);
brain2(brain2<tresh(1))=0;
brain2(brain2>tresh(1)&brain2<tresh(2))=128;
brain2(brain2>tresh(2))=0;

brain2 = logical(brain2); 
brain3 = brain2;
brain3 = imfill(brain3,"holes");
[brain3,n] = bwlabel(brain3);
shows =[];
for i=1:n 
 len = length(find(brain3==i));
 shows(i)=len;
end
ind =find(shows==max(shows));
brain3(brain3~=ind)=0;
brain3(brain3==ind)=1;

% we have assumed the brain is the largest connected group of the pixels
% in the image.
brain5 = brain2-logical(brain3);
brain6 = brain2-logical(brain5);
brain3 = imopen(uint8(brain6),strel("disk",3,4));
%detecting edges
edge = edge(uint8(brain6),"sobel");
edge = imdilate(edge,strel("disk" ,1));
brain4 = brain;
%drawing edges in red
redi =brain4(:,:,1);
greeni =brain4(:,:,2);
bluei =brain4(:,:,3);
redi(edge~=0)=255;
greeni(edge~=0)=0;
bluei(edge~=0)=0;
brain4(:,:,1)=redi;
brain4(:,:,2)=greeni;
brain4(:,:,3)=bluei;
figure(3)
subplot(1, 2, 1)
imshow(brain4)
title('original image with Boundries - Otsu 3 level')
subplot(1, 2, 2)
imshow(brain_tumor_boundries)
title('original image with Boundries - Active contours')
%% 2 a 
clc;clear;
us_heart = imread("us_heart.jpg");

%imshow(us_heart)
size_us = size(us_heart);
binary_us = zeros([size_us(1),size_us(2)]);
binary_us(85:115,170:230)=255;
%imshow(binary_us)
us_chan_1 = activecontour(rgb2gray(us_heart),binary_us,2000,'Chan-vese','SmoothFactor',1);
Mx = [-1 0 1; -1 0 1; -1 0 1];
My = [-1 -1 -1; 0 0 0; 1 1 1];
%perwit for edge detction
Y = conv2(us_chan_1,Mx,"same");
Y1 = conv2(us_chan_1 ,My,"same");
Y2 = abs(Y1)+abs(Y);
edgi = find(Y2~=0);
us_heart1=us_heart;
red_us = us_heart1(:,:,1);
green_us = us_heart1(:,:,2);
blue_us = us_heart1(:,:,3);
red_us(edgi)=255;
green_us(edgi)=0;
blue_us(edgi)=0;
us_heart1(:,:,1) = red_us ;
us_heart1(:,:,2) = green_us;
us_heart1(:,:,3) = blue_us;


us_chan_3 = activecontour(rgb2gray(us_heart),binary_us,2000,'Chan-vese','SmoothFactor',3);

%perwit for edge detction
Y_3 = conv2(us_chan_3,Mx,"same");
Y1_3 = conv2(us_chan_3 ,My,"same");
Y2_3 = abs(Y1_3)+abs(Y_3);
edgi_3 = find(Y2_3~=0);
us_heart3=us_heart;
red_us_3 = us_heart3(:,:,1);
green_us_3 = us_heart3(:,:,2);
blue_us_3 = us_heart3(:,:,3);
red_us_3(edgi_3)=255;
green_us_3(edgi_3)=0;
blue_us_3(edgi_3)=0;
us_heart3(:,:,1) = red_us_3 ;
us_heart3(:,:,2) = green_us_3;
us_heart3(:,:,3) = blue_us_3;


us_chan_5 = activecontour(rgb2gray(us_heart),binary_us,2000,'Chan-vese','SmoothFactor',5);

%perwit for edge detction
Y_5 = conv2(us_chan_5,Mx,"same");
Y1_5 = conv2(us_chan_5 ,My,"same");
Y2_5 = abs(Y1_5)+abs(Y_5);
edgi_5 = find(Y2_5~=0);
us_heart5=us_heart;
red_us_5 = us_heart5(:,:,1);
green_us_5 = us_heart5(:,:,2);
blue_us_5 = us_heart5(:,:,3);
red_us_5(edgi_5)=255;
green_us_5(edgi_5)=0;
blue_us_5(edgi_5)=0;
us_heart5(:,:,1) = red_us_5 ;
us_heart5(:,:,2) = green_us_5;
us_heart5(:,:,3) = blue_us_5;


figure(4)
subplot(2,2,1)
imshow(us_heart)
title(" original image ")
subplot(2,2,2)
imshow(us_heart1)
title(" original image with boundries smooth = 1")
subplot(2,2,3)
imshow(us_heart3)
title(" original image with boundries smooth = 3")
subplot(2,2,4)
imshow(us_heart5)
title(" original image with boundries smooth = 5")

%% 3a
clc;clear;
figure(5)
feet = imread("feet.jpg");
imshow(feet)
[x,y] = ginput(2);
bin_fit = rgb2gray(feet);
zeros_feet = zeros(size(bin_fit));
zeros_feet(y(1)-5:y(1)+5,x(1)-5:x(1)+5)=255;
zeros_feet(y(2)-5:y(2)+5,x(2)-5:x(2)+5)=255;
feet_chan_3 = activecontour(bin_fit,zeros_feet,1000,'Chan-vese','SmoothFactor',1,'ContractionBias',0.25);


% 3c
%perwit for edge detction
Mx = [-1 0 1; -1 0 1; -1 0 1];
My = [-1 -1 -1; 0 0 0; 1 1 1];
Y_3 = conv2(feet_chan_3,Mx,"same");
Y1_3 = conv2(feet_chan_3 ,My,"same");
Y2_3 = abs(Y1_3)+abs(Y_3);
edgi_3 = find(Y2_3~=0);
feet3=feet;
red_fe_3 = feet3(:,:,1);
green_fe_3 = feet3(:,:,2);
blue_fe_3 = feet3(:,:,3);
red_fe_3(edgi_3)=255;
green_fe_3(edgi_3)=255;
blue_fe_3(edgi_3)=0;
feet3(:,:,1) = red_fe_3 ;
feet3(:,:,2) = green_fe_3;
feet3(:,:,3) = blue_fe_3;
figure(6)
subplot(2,2,1)
imshow(feet)
title(" original image ")
subplot(2,2,2)
imshow(bin_fit)
title(" original image gray level")
subplot(2,2,3)
imshow(feet_chan_3)
title(" The shoes and trouser")
subplot(2,2,4)
imshow(feet3)
title("original image with boundries")
% 3d

zeros_feet2 = zeros(size(bin_fit));
zeros_feet2(y(1)-5:y(1)+5,x(1)-5:x(1)+5)=255;
feet_chan_4 = activecontour(bin_fit,zeros_feet2,1000,'Chan-vese','SmoothFactor',1,'ContractionBias',0.25);
% 3e
%perwit for edge detction
Mx = [-1 0 1; -1 0 1; -1 0 1];
My = [-1 -1 -1; 0 0 0; 1 1 1];
Y_4 = conv2(feet_chan_4,Mx,"same");
Y1_4 = conv2(feet_chan_4 ,My,"same");
Y2_4= abs(Y1_4)+abs(Y_4);
edgi_4 = find(Y2_4~=0);
feet4=feet;
red_fe_4 = feet4(:,:,1);
green_fe_4 = feet4(:,:,2);
blue_fe_4 = feet4(:,:,3);
red_fe_4(edgi_4)=255;
green_fe_4(edgi_4)=255;
blue_fe_4(edgi_4)=0;
feet4(:,:,1) = red_fe_4 ;
feet4(:,:,2) = green_fe_4;
feet4(:,:,3) = blue_fe_4;
figure(7)
subplot(2,2,1)
imshow(feet)
title("original Image")
subplot(2,2,3)
imshow(feet3)
title("shoes and trouser")
subplot(2,2,4)
imshow(feet4)
title("only the shoes")

% 4

video_feet = VideoReader('feet.avi');
vec = 1:5:200;
less_frames={};
count = 1;
for i = 1:5:200
   less_frames{count} = read(video_feet ,i);
   count =count+ 1;
end
se = ones(5);
size4 = size(less_frames{1});
dim4 = ones(size4(1),size4(2),size4(3),40);
final_frames={};
for i = 1:40
    feet_chan_4 = imerode(feet_chan_4,se);
    bin_image = rgb2gray(less_frames{i});
    feet_chan = activecontour(bin_image ,feet_chan_4,300,'Chan-vese','SmoothFactor',1,'ContractionBias',0.25);
    feet_chan_4=feet_chan;
    Mx = [-1 0 1; -1 0 1; -1 0 1];
    My = [-1 -1 -1; 0 0 0; 1 1 1];
    Y_4 = conv2(feet_chan_4,Mx,"same");
    Y1_4 = conv2(feet_chan_4 ,My,"same");
    Y2_4= abs(Y1_4)+abs(Y_4);
    edgi_4 = find(Y2_4~=0);
    feet4=less_frames{i};
    red_fe_4 = feet4(:,:,1);
    green_fe_4 = feet4(:,:,2);
    blue_fe_4 = feet4(:,:,3);
    red_fe_4(edgi_4)=255;
    green_fe_4(edgi_4)=255;
    blue_fe_4(edgi_4)=0;
    feet4(:,:,1) = red_fe_4 ;
    feet4(:,:,2) = green_fe_4;
    feet4(:,:,3) = blue_fe_4;
    dim4(:,:,:,i)=feet4;

    
end

implay(uint8(dim4))
%% 5
clc;clear;
se1 = ones(5);
se  = strel('disk', 5);
therm = VideoReader('thermal.avi');
vec = 1:5:200;
frames={};
for i = 1:25
   frames{i} = read(therm ,i);
end

hsv_image= rgb2hsv(frames{1});
lowerThreshold = [0.0, 0.9005, 0.7];
upperThreshold = [0.17, 1, 0.827];
red= (hsv_image(:, :, 1) >= lowerThreshold(1) & hsv_image(:, :, 1) <= upperThreshold(1)) & ...
    (hsv_image(:, :, 2) >= lowerThreshold(2) & hsv_image(:, :, 2) <= upperThreshold(2)) & ...
    (hsv_image(:, :, 3) >= lowerThreshold(3) & hsv_image(:, :, 3) <= upperThreshold(3));
red  = imclose(red,se);
red  = imfill(red,"holes");

for i = 1:25
 
    
    bin_image = rgb2gray(frames{i});
    feet_chan_4 = activecontour(bin_image ,red ,150,'Chan-vese','SmoothFactor',1.07,'ContractionBias',0.405);
    red =feet_chan_4;
    Mx = [-1 0 1; -1 0 1; -1 0 1];
    My = [-1 -1 -1; 0 0 0; 1 1 1];
    Y_4 = conv2(feet_chan_4,Mx,"same");
    Y1_4 = conv2(feet_chan_4 ,My,"same");
    Y2_4= abs(Y1_4)+abs(Y_4);
    edgi_4 = find(Y2_4~=0);
    therm4=frames{i};
    red_fe_4 = therm4(:,:,1);
    green_fe_4 = therm4(:,:,2);
    blue_fe_4 = therm4(:,:,3); 
    red_fe_4(edgi_4)=255;
    green_fe_4(edgi_4)=0;
    blue_fe_4(edgi_4)=0;
    therm4(:,:,1) = red_fe_4 ;
    therm4(:,:,2) = green_fe_4;
    therm4(:,:,3) = blue_fe_4;
    dim4(:,:,:,i)=therm4;

    red = imerode(red,se1);
    
end

figure(14)
imshow(frames{1})
implay(uint8(dim4))


