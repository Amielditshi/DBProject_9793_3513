-- Replace this ID with the server you want to test
DO $$
DECLARE
    sid INT := 1;  -- Server ID to delete
BEGIN
    -- Delete references from related tables
    DELETE FROM productiondeployment WHERE serverid = sid;
    DELETE FROM maintenancerecords WHERE serverid = sid;
    DELETE FROM errorlogs WHERE serverid = sid;
    DELETE FROM streamingsessions WHERE serverid = sid;
    DELETE FROM networkusage WHERE serverid = sid;

    -- Delete the server (this will fire the trigger)
    DELETE FROM servers WHERE serverid = sid;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM server_deletion_log ORDER BY deleted_at DESC;
