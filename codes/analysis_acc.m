function analysis_acc(healthy,faulty,feature,datawidth,dataset)
%this program uses 4 threshold values which can be changed by the user
thresh_zcr=1;           %threshold value for zcr
thresh_separation=50;   %threshold value for sepation
thresh_ratio=1.2;       %threshold value for ratio of means
thresh_std=1.3;         %threshold value for standard deviation of means of datasets
%Inorder to looosen the thresholds,the user is advised to change the...
%...threshold values from bottom to top i.e., do for std then move to zcr
score=ones(1,feature);sepcount=0;

diffdata=healthy-faulty;
for j=1:feature
    count = 0;             
    for i=1:((datawidth*dataset)-1)
        if(diffdata(i+1,j)>=0 && diffdata(i,j)<=0)
            count=count+1;
        else if(diffdata(i+1,j)<=0 && diffdata(i,j)>=0)
                count=count+1;
            end;
        end;
    end;
    if count>thresh_zcr
        score(1,j)=0;
    end
end;

for i=1:feature
    if(score(1,i)~=0)
        a=healthy(:,i);
        b=faulty(:,i);
    else
        continue;
    end
    meanh=mean(a);
    meanf=mean(b);
    if(meanh>meanf)
        Max=a;
        Min=b;
    else
        Max=b;
        Min=a;
    end
    for j=1:dataset*datawidth
        if(Min(j,1)>=min(Max)||Max(j,1)<max(Min))
            sepcount=sepcount+1;
        end
        
    end
    if((sepcount>=thresh_separation)||abs((mean(Max)/mean(Min))<thresh_ratio))       %threshold for separation
        score(1,i)=0;
    end
    sepcount=0;
end

for i=1:feature;       
    nor_hea=healthy(:,i);nor_fau=faulty(:,i);
    std_hea=std(nor_hea);std_fau=std(nor_fau);
    mn_hea=mean(nor_hea);mn_fau=mean(nor_fau);
    nor_hea(:,1)=(nor_hea(:,1)-mn_hea)/std_hea;nor_fau(:,1)=(nor_fau(:,1)-mn_fau)/std_fau;
    for j=0:(dataset-1)
        ind=datawidth*j+1:datawidth*j+datawidth;
        temp_hea=nor_hea(ind,1);temp_fau=nor_fau(ind,1);
        h(j+1)=mean(temp_hea);  f(j+1)=mean(temp_fau);
    end
    if(i==628)
        fprintf('h=%d   f=%d\n',std(h),std(f));
    end
    if(std(h)+std(f)>thresh_std)       %threshold for standard deviation
        score(i)=0;
    end
end

[sorted,ind]=sort(score,'descend');
for i=1:feature;
    if(score(ind(i))~=0)
        disp(ind(i));
    end
end
end
