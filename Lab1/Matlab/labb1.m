%% Labb 1 - TNM087



%% Dot 1
% Read in and plot the gfun

clear all;
makegfun;
load('gfun.mat');
plot(gfun);
hold on
plot(2.^gfun)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Dot 2

ImgCell = {'Img1.tiff', 'Img2.tiff','Img3.tiff','Img4.tiff','Img5.tiff','Img6.tiff','Img7.tiff','Img8.tiff','Img9.tiff','Img10.tiff','Img11.tiff','Img12.tiff','Img13.tiff','Img14.tiff'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Spara bilderna i en 4-dim matris


load('gfun.mat');
% Ladda in bilderna i en cell array
imagesCell = {imread('Img1.tiff'), imread('Img2.tiff'),imread('Img3.tiff'),imread('Img4.tiff'),imread('Img5.tiff'),imread('Img6.tiff'),imread('Img7.tiff'),imread('Img8.tiff'),imread('Img9.tiff'),imread('Img10.tiff'),imread('Img11.tiff'),imread('Img12.tiff'),imread('Img13.tiff'),imread('Img14.tiff')};

% Skapa en ny matris f�r den f�rsta bilden f�r att alokera minne
 pics4dimarray  = imread('Img1.tiff');

 %
finalMatrix = double(pics4dimarray*0);
finalWeight = double(pics4dimarray*0);
finalMatrix2 = double(pics4dimarray*0);


% Skapa den 4-dimensionella matrisen med resterande bilderna
for i = 2:14
    pics4dimarray(:,:,:,i) = imagesCell{i};
end


% Creating a copy of the 4dim array index with zeros
pics4dimarrayNew = double(pics4dimarray.*0);
weightfunc = double(pics4dimarray.*0);

valueMatrix = double(pics4dimarray);
%

montage(pics4dimarray);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% "Preperations assigments"

% maxvrde av en av de frsta bilderna
image_dark=imread('Img1.tiff');
M = max(max(image_dark(:,:,1)));
index_M = find(image_dark == M);

% minv�rde av en av de sista bilderna
image_light=imread('Img14.tiff');
m = min(min(image_light(:,:,1)));
index_m = find(image_light == m,1);

% Medianv�rde
image_median=imread('Img9.tiff');
med = median(median(image_median(:,:,1)));
index_med = find(image_median == med,1);

% Allokerar minne
arr1 = zeros(14,1);
arr2 = zeros(14,1);
arr3 = zeros(14,1);

for i = 1:length(ImgCell)
    
    %temp = ImgCell{i};
    %bild = imread(temp);
    
    arr1(i) = imagesCell(index_M);
    arr2(i) = imagesCell(index_m);
    arr3(i) = imagesCell(index_med);
end


% Plottar de pixelv�rderna f�r de olika bilderna
plot(arr1);
plot(arr2);
plot(arr3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Logaritm images to exposure images
%for i=1:3
    for values = 0:255
            index = find(pics4dimarray(:,:,1,:) == values);
            pics4dimarrayNew(index) = gfun(values+1,1); 
    end
%end

time = 1;

for i=1:14
    pics4dimarrayNew(:,:,:,i) = pics4dimarrayNew(:,:,:,i) - log2(time);
    time = time*2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Weightfunction

    maximum = 255;
    minimum = 0;
    %valueMatrix = double(pics4dimarray(:));
    condition = 255/2;
    
    d = (valueMatrix <= condition);

    w1 = d.* (valueMatrix );

    e = (valueMatrix > condition);

    w2 = e.* (maximum - valueMatrix );

    weightfunc = (2*(w1+w2))/255;

    montage(weightfunc)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 


%for i = 1:14
    
    %E = E + ((weightfunc(:,:,:,i).*pics4dimarrayNew(:,:,:,i)));
    %finalMatrix = finalMatrix + (weightfunc(:,:,:,i).*pics4dimarrayNew(:,:,:,i) );
    
    %W = W + weightfunc(:,:,:,i);
    %finalWeight = finalWeight + weightfunc(:,:,:,i);
    
    
    %disp(finalMatrix(340:350,508:512,1));
    %pause(1);
%end

%finalMatrix = sum(weightfunc.*pics4dimarrayNew, 4);

finalMatrix2 = sum(pics4dimarrayNew, 4);

finalWeight = sum(weightfunc, 4);

finalMatrix = 2.^((finalMatrix2.*finalWeight) ./ finalWeight);

imshow(tonemap(finalMatrix));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% "Exposure time - testing"

% Set some time constant
% time = 1/128;
% time2 = 1;
% 
% storage = zeros(14,1);
% storage2 = zeros(14,1);
% for x=1:14
% 
%     storage(x) = log2(time);
%     storage2(x) = log2(time2);
%     
%     time = time*2;
%     time2 = time2*2;
% end
% 
% plot(storage);
% hold on ;
% plot(storage2);


%% "Learn about matrix"

% % % Skapa en 3x3 matris
% A = [1, 2, 1;2 4 5; 3 5 6]
% % skapa en 3x3x2 matris (3-dim)
% A(:,:,2) = [1 2 2;7 6 5; 2 5 2]
% % hitta v�rdet 7
% index = find(A(:,:,:) == 7)
% A(index) = 16
% 
% index = find(A(:) == 1)
% A(:,:,3) = [1 2 2;7 6 5; 2 5 2]
% 
% %Skapa en 3x3x3x2 matris (4-dim)
% A(:,:,:,2) = A
% index = find(A(:) == 1)


%% Sample of small 4-dim array
% % % %intensity in picture --> 0 - 255
% % % %gfun values maps --> 1 - 256 dvs 1 -> 0 och 256->255
% for values= 0:255
%     index = find(A(:) == values);
%     A(index) = gfun(values+1);
% end


%% 
% % % % intensity in picture --> 0 - 255
% % % % gfun values maps --> 1 - 256 dvs 1 -> 0 och 256->255

% time = 1/128;
% 
% for i=1:14
%     for values= 0:255
%         index = find(pics4dimarray(:,:,:,i) == values);
%         
%         pics4dimarrayNew(index) = uint8(255 * (gfun(values+1))/ (abs(max(gfun(:,1))) + abs(min(gfun(:,1))) )  / time);
%         
%         time = time*2;
%     end
% end