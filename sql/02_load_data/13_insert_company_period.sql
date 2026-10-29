-- Inserting Company details into database
USE CreditRisk;

INSERT INTO dbo.Company (CompanyName, Industry, Country, ISListed)
VALUES ('Shoprite Holdings Ltd', 'Retail - Food and Grocery', 'South Africa', 1);

INSERT INTO dbo.FinancialPeriod (CompanyID, FiscalYearEnd, PeriodType, Currency)
SELECT CompanyID, '2026-06-28', 'Annual', 'ZAR'
FROM dbo.Company
WHERE CompanyName = 'Shoprite Holdings Ltd';