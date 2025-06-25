-- The column of the foreign key 'datacenterid' in the table 'servers' did not contain any data
-- adding data from the linked table 'datacenters' using SQL script:

-- Anonymous code block to assign a random datacenter ID to each server individually
DO $$
DECLARE
    srv RECORD;   -- Variable to iterate over each server
    dc_id INT;    -- Variable to store a randomly selected datacenter ID
BEGIN
    -- Loop over each server in the Servers table
    FOR srv IN SELECT serverid FROM Servers LOOP

        -- Select a random datacenter ID from the Datacenters table
        SELECT datacenterid
        INTO dc_id
        FROM Datacenters
        ORDER BY RANDOM()
        LIMIT 1;

        -- Update the current server with the randomly selected datacenter ID
        UPDATE Servers
        SET datacenterid = dc_id
        WHERE serverid = srv.serverid;

    END LOOP;
END $$;
