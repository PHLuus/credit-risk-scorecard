USE CreditRisk;

DROP TABLE IF EXISTS #Load;

CREATE TABLE #Load (ItemName NVARCHAR(150), Amount DECIMAL(19,2));

INSERT INTO #Load (ItemName, Amount) VALUES
('Sale of merchandise',                               232088),
('Alternative revenue',                                 3927),
('Interest revenue',                                     313),
('Revenue',                                           236328),
('Cost of sales',                                    -176549),
('Gross profit',                                       55539),
('Share of profit of equity accounted investments',      268),
('Depreciation and amortisation',                      -6845),
('Employee benefits expense',                         -18289),
('Credit impairment losses',                            -179),
('Other operating expenses',                          -21916),
('Trading profit',                                     12818),
('Exchange rate gain/loss',                               27),
('Profit on lease modifications and terminations',        96),
('Items of a capital nature',                           -279),
('Operating profit',                                   12662),
('Interest received from bank account balances',         517),
('Finance costs',                                      -4153),
('Profit before income tax',                            9026),
('Income tax expense',                                 -2805),
('Profit from continuing operations',                   6221),
('Profit for the year',                                 6221),
('Other comprehensive income/(loss), net of tax',       -871),
('Total comprehensive income for the year',             5350);

-- Typo check: this should return ZERO rows
SELECT l.ItemName AS UnmatchedName
FROM #Load AS l
LEFT JOIN dbo.LineItemDefinition AS li ON li.ItemName = l.ItemName
WHERE li.ItemID IS NULL;

--PART B
DECLARE @PeriodID INT = (
    SELECT p.PeriodID
    FROM dbo.FinancialPeriod AS p
    JOIN dbo.Company AS c ON c.CompanyID = p.CompanyID
    WHERE c.CompanyName = 'Shoprite Holdings Ltd'
      AND p.FiscalYearEnd = '2024-06-30'
      AND p.PeriodType = 'Annual'
);

INSERT INTO dbo.FinancialStatementValue (PeriodID, ItemID, Amount)
SELECT @PeriodID, li.ItemID, l.Amount
FROM #Load AS l
JOIN dbo.LineItemDefinition AS li ON li.ItemName = l.ItemName;

DROP TABLE #Load;