function fea_plotting2(healthy_old,faulty_old,feature_old,datawidth_old,datasets_old,P_Ranges)

healthy=conversion(healthy_old,feature_old,datawidth_old,datasets_old,P_Ranges);
faulty=conversion(faulty_old,feature_old,datawidth_old,datasets_old,P_Ranges);
feature=feature_old*P_Ranges;datawidth=datawidth_old/4;datasets=datasets_old;



for f_num = 1:1144;
    x_plot = 1:70;
    h = figure;         
    plot(x_plot, healthy(:,f_num), '-g', x_plot, faulty(:,f_num), '-b');
    set(gca,'XTick',0:10:70);
    grid on;      
    path = sprintf('F:\\Desktop\\MATLABMYDATA\\vib\\Fea_%d',f_num);
    legend({'Healthy','Faulty'}, 'Location', 'NorthEast');
    colm=mod(f_num,feature_old);
    press=floor(f_num/feature_old) + 1;
    ti = sprintf('Fea%d  press%d',colm,press);
    title(ti);
    xlabel('Samples');ylabel('Amplitude');
    saveas(h,path,'png'); 
    close;
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

