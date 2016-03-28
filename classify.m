net = load('results/New Architectural Tests/vsa-experiment-Simple CNN With 3 FCs/vsa.mat') ;
whos net
vl_simplenn_display(net) ;

im = imread('D:/DLSU/Masters/Term 2/CSC930M/Final Project/project_files/resized227/abandoned_cemetery/257001412_fc7e01b5ea.jpg');
im_ = resizeImg(im, 227);
im_ = im2single(im_);
im_ = im_ - net.imageMean;
% im_ = imresize(im_, net.normalization.imageSize(1:2)) ;
% im_ = im_ - net.normalization.averageImage ;

res = vl_simplenn(net, im_) ;
scores = squeeze(gather(res(end).x)) ;
disp(scores)
[bestScore, best] = max(scores) ;

figure(1) ; clf ; imagesc(im) ;
descriptions = {'negative', 'neutral', 'positive'};
title(sprintf('%s (%d), score %.4f',...
  descriptions{best}, best, bestScore)) ;
% title(sprintf('(%d), score %.4f',...
%   best, bestScore)) ;