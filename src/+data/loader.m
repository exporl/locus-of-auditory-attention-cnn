function [train,val,test] = loader(windowSize,testTrialIds)
fprintf('Loading data.. ');

allTrials = 1:8; % skip repetitions
trainAndValTrialIds = allTrials(~ismember(allTrials,testTrialIds));
subjectIds = 1:16;
for subjectId = 1:numel(subjectIds)
    tmp = data.preprocess_trainval(trainAndValTrialIds,windowSize,subjectId);
    
    train(subjectId).x = tmp.xtr;
    train(subjectId).y = tmp.ytr;
    train(subjectId).subjectId = subjectId;
    train(subjectId).trialId = trainAndValTrialIds;
    
    val(subjectId).x = tmp.xvl;
    val(subjectId).y = tmp.yvl;
    val(subjectId).subjectId = subjectId;
    val(subjectId).trialId = trainAndValTrialIds;
    
    for testTrialIdx = 1:numel(testTrialIds)
        test(subjectId,testTrialIdx) = ...
            addToStruct(testTrialIds(testTrialIdx),windowSize,subjectId);
        test(subjectId,testTrialIdx).subjectId = subjectId;
        test(subjectId,testTrialIdx).trialId = testTrialIds(testTrialIdx);
    end
end

fprintf('Done.\n');
end

function struct = addToStruct(trialId,windowSize,subjectId)
struct = data.preprocess_test(trialId,windowSize,subjectId);
struct.subjectId = subjectId;
struct.trialId = trialId;
end