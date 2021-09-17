clear;clc;
i = 2;
RGB = imread(['input/',num2str(i),'.jpg']);
I  = rgb2gray(RGB);
BW = edge(I,'sobel');
votem = readmatrix(['vote/vote',num2str(i),'.txt']);
H = votem;
H(:,end) = [];
H(isnan(H)) = 0;
theta = 0:0.01:pi;
theta = theta/pi*180 - 90;
dis = size(H,1);
rho = -(dis-1)/2:(dis-1)/2;
% [H,theta,rho] = hough(BW,'Theta',thetaRange);
P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
lines = houghlines(BW,theta,rho,P);
% lines = houghlines(BW,theta,rho,P,'FillGap',10,'MinLength',20);

figure, imshow(RGB), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');



