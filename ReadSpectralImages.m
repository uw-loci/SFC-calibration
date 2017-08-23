function stack=ReadSpectralImages(imagepath, imagename, channels, offset, map, bandsize, pinumber,theta,long)
%%channels refer to how much images in a cycle

%%imagepath='C:\Users\gu\Desktop\ÊîÆÚ¿ÆÑÐ\demo\data\threechannel\';
%%imagename='JeffBeads70ms-005';
%%channels=28;  %%28 steps to record the whole sample
%%offset=5;
%%map has two pages
%%bandsize refers to how many pixels in one band
%%pinumber refers to how many bands
stack1=zeros([512,512,channels]); %%size*channels
stack2=zeros([long,long,channels]); %%should be equal to the size of rotated image

%%for i=1+offset:channels+offset
    %%stack1(:,:,i-offset)=imread([imagepath imagename '_Cycle00001_Ch1_' sprintf('%06d',i) '.ome.tif' ])'; %%original image stack
%%end

for i=1+offset:channels+offset %%read images
    stack1(:,:,i-offset)=imread([imagepath imagename '_Cycle' sprintf('%05d',1+(i-1)*3) '_CurrentSettings_Ch1_000002.tif' ]); %%original image stack
end

for i=1:channels %%rotate each image
    stack2(:,:,i)=imrotate(stack1(:,:,i),theta);
end

long=size(stack2,1);
center=floor(long/2);  %%to find the center of rotation
stack1(1:512,1:512,1:channels)=stack2(center-255:center+256,center-255:center+256,1:channels);  %%resize the rotated images to 512*512
%%start=sum(map(:,1,1)==1)+1; %%y starts from band 2, because band 1 is not a real band
%%stop=512-sum(map(:,1,1)==max(map(:,1,1))); %%y stops at band 31, because band 32 is not a real band

%%stack=zeros([channels*pinumber,512,16]);
stack=zeros([channels*pinumber,512,bandsize]);
%%lambda=zeros([channels*pinumber,512,bandsize]);

%%manually set the bin range
%%intervals=[700 670 655 640 625 610 595 580 565 555 545 535 525 515 500 450];
%%intervals=[700 660 650 640 630 620 610 590 575 550 540 530 520 510 500 450];
intervals=[700 685 670 655 640 625 610 590 575 560 546 533 520 506 493 450];

for n=1:channels
    for y=1:512 %%stop
        for x=1:512
            lambda=map(y,x,2);  %%find lambda of this pixel
            bin=sum(lambda<=intervals);  %%find correct lambda bin it belongs to
            bandn=map(y,x,1);  %%find band number in order to determine the index of stack
            if(bandn>=2&&bandn<=31)  %%the 1st and 32th band are not in use
            stack(channels+1-n+(bandn-2)*channels,x,bin)=stack1(y,x,n);  %%copy the grayscale to it
            end
        end    
    end
end

%%temp=zeros([channels*pinumber/2,512,bandsize]);

%%temp=stack(1:2:end-1,:,:)+stack(2:2:end,:,:);

stack=stack-min(stack(:));
stack=stack/max(stack(:));



