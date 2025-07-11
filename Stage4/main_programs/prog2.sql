-- Main Program 2:
-- This script updates server statuses based on latest network conditions
-- and then prints a summary of servers with high severity errors using a refcursor.

DO $$
DECLARE
    error_summary_cursor REFCURSOR;
    row RECORD;
BEGIN
    RAISE NOTICE '=== START: Updating server status ===';

    -- Call the procedure to update server status based on latency/packetloss
    CALL update_server_status_by_network();

    -- Call the function that opens a cursor for high severity error summary
    error_summary_cursor := get_server_error_summary();

    RAISE NOTICE '=== High severity error summary by server ===';

    LOOP
        FETCH error_summary_cursor INTO row;
        EXIT WHEN NOT FOUND;

        RAISE NOTICE 'Server ID: %, Location: %, High Errors: %',
            row.serverid, row.location, row.high_errors;
    END LOOP;

    CLOSE error_summary_cursor;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Unexpected error in Main Program 2: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;
