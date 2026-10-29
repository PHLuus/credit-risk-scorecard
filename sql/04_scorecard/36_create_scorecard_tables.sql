-- Creating
USE CreditRisk;

-- Which ratio belongs to which category
CREATE TABLE dbo.RatioDefinition (
    RatioName  VARCHAR(50) NOT NULL,
    Category   VARCHAR(30) NOT NULL,
    CONSTRAINT PK_RatioDefinition PRIMARY KEY (RatioName),
    CONSTRAINT CK_RatioDef_Category CHECK (Category IN
        ('Liquidity', 'Leverage', 'Coverage and Cash Flow', 'Profitability'))
);

-- Category weights, one set per type of lending
CREATE TABLE dbo.CategoryWeight (
    WeightSet  VARCHAR(30)  NOT NULL,
    Category   VARCHAR(30)  NOT NULL,
    Weight     DECIMAL(5,4) NOT NULL,
    CONSTRAINT PK_CategoryWeight PRIMARY KEY (WeightSet, Category),
    CONSTRAINT CK_Weight_Category CHECK (Category IN
        ('Liquidity', 'Leverage', 'Coverage and Cash Flow', 'Profitability')),
    CONSTRAINT CK_Weight_Range CHECK (Weight BETWEEN 0 AND 1)
);

-- Bands: a ratio value in [LowerBound, UpperBound) earns the points
CREATE TABLE dbo.ScoreBand (
    BandID      INT IDENTITY(1,1) NOT NULL,
    RatioName   VARCHAR(50)   NOT NULL,
    Industry    VARCHAR(100)  NOT NULL DEFAULT 'Default',
    LowerBound  DECIMAL(12,4) NOT NULL,
    UpperBound  DECIMAL(12,4) NOT NULL,
    Points      TINYINT       NOT NULL,
    CONSTRAINT PK_ScoreBand PRIMARY KEY (BandID),
    CONSTRAINT FK_ScoreBand_Ratio FOREIGN KEY (RatioName)
        REFERENCES dbo.RatioDefinition (RatioName),
    CONSTRAINT UQ_ScoreBand UNIQUE (RatioName, Industry, LowerBound),
    CONSTRAINT CK_ScoreBand_Points CHECK (Points BETWEEN 1 AND 5),
    CONSTRAINT CK_ScoreBand_Order CHECK (LowerBound < UpperBound)
);

-- Score to letter grade
CREATE TABLE dbo.GradeBand (
    Grade       CHAR(1)      NOT NULL,
    LowerScore  DECIMAL(5,1) NOT NULL,
    UpperScore  DECIMAL(5,1) NOT NULL,
    CONSTRAINT PK_GradeBand PRIMARY KEY (Grade),
    CONSTRAINT CK_GradeBand_Order CHECK (LowerScore < UpperScore)
);

-- Seed: ratio categories
INSERT INTO dbo.RatioDefinition (RatioName, Category) VALUES
('CurrentRatio',                'Liquidity'),
('QuickRatio',                  'Liquidity'),
('DebtToEquity_InclLeases',     'Leverage'),
('NetDebtToEBITDA_InclLeases',  'Leverage'),
('InterestCover',               'Coverage and Cash Flow'),
('DebtServiceCover',            'Coverage and Cash Flow'),
('CashConversion',              'Coverage and Cash Flow'),
('FreeCashFlowToDebtPct',       'Coverage and Cash Flow'),
('DividendCover',               'Coverage and Cash Flow'),
('OperatingMarginPct',          'Profitability'),
('NetMarginPct',                'Profitability');

-- Seed: weights
INSERT INTO dbo.CategoryWeight (WeightSet, Category, Weight) VALUES
('Short-term lending', 'Liquidity',              0.35),
('Short-term lending', 'Leverage',               0.30),
('Short-term lending', 'Coverage and Cash Flow', 0.20),
('Short-term lending', 'Profitability',          0.15),
('Term lending',       'Liquidity',              0.15),
('Term lending',       'Leverage',               0.30),
('Term lending',       'Coverage and Cash Flow', 0.35),
('Term lending',       'Profitability',          0.20);

-- Seed: grades
INSERT INTO dbo.GradeBand (Grade, LowerScore, UpperScore) VALUES
('E',   0.0,  35.0),
('D',  35.0,  50.0),
('C',  50.0,  65.0),
('B',  65.0,  80.0),
('A',  80.0, 100.1);