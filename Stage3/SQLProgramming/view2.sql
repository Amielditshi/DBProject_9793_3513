-- View from the control_transmission database 
-- Overview of server health: number of errors, maintenance, average latency, loss rate
CREATE VIEW ServerHealthOverview AS
SELECT
    s.serverid,
    dc.name AS datacenter_name,
    dc.country AS datacenter_country,
    s.status AS server_status,
    COUNT(DISTINCT e.errorid) AS error_count,
    COUNT(DISTINCT m.recordid) AS maintenance_count,
    ROUND(AVG(n.averagelatency)::NUMERIC, 2) AS avg_latency,
    ROUND(AVG(n.packetloss)::NUMERIC, 2) AS avg_packetloss
FROM servers s
LEFT JOIN datacenters dc ON s.datacenterid = dc.datacenterid
LEFT JOIN errorlogs e ON s.serverid = e.serverid
LEFT JOIN maintenancerecords m ON s.serverid = m.serverid
LEFT JOIN networkusage n ON s.serverid = n.serverid
GROUP BY s.serverid, dc.name, dc.country, s.status;


--query 1: List of the most unstable servers (more than 10 errors or latency > 200ms), where the data exists
SELECT *
FROM ServerHealthOverview
WHERE error_count > 10 OR avg_latency > 200
ORDER BY avg_latency ASC;


--query 2: Average latency by data center country
SELECT datacenter_country, ROUND(AVG(avg_latency), 2) AS country_avg_latency
FROM ServerHealthOverview
GROUP BY datacenter_country
ORDER BY country_avg_latency ASC;

