-- Loading income statment values 
USE CreditRisk;

DROP TABLE IF EXISTS #Load;
-- PART A - loading temp table to check for spelling errors
CREATE TABLE #Load (ItemName NVARCHAR(150), Amount DECIMAL(19,2));

INSERT INTO #Load (ItemName, Amount) VALUES
('Sale of merchandise',                               252701),
('Alternative revenue',                                 3669),
('Interest revenue',                                     218),
('Revenue',                                           256588),
('Cost of sales',                                    -191259),
('Gross profit',                                       61442),
('Share of profit of equity accounted investments',      250),
('Depreciation and amortisation',                      -7988),
('Employee benefits expense',                         -20266),
('Credit impairment losses',                             -76),
('Other operating expenses',                          -22339),
('Trading profit',                                     14910),
('Profit on lease modifications and terminations',       95),
('Items of a capital nature',                            103),
('Operating profit',                                   15108),
('Interest received from bank account balances',         357),
('Finance costs',                                      -5115),
('Profit before income tax',                           10350),
('Income tax expense',                                 -2786),
('Profit from continuing operations',                   7564),
('Profit/(loss) from discontinued operations',            19),
('Profit for the year',                                 7583),
('Other comprehensive income/(loss), net of tax',       -136),
('Total comprehensive income for the year',             7447);

-- Typo check: this should return ZERO rows
SELECT l.ItemName AS UnmatchedName
FROM #Load AS l
LEFT JOIN dbo.LineItemDefinition AS li ON li.ItemName = l.ItemName
WHERE li.ItemID IS NULL;
-- PART B - loading actual values 
DECLARE @PeriodID INT = (
    SELECT p.PeriodID
    FROM dbo.FinancialPeriod AS p
    JOIN dbo.Company AS c ON c.CompanyID = p.CompanyID
    WHERE c.CompanyName = 'Shoprite Holdings Ltd'
      AND p.FiscalYearEnd = '2025-06-29'
      AND p.PeriodType = 'Annual'
);

INSERT INTO dbo.FinancialStatementValue (PeriodID, ItemID, Amount)
SELECT @PeriodID, li.ItemID, l.Amount
FROM #Load AS l
JOIN dbo.LineItemDefinition AS li ON li.ItemName = l.ItemName;

DROP TABLE #Load;
