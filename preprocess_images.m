dataDir = 'D:/DLSU/Masters/Term 2/CSC930M/Final Project/project_files/bi_concepts1553';
resizedDataDir = 'D:/DLSU/Masters/Term 2/CSC930M/Final Project/project_files/resized227';
if ~exist(resizedDataDir, 'dir')
    mkdir(resizedDataDir);
end

anpFolders = dir(dataDir); % assumed to be all folders
for i= 1:numel(anpFolders)
   anpFolder = anpFolders(i);   
   currAnpFolderDir = [dataDir '/' anpFolder.name '/'];
   resizedAnpFolderDir = [resizedDataDir '/' anpFolder.name '/'];
   disp(['Processing folder number ' num2str(i)])
   if ~exist(resizedAnpFolderDir, 'dir')
   
       mkdir(resizedAnpFolderDir);
       anpImages = dir([currAnpFolderDir '*.jpg']);

       disp(['Processing folder ' anpFolder.name])

       for j=1:numel(anpImages)
           try
               imgFile = imread([currAnpFolderDir anpImages(j).name]);
               resizedImg = resizeImg(imgFile, 227);
               imwrite(resizedImg, [resizedAnpFolderDir anpImages(j).name]);
           catch exception
               disp(getReport(exception))
           end
       end
   end
end

   

