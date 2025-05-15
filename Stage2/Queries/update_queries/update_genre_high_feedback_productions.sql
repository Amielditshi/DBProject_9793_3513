UPDATE Production
SET Genre = 'על טבעי'
WHERE ProductionID IN (
    SELECT P.ProductionID
    FROM Production P
    JOIN Feedback F ON P.ProductionID = F.ProductionID
    GROUP BY P.ProductionID
    HAVING AVG(F.FeedbackRating) > 5
);