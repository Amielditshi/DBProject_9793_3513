-- This query retrieves the content creators who participated in productions 
-- that were released in the current year.
SELECT DISTINCT
    CC.Content_CreatorFullName,
    P.Title,
    P.ReleaseDate
FROM Content_Creator CC
JOIN Contract C ON CC.CreatorID = C.CreatorID
JOIN Production P ON C.ProductionID = P.ProductionID
WHERE EXTRACT(YEAR FROM P.ReleaseDate) = EXTRACT(YEAR FROM CURRENT_DATE);
