function loc=PinholeLocation(array,start,stop)

loc=0;
total=0;
for i=start:stop
    loc=loc+i*array(i);
    total=total+array(i);
end

loc=loc/total; %%intergral in discrete manner