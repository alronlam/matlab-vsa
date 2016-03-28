function vsaTrain(varargin)

setup;

% -------------------------------------------------------------------------
% Part 4.1: prepare the data
% -------------------------------------------------------------------------

% Load character dataset
imdb = load('matfile-4500-1500.mat') ;

% vgg_net = load('imagenet-vgg-f.mat');
% vl_displaysimplenn(vgg_net);

descriptions = { 'Simple CNN with Relu' };
nets = [  initializeSimpleCNNWRelu()];
% descriptions = {'Simple CNN With 3 FCs'; 'Simple CNN with 4 FCs'; 'Simple CNN w/ Relu'; 'New CNN with less Relu'};
% nets = [initializeSimpleCNNWithMoreFC(), initializeSimpleCNNWithEvenMoreFC()...
%         initializeSimpleCNNWRelu(), initializeNewCNNWoRelu()];
    
for i=1:numel(nets)
% -------------------------------------------------------------------------
% Part 4.2: initialize a CNN architecture
% -------------------------------------------------------------------------
net = nets(i);
% net = initializeSimpleCNN() ;
% net = initializeNewCNN() ;

% -------------------------------------------------------------------------
% Part 4.3: train and evaluate the CNN
% -------------------------------------------------------------------------

trainOpts.batchSize = 100 ;
trainOpts.numEpochs = 15 ;
trainOpts.continue = true ;
trainOpts.useGpu = false ;
trainOpts.learningRate = 0.001 ;
trainOpts.expDir = ['results/New Architectural Tests/vsa-experiment-' char(descriptions(i))];
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

end