% This script uses the standard way MF stores FSC data for multiple samples.
figure;
% sample={}; add sample names
scala ='log'; % data aquired as log or lin? Does not matter anymore.
data=fca_readfcs(sample2file(sample))/100;
 
[a,b]=hist(data(:,21),unique(data(:,21)));
[x,j]=sort(a,'descend');
gatevalue = b(j(1));
for g=1:numel(b)
subplot(1,numel(b),g);
gatevalue=b(g);
filtro =  (data(:,21) == gatevalue) & (data(:,channel2number('fsc'))>=cutoff(1)) & (data(:,channel2number('ssc'))>=cutoff(2));
dscatter(data(filtro,channel2number('fsc')),data(filtro,channel2number('ssc')),'LOGY',true,'LOGX',true)
xlim([1,1e4])
ylim([1,1e4])
set(gca,'XScala',scala);
set(gca,'YScala',scala);
set(gca,'TickDir','out');
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
set(gca,'Layer', 'Top');
xlabel(channel2name('fsc'));
ylabel(channel2name('ssc')) ;
title(gatevalue);
end
