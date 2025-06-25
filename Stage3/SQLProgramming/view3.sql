-- View from the merged database
-- Provide a complete overview of content creators, their productions, the deployment infrastructure, and related server activity.
CREATE VIEW FullProductionInfrastructureView AS
SELECT
    -- Creator
    cc.creatorid,
    cc.content_creatorfullname,
    cc.country AS creator_country,
    cc.isactive,
    
    -- Agent
    ag.agencyname,

    -- Production
    p.productionid,
    p.title,
    p.genre,
    p.productiontype,
    p.releasedate,

    -- Contract
    ct.rolecontract,
    ct.payment,

    -- Deployment
    pd.deploymentid,
    pd.deploymentdate,
    pd.deploymentversion,

    -- Server
    s.serverid,
    s.status AS server_status,
    s.ipaddress,

    -- Datacenter
    dc.name AS datacenter_name,
    dc.city AS datacenter_city,
    dc.country AS datacenter_country,

    -- Info réseau
    nu.averagelatency,
    nu.packetloss,

    -- Errors
    el.errorcode,
    el.severity,

    -- Maintenance
    mr.maintenancetype,
    mr.downtimeminutes,

    -- Sessions
    ss.sessionid,
    ss.videoquality
FROM content_creator cc
JOIN agent ag ON cc.agentid = ag.agentid
JOIN contract ct ON cc.creatorid = ct.creatorid
JOIN production p ON ct.productionid = p.productionid
JOIN productiondeployment pd ON pd.productionid = p.productionid
JOIN servers s ON s.serverid = pd.serverid
JOIN datacenters dc ON s.datacenterid = dc.datacenterid
LEFT JOIN errorlogs el ON el.serverid = s.serverid
LEFT JOIN maintenancerecords mr ON mr.serverid = s.serverid
LEFT JOIN networkusage nu ON nu.serverid = s.serverid
LEFT JOIN streamingsessions ss ON ss.serverid = s.serverid;


-- query 1: Top 10 productions with the highest number of server errors
SELECT 
    title,
    COUNT(DISTINCT errorcode) AS total_errors
FROM FullProductionInfrastructureView
GROUP BY title
ORDER BY total_errors DESC
LIMIT 10;

-- query 2: List of active creators whose productions were deployed on servers that underwent maintenance of more than 120 minutes
SELECT DISTINCT
    content_creatorfullname,
    title,
    deploymentdate,
    maintenancetype,
    downtimeminutes,
    datacenter_name
FROM FullProductionInfrastructureView
WHERE isactive = true
  AND downtimeminutes > 120
ORDER BY downtimeminutes DESC;

