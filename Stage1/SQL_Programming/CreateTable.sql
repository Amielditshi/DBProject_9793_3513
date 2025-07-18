-- טבלת סוכנים
CREATE TABLE Agent (
    AgentID INT PRIMARY KEY,
    AgentFullName VARCHAR(100),
    AgencyName VARCHAR(100),
    PhoneNumber VARCHAR(20),
    Email VARCHAR(100)
);

-- טבלת יוצרים
CREATE TABLE Content_Creator (
    CreatorID INT PRIMARY KEY,
    Content_CreatorFullName VARCHAR(100),
    BirthDate DATE,
    Country VARCHAR(50),
    IsActive BOOLEAN,
    JoinDate DATE,
    AgentID INT,
    FOREIGN KEY (AgentID) REFERENCES Agent(AgentID)
);

-- טבלת הפקות
CREATE TABLE Production (
    ProductionID INT PRIMARY KEY,
    Title VARCHAR(100),
    ProductionType VARCHAR(50),
    ReleaseDate DATE,
    Genre VARCHAR(50),
    ProductionRating DECIMAL(3,1)
);

-- טבלת חוזים
CREATE TABLE Contract (
    ContractID INT PRIMARY KEY,
    CreatorID INT,
    ProductionID INT,
    StartDate DATE,
    EndDate DATE,
    Payment DECIMAL(10,2),
    RoleContract VARCHAR(50),
    FOREIGN KEY (CreatorID) REFERENCES Content_Creator(CreatorID),
    FOREIGN KEY (ProductionID) REFERENCES Production(ProductionID)
);

-- טבלת פרסים
CREATE TABLE Award (
    AwardID INT PRIMARY KEY,
	CreatorID INT,
    AwardName VARCHAR(100),
    AwardYear Date,
	FOREIGN KEY (CreatorID) REFERENCES Content_Creator(CreatorID)
);

-- טבלת משוב
CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY,
    ProductionID INT,
    FeedbackDate DATE,
    FeedbackRating DECIMAL(2,1),
    FeedbackComment TEXT,
    FOREIGN KEY (ProductionID) REFERENCES Production(ProductionID)
);
