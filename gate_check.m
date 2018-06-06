% This script uses the standard way MF stores FSC data for multiple samples.
figure;
chosen_sample = ''; %add a single sample name
scala ='log'; % data aquired as log or lin? Does not matter anymore.

data = fca_readfcs(sample.file{chosen_sample}) / 100;

[a,b]=hist(data(:,21),unique(data(:,21)));
[x,j]=sort(a,'descend');
gatevalue = b(j(1));
for g=1:numel(b)
subplot(1,numel(b),g);
gatevalue=b(g);
filtro =  (data(:,21) == gatevalue);
dscatter(data(filtro,channel.number('fsc')),data(filtro,channel.number('ssc')),'LOGY',true,'LOGX',true)
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
