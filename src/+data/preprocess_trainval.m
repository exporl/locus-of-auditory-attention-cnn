function out = preprocess_trainval(trialIds,windowSize,subjectId)
p.targetSampleRate = 128; % Hz
p.lowpass = 32; % Hz
p.highpass = 1;  % Hz

out = struct();
out.fs = p.targetSampleRate;
out.lowpass = p.lowpass;
out.highpass = p.highpass;
out.windowSize = windowSize;
out.subjectId = subjectId;

baseDir = utils.dataDir('AAD2015_128hz');
file = fullfile(baseDir,sprintf('S%i.mat',subjectId));

%% Load the EEG data
file = load(file);
files = file.trials(trialIds);
for iTrial = 1:numel(trialIds)
    eegfiles(iTrial).trial = files{iTrial};
end
neegfiles = length(eegfiles);

% also make the EEG files of the same length
for i = 1:neegfiles
    eegfiles(i).trial.RawData.EegData = cutoff_eeg(eegfiles(i).trial.RawData.EegData,out.fs);
end
clear files;

%% Apply a BPF
bpFilter = data.constructBpFilter(p);
for i = 1:neegfiles
    eegfiles(i).trial.RawData.EegData = filtfilt(bpFilter.numerator,1,double(eegfiles(i).trial.RawData.EegData));
end

for i = 1:neegfiles
    images(i).file = eegfiles(i).trial.RawData.EegData;
    images(i).label = eegfiles(i).trial.attended_ear;
end
clear eegfiles;

%% Take apart the testing and validation data
for i = 1:neegfiles
    N = size(images(i).file,1);
    Nval = round(0.15*N); % 15% validation data
    images(i).file_val = images(i).file(end-Nval+1:end,:);
    images(i).file = images(i).file(1:end-Nval,:);
end

% Sort so all L labels come before R
structimages = SortArrayofStruct(images,'label');

% Create overlapping images (50% overlap)
nSamples = windowSize*p.targetSampleRate; % number of samples in a window
overlap = 1/2;
nSamplesWithOverlap = overlap*nSamples;
for i = 1:neegfiles
    nImTrain = round(size(structimages(i).file,1)/(nSamplesWithOverlap)-2);
    nImVal = round(size(structimages(i).file_val,1)/(nSamplesWithOverlap)-2);
    for u = 1:nSamples-nSamplesWithOverlap:nImTrain*nSamplesWithOverlap
        overlap_images(i).file(1:nSamples,:,1+(u-1)/(nSamples-nSamplesWithOverlap)) = structimages(i).file(u:u+nSamples-1,:);
    end
    for u = 1:nSamples-nSamplesWithOverlap:nImVal*nSamplesWithOverlap
        overlap_images(i).file_val(1:nSamples,:,1+(u-1)/(nSamples-nSamplesWithOverlap)) = structimages(i).file_val(u:u+nSamples-1,:);
    end
end

im = [];
im_val = [];
for i = 1:neegfiles
    im = cat(3,im,overlap_images(i).file);
    im_val = cat(3,im_val,overlap_images(i).file_val);
end

%create labels
imdb.labels(:,1:size(im,3)/2) = 0; %left
imdb.labels(:,1+size(im,3)/2:size(im,3)) = 1; %right
imdb.labels_val(:,1:size(im_val,3)/2) = 0; %left
imdb.labels_val(:,1+size(im_val,3)/2:size(im_val,3)) = 1; %right

imdb.images = im;
imdb.images_val = im_val;

out.xtr = imdb.images;
out.ytr = 1+imdb.labels;
out.xvl = imdb.images_val;
out.yvl = 1+imdb.labels_val;
end

function data = cutoff_eeg(data,fs)
limit = 6.45*60*fs;
if size(data,1) > limit
    data = data(1:limit,:);
end
if size(data,1) < 2.5*60*fs
    data = data(1:15360,:);
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