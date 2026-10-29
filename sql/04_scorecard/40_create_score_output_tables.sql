-- Creating score tables
USE CreditRisk;

CREATE TABLE dbo.RatioScore (
    RatioScoreID  INT IDENTITY(1,1) NOT NULL,
    PeriodID      INT           NOT NULL,
    RatioName     VARCHAR(50)   NOT NULL,
    Category      VARCHAR(30)   NOT NULL,
    RatioValue    DECIMAL(18,4) NULL,
    Points        TINYINT       NULL,
    CONSTRAINT PK_RatioScore PRIMARY KEY (RatioScoreID),
    CONSTRAINT FK_RatioScore_Period FOREIGN KEY (PeriodID)
        REFERENCES dbo.FinancialPeriod (PeriodID),
    CONSTRAINT FK_RatioScore_Ratio FOREIGN KEY (RatioName)
        REFERENCES dbo.RatioDefinition (RatioName),
    CONSTRAINT UQ_RatioScore UNIQUE (PeriodID, RatioName)
);

CREATE TABLE dbo.CategoryScore (
    CategoryScoreID INT IDENTITY(1,1) NOT NULL,
    PeriodID        INT          NOT NULL,
    Category        VARCHAR(30)  NOT NULL,
    CategoryScore   DECIMAL(4,2) NOT NULL,
    CONSTRAINT PK_CategoryScore PRIMARY KEY (CategoryScoreID),
    CONSTRAINT FK_CategoryScore_Period FOREIGN KEY (PeriodID)
        REFERENCES dbo.FinancialPeriod (PeriodID),
    CONSTRAINT UQ_CategoryScore UNIQUE (PeriodID, Category)
);

CREATE TABLE dbo.RiskScore (
    RiskScoreID   INT IDENTITY(1,1) NOT NULL,
    PeriodID      INT          NOT NULL,
    WeightSet     VARCHAR(30)  NOT NULL,
    AverageScore  DECIMAL(6,4) NOT NULL,
    Score         DECIMAL(5,1) NOT NULL,
    Grade         CHAR(1)      NOT NULL,
    ScoredAt      DATETIME2    NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT PK_RiskScore PRIMARY KEY (RiskScoreID),
    CONSTRAINT FK_RiskScore_Period FOREIGN KEY (PeriodID)
        REFERENCES dbo.FinancialPeriod (PeriodID),
    CONSTRAINT UQ_RiskScore UNIQUE (PeriodID, WeightSet)
);