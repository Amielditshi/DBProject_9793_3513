SELECT
    CC.Content_CreatorFullName,
    A.AgentFullName,
    EXTRACT(YEAR FROM C.StartDate) AS ContractYear,
    COUNT(C.ContractID) AS NumContracts,
    SUM(C.Payment) AS TotalPayments
FROM Contract C
JOIN Content_Creator CC ON C.CreatorID = CC.CreatorID
LEFT JOIN Agent A ON CC.AgentID = A.AgentID
GROUP BY CC.Content_CreatorFullName, A.AgentFullName, EXTRACT(YEAR FROM C.StartDate)
ORDER BY TotalPayments DESC;