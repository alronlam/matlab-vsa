resizedDataDir = 'D:/DLSU/Masters/Term 2/CSC930M/Final Project/project_files/resized227';
testDir = 'D:/DLSU/Masters/Term 2/CSC930M/Final Project/project_files/test';
% resizedDataDir = testDir;
matDir = 'D:/DLSU/Masters/Term 2/CSC930M/Final Project/project_files/matfile.mat';
charsMatDir = 'D:/DLSU/Masters/Term 2/CSC930M/Final Project/project_files/charsdb.mat';

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
for i= 3:3%numel(anpFolders)
   anpFolder = anpFolders(i);   
   currAnpFolderDir = [resizedDataDir '/' anpFolder.name '/'];
   disp(['Processing folder number ' num2str(i) ': ' anpFolder.name])
%    disp(sentimentScores(anpFolder.name))
   anpImages = dir([currAnpFolderDir '*.jpg']);
   
%    Unused because it returns a cell array of size 120 x 1, instead of a
%    256x256x3xN
%    currImages = arrayfun(@(x) imread([currAnpFolderDir x.name]),anpImages, 'UniformOutput', false);

   %%%%% IMAGE DATA %%%%%
    for j=1:numel(anpImages)
      currImg = im2single(imread([currAnpFolderDir anpImages(j).name]));
      if j == 1
          currImages = currImg;
      else
          currImages = cat(4, currImages, currImg);
      end
    end
    % Append to the mat file
    try
        m.images = cat(4, m.images, currImages);
    catch exception
        m.images = currImages;
    end
    
    %%%%% LABELS %%%%%
    currLabels = getSentimentClass(sentimentScores(anpFolder.name)) * ones([1 numel(anpImages)]);
    try
        m.labels = cat(2, m.labels, currLabels);
    catch exception
        m.labels = currLabels;
    end
   
end