for f_num = 1:286
    x_plot = 1:280;
    h = figure;         
    plot(x_plot, fea_vib_hea(:,f_num), '-g', x_plot, fea_vib_lov(:,f_num), '-b');
    set(gca,'XTick',0:10:280);
    grid on;        
    path = sprintf('C:\\Users\\Rahul Sevakula\\Desktop\\Plots\\Vibration\\Fea_%d',f_num);
    legend({'Healthy','LOV'}, 'Location', 'NorthEast');
    ti = sprintf('Fea %d',f_num);
    title(ti);
    xlabel('Samples');ylabel('Amplitude');
    saveas(h,path,'png'); 
    close;
end

