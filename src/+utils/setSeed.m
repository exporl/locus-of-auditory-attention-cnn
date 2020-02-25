function scurr = setSeed(str,experimentName,run)
path = utils.seedPath(experimentName,run);
if exist(path,'file')
    warning('seed already exists (%s)... using that one instead',path);
    scurr = load(path);
    rng(scurr.seed);
    return;
end
rng(str); 

scurr.seed = rng;
% add some meta-data
scurr.metadata.experimentName = experimentName;
scurr.metadata.run = run;
scurr.metadata.path = path;
scurr.metadata.date = datetime;
[parentDir,~,~] = fileparts(path);
if ~exist(parentDir,'dir')  
    mkdir(parentDir);
end
fprintf('Saving new seed to %s\n',path);
save(path,'-struct','scurr');

% set file permissions to read only
fileattrib(path,'-w');
end