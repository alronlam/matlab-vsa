function scoreMap = readSentimentScores(fileDir)

scoreMap = containers.Map('KeyType','char','ValueType', 'double');

fileID = fopen(fileDir, 'r');

tline = fgetl(fileID);
while ischar(tline)
    anp = extractANP(tline);
    score = extractSentimentScore(tline);
    scoreMap(anp) = score;
    tline = fgetl(fileID);
end

fclose(fileID);
% size(scoreMap)
% disp(scoreMap('beautiful_flower'))

