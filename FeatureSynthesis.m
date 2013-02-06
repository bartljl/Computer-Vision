%feature synthesis
%For image house
img1 = imread('House.jpg');
img1 = im2double(img1);
Result1_img1 = Canny_edge_detector(img1,0.1,0.5);
synthesis_output1 = Canny_edge_detector(Result1_img1,0.35,0.5);
Result2_img1 = Canny_edge_detector(img1,0.35,0.5);
[r1,c1] = size(Result1_img1);
Add_edge_img1 = zeros(r1,c1);
for i = 1:r1

  for j = 1:c1
 
    if Result2_img1(i,j) == 2 & synthesis_output1(i,j) ~= 2
    Add_edge_img1(i,j) = 2; 
  end
	
  end

end

for i = 1:r1

  for j = 1:c1
 
    if Result1_img1(i,j) ~= 2 & Add_edge_img1(i,j) == 2
    Result1_img1(i,j) = 2; 
	end
	
  end

end
Output1 = Result1_img1;
figure,imshow(Output1,[]); 
%For image Lena
img2 = imread('Lena.jpg');
img2 = im2double(img2);
Result1_img2 = Canny_edge_detector(img2,0.02,0.5);
synthesis_output2 = Canny_edge_detector(Result1_img2,0.06,0.5);
Result2_img2 = Canny_edge_detector(img2,0.06,0.5);
[r2,c2] = size(Result1_img2);
Add_edge_img2 = zeros(r2,c2);
for i = 1:r2

  for j = 1:c2
 
    if Result2_img2(i,j) == 2 & synthesis_output2(i,j) ~= 2
    Add_edge_img2(i,j) = 2; 
	end
	
  end

end
for i = 1:r2

  for j = 1:c2
 
    if Result1_img2(i,j) ~= 2 & Add_edge_img2(i,j) == 2
    Result1_img2(i,j) = 2; 
	end
	
  end

end
Output2 = Result1_img2;
figure,imshow(Output2,[]); 
