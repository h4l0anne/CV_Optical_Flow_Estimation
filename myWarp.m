function [warpedImg2,I] = myWarp(img1,img2,u,v)

%       'nearest' - nearest neighbor interpolation
%       'linear'  - bilinear interpolation
%       'spline'  - spline interpolation
%       'cubic'   - bicubic interpolation as long as the data is
%                   uniformly spaced, otherwise the same as 'spline'
%       'makima'  - modified Akima cubic interpolation

img1 = double(img1);
img2 = double(img2);
figure('Name','img1');
J = uint8(img1);
imshow(J);

[M,N]=size(img2);
[x,y]=meshgrid(1:N,1:M);


%warped Img2 for bicubic interpolation
warpedImg2=interp2(x,y,img2,x+u,y+v,'cubic');
I=find(isnan(warpedImg2));
warpedImg2(I)=zeros(size(I));
%take the difference of img1
result_bicubic = warpedImg2 - img1;
%display the difference and take absolute
figure('Name','bicubic method');
imshow(abs(result_bicubic));

%warped Img2 for bilinear interpolation
warpedImg2=interp2(x,y,img2,x+u,y+v,'linear');
I=find(isnan(warpedImg2));
warpedImg2(I)=zeros(size(I));
%take the difference of img1
result_bilinear = warpedImg2 - img1;
%display the difference and take absolute
figure('Name','bilinear method');
imshow(abs(result_bilinear));

for i = 1:5
    figure('Name','warped Image');
    imshow(uint8(warpedImg2));
    figure('Name','img1');
    imshow(J);
    drawnow;
end

end
