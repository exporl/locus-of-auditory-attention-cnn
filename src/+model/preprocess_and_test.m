function accTest = preprocess_and_test(bestGeneric,testData,experimentName,windowSize,run,story,bestEpoch,seed)
[testData.x,testData.y] = model.preprocess(testData.x,testData.y);

subjectId = testData.subjectId;

fprintf('Testing subject %i... ',subjectId);

accTest = model.evaluate(bestGeneric.net,testData.x,testData.y);

% test results
T_test = model.buildResultTable(accTest,'test',subjectId, ...
    windowSize,run,experimentName,bestEpoch,seed);

% train results
accTrain = 1-bestGeneric.stats.train(end).top1err;
T_train = model.buildResultTable(accTrain,'train',subjectId, ...
    windowSize,run,experimentName,bestEpoch,seed);

% val results
accVal = 1-bestGeneric.stats.val(end).top1err;
T_val = model.buildResultTable(accVal,'val',subjectId, ...
    windowSize,run,experimentName,bestEpoch,seed);

T = [T_test;T_val;T_train];

if isnumeric(story)
    T.Story = repmat(story,height(T),1);
else
    T.Story = repmat({story},height(T),1);
end

path = utils.resultsFile(experimentName,windowSize);
utils.saveTable(T,path);
end