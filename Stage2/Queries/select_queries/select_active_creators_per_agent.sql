SELECT
    A.AgentFullName,
    COUNT(CC.CreatorID) AS ActiveCreators,
    AVG(DATE_PART('year', CURRENT_DATE) - DATE_PART('year', CC.JoinDate)) AS Avg_Years_With_Agent
FROM Agent A
JOIN Content_Creator CC ON A.AgentID = CC.AgentID
WHERE CC.IsActive = TRUE
GROUP BY A.AgentFullName
HAVING COUNT(CC.CreatorID) >= 2
   AND AVG(DATE_PART('year', CURRENT_DATE) - DATE_PART('year', CC.JoinDate)) >= 2
ORDER BY Avg_Years_With_Agent DESC;
