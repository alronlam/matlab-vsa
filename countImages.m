function count = countImages(dataDir)
count = 0;
anpFolders = dir(dataDir); % assumed to be all folders
for i= 1:numel(anpFolders)
   anpImages = dir([dataDir '/' anpFolders(i).name '/' '*.jpg']);
   count = count + numel(anpImages);
end


   

