function [confusionMatrix, precision, recall, f_measure, accuracy] = evaluateModel(testDir, net)
% testDir = 'D:/DLSU/Masters/Term 2/CSC930M/Final Project/project_files/test';
% net = load('D:/DLSU/Masters/Term 2/CSC930M/Final Project/project_files/results/vsa-experiment/vsa.mat') ;
anpDir =  'D:/DLSU/Masters/Term 2/CSC930M/Final Project/project_files/final_anps.txt';
sentimentScores = readSentimentScores(anpDir);
anpFolders = dir(testDir);
confusionMatrix = zeros(3); %create 3x3 confusion matrix
nFolders = numel(anpFolders);
for i = 3:nFolders
    currAnpFolder = anpFolders(i);
    correctClass = getSentimentClass(sentimentScores(currAnpFolder.name));
    
    currAnpFolderDir = [testDir '/' currAnpFolder.name];
    anpImages = dir(currAnpFolderDir);
    nImages = numel(anpImages);
    
    disp(['Processing folder: ' currAnpFolder.name '(' num2str(correctClass) ')'])
    for j=3:nImages
        im = imread([currAnpFolderDir '/' anpImages(j).name]);
        im_ = resizeImg(im, 227); % not needed for now because it is assumed
%     that the test images are 227x227
        im_ = im2single(im_);
        im_ = im_ - net.imageMean;
%         im_ = 255 * im_;

        res = vl_simplenn(net, im_);
        scores = squeeze(gather(res(end).x)) ;
        [bestScore, best] = max(scores) ;
        confusionMatrix(correctClass, best) = confusionMatrix(correctClass, best) + 1;
        
%         disp(['Processed ' num2str(j) ' images'])
    end
end


precision = sum(confusionMatrix, 1);
recall = reshape(sum(confusionMatrix, 2), 1, 3);

for i=1:3
    precision(i) = confusionMatrix(i,i) / precision(i);
    recall(i) = confusionMatrix(i,i) / recall(i);
end

f_measure = 2 .* precision .* recall ./ (precision + recall);

accuracy = trace(confusionMatrix) / sum(sum(confusionMatrix));

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

% Calculate Precision and Recall here
  