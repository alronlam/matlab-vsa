% resizedDataDir = 'D:/DLSU/Masters/Term 2/CSC930M/Final Project/project_files/resized227';
resizedDataDir = 'D:/DLSU/Masters/Term 2/CSC930M/Final Project/project_files/test';
matDir = 'D:/DLSU/Masters/Term 2/CSC930M/Final Project/project_files/matfile.mat';

warning('off', 'MATLAB:REGEXP:ErrorLiteral');
anpDir =  'D:/DLSU/Masters/Term 2/CSC930M/Final Project/project_files/final_anps.txt';
sentimentScores = readSentimentScores(anpDir);
% size is 487,261
% imgCount = countImages(resizedDataDir);
% disp(['Total image count: ' num2str(imgCount)])
% images = zeros(256,256,imgCount);
% size(images)
% if ~exist(matfile)
%     save matfile -v7.3
% end
m = matfile(matDir, 'Writable', true);

% testm = load(charsMatDir);
% size(testm.images.data)
% testm = load(matDir);
% size(testm.images)
% size(cell2mat(testm.images))


anpFolders = dir(resizedDataDir); % assumed to be all folders

% create training/testing partition
startFolder = 3;
stepFolder = 1;
lastFolderToProcess = numel(anpFolders);
limitPerFolder = 10000000;
percentageValidate = 0.1;

% numTrainingPerFolder = limitPerFolder-numValidatePerFolder;
% basePattern = zeros(1, limitPerFolder);
% for i=1:limitPerFolder
%     if i <= numTrainingPerFolder
%         basePattern(i) = 1;
%     else
%         basePattern(i) = 2;
%     end
% end

successfullyProcessedFolders = 0;
% Construct images and labels
for i= startFolder:stepFolder:lastFolderToProcess
   anpFolder = anpFolders(i);   
   currAnpFolderDir = [resizedDataDir '/' anpFolder.name '/'];
   disp(['Processing folder number ' num2str(i) ': ' anpFolder.name])
   anpImages = dir([currAnpFolderDir '*.jpg']);
   imageLimitForCurrFolder = min(limitPerFolder, numel(anpImages));
%    disp(sentimentScores(anpFolder.name))
   
%    Unused because it returns a cell array of size 120 x 1, instead of a
%    256x256x3xN
%    currImages = arrayfun(@(x) imread([currAnpFolderDir x.name]),anpImages, 'UniformOutput', false);

    %%%%% LABELS %%%%%
    try
        currLabels = getSentimentClass(sentimentScores(anpFolder.name)) * ones([1 imageLimitForCurrFolder]);
        try
            m.labels = cat(2, m.labels, currLabels);
        catch exception
            m.labels = currLabels;
        end
    catch exception
        disp(getReport(exception))
        continue; % skip this folder because there is no available sentiment score
    end

   %%%%% IMAGE DATA %%%%%
    for j=1:imageLimitForCurrFolder
      rawImg = imread([currAnpFolderDir anpImages(j).name]);
      currImg = im2single(rawImg);
      
      if j == 1
          currImages = currImg;
      else
          try
            currImages = cat(4, currImages, currImg);
          catch exception % Image is probably gray scale, thus lacking a third dimension
              rgbImage = repmat(currImg,[1 1 3]);
%               rgbImage = cat(3,grayImage,grayImage,grayImage);
%               %alternative option
              currImages = cat(4, currImages, rgbImage);
          end
      end
      disp(['Finished image: ' num2str(j)]);
    end
    % Append to the mat file
    try
        m.images = cat(4, m.images, currImages);
    catch exception
        m.images = currImages;
    end
    
    %%%% Partitions %%%%
    numValidation = floor(imageLimitForCurrFolder * percentageValidate);
    numTraining = imageLimitForCurrFolder - numValidation;
    currPartitions = cat(2, ones(1, numTraining), 2*ones(1, numValidation));
    try
        m.partitions = cat(2, m.partitions, currPartitions);
    catch exception
        m.partitions = currPartitions;
    end
    
    successfullyProcessedFolders = successfullyProcessedFolders + 1;
end
disp('Successfully processed:')
disp(successfullyProcessedFolders)
% partitions = repmat(basePattern, [1 successfullyProcessedFolders]);
% m.partitions = partitions;