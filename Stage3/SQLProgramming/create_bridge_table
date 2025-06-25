-- This table serves as a logical bridge between the two integrated databases.
-- It connects productions from the 'Production' table with servers from the 'Servers' table,
-- representing the deployment of a specific production onto a specific server.

CREATE TABLE ProductionDeployment (
DeploymentID INT PRIMARY KEY,
ProductionID INT,
ServerID INT,
DeploymentDate DATE,
DeploymentVersion VARCHAR(30),

FOREIGN KEY (ProductionID) REFERENCES Production(ProductionID),
FOREIGN KEY (ServerID) REFERENCES Servers(ServerID)
);
