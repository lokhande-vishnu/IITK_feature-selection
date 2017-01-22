% % PROGRAM TO FIND BEST FEAUTURES
% % Parameter description
% "healthy" is the healthy data set
% "faulty" is the faulty data set,amy be lov or liv
% "feature" is the number of features to be studied
% "datawidth" is the width of each data set
% "datasets" is the number of data sets considered
% "maxrejects" is the maximum number of datasets to be rejected
% "score" is the number which is alloted to each feature,which decides the rankings
% "tratio" stands for the ratio of the total means,total means being "mh,mf" 
% "nmean" is the normalised means i.e.,the total mean minus the rejected dataset's mean
% "count1,count2" stores the counts where hea/fau>1 or fau/hea>1
% respectively
function analysis(healthy,faulty,feature,datawidth,datasets,maxrejects)
count1=0;count2=0;total_ratio=0;nmean1_hea=0;nmean2_hea=0;
nmean1_fau=0;nmean2_fau=0;mean_hea=0;mean_fau=0;score=zeros(1,feature);

%scores are being alloted to each feature which are then sorted out to find out the best feature
for i=1:feature;        %in this loop, scores are being alloted on the basis of the ratio of means
    for j=0:(datasets-1)
        ind=datawidth*j+1:datawidth*j+datawidth;
        temp_hea=healthy(ind,i);
        temp_fau=faulty(ind,i);
        h=mean(temp_hea);       %h,f are healthy and faulty means of a specific dataset
        f=mean(temp_fau);
        mean_hea=mean_hea+h;                    %finds the total mean of the healthy ,faulty plot respectively
        mean_fau=mean_fau+f;                   
        if(abs((h/f))>1)
            count1=count1+1;
            nmean1_hea=nmean1_hea+h;      %normalised mean1 considers only those datasets which have h/f>1
            nmean1_fau=nmean1_fau+f;
        end
        if(abs((f/h))>1)
            count2=count2+1;
            nmean2_hea=nmean2_hea+h;      %normalised mean2 considers only those datasets which have h/f<1
            nmean2_fau=nmean2_fau+f;
        end
    end
    total_ratio=max(abs(mean_hea),abs(mean_fau))/min(abs(mean_hea),abs(mean_fau));
    if(mean_hea/mean_fau<0)                     %negative datasets can be handled with these corrections
        total_ratio=-total_ratio;
    end
    if(count1>count2)                             %scores are being allotted to each feature,the value of the score describes...
        score(i)=abs(((nmean1_hea/nmean1_fau)-1)*100);  %... the magnitude of the difference between the healthy plot and the faulty...
    else                                          %...plot with respect to the that plot which has lower mean
        score(i)=abs(((nmean2_fau/nmean2_hea)-1)*100);
    end
    score(i)=score(i)+abs((total_ratio-1)*100);
    for k=(maxrejects+1):(datasets-maxrejects-1);
        if(count1==k)                  %those features get a score zero which have uneven plots             
            score(i)=0;
        end
    end
    if(count1+count2<(datasets-maxrejects))
        score(i)=0;
    end
    
    temp_hea=healthy(:,i);temp_fau=faulty(:,i);
    std_dev(i)=abs(std(temp_hea)/mean_hea) + abs(std(temp_fau)/mean_fau);
    count1=0;count2=0;
    nmean1_fau=0;nmean2_fau=0;nmean1_hea=0;nmean2_hea=0;total_ratio=0;mean_hea=0;mean_fau=0;
end

%in this loop scores are being allloted on the basis of number of zero crossings
diffdata=healthy-faulty;
for j=1:feature
    
    count = 0;
    thresh = 0;
    for i=1:((datawidth*datasets)-1)
        if(diffdata(i+1,j)>=thresh && diffdata(i,j)<=thresh)
            count=count+1;
        else if(diffdata(i+1,j)<=thresh && diffdata(i,j)>=thresh)
                count=count+1;
            end;
        end;
    end;
    if(count~=0)
        score(j)=score(j)+100/count;
    else
        score(j)=score(j)+200;
    end
end;

score=score/10;
[arr,sorted]=sort(score,'descend');     %features are being sorted over here

for i=1:100
    score(sorted(i))=score(sorted(i))+ 1/std_dev(i);
end

[arr,sorted]=sort(score,'descend');
for k=1:100;        %features are  being printed,the best one comes the first
    fprintf('feature %d\n',sorted(k));
end



