-- This query calculates the average production rating for each production type 
-- and the release year.
SELECT
    ProductionType,
    EXTRACT(YEAR FROM ReleaseDate) AS ReleaseYear,
    AVG(ProductionRating) AS AverageRating
FROM Production
GROUP BY ProductionType, EXTRACT(YEAR FROM ReleaseDate)
ORDER BY AverageRating DESC;
