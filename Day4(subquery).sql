select Max(Scores)
as SecondHighestScore
from [dbo].[Table_Score] 
where Scores < (select Max(Scores) from [dbo].[Table_Score] )


SELECT TOP 1 Scores AS SecondHighestScore
FROM (
    SELECT DISTINCT TOP 2 Scores
    FROM [dbo].[Table_Score]
    ORDER BY Scores DESC
) t
ORDER BY Scores ASC;


