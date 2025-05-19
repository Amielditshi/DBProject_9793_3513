SELECT
    CC.Content_CreatorFullName,
    CC.JoinDate,
    A.AwardName,
    A.AwardYear
FROM Content_Creator CC
JOIN Award A ON CC.CreatorID = A.CreatorID
WHERE CC.IsActive = TRUE
  AND NOT EXISTS (
    SELECT 1
    FROM Contract C
    WHERE C.CreatorID = CC.CreatorID
      AND C.EndDate >= (CURRENT_DATE - INTERVAL '3 years')
)
  AND A.AwardYear >= DATE '2015-01-01'
ORDER BY A.AwardYear DESC;
