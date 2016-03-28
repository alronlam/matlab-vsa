% --------------------------------------------------------------------
function [im, labels] = getBatch(imdb, batch)
% --------------------------------------------------------------------
im = 255 * imdb.images(:,:,:,batch) ;
% im = 256 * reshape(im, 32, 32, 1, []) ;
labels = imdb.labels(1,batch) ;
