clearvars; close all; clc;

run(fullfile(srcDir,'..','matconvnet-1.0-beta25','matlab','vl_setupnn'));

experimentName = 'experiment-1'; % name of folder that will be created in ../models and ../results
stories = {'milan','maarten'}; % other options (not used): 'bianca', 'eline'
windowSizes = [1/128*17 0.25 0.5 1 2 5 10]; % s
nRuns = 10;

for run = 1:nRuns
    newRng = utils.setSeed('shuffle',experimentName,run); % fix seed and save to disk
    
    for windowSize = windowSizes
        for story = stories
            story = story{1}; %#ok<FXSET>

            testTrialIds = utils.getTestTrialIds(story);
            nTestTrials = numel(testTrialIds);

            [trainData,valData,testData] = data.loader(windowSize,testTrialIds);
            % train = # subjects
            % val = # subjects
            % test = # subjects X # trials struct
            assert(length(trainData)==length(valData));
            assert(length(valData)==size(testData,1));
            assert(size(testData,2)==nTestTrials);

            nSubjects = length(trainData);

            % Normalize the data
            for subjectIdx = 1:nSubjects
                train2D.x = reshape(permute(trainData(subjectIdx).x,[1 3 2]),[],64);

                % First remove the bottom and top 10% of the squared samples
                trimmedMeanPerColumn = trimmean((train2D.x).^2,20);

                % Then normalize all the data based on statistics of the train set
                eegScalingFactor = sqrt(median(trimmedMeanPerColumn));
                trainData(subjectIdx).x = trainData(subjectIdx).x/eegScalingFactor;
                valData(subjectIdx).x = valData(subjectIdx).x/eegScalingFactor;
                for trialIdx = 1:nTestTrials
                    testData(subjectIdx,trialIdx).x = testData(subjectIdx,trialIdx).x/eegScalingFactor;
                end
            end
            clear train2D;

            % Concat data
            allTrain.x = [];
            allTrain.y = [];
            allVal.x = [];
            allVal.y = [];
            for subjectIdx = 1:nSubjects
                allTrain.x = cat(3,allTrain.x,trainData(subjectIdx).x);
                allTrain.y = cat(2,allTrain.y,trainData(subjectIdx).y);
                allVal.x = cat(3,allVal.x,valData(subjectIdx).x);
                allVal.y = cat(2,allVal.y,valData(subjectIdx).y);
            end
            clear trainData valData;

            % Train
            model.preprocess_and_train(allTrain,allVal,windowSize,experimentName,run,story);                

            % Select the best model based on its val acc
            genericPath = utils.genericModelDir(experimentName,run,windowSize,story);
            [bestGeneric,bestGenericEpoch] = utils.getBestModel(genericPath);

            % Test
            thisRng = rng;
            for subjectIdx = 1:nSubjects
                for trialIdx = 1:nTestTrials                      
                    model.preprocess_and_test(bestGeneric,testData(subjectIdx,trialIdx), ...
                        experimentName,windowSize,run,story,bestGenericEpoch,thisRng.Seed);
                end
            end               
        end
    end
end
