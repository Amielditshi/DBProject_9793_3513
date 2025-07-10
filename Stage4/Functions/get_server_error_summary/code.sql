CREATE OR REPLACE FUNCTION get_server_error_summary()
RETURNS REFCURSOR
AS $$
DECLARE
    ref refcursor := 'error_summary_cursor'; -- Nom explicite
BEGIN
    OPEN ref FOR
        SELECT s.serverid, s.location, COUNT(e.errorid) AS high_errors
        FROM servers s
        JOIN errorlogs e ON s.serverid = e.serverid
        WHERE e.severity = 'High'
        GROUP BY s.serverid, s.location
        ORDER BY high_errors DESC;
    RETURN ref;
END;
$$ LANGUAGE plpgsql;
