n = 6;
for i = 1:n
    imgname = ['input/',num2str(i),'.jpg'];
    lineimgname = ['img_deafault/default',num2str(i),'.png'];
    RGB = imread(['input/',num2str(i),'.jpg']);
    I  = rgb2gray(RGB);
    BW = edge(I,'sobel');
    thetaRange = 0:0.01:pi;
    thetaRange = thetaRange/pi*180 - 90;
    [H,theta,rho] = hough(BW,'Theta',thetaRange);
    P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
    lines = houghlines(BW,theta,rho,P);
    fh1 = figure();
    imshow(RGB), hold on
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
    line_detected_img = saveAnnotatedImg(fh1);
    imwrite(line_detected_img, lineimgname);
end