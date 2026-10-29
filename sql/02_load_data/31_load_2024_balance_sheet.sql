USE CreditRisk;

DROP TABLE IF EXISTS #Load;

CREATE TABLE #Load (ItemName NVARCHAR(150), Amount DECIMAL(19,2));

INSERT INTO #Load (ItemName, Amount) VALUES
-- Non-current assets
('Property, plant and equipment',                     19672),
('Investment properties',                               617),
('Right-of-use assets',                               30469),
('Intangible assets',                                  4695),
('Equity accounted investments',                       2478),
('Investments at fair value through OCI',                67),
('Insurance cell captive investments - non-current',    129),
('Loans receivable - non-current',                      429),
('Deferred income tax assets',                         3297),
('Trade and other receivables - non-current',           416),
('Total non-current assets',                          62269),
-- Current assets
('Inventories',                                       28366),
('Trade and other receivables - current',              6298),
('Current income tax assets',                           736),
('Insurance cell captive investments - current',        402),
('Government bonds and bills - current',                886),
('Loans receivable - current',                          680),
('Restricted cash',                                       3),
('Cash and cash equivalents',                         11732),
('Assets classified as held for sale',                  956),
('Total current assets',                              50059),
('Total assets',                                     112328),
-- Equity
('Stated capital',                                     7516),
('Treasury shares',                                   -2616),
('Reserves',                                          22891),
('Non-controlling interest',                            -67),
('Total equity',                                      27724),
-- Non-current liabilities
('Lease liabilities - non-current',                   36702),
('Borrowings - non-current',                           5788),
('Deferred income tax liabilities',                       8),
('Employee benefits and other provisions - non-current', 482),
('Trade and other payables - non-current',               86),
('Total non-current liabilities',                     43066),
-- Current liabilities
('Trade and other payables - current',                32458),
('Contract liabilities',                               1219),
('Lease liabilities - current',                        3775),
('Borrowings - current',                                205),
('Current income tax liabilities',                      784),
('Employee benefits and other provisions - current',    202),
('Bank overdrafts and other short-term facilities',    2895),
('Total current liabilities',                         41538),
-- Totals
('Total liabilities',                                 84604),
('Total equity and liabilities',                     112328);

-- Typo check: this should return ZERO rows
SELECT l.ItemName AS UnmatchedName
FROM #Load AS l
LEFT JOIN dbo.LineItemDefinition AS li ON li.ItemName = l.ItemName
WHERE li.ItemID IS NULL;

-- PART B 
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