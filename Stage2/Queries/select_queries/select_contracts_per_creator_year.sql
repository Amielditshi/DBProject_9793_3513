SELECT
    CC.Content_CreatorFullName,
    A.AgentFullName,
    EXTRACT(YEAR FROM C.StartDate) AS ContractYear,
    SUM(C.Payment) AS TotalPayments
FROM Contract C
JOIN Content_Creator CC ON C.CreatorID = CC.CreatorID
LEFT JOIN Agent A ON CC.AgentID = A.AgentID
WHERE C.StartDate >= CURRENT_DATE - INTERVAL '5 years'
GROUP BY CC.Content_CreatorFullName, A.AgentFullName, EXTRACT(YEAR FROM C.StartDate)
ORDER BY TotalPayments DESC;
