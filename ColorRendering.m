function rgbstack=ColorRendering(stack, transmatrix)

rgbstack=zeros([size(stack,1),size(stack,2),size(transmatrix,1)]); %%840*512*3

%%3-by-15 dot product 15-by-512
for y=1:512
    rgbstack(1:size(rgbstack,1),y,1:3)=(transmatrix*(squeeze(stack(1:size(rgbstack,1),y,1:15)))')';
end

rgbstack=rgbstack-min(rgbstack(:));
rgbstack=rgbstack/max(rgbstack(:));