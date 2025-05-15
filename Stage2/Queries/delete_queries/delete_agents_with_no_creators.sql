DELETE From Agent
WHERE AgentID NOT IN (
    SELECT DISTINCT AgentID FROM Content_Creator
    WHERE AgentID IS NOT NULL
);