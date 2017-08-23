function stack=ReadTiltedSpectralImages(imagepath, imagename, channels, offset, map, bandsize, pinumber,theta)
%%channels refer to how much images in a cycle

%%imagepath='C:\Users\gu\Desktop\ÊîÆÚ¿ÆÑÐ\demo\data\threechannel\';
%%imagename='JeffBeads70ms-005';
%%channels=28;  %%28 steps to record the whole sample
%%offset=5;
%%map has two pages
%%bandsize refers to how many pixels in one band
%%pinumber refers to how many bands
stack1=zeros([512,512,channels]); %%size*channels

%%for i=1+offset:channels+offset
    %%stack1(:,:,i-offset)=imread([imagepath imagename '_Cycle00001_Ch1_' sprintf('%06d',i) '.ome.tif' ])'; %%original image stack
%%end

for i=1+offset:channels+offset
    stack1(:,:,i-offset)=imread([imagepath imagename '_Cycle' sprintf('%05d',1+(i-1)*3) '_CurrentSettings_Ch1_000002.tif' ]); %%original image stack
end

start=sum(map(:,1,1)==1)+1; %%y starts from band 2, because band 1 is not a real band
stop=512-sum(map(:,1,1)==max(map(:,1,1))); %%y stops at band 31, because band 32 is not a real band

%%stack=zeros([channels*pinumber,512,16]);
stack=zeros([channels*pinumber,512,bandsize]);
%%lambda=zeros([channels*pinumber,512,bandsize]);

%%a=start;
for n=1:channels
    for x=start:stop %%stop
            wavelength=map(x,1,2); %%bin is wavelength
            %%bandn=map(x,1,1);
            bandn=2+floor((x-start)/15); %%bandnumber: belong to which pinhole/band
            %%lastbandn=2;
            binorder=sort(map(start+(bandn-2)*bandsize:start+(bandn-2)*bandsize+bandsize-1,1,2),'descend')';; %%binorder: wavelength in one band set in order
            %%binorder=sort(map(a:a+sum(map(:,1,1)==bandn)-1,1,2),'descend')'; %%binorder: wavelength in one band set in order
            %%if(bandn~=lastbandn)
                %%a=a+sum(map(:,1,1)==bandn);
                %%lastbandn=bandn;
            %%end
            bin=find(binorder==wavelength); %%bin: belong to which lambda bin
            %%stack(n+(bandn-2)*channels,1:512,bin)=stack1(x,1:512,n);
            %%lambda(n+(bandn-2)*channels,1:512,bin)=wavelength;
            stack(channels+1-n+(bandn-2)*channels,1:512,bin)=stack1(x,1:512,n); %%with same y can be simplified to vectorization maybe,red is upper and back,the sample in channels are moving upward
    end
end

%%temp=zeros([channels*pinumber/2,512,bandsize]);

%%temp=stack(1:2:end-1,:,:)+stack(2:2:end,:,:);

stack=stack-min(stack(:));
stack=stack/max(stack(:));