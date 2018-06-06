%% multisample_analysis_load.m
% nothe that previous version of my code used containers.map.
% this version is modified to use tables directly.

%% Channel settings
% the channel table allows easy handling of channel stuff.
% for example showing the pretty name for fl1 is channel.name('fl1'),
% a less stuff one word name is in .color
% while to get the corresponding column in the fcs (as annotated in the
% .par field in metadata from fca_readfcs use channel.number('fl1').
% the channels are 'fsc', 'ssc', 'fl1', 'fl2', 'fl3', 'fl4'.
channel=table({'Front Scatter', 'Side Scatter', '525/30 nm fluorescence (FL1)', '586/25 nm fluorescence (FL2)', '615/25 nm fluorescence (FL3)', '655/LP nm fluorescence (FL4)'}',...
    {'Front', 'Side', 'Green', 'Orange', 'Red', 'Far-red'}',...
    [3, 6, 9, 12, 15, 18]',...
    'VariableNames',{'name','color','number'},...
    'RowNames',{'fsc', 'ssc', 'fl1', 'fl2', 'fl3', 'fl4'});

%% Sample Scheme
% a sample scheme is a csv table that controls the filenames and their layout.
% * the sample short name is in samplelist column, which will be used a the
% handle for that sample.
% * name. The pretty display name. TBH I failed to get unicode to be read.
% * file. the filename, gotten say via $ ls -1
% * colorR. R of RGB for lines
% * colorG. G
% * colorB. B
% * these three will go to make the 3x1 vector color variable.
% * style. The line style of the histogram.
% * <some custom column>
sample = readtable('scheme.csv', 'Encoding', 'UTF-8');
sample.Properties.RowNames=sample.samplelist;
sample.color=num2cell([sample.colorR, sample.colorG, sample.colorB],2);

%% Saver
% save figures? if so change the saver boolean (and re-evaluate this
% block).
saver=true;
if (saver)
    vprint=@(varargin) print(varargin{:});
else
    vprint=@(varargin) 0;
end