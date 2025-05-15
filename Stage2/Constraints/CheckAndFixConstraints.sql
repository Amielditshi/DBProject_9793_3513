------------------------------------------------------------
-- אילוץ 1: NOT NULL על Agent.Email
------------------------------------------------------------

-- בדיקת ערכים NULL
SELECT * FROM Agent WHERE Email IS NULL;

-- עדכון לערך ברירת מחדל
UPDATE Agent
SET Email = 'default@email.com'
WHERE Email IS NULL;

-- הוספת האילוץ
ALTER TABLE Agent
ALTER COLUMN Email SET NOT NULL;



------------------------------------------------------------
-- אילוץ 2: CHECK על Production.ProductionRating בין 0 ל-10
------------------------------------------------------------

-- בדיקת ערכים מחוץ לתחום
SELECT * FROM Production WHERE ProductionRating < 0 OR ProductionRating > 10;

-- עדכון לערך תקין
UPDATE Production
SET ProductionRating = 5.0
WHERE ProductionRating < 0 OR ProductionRating > 10;

-- הוספת האילוץ
ALTER TABLE Production
ADD CONSTRAINT chk_ProductionRating
CHECK (ProductionRating >= 0 AND ProductionRating <= 10);



------------------------------------------------------------
-- אילוץ 3: DEFAULT על Feedback.FeedbackRating
------------------------------------------------------------

-- בדיקת ערכים ריקים
SELECT * FROM Feedback WHERE FeedbackRating IS NULL;

-- עדכון לערך ברירת מחדל
UPDATE Feedback
SET FeedbackRating = 5.0
WHERE FeedbackRating IS NULL;

-- הוספת ברירת מחדל
ALTER TABLE Feedback
ALTER COLUMN FeedbackRating SET DEFAULT 5.0;



------------------------------------------------------------
-- אילוץ 4: CHECK על FeedbackRating בין 1 ל-10
------------------------------------------------------------

-- בדיקת ערכים שיפרו את האילוץ
SELECT * FROM Feedback WHERE FeedbackRating < 1 OR FeedbackRating > 10;

-- עדכון לערך ברירת מחדל
UPDATE Feedback
SET FeedbackRating = 5.0
WHERE FeedbackRating < 1 OR FeedbackRating > 10;

-- הוספת האילוץ
ALTER TABLE Feedback
ADD CONSTRAINT chk_FeedbackRating
CHECK (FeedbackRating >= 1 AND FeedbackRating <= 10);



------------------------------------------------------------
-- אילוץ 5: DEFAULT על Feedback.FeedbackDate
------------------------------------------------------------

-- בדיקת ערכים ריקים
SELECT * FROM Feedback WHERE FeedbackDate IS NULL;

-- עדכון לתאריך היום
UPDATE Feedback
SET FeedbackDate = CURRENT_DATE
WHERE FeedbackDate IS NULL;

-- הוספת ברירת מחדל
ALTER TABLE Feedback
ALTER COLUMN FeedbackDate SET DEFAULT CURRENT_DATE;



------------------------------------------------------------
-- אילוץ 6: CHECK על Contract.Payment שיהיה חיובי
------------------------------------------------------------

-- בדיקת ערכים שליליים
SELECT * FROM Contract WHERE Payment < 0;

-- עדכון לאפס
UPDATE Contract
SET Payment = 0
WHERE Payment < 0;

-- הוספת האילוץ
ALTER TABLE Contract
ADD CONSTRAINT chk_PaymentPositive
CHECK (Payment >= 0);



------------------------------------------------------------
-- אילוץ 7: CHECK על Contract.EndDate שיהיה אחרי StartDate
------------------------------------------------------------

-- בדיקת תאריכים לא תקינים
SELECT * FROM Contract WHERE EndDate <= StartDate;

-- עדכון ל-30 יום אחרי התחלה
UPDATE Contract
SET EndDate = StartDate + INTERVAL '30 days'
WHERE EndDate <= StartDate;

-- הוספת האילוץ
ALTER TABLE Contract
ADD CONSTRAINT chk_ContractDates
CHECK (EndDate > StartDate);



------------------------------------------------------------
-- אילוץ 8: CHECK על Award.AwardYear בין 1900 להיום
------------------------------------------------------------

-- בדיקת ערכים לא תקינים
SELECT * FROM Award WHERE AwardYear < '1900-01-01' OR AwardYear > CURRENT_DATE;

-- עדכון לערך ברירת מחדל
UPDATE Award
SET AwardYear = CURRENT_DATE
WHERE AwardYear < '1900-01-01' OR AwardYear > CURRENT_DATE;

-- הוספת האילוץ
ALTER TABLE Award
ADD CONSTRAINT chk_AwardYear
CHECK (AwardYear BETWEEN '1900-01-01' AND CURRENT_DATE);
