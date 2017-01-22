function main_vib(healthy_old,faulty_old,feature_old,datawidth_old,dataset_old,P_Ranges)

brej_healthy=conversion(healthy_old,feature_old,datawidth_old,dataset_old,P_Ranges);
brej_faulty=conversion(faulty_old,feature_old,datawidth_old,dataset_old,P_Ranges);
feature=feature_old*P_Ranges;datawidth=datawidth_old/4;dataset=dataset_old;

%this program uses 4 threshold values which can be changed by the user
thresh_zcr=15;           %threshold value for zcr
thresh_separation=20;   %threshold value for sepation
thresh_ratio=2;       %threshold value for ratio of means
thresh_std=1.8;         %threshold value for standard deviation of means of datasets
%In order to looosen the thresholds,the user is advised to change the...
%...threshold values from bottom to top i.e., do for std then move to zcr
score=ones(1,feature);rej=zeros(1,feature);

%this function finds which dataset has to be rejected
k=rej_func(brej_healthy,brej_faulty,feature,datawidth,dataset,thresh_zcr,thresh_separation,thresh_ratio,thresh_std);

%if k is non zero,then some dataset has to be rejected.The removal of that particular dataset is below
if(k~=0)
    ind=datawidth*(k-1);
    if(ind~=0)
        healthy(1:ind,1)=brej_healthy(1:ind,1);
        faulty(1:ind,1)=brej_faulty(1:ind,1);
    end
    healthy(ind+1:(dataset*datawidth)-datawidth,1)=brej_healthy(ind+datawidth+1:(dataset*datawidth),1);
    faulty(ind+1:(dataset*datawidth)-datawidth,1)=brej_faulty(ind+datawidth+1:(dataset*datawidth),1);
    dataset=dataset-1;
else
    healthy=brej_healthy;faulty=brej_faulty; 
end
        
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
    if (count>thresh_zcr)
        score(1,j)=0;
    end    
end;

for i=1:feature
    if(score(1,i)~=0)
        meanh=mean(healthy(:,i));
        meanf=mean(faulty(:,i));
    else
        continue;
    end
    if(meanh>meanf)
        upper=healthy(:,i);
        lower=faulty(:,i);
    else
        upper=faulty(:,i);
        lower=healthy(:,i);
    end
    
    for j=1:dataset*datawidth
        if(rej_lower(j,1)>=min(rej_upper)||rej_upper(j,1)<max(rej_lower))
            sepcount=sepcount+1;
        end
        
    end
    if((sepcount>=thresh_separation)||abs((mean(upper)/mean(lower))<thresh_ratio))       %threshold for separation
        score(1,i)=0;
    end
    sepcount=0;
end


for i=1:feature;  
    h=zeros(dataset);f=zeros(dataset);
    nor_hea=healthy(:,i);nor_fau=faulty(:,i);
    std_hea=std(nor_hea);std_fau=std(nor_fau);
    mn_hea=mean(nor_hea);mn_fau=mean(nor_fau);
    nor_hea(:,1)=(nor_hea(:,1)-mn_hea)/std_hea;nor_fau(:,1)=(nor_fau(:,1)-mn_fau)/std_fau;
    for j=0:(dataset-1)
        ind=datawidth*j+1:datawidth*j+datawidth;
        temp_hea=nor_hea(ind,1);temp_fau=nor_fau(ind,1);
        h(j+1)=mean(temp_hea);  f(j+1)=mean(temp_fau);
    end
    if(std(h)+std(f)>thresh_std)       %threshold for standard deviation
        score(i)=0;
    end
end


[~,ind]=sort(score,'descend');
for i=1:feature;
    if(score(ind(i))~=0)
        colm=mod(ind(i),feature_old);
        pres=floor(ind(i)/feature_old);
        p1=2*(pres+1);
        p2=2+2*(pres+1);
        fprintf('feature%d    pressure %d-%d  ',colm,p1,p2);
        fprintf('\n');
    end
end
end

function accnew= conversion(matrix,features,datawidth,datasets,P_Ranges)
a=zeros(((datasets*datawidth)/P_Ranges),features);
b=zeros(((datasets*datawidth)/P_Ranges),features);
c=zeros(((datasets*datawidth)/P_Ranges),features);
d=zeros(((datasets*datawidth)/P_Ranges),features);
for i=0:(datasets-1);
    for j=1:(datawidth/P_Ranges);
        a((datawidth/P_Ranges)*i+j,:)=matrix(datawidth*i+j,:);
        b((datawidth/P_Ranges)*i+j,:)=matrix(datawidth*i+(datawidth/P_Ranges)+j,:);
        c((datawidth/P_Ranges)*i+j,:)=matrix(datawidth*i+2*(datawidth/P_Ranges)+j,:);
        d((datawidth/P_Ranges)*i+j,:)=matrix(datawidth*i+3*(datawidth/P_Ranges)+j,:);
    end
end
accnew=[a,b,c,d];
end

