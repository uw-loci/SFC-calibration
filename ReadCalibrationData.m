function image=ReadCalibrationData()
%%image is a struct, containing the information of name, image, peaks,
%%threshold, peakvalue and peakloc
%%imagepath='C:\Users\gu\Desktop\myscripts\data\cal\';
imagepath='C:\Users\gu\Desktop\laser lines\640 laser line image 30um pinhole-001\';

%%Read calibration images
image.name='640 laser line image 30um pinhole-001_Cycle00001_Ch3_000001.ome.tif';
image.image=imread([imagepath image.name]);

temp=image.image;
addup=zeros([1,size(temp,2)]);

for i=1:size(temp,2)
    addup(i)=sum(temp(:,i));  %%add up the columns
end

addup=addup-min(addup);
addup=addup/max(addup);  %%normalization
%%count=sum(addup>mean(addup));  %%as reference
number=0;
k=1;  %%initialization
for i=1:length(addup)
    flag=0;
    if(addup(i)>mean(addup))
        number=number+1;
        flag=1;  %%mark if there is continuous peakvalues
    end
    if(flag==0)
        if(number~=0) %%there is an array of possible peaks
            loc(k)=PinholeLocation(addup,i-number+1,i);  %%calculate the location of each pinhole
            k=k+1;  %%move to next index
            number=0;
        end
    end
end
 
for i=1:length(loc)-1  %%distance between two pinholes
    intervals(i)=loc(i+1)-loc(i);
end
j=i;