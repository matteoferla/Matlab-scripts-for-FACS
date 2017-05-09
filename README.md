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
