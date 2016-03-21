function vsaTrain(varargin)

setup;

% -------------------------------------------------------------------------
% Part 4.1: prepare the data
% -------------------------------------------------------------------------

% Load character dataset
imdb = load('matfile-1525.mat') ;


% -------------------------------------------------------------------------
% Part 4.2: initialize a CNN architecture
% -------------------------------------------------------------------------

net = initializeSimpleCNN2() ;
% net = initializeNewCNN() ;

% -------------------------------------------------------------------------
% Part 4.3: train and evaluate the CNN
% -------------------------------------------------------------------------

trainOpts.batchSize = 100 ;
trainOpts.numEpochs = 30 ;
trainOpts.continue = true ;
trainOpts.useGpu = false ;
trainOpts.learningRate = 0.001 ;
trainOpts.expDir = 'results/vsa-experiment' ;
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
% net.imageMean = imageMean ;
save('results/vsa-experiment/vsa.mat', '-struct', 'net') ;

% Perform evaluation
testDir = 'D:/DLSU/Masters/Term 2/CSC930M/Final Project/project_files/dataset_6000/test';
net = load('D:/DLSU/Masters/Term 2/CSC930M/Final Project/project_files/results/vsa-experiment/vsa.mat') ;
[confusionMatrix, precision, recall, f_measure, accuracy] = evaluateModel(testDir, net);
disp('Confusion Matrix')
disp(confusionMatrix)
disp('Precision')
disp(precision)
disp('Recall')
disp(recall)
disp('F-Measure')
disp(f_measure)
disp('Accuracy')
disp(accuracy)

