-- Testing table columns
USE CreditRisk;

-- 1. Period for a company that does't exist (FK violation)
INSERT INTO dbo.FinancialPeriod (CompanyID, FiscalYearEnd) VALUES (99, '2025-12-31');

-- 2 Same value twice for the same period and item (UNIQUE violation)
INSERT INTO dbo.FinancialStatementValue (PeriodID, ItemID, Amount) VALUES (1, 1, 100);

-- 3. Invalid statement type (CHECK violation)
INSERT INTO dbo.LineItemDefinition (ItemName, StatementType) VALUES ('Test', 'Blance Sheett');