-- create a temp copy
CREATE TEMP TABLE old_status AS
SELECT serverid, status FROM servers;

-- call the procedure
CALL update_server_status_by_network();

-- compare the status
SELECT s.serverid, old.status AS old_status, s.status AS new_status
FROM servers s
JOIN old_status old ON s.serverid = old.serverid
WHERE s.status <> old.status;
