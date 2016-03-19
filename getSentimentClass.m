function class = getSentimentClass(score)

if score >= 2/3
    class = 3;
elseif score > -2/3
    class = 2;
else
    class = 1;
end
