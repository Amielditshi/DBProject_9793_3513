-- This query fetches productions that have an average feedback rating above 8.0 
-- and a production rating higher than 7.5.
SELECT
    P.Title,
    P.ProductionRating,
    AVG(F.FeedbackRating) AS AverageFeedback
FROM Production P
JOIN Feedback F ON P.ProductionID = F.ProductionID
GROUP BY P.Title, P.ProductionRating
HAVING AVG(F.FeedbackRating) > 8.0 AND P.ProductionRating > 7.5
ORDER BY AverageFeedback DESC;
