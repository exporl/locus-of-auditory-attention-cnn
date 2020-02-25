function [net,opts,imdb] = init(x,y,spl)
opts.networkType = 'simplenn';

net = model.constructModel(size(x));

imdb.images.set = zeros(size(spl.Tr_Ind,1),1);
imdb.images.set(spl.Tr_Ind) = 1; %train
imdb.images.set(spl.Ts_Ind) = 2; %validation
imdb.images.data = single(x);  % matconvnet assumes data to be single floats

imdb.images.labels = double(y);

imdb.meta.classes = {'c1','c2'};
net.meta.classes = imdb.meta.classes;
imdb.meta.sets = {'train','val'};
end