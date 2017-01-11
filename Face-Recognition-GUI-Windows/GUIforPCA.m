function varargout = GUIforPCA(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIforPCA_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIforPCA_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function GUIforPCA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIforPCA (see VARARGIN)

% Choose default command line output for GUIforPCA
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

function varargout = GUIforPCA_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function Close_Callback(hObject, eventdata, handles)

close all;


function SelectImage_Callback(hObject, eventdata, handles)

% give To choose Test Image and display it
path = 'test_images\*';
selectedFile = uigetfile(fullfile(path ));
axes(handles.TestImage);

  ImgName = char(strcat('test_images\',selectedFile));
  Q=ImgName;
  test_image_selected1=imread(ImgName,'jpg');
 
imshow(test_image_selected1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%reading training images and assigning a label to each training image
training_images=dir('train_images\*.jpg');

Lt=[];% to assign image label
T=[]; % to create matrix each row is an image

for k = 1 : length(training_images)
    
 ImgName = training_images(k).name;
  Lt=[Lt ; ImgName(:,1:3)];% assigning label for images by taking first 3 letters from each image
  ImgName = char(strcat('train_images\',ImgName(1:end-4)));

 TrainIm = imread(ImgName, 'jpg');
 Img=reshape(TrainIm,1,64*64);
 T=[T ; Img]; 
end
%%%%%%%%%%%%%

%subtract off the mean for each dimension
mT=mean(T,2);%mean of rows
D=double(T)-repmat(mT,1,size(T,2));

%covariance matrix
sigma=(1/(length(training_images)-1))*D*(D');


%eigenvalues and eigenvectors
[V,DD]=eigs(sigma,length(training_images)-2); % V eigenvectors and DD eignvalues

%transformation matrix
phai=D'*V;

Ft=[]; % features matrix
for k = 1 : length(training_images)
                                    
 ImgName = training_images(k).name;
  ImgName = char(strcat('train_images\',ImgName(1:end-4)));
 TrainIm = imread(ImgName, 'jpg');
 Img=reshape(TrainIm,1,64*64);
 feature_vector_Train=double(Img)*phai;
 Ft=[Ft;feature_vector_Train];% each row a feature vector for an image
end


 test_image_selected=reshape(test_image_selected1,1,64*64);
 proj=double(test_image_selected)*phai; 
 
 

for k=1:length(training_images)
    x(k)=norm(proj-Ft(k,:));
end

[a z]=min(x); % minimum distance between one test image and all training images. z is the index and a the value.
[b g]=sort(x);  %the distances between one image and all training images. It sorts from the smallest to biggest.  g is the index and b the value.



if Lt(z,1:end)~=Q(:,13:15) % comparing the labels to check the matching

set(handles.ResultM,'string','Not Match');
elseif Lt(z,1:end)==Q(:,13:15)

set(handles.ResultM,'string','Match');
end
% axes(handles.ResultImage);
% MatchedImage=T(z,:);
% MatchedImage=reshape(MatchedImage,64,64);
% imshow(MatchedImage);

axes(handles.axes3);
MatchedImage=T(g(1),:); % first matched image
MatchedImage=reshape(MatchedImage,64,64);
imshow(MatchedImage);
MatchedImage=reshape(MatchedImage,64,64);
axes(handles.axes4);
MatchedImage=T(g(2),:);%second matched image
MatchedImage=reshape(MatchedImage,64,64);
imshow(MatchedImage);
axes(handles.axes5);
MatchedImage=T(g(3),:);%third matched image
MatchedImage=reshape(MatchedImage,64,64);
imshow(MatchedImage);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To calculate the accuracy we will read all the test images and search for
% matching and if not match we will increase the error

%reading test images

e=0; % error

test_images=dir('test_images\*.jpg');
for k = 1 : length(test_images)
    
 ImgName = test_images(k).name;
  ImgName = char(strcat('test_images\',ImgName(1:end-4)));

 TestIm = imread(ImgName, 'jpg');
 
 
  test_image_selected=reshape(TestIm,1,64*64);
 feature_vector_test=double(test_image_selected)*phai; 

for k=1:length(training_images)
    x(k)=norm(feature_vector_test-Ft(k,:)); % calculate the distances
end

[a z]=min(x);% minimum distance between one test image and all training images. z is the index and a the value.

if Lt(z,1:end)~=ImgName(:,13:15) % comparing the labels to check the matching and calculate the error
 e=e+1;% increase the error if not match

end

end
% Accuracy
accuracy=(1-(e/length(test_images)))*100


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function edit5_Callback(hObject, eventdata, handles)

function edit5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit6_Callback(hObject, eventdata, handles)

function edit6_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit7_Callback(hObject, eventdata, handles)

function edit7_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function accuracyResult_Callback(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
