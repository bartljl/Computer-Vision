
function Final_output = Canny_edge_detector(img,sigma,Threshold)%sigma is scale,Threshold is the high threshold
%for sigma = start_sigma:0.05:0.35
%2D Gaussian filter generator,size = 5*5
x = -1/2:1/(5-1):1/2;
[Y,X] = meshgrid(x,x);
Gaussian_filter = exp( -(X.^2+Y.^2)/(2*sigma^2) );
Gaussian_filter = Gaussian_filter / sum(Gaussian_filter(:));
%Use gaussian filter to smooth
conv_img = conv2(img,Gaussian_filter);
%figure, imshow(conv_img,[]);
%Find the edge strength
x = [
     -1 0 1
     -2 0 2
	   -1 0 1
	  ];
y = [
     1  2  1
     0  0  0
    -1 -2 -1	
    ];	 
Gx = conv2(conv_img,x);
Gy = conv2(conv_img,y);
G = abs(Gx) + abs(Gy);
%figure, imshow(G,[]);
%Find the edge direction
[r,c] = size(Gx);
img_degree = zeros(r,c);
for i = 1:r

  for j = 1:c
  
  if Gx(i,j) == 0 & Gy(i,j) == 0 
  img_degree(i,j) = 0;
  elseif Gx(i,j) == 0 & Gy(i,j) ~= 0 
  img_degree(i,j) = 1.5708;
  else
  img_degree(i,j) = atan( Gy(i,j)/Gx(i,j) );
  
  end
  
  end

end
%Label the degree to the nearest 45 degree range.
[r,c] = size(img_degree);
for i = 1:r

  for j = 1:c
  
  if (img_degree(i,j)>=-0.3927 & img_degree(i,j)<0.3927) | (img_degree(i,j)>=2.7489) | (img_degree(i,j)<-2.7489)
  img_degree(i,j) = 0;
  elseif (img_degree(i,j)>=0.3927 & img_degree(i,j)<1.1781) | (img_degree(i,j)>=-2.7489 & img_degree(i,j)<-1.9635)
  img_degree(i,j) = 45;
  elseif (img_degree(i,j)>=1.1781 & img_degree(i,j)<1.9635) | (img_degree(i,j)>=-1.9635 & img_degree(i,j)<-1.1781)
  img_degree(i,j) = 90;
  elseif (img_degree(i,j)>=1.9635 & img_degree(i,j)<=2.7489) | (img_degree(i,j)>=-1.1781 & img_degree(i,j)<-0.3927)
  img_degree(i,j) = 135;
  
  end
  
  end
  
end
%Non-maximum supressing
Non_max_supress_img = G;
%Non_max_supress_img([1 r],:) = 0;
%Non_max_supress_img(:,[1 c]) = 0;

for i = 2:r-1

  for j = 2:c-1
  
  if img_degree(i,j) == 0 
     if max([G(i,j),G(i,j-1),G(i,j+1)]) ~= G(i,j)
	 Non_max_supress_img(i,j) = 0;
	 end
	
  elseif img_degree(i,j) == 45
     if max([G(i,j),G(i+1,j-1),G(i-1,j+1)]) ~= G(i,j) 
     Non_max_supress_img(i,j) = 0;
	 end
	 
  elseif img_degree(i,j) == 90
     if max([G(i,j),G(i-1,j),G(i+1,j)]) ~= G(i,j)
     Non_max_supress_img(i,j) = 0;
	 end
  
  elseif img_degree(i,j) == 135
    if max([G(i,j),G(i-1,j-1),G(i+1,j+1)]) ~= G(i,j)
    Non_max_supress_img(i,j) = 0;
	end
  
  end
  
  end
  
end  
%figure, imshow(Non_max_supress_img,[]);
%Double Thresholding
T_high = Threshold;
T_low = 0.4 * Threshold;
%Hysteresis:choose the weak edges which connect to strong edge
[r,c] = size(Non_max_supress_img);
Hysteresis_img = zeros(r,c);
for i = 1:r

  for j = 1:c
  
   if Non_max_supress_img(i,j) >= T_high
   Hysteresis_img(i,j) = 2;%strong edge
   elseif Non_max_supress_img(i,j) < T_low
   Hysteresis_img(i,j) = 0;%supressed edge
   elseif Non_max_supress_img(i,j) >= T_low & Non_max_supress_img(i,j) < T_high
   Hysteresis_img(i,j) = 1;%weak edge,need check
   end
  
  end

