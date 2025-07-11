-- Main Program 1: 
-- This script analyzes high-paying active content creators and then deletes old feedbacks older than 5 years.
-- It calls a FUNCTION (to calculate total payments) and a PROCEDURE (to clean outdated feedbacks).

DO $$
DECLARE
    r RECORD;
    deleted_count INT;
BEGIN
    RAISE NOTICE '=== START: Payment analysis for active content creators ===';

    -- Call the function and filter inside the loop
    FOR r IN SELECT * FROM calculate_total_payments_for_active_creators() LOOP
    END LOOP;

    RAISE NOTICE '=== END: Payment analysis ===';

    -- Call the procedure to delete old feedbacks and return deleted count

	  RAISE NOTICE '=== START: Checking old feedbacks ===';
    CALL delete_old_feedbacks_and_count(deleted_count);

    -- Show the result
    RAISE NOTICE 'Total old feedbacks deleted: %', deleted_count;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Unexpected error in Main Program 1: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;
