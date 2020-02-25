function path = genericModelDir(experimentName,run,windowSize,str)
basePath = utils.modelsDir(experimentName,run,windowSize);
path = fullfile(basePath,sprintf('Results_generic_%s',str));
end
