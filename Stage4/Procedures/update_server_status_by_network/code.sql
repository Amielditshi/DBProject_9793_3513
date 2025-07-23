CREATE OR REPLACE PROCEDURE update_server_status_by_network()
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
BEGIN
    -- Browse each server with its latest network stats
    FOR rec IN 
        SELECT s.serverid, n.averagelatency, n.packetloss
        FROM servers s
        JOIN (
            -- We take the last network measurement for each server
            SELECT DISTINCT ON (serverid) *
            FROM networkusage
            ORDER BY serverid, "timestamp" DESC
        ) n ON s.serverid = n.serverid
    LOOP
        BEGIN
            -- Update status as per conditions
            IF rec.averagelatency > 500 OR rec.packetloss > 5 THEN
                UPDATE servers SET status = 'Maintenance' WHERE serverid = rec.serverid;
            ELSE
                UPDATE servers SET status = 'Active' WHERE serverid = rec.serverid;
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Error updating server %: %', rec.serverid, SQLERRM;
                CONTINUE;
        END;
    END LOOP;
    
    RAISE NOTICE 'Server status update completed.';
END;
$$;
