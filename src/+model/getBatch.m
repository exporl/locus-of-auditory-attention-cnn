function [images, labels] = getBatch(imdb, batch)
images = imdb.images.data(:,:,:,batch);
labels = imdb.images.labels(batch);
end