-- This query lists agents who represent multiple active content creators,
-- and shows how many active creators each agent represents.
SELECT
    A.AgentFullName,
    COUNT(CC.CreatorID) AS ActiveCreators
FROM Agent A
JOIN Content_Creator CC ON A.AgentID = CC.AgentID
WHERE CC.IsActive = TRUE
GROUP BY A.AgentFullName
ORDER BY ActiveCreators DESC;
