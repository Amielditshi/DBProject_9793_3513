CREATE OR REPLACE PROCEDURE update_server_status_by_network()
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
BEGIN
    -- Parcourir chaque serveur avec ses dernières stats réseau
    FOR rec IN 
        SELECT s.serverid, n.averagelatency, n.packetloss
        FROM servers s
        JOIN (
            -- On prend la dernière mesure réseau pour chaque serveur
            SELECT DISTINCT ON (serverid) *
            FROM networkusage
            ORDER BY serverid, "timestamp" DESC
        ) n ON s.serverid = n.serverid
    LOOP
        BEGIN
            -- Mettre à jour le statut selon les conditions
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
