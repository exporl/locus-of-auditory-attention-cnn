function [model,totalBestEpoch,totalBestError] = getBestModel(oneOrMorePaths)
if iscell(oneOrMorePaths)
    % possibly >1 paths
    parentDirBestModel = '';
    totalBestError = Inf;
    totalBestEpoch = NaN;
    for path = oneOrMorePaths
        path = path{1}; %#ok<FXSET>
        [bestEpoch,bestError] = utils.findBestEpoch(path);
        if bestError < totalBestError
            totalBestError = bestError;
            parentDirBestModel = path;
            totalBestEpoch = bestEpoch;
        end
    end
else
    parentDirBestModel = oneOrMorePaths;
    [totalBestEpoch,totalBestError] = utils.findBestEpoch(oneOrMorePaths);
end
model = load(fullfile(parentDirBestModel,sprintf('net-epoch-%i',totalBestEpoch)));
end
