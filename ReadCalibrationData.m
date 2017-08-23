function image=ReadCalibrationData()
%%image is a struct, containing the information of name, image, peaks,
%%threshold, peakvalue and peakloc
imagepath='C:\Users\gu\Desktop\myscripts\data\cal\';

%%Read calibration images
image(1).name='Dot520Spec-005_Cycle00001_CurrentSettings_Ch1_000001.tif';
image(1).image=imread([imagepath image(1).name]);
image(1).peaks=520.0;
image(1).threshold=0.1;
image(2).name='Dot560Spec-013_Cycle00001_CurrentSettings_Ch1_000001.tif';
image(2).image=imread([imagepath image(2).name]);
image(2).peaks=560.0;
image(2).threshold=0.2;
image(3).name='Dot590Spec-016_Cycle00001_CurrentSettings_Ch1_000001.tif';
image(3).image=imread([imagepath image(3).name]);
image(3).peaks=590.0;
image(3).threshold=0.18;
image(4).name='Dot610Spec-018_Cycle00001_CurrentSettings_Ch1_000001.tif';
image(4).image=imread([imagepath image(4).name]);
image(4).peaks=610.0;
image(4).threshold=0.2;
image(5).name='Dot640Spec-020_Cycle00001_CurrentSettings_Ch1_000001.tif';
image(5).image=imread([imagepath image(5).name]);
image(5).peaks=640.0;
image(5).threshold=0.18;

%%to find peak values and their locations for each wavelength

a=zeros([length(image),512]);

for x=1:length(image)
   a(x,:)=a(x,:)+sum(image(x).image'); %%add up the rows, the result forms an array
   a(x,:)=a(x,:)-min(a(x,:));
   a(x,:)=a(x,:)/max(a(x,:)); %%each element from 0 to 1
   [peakvalue,peakloc]=IdentifySpectralPeaks(a(x,:),image(x).threshold);
   
   % make sure there are 32 peaks
   if(length(peakloc)>32)
       temp1=zeros([1,length(peakloc)]);
       temp1indice=zeros([1,length(peakloc)]);
       temp2=zeros([1,length(peakloc)]);
       temp2indice=zeros([1,length(peakloc)]);
       temp1(1)=peakloc(1);
       temp1indice(1)=1;
       i=2;j=1; %%i is index for temp1, j is index for temp2
       for k=1:length(peakloc)-1
           if(j==1&&mod(abs(peakloc(k+1)-temp1(i-1)),15)>2||mod(abs(peakloc(k+1)-temp2(j-1)),15)<=2||15-mod(abs(peakloc(k+1)-temp2(j-1)),15)<=2)
               temp2(j)=peakloc(k+1);
               temp2indice(k+1)=1;
               j=j+1;
           end
           if(mod(abs(peakloc(k+1)-temp1(i-1)),15)<=2||mod(15-abs(peakloc(k+1)-temp1(i-1)),15)<=2)
               temp1(i)=peakloc(k+1);
               temp1indice(k+1)=1;
               i=i+1;
           end
       end
       if(i-1==32) %%temp1indice has 32 peaks
           pindice=temp1indice(1:length(peakloc));
       else  %%temp2indice has 32 peaks
           pindice=temp2indice(1:length(peakloc));
       end
   else
       pindice=ones([1,length(peakloc)]);
   end
   image(x).peakvalue=peakvalue(pindice==1);
   image(x).peakloc=peakloc(pindice==1);
           
end


