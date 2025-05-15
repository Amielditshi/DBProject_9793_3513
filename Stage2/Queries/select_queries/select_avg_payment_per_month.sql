SELECT
    CC.Content_CreatorFullName,
    EXTRACT(YEAR FROM C.StartDate) AS StartYear,
    EXTRACT(MONTH FROM C.StartDate) AS StartMonth,
    ROUND(AVG(C.Payment), 2) AS AvgPayment
FROM Contract C
JOIN Content_Creator CC ON C.CreatorID = CC.CreatorID
GROUP BY CC.Content_CreatorFullName, EXTRACT(YEAR FROM C.StartDate), EXTRACT(MONTH FROM C.StartDate)
ORDER BY AvgPayment DESC;