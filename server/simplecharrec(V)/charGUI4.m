function varargout = charGUI4(varargin)
%{
       CHARGUI4 M-file for charGUI4.fig
      CHARGUI4, by itself, creates a new CHARGUI4 or raises the existing
      singleton*.

      H = CHARGUI4 returns the handle to a new CHARGUI4 or the handle to
      the existing singleton*.

      CHARGUI4('CALLBACK',hObject,eventData,handles,...) calls the local
      function named CALLBACK in CHARGUI4.M with the given input arguments.

      CHARGUI4('Property','Value',...) creates a new CHARGUI4 or raises the
      existing singleton*.  Starting from the left, property value pairs are
      applied to the GUI before charGUI_OpeningFunction gets called.  An
      unrecognized property name or invalid value makes property application
      stop.  All inputs are passed to charGUI4_OpeningFcn via varargin.


      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
      instance to run (singleton)".

 See also: GUIDE, GUIDATA, GUIHANDLES

 Edit the above text to modify the response to help charGUI4

 Last Modified by GUIDE v2.5 04-May-2009 08:58:24

 Begin initialization code - DO NOT EDIT
%}
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @charGUI4_OpeningFcn, ...
                   'gui_OutputFcn',  @charGUI4_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before charGUI4 is made visible.
function charGUI4_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to charGUI4 (see VARARGIN)
load data;
assignin('base','net',net);
% Choose default command line output for charGUI4
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes charGUI4 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = charGUI4_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbLoadSet.
function pbLoad_Callback(hObject, eventdata, handles)
% hObject    handle to pbLoadSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.bmp';'*.jpg';'*.gif';'*.*'}, 'Pick an Image File');
S = imread([pathname,filename]);
axes(handles.axes1);
imshow(S);

handles.S = S;
guidata(hObject, handles);


% --- Executes on button press in pbSelect.
function pbSelect_Callback(hObject, eventdata, handles)
% hObject    handle to pbSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

S = handles.S;
axes(handles.axes1);
% Selection of location
if isfield(handles,'api')
    handles.api.delete();
    rmfield(handles,'api');
    rmfield(handles,'hRect');
    axes(handles.axes1);
    imshow(S);
end

axes(handles.axes1);
sz = size(S);
handles.hRect = imrect(gca,[round(sz(2)/2) round(sz(1)/2) 20 20]); % Select object
handles.api = iptgetapi(handles.hRect);

guidata(hObject, handles);

%{
 img_crop = imcrop(S);
 axes(handles.axes2);
 imshow(img_crop);
 
 handles.img_crop = img_crop;
%}
%{
guidata(hObject, handles);
S = handles.S;
axes(handles.axes1);
img_crop = imcrop(S);
axes(handles.axes2);
imshow(img_crop);
handles.img_crop = img_crop;
%}
%{
axes(handles.axes12);
I=handles.img_crop;
Igray = rgb2gray(I);
Ibw = im2bw(Igray,graythresh(Igray));
Iedge = edge(uint8(Ibw));
se = strel('square',2);
Iedge2 = imdilate(Iedge, se); 
Ifill= imfill(Iedge2,'holes');
[Ilabel num] = bwlabel(Ifill);
Iprops = regionprops(Ilabel);
Ibox = [Iprops.BoundingBox];
[y,x]=size(Ibox);%
x=x/4;%

Ibox = reshape(Ibox,[4 x]);%

handles.Ibox=Ibox;
imshow(I)

selected_col = get(handles.edit5,'string');
selected_col = evalin('base',selected_col);

selected_ln = get(handles.edit6,'string');
selected_ln = evalin('base',selected_ln);

for cnt = 1:selected_ln * selected_col
    rectangle('position',Ibox(:,cnt),'edgecolor','r');
end
guidata(hObject, handles);
%}




% --- Executes on button press in pbCrop.
function pbCrop_Callback(hObject, eventdata, handles)
% hObject    handle to pbCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.loc = handles.api.getPosition();
axes(handles.axes1);
S = handles.S;

