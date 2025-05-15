UPDATE Contract
SET Payment = Payment * 1.1
WHERE CreatorID IN (
    SELECT CreatorID
    FROM Content_Creator
    WHERE IsActive = TRUE
)
AND EXTRACT(YEAR FROM StartDate) <= EXTRACT(YEAR FROM CURRENT_DATE) - 5;