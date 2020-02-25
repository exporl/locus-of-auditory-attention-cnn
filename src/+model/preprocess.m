function [x,y] = preprocess_nomwf(x,y)
x = permute(x,[1 2 4 3]);
y = permute(y,[1 2 4 3]);
end