handles.img_crop = imcrop(S,handles.loc);
%{
 to display the corp..
axes(handles.axes2);
imshow(handles.img_crop);
end display te corp

 img_crop = imcrop(S);
 axes(handles.axes2);
 imshow(img_crop);
 
 handles.img_crop = img_crop;

for the many words

S = handles.S;
axes(handles.axes1);
img_crop = imcrop(S);
axes(handles.axes2);
imshow(img_crop);
handles.img_crop = img_crop;
%}
axes(handles.axes12);
I=handles.img_crop;
Igray = rgb2gray(I);
Ibw = im2bw(Igray,graythresh(Igray));
Iedge = edge(uint8(Ibw));
se = strel('square',2);
Iedge2 = imdilate(Iedge, se); 
Ifill= imfill(Iedge2,'holes');
[Ilabel num] = bwlabel(Ifill);
Iprops = regionprops(Ilabel);
Ibox = [Iprops.BoundingBox];
[y,x]=size(Ibox);%
disp(x);
x=x/4;%
handels.x = x;

Ibox = reshape(Ibox,[4 x]);%

handles.Ibox=Ibox;

imshow(I)

%selected_col = get(handles.edit9,'string');
%selected_col = evalin('base',selected_col);
[y, selected_col] = size(handles.Ibox);
%selected_col = 5;
%selected_ln = get(handles.edit6,'string');
%selected_ln = evalin('base',selected_ln);
selected_ln = 1;
for cnt = 1:selected_ln * selected_col
   rectangle('position',Ibox(:,cnt),'edgecolor','r');
end
i=1;
for cnt = 1:selected_ln * selected_col
    
    %rectangle('position',Ibox(:,cnt),'edgecolor','r');
    
    X=Ibox(:,cnt);
    a=X(2,1);
    b=X(1,1);
   
    c=X(3,1)+b;
    d=X(4,1)+a;
    

   %handles.cutImg = I(a:d,b:c);
   if(i==1)       
       i=i+1;
       cutImg1 = I(a:d,b:c);
       handles.cutImg1 = cutImg1;
       axes(handles.axes2);
       imshow(handles.cutImg1);
       
   elseif(i==2)
         i=i+1;
         handles.cutImg2 = I(a:d,b:c);
         axes(handles.axes13);
         imshow(handles.cutImg2);
       
   elseif(i==3)
         i=i+1;
         handles.cutImg3 = I(a:d,b:c);
         axes(handles.axes26);
         imshow(handles.cutImg3);
         
   elseif(i==4)
         i=i+1;
         handles.cutImg4 = I(a:d,b:c);
         axes(handles.axes14);
         imshow(handles.cutImg4);
         
   elseif(i==5)
         i=i+1;
         handles.cutImg5 = I(a:d,b:c);
         axes(handles.axes15);
         imshow(handles.cutImg5);
         
   elseif(i==6)
         i=i+1;
         handles.cutImg6 = I(a:d,b:c);
         axes(handles.axes27);
         imshow(handles.cutImg6);
         
   elseif(i==7)
         i=i+1;
         handles.cutImg7 = I(a:d,b:c);
         axes(handles.axes28);
         imshow(handles.cutImg7);
         
   elseif(i==8)
         i=i+1;
         handles.cutImg8 = I(a:d,b:c);
         axes(handles.axes29);
         imshow(handles.cutImg8);
         
   elseif(i==9)
         i=i+1;
         handles.cutImg9 = I(a:d,b:c);
         axes(handles.axes30);
         imshow(handles.cutImg9);
                
        end
   
end
%{
for cnt = 1:selected_ln * selected_col
   rectangle('position',Ibox(:,cnt),'edgecolor','r');
end
%}
%guidata(hObject, handles);

%End of Many words

guidata(hObject, handles);

