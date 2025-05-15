-- This query calculates the number of active content creators represented by each agent.
SELECT
    A.AgentFullName,
    COUNT(CC.CreatorID) AS ActiveCreators
FROM Agent A
JOIN Content_Creator CC ON A.AgentID = CC.AgentID
WHERE CC.IsActive = TRUE
GROUP BY A.AgentFullName
ORDER BY ActiveCreators DESC;
