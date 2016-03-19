function score = extractSentimentScore(string)
% e.g. abandoned_school [sentiment: -1.29]
tokens = strsplit(string, ' ');
score = str2double(tokens(2)); %caused by split returning empty first and last tokens