function resizedImg = resizeImg(img, targetSize)
    [height, width, depth] = size(img);
    scale = max(targetSize / width, targetSize/ height); % scale according to the smaller dimension
    scaledImg = imresize(img, scale);
    
    [scaledHeight, scaledWidth, depth ] = size(scaledImg);
    
    startX = double(floor((scaledWidth - targetSize) / 2));
    startY = double(floor((scaledHeight - targetSize) / 2));
    resizedImg = imcrop(scaledImg, [startX startY targetSize targetSize]); % this might not be exact, so resize again to be exact
    resizedImg = imcrop(resizedImg, [0 0 targetSize targetSize]); % this might not be exact, so crop again to be exact
    
   