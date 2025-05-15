SELECT
    P.Title,
    P.ReleaseDate,
    P.ProductionRating,
    ROUND(AVG(F.FeedbackRating), 2) AS AvgFeedback
FROM Production P
JOIN Feedback F ON P.ProductionID = F.ProductionID
WHERE EXTRACT(MONTH FROM P.ReleaseDate) BETWEEN 6 AND 8
  AND P.ProductionRating > 8
GROUP BY P.Title, P.ReleaseDate, P.ProductionRating
ORDER BY AvgFeedback DESC;