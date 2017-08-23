function [peakvalue,peakloc]=IdentifySpectralPeaks(array,threshold)
%%to identify [peakvalue,peaklocation] in an array (pre-processed by add up the rows)
[pk,loc]=findpeaks(array);  %%roughly find the peaks
avgpk=zeros([1,length(pk)]);

for i=1+5:length(array)-5
    avgpk(i)=sum(array(i-5:i+5))/11;
end

avgpk(1:5)=avgpk(6);
avgpk(length(array)-4:length(array))=avgpk(length(array)-5);
peakvalue=pk(pk>avgpk(loc)+threshold); %%vector calculation directly, corresponding to each position
peakloc=loc(pk>avgpk(loc)+threshold);
        
