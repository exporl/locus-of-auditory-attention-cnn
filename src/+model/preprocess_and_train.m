function preprocess_and_train(train,val,windowSize,experimentName,run,str)
[train.x,train.y] = model.preprocess(train.x,train.y);
[val.x,val.y] = model.preprocess(val.x,val.y);

x = cat(4,train.x,val.x);
y = cat(2,train.y,val.y);
spl.Ts_Ind = [false(size(train.x,4),1);true(size(val.x,4),1)]; % indices of test data
spl.Tr_Ind = ~spl.Ts_Ind; % indices of training data
clear train val;

%% init network
[net,~,imdb] = model.init(x,y,spl);
net.meta.trainOpts.numEpochs = 100;

%% train
genericPath = utils.genericModelDir(experimentName,run,windowSize,str);
cnn_train_no_rng(net, imdb, @model.getBatch, 'expDir', genericPath, net.meta.trainOpts);
end
