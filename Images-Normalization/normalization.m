% Normalization for all images 
% Reading from excel file 
filename = 'Dataset_Face_Recognition.xlsx';

% Makin 6 arrays to store the 5 features location and the names
[num,Names,raw] = xlsread(filename, 'A2:A151'); 
Eye1 = xlsread(filename, 'B2:C151');
Eye2 = xlsread(filename, 'D2:E151');
Nose = xlsread(filename, 'F2:G151');
Mouth1 = xlsread(filename, 'H2:I151');
Mouth2 = xlsread(filename, 'J2:K151');

% Step 1: Initialization
Fb = [13 20; 50 20; 34 34; 16 50; 48 50];
% F initialized with first image coordinates
F = [Eye1(1,:) ; Eye2(1,:); Nose(1,:) ; Mouth1(1,:); Mouth2(1,:)]; 
% The threshold to stop the loop and get the final F
Threshold = 0.0001 * ones(size(F)); 
Fn = zeros(size(F));
count = 0;

while (abs(F - Fn) > Threshold)
% Step 2
Fn = F; % prepare Fn to the next step
% putting ones in the last column of F, to calculate A & B together
P = [Fn ones(5,1)]; 
A = pinv(P)*Fb;  % pinv() uses SVD to get the inverse of P
F_ = P * A;  % Getting F_
F = F_; % updating F
% intialize accumulation to calculate average of all Fi at the end
Fi_acc = zeros(size(F)); 

% Step 3 
 for i = 1 : size(Names) % loop to all images
   % form of Fi 
   Fi = [Eye1(i,:) ; Eye2(i,:); Nose(i,:) ; Mouth1(i,:); Mouth2(i,:)]; 
   Pi = [Fi ones(5,1)];
   
   Ai = pinv(Pi)*F; % Affine transformation for each image
   Fi_ = Pi * Ai; % apply the affine transfomation to get Fi_
   Fi_acc = Fi_acc + Fi_; % 
 end

% Step 4
% update F by averaging the aligned features for all images
F = Fi_acc/length(Names);
count = count +1 ;

end

% Paths to input and output folders
path_source = 'faces_320x320/';
path_output = 'faces_64x64/';
NewIm = zeros(64,64); % initialize the new iamge matrix 

for k = 1 : length(Names)
 % prepare the name of the image _ its path to read it
 ImgName = char(strcat(path_source, Names(k)));
 RGBIm = imread(ImgName, 'jpg');
 Im = rgb2gray(RGBIm);
 %imshow(Im)
 
 Fk = [Eye1(k,:) ; Eye2(k,:); Nose(k,:) ; Mouth1(k,:); Mouth2(k,:)]; 
 Pk = [Fk ones(5,1)];
 Ak = pinv(Pk)*F;  % Get Affine transformation for each image
 
 Ak_ = [Ak [0;0;1]];
 A_inv = pinv(Ak_);
% Apply the inverse affine transformation from output to input.
 for x = 1: 64  % nested loop to look at all pixels in 64 x 64
     for y = 1: 64
        X_ = [x; y; 1];
        X_orig = A_inv' * X_ ;
        X_orig = ceil(abs(X_orig));
        % To deal with pixels of indeces > 320
        if (X_orig(1) > 320)
            X_orig(1) = 320;
        end
        if(X_orig(2) > 320)
            X_orig(2) = 320;
        end
        % NewIm(x,y) = Im(X_orig(1), X_orig(2));
        NewIm(y,x) = Im(X_orig(2), X_orig(1));
     end 
 end

 I = mat2gray(NewIm); % convert the matrix to image 
 imshow(I); % show all images after normalization
 path_out = char(strcat(path_output, Names(k), '.jpg'));
 imwrite(I, path_out); % save all images to the output folder
end
