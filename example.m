%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% About
%{
This is an example of my setup for analysis files.
I make spreadsheet called scheme.csv with the following fields:
* samplelist. This is a one-two letter code for the sample (e.g. A)
* name. The pretty name
* file. the filename
* colorR. R of RGB for lines
* colorG. G
* colorB. B
* style. The line style of the histogram.


%}
%% Fluff
channelcodes={'fsc','ssc','fl1','fl2','fl3','fl4'};
channel2name=containers.Map(channelcodes,...
    {'Front Scatter','Side Scatter','525/30 nm fluorescence (FL1)','586/25 nm fluorescence (FL2)','615/25 nm fluorescence (FL3)','655/LP nm fluorescence (FL4)'});
channel2color=containers.Map(channelcodes,...
    {'Front','Side','Green','Orange','Red','Far-red'});
channel2number=containers.Map(channelcodes,[3,6,9,12,15,18]); %check .par in metadata.

%% Input
%%% read from file
scheme=readtable('scheme.csv');
% something odd check:
% scheme.Properties.VariableNames

%%% parse file (and manually override if need be...)
% the short handles e.g. sample A
samplelist=scheme.samplelist;
% Files of those
sample2file=containers.Map(samplelist,scheme.file);
% Pretty names of those for titles
sample2name=containers.Map(samplelist,scheme.name);
% RGB for lines
sample2color=containers.Map(samplelist,num2cell([scheme.colorR, scheme.colorG, scheme.colorB],2));
% dashingness
sample2style=containers.Map(samplelist,scheme.style);
% hack... experimental. Memory issues!
%{
dataset=num2cell(zeros(numel(samplelist),1),2);
for i=1:numel(samplelist)
dataset{i}=fca_readfcs(sample2file(samplelist{i}));
end
sample2data=containers.Map(samplelist,dataset);
clear dataset;
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Scatterplot
samples={'A','B'}; 
layout=[1,2]; % for the subplotting
cutoff=[0,0]; % Front, Side. No longer used.
%greenness=false;  %plot greeness based on FL1? Not doable w dscatter.
scala ='log'; % data aquired as log or lin? Does not matter anymore.
gated = false; %gated into most populous gate
%%% Plot
figure;
channels={'fsc','ssc'};
%channels={'ssc',strcat('fl',num2str(c))}; %(x,y)
for i=1:numel(samples)
    subplot(layout(1),layout(2),i)
    data=fca_readfcs(sample2file(samples{i}))/100;
    
    if (gated == true)
        % determine most populous gate. I am pretty sure the numbers are
        % char.
        [a,b]=hist(data(:,21),unique(data(:,21)));
        [x,j]=sort(a,'descend');
        gatevalue = b(j(1));
        filtro =  (data(:,21) == gatevalue) & (data(:,channel2number('fsc'))>=cutoff(1)) & (data(:,channel2number('ssc'))>=cutoff(2));
    else
        filtro =  (data(:,channel2number('fsc'))>=cutoff(1)) & (data(:,channel2number('ssc'))>=cutoff(2));
    end
    dscatter(data(filtro,channel2number(channels{1})),data(filtro,channel2number(channels{2})),'LOGY',true,'LOGX',true)
    if (cutoff(1)+cutoff(2) ~=0)
        line([1 1e4],[cutoff cutoff])
        line([cutoff cutoff],[1 1e4])
    end
    ax=gca;
    ax.XScale=scala;
    ax.YScale=scala;
    ax.TickDir='out';
    xlim([1,1e4])
    ylim([1,1e4])
    xlabel(channel2name(channels{1}))
    ylabel(channel2name(channels{2}))
    title(sample2name(samples{i}))
end
colorbar;
clear data ax filtro;

%% histogram (rough)
figure;
samples={'A','B','C','D','wt'};
channel='fl1';
cutoff=[0,0];
hold on
bs=-2:0.02:4;
for i=1:numel(samples)
    s=samples{i};
    data=fca_readfcs(sample2file(s))/100;
    [a,b]=hist(data(:,21),unique(data(:,21)));
    [x,j]=sort(a,'descend');
    gatevalue = b(j(1));
    filtro =  (data(:,21) == gatevalue) & (data(:,channel2number('fsc'))>=cutoff(1)) & (data(:,channel2number('ssc'))>=cutoff(2));
    [N,edges] = histcounts(log10(data(filtro,channel2number(channel))),bs);
    plot(10.^edges,[N,0]/sum(filtro)*1e4,'LineWidth',2,'Color',sample2color(s),'LineStyle',sample2style(s));
end
ylabel('Counts per bin (10^{0.02} increments)') % based on bs
xlabel(channel2name(channel))
legend(values(sample2name,samples),'Location','best')
title(sprintf('Gated fluorescent distribution in %d bins',numel(bs)))
scala ='log';
ax=gca;
ax.XScale=scala;
ax.TickDir='out';
