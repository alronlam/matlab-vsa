function [confusionMatrix, precision, recall, f_measure, accuracy, summaryString] = evaluateModel(testDir, net)

% testDir = 'luminance_4500_1500/test';
% net = load('results/New Architectural Tests/vsa-experiment-Simple CNN with Relu - Luminance/vsa.mat') ;
try
    net.imageMean;
catch exception
   disp('Warning, there is no image mean available') 
end
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
%         im_ = resizeImg(im, 227); % not needed for now because it is assumed
%     that the test images are 227x227
        im_ = im2single(im);
        try
            im_ = im_ - net.imageMean;
        catch exception
           disp('No image mean') 
        end
        im_ = 255 * im_;

        try
            res = vl_simplenn(net, im_);
        catch
            im_ = repmat(im_,[1 1 3]);
            res = vl_simplenn(net, im_);
        end
        
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


% f_measure = harmean(cat(1, precision, recall), 1);
f_measure = 2 * ( precision .* recall ) ./ (precision + recall);

accuracy = trace(confusionMatrix) / sum(sum(confusionMatrix));



summaryString = ['Accuracy: ' num2str(accuracy)];

s = sprintf([repmat('%d ',1,size(confusionMatrix,2)) '\n'],confusionMatrix');
summaryString = [summaryString char(10) sprintf('Confusion Matrix\n%s', s)];

summaryString = [summaryString sprintf('Precision, Recall, F-Measure:\n') ...
    sprintf('%0.4f\t%0.4f\t%0.4f\n', ...
                        precision, recall, f_measure)];

                    disp(summaryString);
                    
% summaryString = ['Confusion Matrix' char(10) mat2str(confusionMatrix) ...
%     char(10) 'Precision: '  num2str(precision) ...
%     char(10) 'Recall: ' num2str(recall) ...
%     char(10) 'F-Measure: ' num2str(f_measure) ...
%     char(10) 'Accuracy: ' num2str(accuracy) ...
%     ];

% disp('Confusion Matrix')
% disp(confusionMatrix)
% disp('Precision')
% disp(precision)
% disp('Recall')
% disp(recall)
% disp('F-Measure')
% disp(f_measure)
% disp('Accuracy')
% disp(accuracy)
% Calculate Precision and Recall here
  