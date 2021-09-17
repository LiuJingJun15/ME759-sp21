clear;clc;
RGB = imread('input/17.jpg');
I  = rgb2gray(RGB);
i = 17;
BW = edge(I,'sobel');
imgname = ['input/',num2str(i),'.jpg'];

thetaRange = 0:0.01:pi;
thetaRange = thetaRange/pi*180 - 90;
% [H,theta,rho] = hough(BW,'RhoResolution',0.5,'Theta',-90:1:89);
[H,theta,rho] = hough(BW,'RhoResolution',1,'Theta',thetaRange);
votem = readmatrix('vote/vote17.txt');
votem(:,end) = [];
%%
figure(1)
surf(H,'EdgeColor','r');

figure(2)
surf(votem,'EdgeColor','b');