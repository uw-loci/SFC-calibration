function [peakvalue,peakloc]=IdentifySpectralPeaks(array,threshold)
%%to identify [peakvalue,peaklocation] in an array (pre-processed by add up the rows)
[pk,loc]=findpeaks(array);  %%roughly find the peaks
avgpk=zeros([1,length(pk)]);

for i=1+8:length(array)-8
    avgpk(i)=sum(array(i-8:i+8))/17;
end

avgpk(1:8)=avgpk(9);
avgpk(length(array)-7:length(array))=avgpk(length(array)-8);
peakvalue=pk(pk>avgpk(loc)+threshold); %%vector calculation directly, corresponding to each position
peakloc=loc(pk>avgpk(loc)+threshold);
        
