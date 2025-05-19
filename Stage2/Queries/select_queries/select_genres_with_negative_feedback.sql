SELECT
    P.Genre,
    COUNT(F.FeedbackID) AS Negative_Feedback_Count,
    AVG(F.FeedbackRating) AS Avg_Negative_Rating
FROM Production P
JOIN Feedback F ON P.ProductionID = F.ProductionID
WHERE F.FeedbackRating <= 6 
GROUP BY P.Genre
HAVING COUNT(F.FeedbackID) >= 3
ORDER BY Avg_Negative_Rating ASC;
