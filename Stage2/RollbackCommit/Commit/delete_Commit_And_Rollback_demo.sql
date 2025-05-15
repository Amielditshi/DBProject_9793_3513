-- Delete_Unused_Agents.sql
-- מטרה: מחיקת סוכנים שלא מקושרים לאף יוצר תוכן, עם אפשרות ל-ROLLBACK או COMMIT

BEGIN;

-- שלב 1: בדיקת אילו סוכנים אינם מקושרים ליוצר תוכן
-- מציג את הסוכנים שאין עליהם הפניות בטבלת Content_Creator
SELECT * FROM Agent
WHERE AgentID NOT IN (
    SELECT DISTINCT AgentID FROM Content_Creator
    WHERE AgentID IS NOT NULL
);


-- שלב 2: מחיקת הסוכנים הלא משויכים
-- מבצע מחיקה של סוכנים שלא מופיעים ב-Content_Creator
DELETE FROM Agent
WHERE AgentID NOT IN (
    SELECT DISTINCT AgentID FROM Content_Creator
    WHERE AgentID IS NOT NULL
);


SELECT * FROM Agent
WHERE AgentID NOT IN (
    SELECT DISTINCT AgentID FROM Content_Creator
    WHERE AgentID IS NOT NULL
-- בשלב זה ניתן לבצע אחת מהפעולות הבאות (הסר תגובה רק מאחת מהן כדי להפעיל אותה):

COMMIT;    -- אישור השינויים ושמירת המחיקה באופן קבוע

ROLLBACK;  -- ביטול המחיקה, החזרת הנתונים לקדמותם


SELECT * FROM Agent
WHERE AgentID NOT IN (
    SELECT DISTINCT AgentID FROM Content_Creator
    WHERE AgentID IS NOT NULL
);
