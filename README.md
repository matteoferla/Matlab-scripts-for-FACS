# Matlab-scripts-for-FACS
A collection of scripts and snippets I use for FACS with the BioRad S3e. It is meant for Oxford Biochem folk —no interpers! ;)

## dscatter
This is a mod of [dscatter](http://uk.mathworks.com/matlabcentral/fileexchange/8430-flow-cytometry-data-reader-and-visualization?focused=6779476&tab=function) present on the exchange. It has two mods. First it has logx parameter and secondly it has the following change:

    minx = min(X(~isinf(X)),[],1);
    maxx = max(X(~isinf(X)),[],1);
    miny = min(Y(~isinf(Y)),[],1);
    maxy = max(Y(~isinf(Y)),[],1);

This stops it from throwing an error due to infinite values.

## fca_readfcs
This is a mod of [fca_readfcs](https://uk.mathworks.com/matlabcentral/fileexchange/9608-fcs-data-reader) by the author himself to deal with 3.1. I am not sure it has gone live on Exchange.


## example
This is just an example of a scatter pot and a histogram in a rather handy format... a protofunction if it wern't of for the fact that I keepchanging bits.

The import is nice though.
Basically it relies on a file called `sheme.cvs` with the following fields:
* samplelist. This is a one-two letter code for the sample (e.g. A)
* name. The pretty name
* file. the filename
* colorR. R of RGB for lines
* colorG. G
* colorB. B
* style. The line style of the histogram.
