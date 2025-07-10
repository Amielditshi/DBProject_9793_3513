-- Calculates the total payments made to active content creators based on data from a contract table.
-- Returns a table with three columns: creator_id, creator_name, and total_payment.

CREATE OR REPLACE FUNCTION calculate_total_payments_for_active_creators()
RETURNS TABLE (
    creator_id INT,
    creator_name VARCHAR,
    total_payment NUMERIC
)
AS $$
DECLARE
    rec RECORD;   --rec is a generic variable to store rows from query
    total NUMERIC := 0;  -- result 
BEGIN
    FOR rec IN  --Iterates over every active creator in the content_creator table using an implicit cursor.
        SELECT creatorid, content_creatorfullname
        FROM content_creator
        WHERE isactive = true
    LOOP
        BEGIN   --Sums up the payments made to the current creator from the contract table
            SELECT COALESCE(SUM(payment), 0) --If no payments exist, defaults to 0 using COALESCE.
            INTO total  
            FROM contract
            WHERE creatorid = rec.creatorid;


            IF total > 100000 THEN
                RAISE NOTICE 'High-earning creator: % with total = %', rec.creatorid, total;
            END IF;

            -- Assigns the values for each column in the return table.
            creator_id := rec.creatorid;
            creator_name := rec.content_creatorfullname;
            total_payment := total;

            RETURN NEXT;

        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Error for creator ID %: %', rec.creatorid, SQLERRM;
                CONTINUE;
        END;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
