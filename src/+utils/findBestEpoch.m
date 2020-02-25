function [bestEpoch,bestError] = findBestEpoch(path)
set = 'val';

files = dir(fullfile(path,'net-epoch-*.mat'));
if isempty(files)
    error('no files matching "net-epoch-*.mat" found in %s',path);
end
bestError = Inf;
for idx = 1:length(files)
    net = load(fullfile(files(idx).folder,files(idx).name));
    if net.state.stats.(set).top1err < bestError % top1err = accuracy
        bestError = net.state.stats.(set).top1err;
        bestEpoch = utils.extractEpochId(files(idx).name);
    end
end
end
