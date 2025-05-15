DELETE FROM Feedback
WHERE FeedbackRating < 2
AND FeedbackDate < CURRENT_DATE - INTERVAL '3 years';