function T = buildResultTable(acc,set,subjectId,windowSize,run,experimentName,bestEpoch,seed)
T = table();
T.Acc = acc;
T.Set = {set};
T.Subject_Id = subjectId;
T.Window_Size = windowSize;
T.Run = run;
T.Experiment_Name = {experimentName};
T.Best_Epoch = bestEpoch;
T.Seed = seed;
end