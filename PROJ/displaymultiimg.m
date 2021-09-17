i = 5;
imgname = ['input/',num2str(i),'.jpg'];
img = imread(imgname);

edgefilename = ['output/out',num2str(i),'.txt'];
edge = readmatrix(edgefilename);
edge = edge*255;
imwrite(edge,'output/edge5.png');
lineimgname = ['img_withline/line',num2str(i),'.png'];
lineimg = imread(lineimgname);
defaultname = ['img_deafault/default',num2str(i),'.png'];
defaultimg = imread(defaultname);

subplot(2,2,1), imshow(img)
subplot(2,2,2), imshow(edge)
subplot(2,2,3), imshow(lineimg)
subplot(2,2,4), imshow(defaultimg)
