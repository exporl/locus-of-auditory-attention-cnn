function path = dataDir(dataset,windowSize)
baseDir = fullfile(srcDir,'..','data');
if nargin < 2
    path = fullfile(baseDir,'raw',dataset);
else
    path = fullfile(baseDir,'processed',dataset,sprintf('%is',windowSize));
end
end