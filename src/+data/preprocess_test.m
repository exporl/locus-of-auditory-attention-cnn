function out = preprocess_test(trialId,windowSize,subjectId)
p.targetSampleRate = 128; % Hz
p.lowpass = 32; % Hz
p.highpass = 1;  % Hz

out = struct();
out.fs = p.targetSampleRate;
out.lowpass = p.lowpass;
out.highpass = p.highpass;
out.windowSize = windowSize;
out.subjectId = subjectId;
out.trialId = trialId;

baseDir = utils.dataDir('AAD2015_128hz');
file = fullfile(baseDir,sprintf('S%i.mat',subjectId));

%% Load the EEG data 
file = load(file);
files = file.trials(trialId);
eegfiles(1).trial = files{1};
neegfiles = length(eegfiles);

% also make the EEG files of the same length
for i = 1:neegfiles
    eegfiles(i).trial.RawData.EegData = cutoff_eeg(eegfiles(i).trial.RawData.EegData,out.fs);
end

%% Apply a BPF
bpFilter = data.constructBpFilter(p);
for i = 1:neegfiles
    eegfiles(i).trial.RawData.EegData = filtfilt(bpFilter.numerator,1,double(eegfiles(i).trial.RawData.EegData));
end  

%% Create one big image for every trial 
for i = 1:neegfiles
    images(i).file = eegfiles(i).trial.RawData.EegData;
    images(i).label = eegfiles(i).trial.attended_ear;
end
clear eegfiles env;

% Put al L labels together before the R images
structimages = SortArrayofStruct(images,'label');

% Create overlapping images (50% overlap)
nSamples = windowSize*p.targetSampleRate; % number of samples in a window
overlap = 1/2;
nSamplesWithOverlap = overlap*nSamples;
for i = 1:neegfiles
    nImTest = round(size(structimages(i).file,1)/(nSamplesWithOverlap)-2);
    for u = 1:nSamples-nSamplesWithOverlap:nImTest*nSamplesWithOverlap
        overlap_images(i).file(1:nSamples,:,1+(u-1)/(nSamples-nSamplesWithOverlap)) = structimages(i).file(u:u+nSamples-1,:);
        overlap_images(i).label = structimages(i).label;
    end
end

im = [];
lab = [];
for i = 1:neegfiles
    im = cat(3,im,overlap_images(i).file);
    labels = repelem(labelToInt(overlap_images(i).label),size(overlap_images(i).file,3));
    lab = cat(2,lab,labels);
end

out.x = im;
out.y = lab;
end

function int = labelToInt(label)
    switch label
        case 'L'
            int = 1;
        case 'R'
            int = 2;
    end
end

function data = cutoff_eeg(data,fs)
limit = 6.4*60*fs;
if size(data,1) > limit
    data = data(1:limit,:);
end
end

function outStructArray = SortArrayofStruct( structArray, fieldName )
    if ( ~isempty(structArray) &&  length (structArray) > 0)
      [~,I] = sort(arrayfun (@(x) x.(fieldName), structArray)) ;
      outStructArray = structArray(I) ;        
    else 
        disp ('Array of struct is empty');
    end      
end
