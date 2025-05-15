-- This query fetches productions that received negative feedback (rating of 6 or lower), 
-- along with feedback details such as rating, comment, and date.
SELECT
    P.Title,
    F.FeedbackRating,
    F.FeedbackComment,
    F.FeedbackDate
FROM Production P
JOIN Feedback F ON P.ProductionID = F.ProductionID
WHERE F.FeedbackRating <= 6
ORDER BY F.FeedbackDate DESC;