% --- Executes on button press in pbPreprocess.
function pbPreprocess_Callback(hObject, eventdata, handles)
% hObject    handle to pbPreprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%selected_col = get(handles.edit9,'string');
%selected_col = evalin('base',selected_col);
[y, selected_col] = size(handles.Ibox);
i=1;
while(i<=selected_col)
    
        if(i==1)       
        
            i = i+1;
            img_crop1 = handles.cutImg1;            
            %imgGray1  = rgb2gray(img_crop1);
            bw11 = im2bw(img_crop1,graythresh(img_crop1));
            axes(handles.axes31);
            imshow(bw11);
            bw12 = edu_imgcrop(bw11);
            axes(handles.axes40);
            imshow(bw12);
            handles.bw12 = bw12;
            
   
   elseif(i==2)
         
             i=i+1;
             img_crop2 = handles.cutImg2;
             %imgGray2  = rgb2gray(img_crop2);
             bw21 = im2bw(img_crop2,graythresh(img_crop2));
             axes(handles.axes32);
             imshow(bw21);
             bw22 = edu_imgcrop(bw21);
             axes(handles.axes41);
             imshow(bw22);
             handles.bw22 = bw22;
             
       
   elseif(i==3)
         
             i=i+1;
             img_crop3 = handles.cutImg3;
             %imgGray3  = rgb2gray(img_crop3);
             bw31 = im2bw(img_crop3,graythresh(img_crop3));
             axes(handles.axes35);
             imshow(bw31);
             bw32 = edu_imgcrop(bw31);
             axes(handles.axes44);
             imshow(bw32);
             handles.bw32 = bw32;
             
   elseif(i==4)
         
             i=i+1;
             img_crop4 = handles.cutImg4;
             %imgGray4  = rgb2gray(img_crop4);
             bw41 = im2bw(img_crop4,graythresh(img_crop4));
             axes(handles.axes33);
             imshow(bw41);
             bw42 = edu_imgcrop(bw41);
             axes(handles.axes42);
             imshow(bw42);
             handles.bw42 = bw42;
             
   
   elseif(i==5)
         i=i+1;
             img_crop5 = handles.cutImg5;
             %imgGray4  = rgb2gray(img_crop4);
             bw51 = im2bw(img_crop5,graythresh(img_crop5));
             axes(handles.axes34);
             imshow(bw51);
             bw52 = edu_imgcrop(bw51);
             axes(handles.axes43);
             imshow(bw52);
             handles.bw52 = bw52;
             
   elseif(i==6)
         i=i+1;
             img_crop6 = handles.cutImg6;
             %imgGray4  = rgb2gray(img_crop4);
             bw61 = im2bw(img_crop6,graythresh(img_crop6));
             axes(handles.axes36);
             imshow(bw61);
             bw62 = edu_imgcrop(bw61);
             axes(handles.axes45);
             imshow(bw62);
             handles.bw62 = bw62;
             
   elseif(i==7)
         i=i+1;
             img_crop7 = handles.cutImg7;
             %imgGray4  = rgb2gray(img_crop4);
             bw71 = im2bw(img_crop7,graythresh(img_crop7));
             axes(handles.axes37);
             imshow(bw71);
             bw72 = edu_imgcrop(bw71);
             axes(handles.axes46);
             imshow(bw72);
             handles.bw72 = bw72;
             
   elseif(i==8)
         i=i+1;
             img_crop8 = handles.cutImg8;
             %imgGray4  = rgb2gray(img_crop4);
             bw81 = im2bw(img_crop8,graythresh(img_crop8));
             axes(handles.axes38);
             imshow(bw81);
             bw82 = edu_imgcrop(bw81);
             axes(handles.axes47);
             imshow(bw82);
             handles.bw82 = bw82;
             
   elseif(i==9)
         i=i+1;
             img_crop9 = handles.cutImg9;
             %imgGray4  = rgb2gray(img_crop4);
             bw91 = im2bw(img_crop9,graythresh(img_crop9));
             axes(handles.axes39);
             imshow(bw91);
             bw92 = edu_imgcrop(bw91);
             axes(handles.axes48);
             imshow(bw92);
             handles.bw92 = bw92;
        
        end
        
     
end
guidata(hObject, handles);


