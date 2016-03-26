function vsaTrain(varargin)

setup;

% -------------------------------------------------------------------------
% Part 4.1: prepare the data
% -------------------------------------------------------------------------

% Load character dataset
imdb = load('matfile-4500-1500.mat') ;


% -------------------------------------------------------------------------
% Part 4.2: initialize a CNN architecture
% -------------------------------------------------------------------------

net = initializeSimpleCNN() ;
% net = initializeNewCNN() ;

% -------------------------------------------------------------------------
% Part 4.3: train and evaluate the CNN
% -------------------------------------------------------------------------

trainOpts.batchSize = 100 ;
trainOpts.numEpochs = 30 ;
trainOpts.continue = true ;
trainOpts.useGpu = false ;
trainOpts.learningRate = 0.001 ;
trainOpts.expDir = 'results/Architectural Tests/vsa-experiment-4500-1500-oldarch-less-epochs';
trainOpts = vl_argparse(trainOpts, varargin);

% Take the average image out
imageMean = mean(imdb.images(:)) ;
imdb.images = imdb.images - imageMean ;
net.imageMean = imageMean;

% Convert to a GPU array if needed
if trainOpts.useGpu
  imdb.images.data = gpuArray(imdb.images.data) ;
end

% Call training function in MatConvNet
[net,info] = cnn_train(net, imdb, @getBatch, trainOpts) ;

% Move the CNN back to the CPU if it was trained on the GPU
if trainOpts.useGpu
  net = vl_simplenn_move(net, 'cpu') ;
end

% Save the result for later use
net.layers(end) = [] ;
save([trainOpts.expDir '/vsa.mat'], '-struct', 'net') ;

% Perform evaluation
testDir = 'D:/DLSU/Masters/Term 2/CSC930M/Final Project/project_files/dataset_4500_1500/test';
[confusionMatrix, precision, recall, f_measure, accuracy, summaryString] = evaluateModel(testDir, net);
disp(summaryString)

metricsFile = fopen([trainOpts.expDir '/metrics.txt'], 'w');
fprintf(metricsFile, summaryString);

