function saveTable(newT,path)
[parentDir,~,~] = fileparts(path);
if exist(path,'file')
    % load the old table and append the new one
    T = readtable(path);
    T = [T;newT];
else
    if ~exist(parentDir,'dir')
        mkdir(parentDir);
    end
    T = newT;
end
Tuniq = unique(T);
nRowsRemoved = height(T)-height(Tuniq);
if nRowsRemoved > 0
    warning('removed %i duplicate rows',nRowsRemoved);
end
writetable(Tuniq,path);
end