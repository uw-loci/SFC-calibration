calimage=ReadCalibrationData();

[map,bandsize,number]=GenerateTheMap(calimage);
map=floor(map);

figure;imagesc(map(:,:,1));  %%different colors indicate differnt bands, bands are the continuous area between boundaries

imagepath='C:\Users\gu\Desktop\myscripts\new_system\LOCI_v1p1Win32 - Copy\zstack-001\';
imagename='zstack-001';
channels=16;
offset=0;
%%imagepath='C:\Users\gu\Desktop\ÊîÆÚ¿ÆÑÐ\demo\data\threechannel\';
%%imagename='JeffBeads70ms-005';
%%channels=28;  %%40 original images, but 28 in use
%%offset=5;  %%starting from No.5 to No.33
disp('Reading spectral images...');
t1=clock;
stack=ReadSpectralImages(imagepath,imagename,channels,offset,map,bandsize,number);
t2=clock;
a=etime(t2,t1);
disp(['Stack built, time cost:',num2str(a)]);

figure;
row=ceil(sqrt(bandsize));
col=ceil(sqrt(bandsize));
for i=1:bandsize
    subplot(row,col,i);image((stack(:,:,i).*256));
end

figure;imagesc(sum(stack,3));

transmatrix=zeros([3,15]);
transmatrix(1,1:5)=1;
transmatrix(2,5:10)=1;
transmatrix(3,10:15)=1;

t3=clock;
rgbstack=ColorRendering(stack,transmatrix);
figure;
image(rgbstack);  %%rgbstack(:,:,1)=R,rgbstack(:,:,2)=G,rgbstack(:,:,3)=B
t4=clock;
b=etime(t4,t3);
disp(['Color Rendered, time cost:',num2str(b)]);

