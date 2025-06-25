-- view from the content_creator database
-- This view shows each creator's agent, productions, role, remuneration, and audience feedback.
CREATE VIEW CreatorProductionSummary AS
SELECT
    c.CreatorID,
    c.Content_CreatorFullName,
    a.AgencyName,
    p.ProductionID,
    p.Title,
    p.ProductionType,
    p.Genre,
    ct.RoleContract,
    ct.Payment,
    fb.FeedbackRating
FROM Content_Creator c
LEFT JOIN Agent a ON c.AgentID = a.AgentID
LEFT JOIN Contract ct ON c.CreatorID = ct.CreatorID
LEFT JOIN Production p ON ct.ProductionID = p.ProductionID
LEFT JOIN Feedback fb ON fb.ProductionID = p.ProductionID;

--query 1: Average payments by gender
SELECT Genre, AVG(Payment) AS AveragePayment
FROM CreatorProductionSummary
GROUP BY Genre
ORDER BY AveragePayment ASC;


--query 2: All creators with an average production rating > 4.5
SELECT DISTINCT Content_CreatorFullName, Title, FeedbackRating
FROM CreatorProductionSummary
WHERE FeedbackRating > 4.5
ORDER BY FeedbackRating ASC;
