function anp = extractANP(string)
% e.g. abandoned_school [sentiment: -1.29]
tokens = strsplit(string, ' ');
anp = char(tokens(1));