% --- Executes on button press in pbExtract.
function pbExtract_Callback(hObject, eventdata, handles)
% hObject    handle to pbExtract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%selected_col = get(handles.edit9,'string');
%selected_col = evalin('base',selected_col);
[y, selected_col] = size(handles.Ibox);
i=1;
while(i<=selected_col)
    
        if(i==1)       
        
            i = i+1;
            bw12  = handles.bw12;
            charvec1 = edu_imgresize(bw12);
            axes(handles.axes5);
            plotchar(charvec1);
            handles.charvec1 = charvec1;
               
   elseif(i==2)
         
             i=i+1;
             bw22  = handles.bw22;
             charvec2 = edu_imgresize(bw22);
             axes(handles.axes49);
             plotchar(charvec2);
             handles.charvec2 = charvec2;
             
       
   elseif(i==3)
         
             i=i+1;
             bw32  = handles.bw32;
             charvec3 = edu_imgresize(bw32);
             axes(handles.axes50);
             plotchar(charvec3);
             handles.charvec3 = charvec3;
             
   elseif(i==4)
         
             i=i+1;
             bw42  = handles.bw42;
             charvec4 = edu_imgresize(bw42);
             axes(handles.axes51);
             plotchar(charvec4);
             handles.charvec4 = charvec4;
             
   
   elseif(i==5)
         i=i+1;
             bw52  = handles.bw52;
             charvec5 = edu_imgresize(bw52);
             axes(handles.axes56);
             plotchar(charvec5);
             handles.charvec5 = charvec5;
             
   elseif(i==6)
         i=i+1;
             bw62  = handles.bw62;
             charvec6 = edu_imgresize(bw62);
             axes(handles.axes57);
             plotchar(charvec6);
             handles.charvec6 = charvec6;
             
   elseif(i==7)
         i=i+1;
             bw72  = handles.bw72;
             charvec7 = edu_imgresize(bw72);
             axes(handles.axes58);
             plotchar(charvec7);
             handles.charvec7 = charvec7;
             
   elseif(i==8)
         i=i+1;
             bw82  = handles.bw82;
             charvec8 = edu_imgresize(bw82);
             axes(handles.axes59);
             plotchar(charvec8);
             handles.charvec8 = charvec8;
             
   elseif(i==9)
         i=i+1;
             bw92  = handles.bw92;
             charvec9 = edu_imgresize(bw92);
             axes(handles.axes60);
             plotchar(charvec9);
             handles.charvec9 = charvec9;
        
        end             
end

guidata(hObject, handles);

% --- Executes on button press in pbRecognize.
function pbRecognize_Callback(hObject, eventdata, handles)
% hObject    handle to pbRecognize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selected_net = get(handles.editNN,'string');
selected_net = evalin('base',selected_net);