end
%figure, imshow(Hysteresis_img,[]);
%choose weak edges which connected to strong edges
for i = 1:r

  for j = 1:c
  
   if Hysteresis_img(i,j) == 1 & i == 1 & j == 1
    if Hysteresis_img(i,j+1) == 2 | Hysteresis_img(i+1,j) == 2 | Hysteresis_img(i+1,j+1) == 2
    Hysteresis_img(i,j) = 2;
	else 
	Hysteresis_img(i,j) = 0;
	end
	
   elseif Hysteresis_img(i,j) == 1 & i == 1 & j == c
    if Hysteresis_img(i,j-1) == 2 | Hysteresis_img(i+1,j) == 2 | Hysteresis_img(i+1,j-1) == 2
    Hysteresis_img(i,j) = 2;
	else 
	Hysteresis_img(i,j) = 0;
	end
   
   elseif Hysteresis_img(i,j) == 1 & i == r & j == 1
    if Hysteresis_img(i-1,j+1) == 2 | Hysteresis_img(i-1,j) == 2 | Hysteresis_img(i,j+1) == 2
    Hysteresis_img(i,j) = 2;
	else 
	Hysteresis_img(i,j) = 0;
	end
   
   elseif Hysteresis_img(i,j) == 1 & i == r & j == c
    if Hysteresis_img(i-1,j) == 2 | Hysteresis_img(i,j-1) == 2 | Hysteresis_img(i-1,j-1) == 2
    Hysteresis_img(i,j) = 2;
	else 
	Hysteresis_img(i,j) = 0;
	end
	
	elseif Hysteresis_img(i,j) == 1 & i == 1 & j ~= 1 & j ~= c
	 if Hysteresis_img(i,j-1) == 2 | Hysteresis_img(i,j+1) == 2 | Hysteresis_img(i+1,j-1) == 2 | Hysteresis_img(i+1,j) == 2 | Hysteresis_img(i+1,j+1) == 2
     Hysteresis_img(i,j) = 2;
	 else 
	 Hysteresis_img(i,j) = 0;
	 end
    
	elseif Hysteresis_img(i,j) == 1 & i == r & j ~= 1 & j ~= c
	 if Hysteresis_img(i,j-1) == 2 | Hysteresis_img(i,j+1) == 2 | Hysteresis_img(i-1,j-1) == 2 | Hysteresis_img(i-1,j) == 2 | Hysteresis_img(i-1,j+1) == 2
     Hysteresis_img(i,j) = 2;
	 else 
	 Hysteresis_img(i,j) = 0;
	 end
	 
	elseif Hysteresis_img(i,j) == 1 & j == 1 & i ~= 1 & i ~= r
	 if Hysteresis_img(i-1,j) == 2 | Hysteresis_img(i-1,j+1) == 2 | Hysteresis_img(i,j+1) == 2 | Hysteresis_img(i+1,j+1) == 2 | Hysteresis_img(i+1,j) == 2
     Hysteresis_img(i,j) = 2;
	 else 
	 Hysteresis_img(i,j) = 0;
	 end
	 
	elseif Hysteresis_img(i,j) == 1 & j == c & i ~= 1 & i ~= r
     if Hysteresis_img(i-1,j) == 2 | Hysteresis_img(i-1,j-1) == 2 | Hysteresis_img(i,j-1) == 2 | Hysteresis_img(i+1,j-1) == 2 | Hysteresis_img(i+1,j) == 2
     Hysteresis_img(i,j) = 2;
	 else 
	 Hysteresis_img(i,j) = 0;
	 end
	 
	elseif Hysteresis_img(i,j) == 1 & i ~= 1 & i ~= r & j ~= 1 & j ~= c
	 if Hysteresis_img(i-1,j) == 2 | Hysteresis_img(i-1,j-1) == 2 | Hysteresis_img(i,j-1) == 2 | Hysteresis_img(i+1,j-1) == 2 | Hysteresis_img(i+1,j) == 2 | Hysteresis_img(i+1,j+1) == 2 | Hysteresis_img(i,j+1) == 2 | Hysteresis_img(i-1,j+1) == 2
     Hysteresis_img(i,j) = 2;
	 else 
	 Hysteresis_img(i,j) = 0;
	 end
     	
    end
  
  end

end

Final_output = Hysteresis_img;
%figure,imshow(Hysteresis_img,[]);
%end
end
