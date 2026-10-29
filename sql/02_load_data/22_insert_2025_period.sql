-- Inserting financial period for date ending 2025/06/29
USE CreditRisk;

INSERT INTO dbo.FinancialPeriod (CompanyID, FiscalYearEnd, PeriodType, Currency)
SELECT CompanyID, '2025-06-29', 'Annual', 'ZAR'
FROM dbo.Company
WHERE CompanyName = 'Shoprite Holdings Ltd';