%selected_col = get(handles.edit9,'string');
%selected_col = evalin('base',selected_col);
[y, selected_col] = size(handles.Ibox);
i=1;
while(i<=selected_col)
    
        if(i==1)       
        
            i = i+1;
            charvec1 = handles.charvec1;
            result1 = sim(selected_net,charvec1);
            [val, num1] = max(result1);
            if(num1 == 10)
                num1=0;
            end            
            S1 = strcat(int2str(num1))
               
   elseif(i==2)
         
             i=i+1;
            charvec2 = handles.charvec2;
            result2 = sim(selected_net,charvec2);
            [val, num2] = max(result2);
            if(num2 == 10)
                num2=0;
            end            
            S1 = strcat(int2str(num1), int2str(num2)) 
       
   elseif(i==3)
         
             i=i+1;
            charvec3 = handles.charvec3;
            result3 = sim(selected_net,charvec3);
            [val, num3] = max(result3);
            if(num3 == 10)
                num3=0;
            end            
            S1 = strcat(int2str(num1), int2str(num2),int2str(num3)) 
             
   elseif(i==4)
         
             i=i+1;
            charvec4 = handles.charvec4;
            result4 = sim(selected_net,charvec4);
            [val, num4] = max(result4);
            if(num4 == 10)
                num4=0;
            end            
            S1 = strcat(int2str(num1), int2str(num2),int2str(num3),int2str(num4)) 
             
   
   elseif(i==5)
         i=i+1;
            charvec5 = handles.charvec5;
            result5 = sim(selected_net,charvec5);
            [val, num5] = max(result5);
            if(num5 == 10)
                num5=0;
            end            
            S1 = strcat(int2str(num1), int2str(num2),int2str(num3),int2str(num4),int2str(num5)) 
             
   elseif(i==6)
         i=i+1;
            charvec6 = handles.charvec6;
            result6 = sim(selected_net,charvec6);
            [val, num6] = max(result6);
            if(num6 == 10)
                num6=0;
            end            
            S1 = strcat(int2str(num1), int2str(num2),int2str(num3),int2str(num4),int2str(num5),int2str(num6)) 
             
   elseif(i==7)
         i=i+1;
            charvec7 = handles.charvec7;
            result7 = sim(selected_net,charvec7);
            [val, num7] = max(result7);
            if(num7 == 10)
                num7=0;
            end            
            S1 = strcat(int2str(num1), int2str(num2),int2str(num3),int2str(num4),int2str(num5),int2str(num6),int2str(num7))
             
   elseif(i==8)
         i=i+1;
            charvec8 = handles.charvec8;
            result8 = sim(selected_net,charvec8);
            [val, num8] = max(result8);
            if(num8 == 10)
                num8=0;
            end            
            S1 = strcat(int2str(num1), int2str(num2),int2str(num3),int2str(num4),int2str(num5),int2str(num6),int2str(num7),int2str(num8))
             
   elseif(i==9)
         i=i+1;
            charvec9 = handles.charvec9;
            result9 = sim(selected_net,charvec9);
            [val, num9] = max(result9);
            if(num9 == 10)
                num9=0;
            end
            S1 = strcat(int2str(num1), int2str(num2),int2str(num3),int2str(num4),int2str(num5),int2str(num6),int2str(num7),int2str(num8),int2str(num9))
        
        end             
end

%s = [int2str(num1),int2str(num2),int2str(num3),int2str(num4),int2str(num5),int2str(num6),int2str(num7),int2str(num8),int2str(num9)]

set(handles.editResult, 'string',S1);


% --- Executes on button press in pbNN.
function pbNN_Callback(hObject, eventdata, handles)
% hObject    handle to pbNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





function editNN_Callback(hObject, eventdata, handles)
% hObject    handle to editNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNN as text
%        str2double(get(hObject,'String')) returns contents of editNN as a double


% --- Executes during object creation, after setting all properties.
function editNN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function editResult_Callback(hObject, eventdata, handles)
% hObject    handle to editResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editResult as text
%        str2double(get(hObject,'String')) returns contents of editResult as a double


% --- Executes during object creation, after setting all properties.
function editResult_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbLoad Training Set.
function pbLoadSet_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile({'*.bmp';'*.jpg';'*.gif';'*.*'}, 'Pick an Image File');
trimg = imread([pathname,filename]);

selected_col = get(handles.edit5,'string');
selected_col = evalin('base',selected_col);

selected_ln = get(handles.edit6,'string');
selected_ln = evalin('base',selected_ln);

img = edu_imgpreprocess(trimg,selected_col,selected_ln);

for cnt = 1:selected_ln * selected_col;
    bw2 = edu_imgcrop(img{cnt});
    charvec = edu_imgresize(bw2);
    out(:,cnt) = charvec;
end
P = out(:,1:40); 
T = [eye(10) eye(10) eye(10) eye(10)];
%Ptest = out(:,(selected_ln -2)* selected_col :selected_ln * selected_col);

%% Creating and training of the Neural Network
net = edu_createnn(P,T);
handles.net = net;

%% Testing the Neural Network
%[a,b]=max(sim(net,Ptest));
%disp(b);
assignin('base','net',net);
guidata(hObject, handles);

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


