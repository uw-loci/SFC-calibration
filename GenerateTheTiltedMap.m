function [maptilted,bandsize,number,long]=GenerateTheTiltedMap(image,theta)

%%pi=3.1415926;
%%steps=1/tan(theta/180*pi);

map=zeros([512,512,2]);
bigmaptilted=zeros([512,512,2]);
%inherit some parameters
for i=1:length(image)
    temp(i).peak=image(i).peaks;
    temp(i).peakloc=image(i).peakloc;
    wl(i)=image(i).peaks;  %% for after use to select the max and min of wavelengths
end

%record the wavelengths together in one vector
bandspread=zeros([1,512]);
for i=1:length(temp)
    bandspread(temp(i).peakloc)=temp(i).peak; %% vector operation
end
%%figure;plot([1:512],bandspread);

%red lines' locations are deemed as boundaries, so band should between two
%red lines
boundary=zeros([1,512]);
boundarypeakh=max(wl); %%or temp.peak?
boundarypeakl=min(wl);
boundary=1;
flag=0;
for i=1:length(temp)
    if (temp(i).peak==boundarypeakh)
        indexh=i;
        flag=flag+1;
    end
    if (temp(i).peak==boundarypeakl)
        indexl=i;
        flag=flag+1;
    end
    if (flag==2)
        break;
    end
end
high=temp(indexh).peakloc;
low=temp(indexl).peakloc;

for i=1:length(high)-1 %%high:index from 2-32 low:1-31
    boundary=[boundary,ceil((low(i)+high(i+1))/2)]; %%adding elements
end
boundary=[boundary,512];

%%ensure each pinhole has 15 pixels away from next ones
for i=2:length(boundary)-2
    if(boundary(i+1)-boundary(i)==16)
        boundary(i+1)=boundary(i+1)-1;
    end
    if(boundary(i+1)-boundary(i)==14)
        boundary(i+1)=boundary(i+1)+1;
    end
end
    
%%figure;plot(boundary,ones(1,length(boundary)),'.');

%%32 bands, each color refers to one band, not related with the wavelength
bands=zeros([1,512]);
for i=1:length(boundary)-1
    bands(boundary(i):boundary(i+1))=i;
end

%%figure;imagesc(bands');

%%linearly interpolate wavelengths to the boundary dots:from 32*5=160 to
%%225, and then interpolate wavelengths to all of the 512 dots, operate the
%%bandspread[]
%%extrapolate boundary first, adding the peaks (160)
for i=1:512
    if(bandspread(i)~=0)
        boundary=[boundary,i];
    end
end
boundary=sort(boundary);
%%figure;plot(boundary,1,'b.');

for i=1:length(boundary) %%interpolate bandspread(boundary(i))
    if(bandspread(boundary(i))==0)
        if(i<length(boundary)-2) %%right linear
            k=(bandspread(boundary(i+2))-bandspread(boundary(i+1)))/(boundary(i+2)-boundary(i+1));
            b=bandspread(boundary(i+2))-k*boundary(i+2);
            bandspread(boundary(i))=k*boundary(i)+b;
        end
        if(i>2) %%left linear as well
            k=(bandspread(boundary(i-1))-bandspread(boundary(i-2)))/(boundary(i-1)-boundary(i-2));
            b=bandspread(boundary(i-1))-k*boundary(i-1);
            bandspread(boundary(i)-1)=k*(boundary(i)-1)+b;
            boundary=[boundary,boundary(i)-1]; %%adding the newly assigned wavelengths indice, or it will cause error in assign other values.
        end
    end
end

boundary=sort(boundary); %%need to do this if new elements are added into an array
for i=1:length(boundary)-1
    k=(bandspread(boundary(i+1))-bandspread(boundary(i)))/(boundary(i+1)-boundary(i));
    b=bandspread(boundary(i+1))-k*boundary(i+1);
    map(boundary(i):boundary(i+1),:,2)=repmat(k*(boundary(i):boundary(i+1))+b,[512,1])';
end

map(:,:,1)=repmat(bands',[1,512]);
number=0;
for i=2:max(map(:,:,1))-1
    number=number+sum(map(:,1,1)==i);
end
bandsize=number/(max(map(:,1,1))-2);
number=number/bandsize;

%%figure;imagesc(map(:,:,2));

%%for y=1:512
    %%count=0;
    %%lastx=1;
    %%initial=y;
    %%for x=1:512
        %%if(count<round(steps))
            %%count=count+1;   %%copy the length of round(steps) at once
        %%else
            %%bigmaptilted(initial,lastx:x,2)=map(y,lastx:x,2);
            %%bigmaptilted(initial,lastx:x,1)=map(y,lastx:x,1);
            %%initial=initial+1; %%move one pixel downward
            %%lastx=x;
            %%count=0;
        %%end
    %%end
%%end

maptilted=zeros([512,512,2]);
bigmaptilted=imrotate(map,theta); %%rotates image by angle degrees
long=size(bigmaptilted,1);
center=floor(long/2);
maptilted(1:512,1:512,2)=bigmaptilted(center-255:center+256,center-255:center+256,2);
maptilted(1:512,1:512,1)=bigmaptilted(center-255:center+256,center-255:center+256,1);
%%figure;imagesc(maptilted(:,:,2));