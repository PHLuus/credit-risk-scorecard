-- New lines added to definitions and period for 2024
USE CreditRisk;

INSERT INTO dbo.LineItemDefinition (ItemName, StatementType, Category) VALUES
('Investment in convertible loans',                      'Cash Flow', 'Investing Activities'),
('Payment for investments at fair value through OCI',    'Cash Flow', 'Investing Activities'),
('Decrease in ring-fenced Angola tax guarantees',        'Cash Flow', 'Investing Activities'),
('Cash outflow on disposal of investment in subsidiary', 'Cash Flow', 'Investing Activities');

INSERT INTO dbo.FinancialPeriod (CompanyID, FiscalYearEnd, PeriodType, Currency)
SELECT CompanyID, '2024-06-30', 'Annual', 'ZAR'
FROM dbo.Company
WHERE CompanyName = 'Shoprite Holdings Ltd';