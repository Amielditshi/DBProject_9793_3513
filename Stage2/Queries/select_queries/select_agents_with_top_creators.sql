SELECT
    A.AgentFullName,
    COUNT(DISTINCT CC.CreatorID) AS TopCreatorsCount
FROM Agent A
JOIN Content_Creator CC ON A.AgentID = CC.AgentID
JOIN Contract C ON CC.CreatorID = C.CreatorID
JOIN Production P ON C.ProductionID = P.ProductionID
JOIN Feedback F ON P.ProductionID = F.ProductionID
WHERE EXTRACT(YEAR FROM F.FeedbackDate) >= EXTRACT(YEAR FROM CURRENT_DATE) - 5
GROUP BY A.AgentFullName
HAVING AVG(F.FeedbackRating) > 8
ORDER BY TopCreatorsCount DESC;