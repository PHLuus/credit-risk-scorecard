-- Testing information to see that relationships work
USE CreditRisk;

INSERT INTO dbo.Company (CompanyName, Industry, Country)
VALUES	('Test Co', 'Manufacturing', 'South Africa');

INSERT INTO dbo.LineItemDefinition (ItemName, StatementType, Category)
VALUES	('Total Current Assets', 'Balance Sheet', 'Current Assets'),
		('Total Current Liabilities', 'Balance Sheet', 'Current Liabilities');

INSERT INTO dbo.FinancialPeriod (CompanyID, FiscalYearEnd)
VALUES	(1, '2025-12-31');

INSERT INTO dbo.FinancialStatementValue (PeriodID, ItemID, Amount)
VALUES	(1, 1, 5000000), (1, 2, 2500000);