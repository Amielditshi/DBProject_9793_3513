UPDATE Production
SET ProductionRating = ProductionRating * 0.9
WHERE ProductionID IN (
    SELECT P.ProductionID
    FROM Production P
    JOIN Feedback F ON P.ProductionID = F.ProductionID
    WHERE EXTRACT(YEAR FROM P.ReleaseDate) <= EXTRACT(YEAR FROM CURRENT_DATE) - 10
    GROUP BY P.ProductionID
    HAVING AVG(F.FeedbackRating) < 6
);