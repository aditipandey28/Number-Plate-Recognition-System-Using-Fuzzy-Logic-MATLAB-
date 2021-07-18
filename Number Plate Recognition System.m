clc;

clear all;

close all;

clear workspace;

I = imread('34.jpg');

Igray = rgb2gray(I);

%array conversion

Img = im2double(Igray);

GImgx = [-1 1];

GImgy = GImgx;

Imgx = conv2(Img,GImgx,'same');

Imgy = conv2(Img,GImgy,'same');

figure(1)

image(Imgx,'CDataMapping','scaled')

colormap('gray')

title('Imgx')

figure(2)

image(Imgy,'CDataMapping','scaled')

colormap('gray')

title('Imgy')

%edge

edgeFIS = mamfis('Name','edgeDetection');

edgeFIS = addInput(edgeFIS,[-1 1],'Name','Imgx');

edgeFIS = addInput(edgeFIS,[-1 1],'Name','Imgy');

sx = 0.1;

sy = 0.1;

edgeFIS = addMF(edgeFIS,'Imgx','gaussmf',[sx 0],'Name','zero');

edgeFIS = addMF(edgeFIS,'Imgy','gaussmf',[sy 0],'Name','zero');

edgeFIS = addOutput(edgeFIS,[0 1],'Name','Iout');

d1 = 0.1;

d2 = 1;

d3 = 1;

d4 = 0;

d5 = 0;

d6 = 0.7;

edgeFIS = addMF(edgeFIS,'Iout','trimf',[d1 d2 d3],'Name','white');

edgeFIS = addMF(edgeFIS,'Iout','trimf',[d4 d5 d6],'Name','black');

figure(3)

subplot(2,2,1)

plotmf(edgeFIS,'input',1)

title('Imgx')

subplot(2,2,2)

plotmf(edgeFIS,'input',2)

title('Imgy')

subplot(2,2,[3 4])

plotmf(edgeFIS,'output',1)

title('Iout')

r1 = "If Imgx is zero and Imgy is zero then Iout is white";

r2 = "If Imgy is not zero or Imgy is not zero then Iout is black";

edgeFIS = addRule(edgeFIS,[r1 r2]);

edgeFIS.Rules

Ieval = zeros(size(Img));

for ii = 1:size(Img,1)

Ieval(ii,:)= evalfis(edgeFIS,[(Imgx(ii,:));(Imgy(ii,:))]');

end

figure(4)

image(Img,'CDataMapping','scaled')

colormap('gray')

title('Original Grayscale Image')

figure(5)

image(Ieval,'CDataMapping','scaled')

colormap('gray')

title('Edge Detection Using Fuzzy logic')

writeFIS(edgeFIS,'Fuzzy_Edge')

[y1,x1] = size(Igray);

%add noise to the image

J = imnoise(Igray,'gaussian',0.02);

% mean filter

M = imnlmfilt(J);

% median filter

K = medfilt2(J);

figure(5)

subplot(2,2,1)

imshow(I)

title('Original image')

subplot(2,2,2)

imshow(J)

title('Noisy image')

subplot(2,2,3)

imshow(M)

title('Mean Filter')

subplot(2,2,4)

imshow(K)

title('Median Filter');

% array conversion

Img = im2double(J);

Mean = im2double(M);

Median = im2double(K);

% noise

noiseFIS = mamfis('Name','Noise Reduction');

noiseFIS = addInput(noiseFIS,[-1 1],'Name','Mean');

noiseFIS = addInput(noiseFIS,[-1 1],'Name','Median');

sx = 0.4;

sy = 0.7;

noiseFIS = addMF(noiseFIS,'Mean','gaussmf',[sx 0],'Name','zero');

noiseFIS = addMF(noiseFIS,'Median','gaussmf',[sy 0],'Name','zero');

noiseFIS = addOutput(noiseFIS,[0,1],'Name','Iout');

noiseFIS = addMF(noiseFIS,'Iout','gaussmf',[0.0314 0.0784 0.1686],'Name','Homogeneous');

noiseFIS = addMF(noiseFIS,'Iout','gaussmf',[0.1314 0.1549 0.2078],'Name','Details');

figure(6)

subplot(2,2,1)

plotmf(noiseFIS,'input',1)

title('Mean')

subplot(2,2,2)

plotmf(noiseFIS,'input',2)

title('Median')

subplot(2,2,[3,4])

plotmf(noiseFIS,'output',1)

title('Iout')

r1 = "If Mean is zero and Median is zero then Iout is Homogeneous ";

r2 = "If Mean is not zero or Median is not zero then Iout is Details";

noiseFIS = addRule(noiseFIS,[r1 r2]);

noiseFIS.Rules

Ieval = zeros(size(Img));

for ii = 1:size(Img,1)

Ieval(ii,:)= evalfis(noiseFIS,[(Mean(ii,:));(Median(ii,:))]');

end

figure(7)

image(Ieval,'CDataMapping','scaled')

colormap('gray')

title('Noise Reduction Using Fuzzy logic')

writeFIS(noiseFIS,'Fuzzy_Noise')

[y1,x1] = size(Igray);

J = imnoise(Igray,'gaussian',0.02);

figure(8)

imshow(J);

impixelinfo;

%extract min and max from the image array

minGraylevel = min(J(:));

maxGraylevel = max(J(:));

disp('minGraylevel');

disp('maxGraylevel');

%array conversion

Img = im2double(J);

%enhance

enhanceFIS = mamfis('Name','image enhancement');

enhanceFIS = addInput(enhanceFIS,[0 1],'Name','Img');

enhanceFIS = addMF(enhanceFIS,'Img','trimf',[-0.4 0 0.4],'Name','DARK');

enhanceFIS = addMF(enhanceFIS,'Img','trimf',[0.1 0.5 0.9],'Name','GRAY');

enhanceFIS = addMF(enhanceFIS,'Img','trimf',[0.6 1 1.4],'Name','BRIGHT');

enhanceFIS = addOutput(enhanceFIS,[0 1],'Name','Iout');

enhanceFIS = addMF(enhanceFIS,'Iout','trimf',[-0.5 0 0.5],'Name','DARKER');

enhanceFIS = addMF(enhanceFIS,'Iout','trimf',[0.2 0.7 1.2],'Name','GRAY');

enhanceFIS = addMF(enhanceFIS,'Iout','trimf',[0.8 1.3 1.8],'Name','BRIGHTER');

figure(9)

subplot(2,1,1)

plotmf(enhanceFIS,'input',1)

title('Img')

subplot(2,1,2)

plotmf(enhanceFIS,'output',1)

title('Iout')

r1 = "If Img is DARK then Iout is DARKER";

r2 = "If Img is GRAY then Iout is GRAY";

r3 = "If Img is BRIGHT then Iout is BRIGHTER";

enhanceFIS = addRule(enhanceFIS,[r1 r2 r3]);

enhanceFIS.Rules

Ieval = zeros(size(Img));

for ii = 1:size(Img,1)

Ieval(ii,:) = evalfis(enhanceFIS,(Img(ii,:))');

end

figure(10)

image(Ieval,'CDataMapping','scaled')

colormap(gray)

title('enhanced using fuzzy logic')

writeFIS(enhanceFIS,'Fuzzy_Enhance')

for i=1:1

imwrite(Ieval,'i.jpg')

end

A=imread('i.jpg');

% A=~A;

g=strel('disk',5);

A=imclose(A,g)