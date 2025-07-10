BEGIN;
SELECT get_server_error_summary();
FETCH ALL FROM error_summary_cursor;
COMMIT;
