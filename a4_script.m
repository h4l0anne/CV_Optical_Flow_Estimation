StudentName = "Anne Li Ne Li"
StudentNumber = "500722909"
disp("Student Name: " + StudentName)
disp("Student ID: " + StudentNumber)

close all;
clear all;

%% CONVOLUTION
%1.1
img = imread('car.jpg');
I = rgb2gray(img);
timeArray = [];
kernelSize = [3,5,7,13,41,51,71];

for i = [3,5,7,13,41,51,71]
    h = fspecial('gaussian', i, i);
    tic
    conv_result = conv2(I,h);
    time = toc;
    timeArray = [timeArray,time];                 
end

plot(kernelSize, timeArray);
xlabel('kernel size');
ylabel('execution time (seconds)');
hold on;

%1.2 Convolution in frequency domain
timeArray2 = [];
for i = [3,5,7,13,41,51,71]
    h = fspecial('gaussian', i, i);
    tic
    %change to freq domain
    h_w = fft2(h,480,640);
    i_w = fft2(I);
    %convolute by multiplying
    result_w = h_w.*i_w;
    %convert back to time domain
    result = ifft2(result_w);
    time = toc
    timeArray2 = [timeArray2,time];
   
end

figure(1);
plot(kernelSize, timeArray2);
legend('conv2','FreqDomain'); 
xlabel('kernel size');
ylabel('execution time (seconds)');
hold off;

%1.3
fprintf('The execution time for convolution in the time domain increases linearly with kernel size.\n');
fprintf("While in frequency based convolution the time taken is much smaller and it's almost constant, \n");
fprintf('no matter the size of the kernel.');

%% HYBRID IMAGE
img1 = imread('thor.png');
img2 = imread('loki.png');
img1 = imresize(img1,[660 1200]);
img2 = imresize(img2,[660 1200]);
%   - Convert to gray - rgb2gray()
thor = rgb2gray(img1);
loki = rgb2gray(img2);

%   - fft2 of images -> img1_fft, img2_fft
%   - Low Pass filter
%   - Make gaussian kernel - Test it
sigma = 6;
hsize = sigma*6 +1;

h2 = fspecial('gaussian', hsize, sigma);
%   - fft2 of gaussian kernel
h2_w = fft2(h2,660,1200);
img1_fft = fft2(thor);
img2_fft = fft2(loki);

%   - Convolute gaussian kernel with img1
%        - Multiply img1_fft with fft2 of gaussian kernel -> low_frequency_img
img1_w = img1_fft.*h2_w;

%    - High pass filter
%        - hpf = 1 - gaussian_kernel (Frequency domain)
hpf = 1 - h2_w;
%    - Multiply img2_fft * hpf -> high_frequency_img
img2_w = img2_fft.*hpf; 
%    - Add low_frequency_img and high_frequency_img -> result
result = img1_w + img2_w;
%    - ifft of result
hybrid_result = ifft2(result);
%    - Show hybrid image
figure(2); 
imshow(uint8(hybrid_result));
figure(3);
imshow(imresize(uint8(hybrid_result),0.1));

%% OPTICAL FLOW ESTIMATION
%% 3.1 sphere
close all;
img1 = imread('Sequences\Sequences\sphere\sphere_0.png');
img2 = imread('Sequences\Sequences\sphere\sphere_1.png');

img1 = rgb2gray(img1);
img2 = rgb2gray(img2);

img1 = double(img1);
img2 = double(img2);

win_length = 25;
threshold = 0.01;
[u,v] = myFlow(img1,img2,win_length,threshold);

%3.2 flowToColor sphere

flow = u;
flow(:,:,2) = v;
flowToColor(flow);
figure('Name','flowToColor for sphere'), imshow(flowToColor(flow),[]);
fprintf('The size of the flow fields increases and the intensity of the colours intensifies \n');
fprintf('when the window length is increased.\n');

% 3.3 myWarp
myWarp(img1,img2,u,v);

%% 3.1 corridor
close all;
img3 = imread('Sequences\Sequences\corridor\bt_0.png');
img4 = imread('Sequences\Sequences\corridor\bt_1.png');

img3 = double(img3);
img4 = double(img4);

win_length = 25;
threshold = 0.01;
[u,v] = myFlow(img3,img4,win_length,threshold);

% 3.2 flowToColor corridor

flow = u;
flow(:,:,2) = v;
flowToColor(flow);
figure('Name','flowToColor for corridor'), imshow(flowToColor(flow),[]);
fprintf('The size of the flow fields increases and the intensity of the colours intensifies \n');
fprintf('when the window length is increased.\n');

% 3.3 myWarp
myWarp(img3,img4,u,v);

%% 3.1 synth
close all;
img5 = imread('Sequences\Sequences\synth\synth_0.png');
img6 = imread('Sequences\Sequences\synth\synth_1.png');

img5 = double(img5);
img6 = double(img6);

win_length = 20;
threshold = 0.01;
[u,v] = myFlow(img5,img6,win_length,threshold);

% 3.2 flowToColor synth

flow = u;
flow(:,:,2) = v;
flowToColor(flow);
figure('Name','flowToColor for synth'), imshow(flowToColor(flow),[]);
fprintf('The size of the flow fields increases and the intensity of the colours intensifies \n');
fprintf('when the window length is increased.\n');

% 3.3 myWarp
myWarp(img5,img6,u,v);

