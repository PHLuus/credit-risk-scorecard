-- loading and checking income statment
USE CreditRisk;
-- PART A
DROP TABLE IF EXISTS #Load;   -- clears temp table 

CREATE TABLE #Load (ItemName NVARCHAR(150), Amount DECIMAL(19,2)); -- creates new temp table

INSERT INTO #Load (ItemName, Amount) VALUES
('Sale of merchandise',                               270775),
('Alternative revenue',                                 3792),
('Interest revenue',                                     183),
('Revenue',                                           274750),
('Cost of sales',                                    -204328),
('Gross profit',                                       66447),
('Share of profit of equity accounted investments',      244),
('Depreciation and amortisation',                      -8622),
('Employee benefits expense',                         -21738),
('Credit impairment losses',                             -86),
('Other operating expenses',                          -24058),
('Trading profit',                                     16162),
('Exchange rate gain/loss',                               -5),
('Profit on lease modifications and terminations',       77),
('Items of a capital nature',                           -267),
('Operating profit',                                   15967),
('Interest received from bank account balances',         367),
('Finance costs',                                      -5364),
('Profit before income tax',                           10970),
('Income tax expense',                                 -2886),
('Profit from continuing operations',                   8084),
('Profit/(loss) from discontinued operations',          -154),
('Profit for the year',                                 7930),
('Other comprehensive income/(loss), net of tax',       -141),
('Total comprehensive income for the year',             7789);

-- Typo check: this should return ZERO rows
SELECT l.ItemName AS UnmatchedName
FROM #Load AS l
LEFT JOIN dbo.LineItemDefinition AS li ON li.ItemName = l.ItemName
WHERE li.ItemID IS NULL;

-- Part B 
DECLARE @PeriodID INT = (
    SELECT p.PeriodID
    FROM dbo.FinancialPeriod AS p
    JOIN dbo.Company AS c ON c.CompanyID = p.CompanyID
    WHERE c.CompanyName = 'Shoprite Holdings Ltd'
      AND p.FiscalYearEnd = '2026-06-28'
      AND p.PeriodType = 'Annual'
);

INSERT INTO dbo.FinancialStatementValue (PeriodID, ItemID, Amount)
SELECT @PeriodID, li.ItemID, l.Amount
FROM #Load AS l
JOIN dbo.LineItemDefinition AS li ON li.ItemName = l.ItemName;

DROP TABLE #Load;