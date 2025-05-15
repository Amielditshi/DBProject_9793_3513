DELETE FROM Feedback
WHERE EXTRACT(MONTH FROM FeedbackDate) = 8
AND FeedbackRating < 4;