USE CreditRisk;

-- TABLE 1: Creating the Company table
CREATE TABLE dbo.Company (
	CompanyID	INT IDENTITY(1,1) NOT NULL,
	CompanyName NVARCHAR(200) NOT NULL,
	Industry	NVARCHAR(100) NOT NULL,
	Country		NVARCHAR(100) NOT NULL,
	ISListed	BIT NOT NULL DEFAULT 0,
	CONSTRAINT PK_Company PRIMARY KEY (CompanyID),
	CONSTRAINT UQ_Company_Name UNIQUE (CompanyName)
);

-- TABLE 2: Creating the LineItemDEfinition table
CREATE TABLE dbo.LineItemDefinition (
	ItemID			INT IDENTITY(1,1) NOT NULL,
	ItemName		NVARCHAR(150) NOT NULL,
	StatementType	VARCHAR(20) NOT NULL,
	Category		NVARCHAR(100) NULL,
	CONSTRAINT PK_LineItemDefinition PRIMARY KEY (ItemID),
	CONSTRAINT UQ_LineItem_Name UNIQUE (ItemName),
	CONSTRAINT CK_LineItem_Statement
		CHECK (StatementType IN ('Balance Sheet', 'Income Statement', 'Cash Flow'))
);

-- TABLE 3: Creating the FinancialPeriod table
CREATE TABLE dbo.FinancialPeriod (
	PeriodID		INT IDENTITY(1,1) NOT NULL,
	CompanyID		INT NOT NULL,
	FiscalYearEnd	DATE NOT NULL,
	PeriodType		VARCHAR(10) NOT NULL DEFAULT 'Annual',
	Currency		CHAR(3) NOT NULL DEFAULT 'ZAR',
	AuditOpinion	VARCHAR(30) NULL,
	CONSTRAINT PK_FinancialPeriod PRIMARY KEY (PeriodID),
	CONSTRAINT FK_Period_Company FOREIGN KEY (CompanyID)
		REFERENCES dbo.Company (CompanyID),
	CONSTRAINT UQ_Period UNIQUE (CompanyID,FiscalYearEnd, PeriodType),
	CONSTRAINT CK_Period_Type CHECK (PeriodType IN ('Annual', 'Interim'))
);

-- TABLE 4: FinancialStatementValue 
CREATE TABLE dbo.FinancialStatementValue (
	ValueID		BIGINT IDENTITY(1,1) NOT NULL,
	PeriodID	INT NOT NULL,
	ItemID		INT NOT NULL,
	Amount	DECIMAL(19,2) NOT NULL,
	CONSTRAINT PK_FinancialStatementValue PRIMARY KEY (ValueID),
	CONSTRAINT FK_Value_Period FOREIGN KEY (PeriodID)
		REFERENCES dbo.FinancialPeriod (PeriodID),
	CONSTRAINT FK_Value_Item FOREIGN KEY (ItemID)
		REFERENCES dbo.LineItemDefinition (ItemID),
	CONSTRAINT UQ_Value UNIQUE (PeriodID, ItemID)
);