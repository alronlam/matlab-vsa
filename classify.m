net = load('results/vsa-experiment/vsa.mat') ;
% vl_simplenn_display(net) ;

im = imread('D:/DLSU/Masters/Term 2/CSC930M/Final Project/project_files/resized227/abandoned_asylum/8039979995_4047b90084.jpg');
im_ = resizeImg(im, 227);
im_ = im2single(im_);
% im_ = imresize(im_, net.normalization.imageSize(1:2)) ;
% im_ = im_ - net.normalization.averageImage ;

res = vl_simplenn(net, im_) ;
scores = squeeze(gather(res(end).x)) ;
disp(scores)
[bestScore, best] = max(scores) ;

figure(1) ; clf ; imagesc(im) ;
% title(sprintf('%s (%d), score %.3f',...
%   net.classes.description{best}, best, bestScore)) ;
title(sprintf('(%d), score %.4f',...
  best, bestScore)) ;