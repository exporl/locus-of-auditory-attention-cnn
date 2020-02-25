function epochId = extractEpochId(path)
[~,filename,~] = fileparts(path);
tmp = split(filename,'-');
epochId = str2double(tmp{3});
end