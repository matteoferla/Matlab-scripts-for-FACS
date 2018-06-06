%% histo
%%% config
chosen_samples = sample.samplelist; % or a subset say
gated = true; % true: plots only values within a gate(s) listed in gatevalues. 
gatevalues = [2.5600, 335552, 838874]; % column 21 in S3e data. To see which you need use gate_check
low_cutoff = [0, 0]; % fsc and ssc cutoff minimum in gate. Not really needed, unless you made soem weird gates.
customgate= false; % true: gate a rectangle between fsc_cutoff and ssc_cutoff
fsc_cutoff=[100 150];
ssc_cutoff=[150 250];
bin_size=0.02; % bin spacing in log incremenets! 10^0.02 = 4.7%
bs = - 2:bin_size:4; 
chosen_channel = 'fl1'; % channel to show.

%%% calculations!
figure;
hold on
for i = 1:numel(chosen_samples)
    s = chosen_samples{i};
    data = fca_readfcs(sample.file{s}) / 100;
    if (gated)
        gatedness = zeros(size(data(:, 21)));
        for z = 1:numel(gatevalues)
            gatedness = gatedness + (data(:, 21) == gatevalues(z));
        end
        filtro = gatedness & (data(:, channel.number('fsc')) >= low_cutoff(1)) & (data(:, channel.number('ssc')) >= low_cutoff(2));
    elseif (customgate)
            f1=data(:,channel.number('fsc'))>=fsc_cutoff(1);
            f2=data(:,channel.number('fsc'))<=fsc_cutoff(2);
            s1=data(:,channel.number('ssc'))>=ssc_cutoff(1);
            s2=data(:,channel.number('ssc'))<=ssc_cutoff(2);
            filtro =  f1 & f2 & s1 & s2;
    else
        filtro = logical(ones(size(data, 1), 1));
    end
    [N, edges] = histcounts(log10(data(filtro, channel.number(chosen_channel))), bs);
    plot(10 .^ edges, [N, 0] / sum(filtro) * 1e4, 'LineWidth', 2, 'Color', sample.color{s}, 'LineStyle', sample.style{s});
end
ylabel(sprintf('Counts per bin (%0.f%% increments)',(10^bin_size)*100-100)); % based on bs
xlabel(channel.name(chosen_channel))
legend(sample.name(chosen_samples), 'Location', 'best')
title(sprintf('Gated fluorescent distribution in %d bins', numel(bs)))
set(gca,'TickDir','out');
set(gca,'XScale','log');
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
set(gca,'Layer', 'Top');
xlim([10 1e3]);
vprint('histogram', '-dpng', '-r1200');