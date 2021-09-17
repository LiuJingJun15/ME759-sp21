
n = 6;
for i = 1:n
    filename = ['input/',num2str(i),'.jpg'];
    img = imread(filename);
    img = rgb2gray(img);
    edge_img = edge(img,'sobel');
    outfilename = ['output/out',num2str(i),'.txt'];
    writematrix(edge_img,outfilename)
    matrixSize = size(img);
    sizefilename = ['size/size',num2str(i),'.txt'];
    fileID = fopen(sizefilename,'w');
    fprintf(fileID,[num2str(matrixSize(1)),',',num2str(matrixSize(2))]);
    fclose(fileID);
end

