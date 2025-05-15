BEGIN;

-- בדיקה
SELECT * FROM Feedback
WHERE FeedbackRating < 2
AND FeedbackDate < CURRENT_DATE - INTERVAL '3 years';

-- ביצוע השינוי
DELETE FROM Feedback
WHERE FeedbackRating < 2
AND FeedbackDate < CURRENT_DATE - INTERVAL '3 years';

--בדיקה אחרי השינוי ולפני השינוי 
SELECT * FROM Feedback
WHERE FeedbackRating < 2
AND FeedbackDate < CURRENT_DATE - INTERVAL '3 years';

-- ביטול
ROLLBACK;

-- בדיקה אחרי הביטול
SELECT * FROM Feedback
WHERE FeedbackRating < 2
AND FeedbackDate < CURRENT_DATE - INTERVAL '3 years';
