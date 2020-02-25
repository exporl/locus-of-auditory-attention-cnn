function out = getTestTrialIds(stories)
if ~iscell(stories)
    stories = {stories};
end
out = [];
for story = stories
    story = story{1}; %#ok<FXSET>
    trialIds = getTestTrialIdsSingleStory(story);
    out = [out trialIds]; %#ok<AGROW>
end
end

function trialIds = getTestTrialIdsSingleStory(story)
switch story
    case 'milan'
        trialIds = [1 2];
    case 'maarten'
        trialIds = [3 4];
    case 'bianca'
        trialIds = [5 6];
    case 'eline'
        trialIds = [7 8];
    otherwise
        error('unknown story');
end
end