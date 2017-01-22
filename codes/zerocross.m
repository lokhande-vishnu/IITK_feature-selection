diffdata=fea_acoustic_hea-fea_acoustic_lov;
for j=1:286
    count = 0;
    thresh = 0;
    for i=1:159
              if(diffdata(i+1,j)>=thresh && diffdata(i,j)<=thresh)
            count=count+1;
        else if(diffdata(i+1,j)<=thresh && diffdata(i,j)>=thresh)
                count=count+1;
            end;
        end;
    end;
    score(j)=100/count;
end;
disp(score);
counter2=sort(score);
disp(find(score==counter2(286)));
    


