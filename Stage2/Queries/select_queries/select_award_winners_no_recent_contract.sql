SELECT DISTINCT
    CC.Content_CreatorFullName,
    CC.JoinDate,
    A.AwardName,
    A.AwardYear
FROM Content_Creator CC
JOIN Award A ON CC.CreatorID = A.CreatorID
WHERE NOT EXISTS (
    SELECT 1
    FROM Contract C
    WHERE C.CreatorID = CC.CreatorID
      AND EXTRACT(YEAR FROM C.EndDate) >= EXTRACT(YEAR FROM CURRENT_DATE) - 3
)
ORDER BY A.AwardYear DESC;
