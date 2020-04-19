% - Compute optical flow (MyFlow)

%         - Using five point gaussian convolution filter (see lab manual) Make sure it's flipped
%             - Run in x direction for Ix
%             - Run in y direction for Iy

function [u,v] =  myFlow(img1,img2,win_length, threshold)
    %5 point Gaa    ussian convolution filter
    conv_filter5 = (1/12)*[-1 8 0 -8 1];
    %flip gaussian kernel
    flipped_gaus_filter = rot90(conv_filter5,2);
    %covert the images to a range of [0 1]
    img1 = mat2gray(img1);
    img2 = mat2gray(img2);
    img1 = imresize(img1, [100 100]);
    img2 = imresize(img2, [100 100]);
    %Compute spatial derivatives in first frame (Ix, Iy)     
    Ix_img1 = conv2(img1,flipped_gaus_filter,'same');
    Iy_img1 = conv2(img1,flipped_gaus_filter','same');

    row = size(img1,1);
    col = size(img1,2);
    i = 3;
    h = fspecial('gaussian',i,1);
    h_w = fft2(h,row,col);
    img1_w = fft2(img1);
    img2_w = fft2(img2);
    result1 = ifft2(h_w.*img1_w);
    result2 = ifft2(h_w.*img2_w);
    %Smooth the images
%     image1 = filter2(h_w, img1);
%     image2 = filter2(h_w, img2);
    %Compute the difference to get temporal derivative, convert it back to
    %time domain
    It = result2 - result1;

    %Compute component wise summations
    h = ones(win_length);
    Ix_Ix = Ix_img1.*Ix_img1;
    Ix_sum = conv2(Ix_Ix,h);
    Iy_Iy = Iy_img1.*Iy_img1;
    Iy_sum = conv2(Iy_Iy,h);
    Ix_Iy = Ix_img1.*Iy_img1;
    Ix_Iy_sum = conv2(Ix_Iy,h);
    Ix_It = Ix_img1.*It;
    Ix_It_sum = conv2(Ix_It,h);
    Iy_It = Iy_img1.*It;
    Iy_It_sum = conv2(Iy_It,h);
    
    u = zeros(size(img1, 1), size(img1, 2));
    v = zeros(size(img1, 1), size(img1, 2));
    %Get Ax = b 
    for row=1:size(Ix_Ix,1)
        for col=1:size(Ix_Ix,2)
           A = [Ix_sum(row,col) Ix_Iy_sum(row,col); Ix_Iy_sum(row,col) Iy_sum(row,col)];
           b = -[Ix_It_sum(row,col); Iy_It_sum(row,col)];
           %Find eigen values
            e = eig(A);
            %solve for x i.e (u,v)
  
                if min(e) < threshold 
                    continue;
                else
                    u_v = A\b;
                    u(row, col) = u_v(1);
                    v(row, col) = u_v(2);
                end
                
                
                
        end
    end
           
end