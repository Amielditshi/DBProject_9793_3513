-- Step 1: Create the log table to track deleted servers
CREATE TABLE IF NOT EXISTS server_deletion_log (
    log_id SERIAL PRIMARY KEY,
    serverid INT,
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_by TEXT DEFAULT CURRENT_USER,
    info TEXT
);

-- Step 2: Define the trigger function that inserts into the log table
CREATE OR REPLACE FUNCTION log_server_deletion()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO server_deletion_log (serverid, info)
    VALUES (
        OLD.serverid,
        CONCAT('Server at location ', OLD.location, ' with IP ', OLD.ipaddress, ' was deleted.')
    );
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Step 3: Bind the trigger to the servers table
CREATE TRIGGER trg_log_server_deletion
AFTER DELETE ON servers
FOR EACH ROW
EXECUTE FUNCTION log_server_deletion();
