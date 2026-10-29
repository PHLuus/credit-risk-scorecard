--PART A loading balance sheet values as temp table

USE CreditRisk;

CREATE TABLE #Load (ItemName NVARCHAR(150), Amount DECIMAL(19,2));

INSERT INTO #Load (ItemName, Amount) VALUES
-- Non-current assets
('Property, plant and equipment',                     24096),
('Right-of-use assets',                               36772),
('Intangible assets',                                  5698),
('Equity accounted investments',                       2590),
('Investments at fair value through OCI',                69),
('Insurance cell captive investments - non-current',    101),
('Government bonds and bills - non-current',            249),
('Loans receivable - non-current',                      455),
('Deferred income tax assets',                         3740),
('Trade and other receivables - non-current',           592),
('Total non-current assets',                          74362),
-- Current assets
('Inventories',                                       31711),
('Trade and other receivables - current',              5730),
('Current income tax assets',                           674),
('Insurance cell captive investments - current',        163),
('Loans receivable - current',                         1142),
('Restricted cash',                                       8),
('Cash and cash equivalents',                         12959),
('Assets classified as held for sale',                 4040),
('Total current assets',                              56427),
('Total assets',                                     130789),
-- Equity
('Stated capital',                                     7516),
('Treasury shares',                                   -3758),
('Reserves',                                          29936),
('Non-controlling interest',                            -78),
('Total equity',                                      33616),
-- Non-current liabilities
('Lease liabilities - non-current',                   44785),
('Borrowings - non-current',                           4512),
('Deferred income tax liabilities',                      35),
('Employee benefits and other provisions - non-current', 624),
('Total non-current liabilities',                     49956),
-- Current liabilities
('Trade and other payables - current',                36961),
('Contract liabilities',                               1201),
('Lease liabilities - current',                        4500),
('Borrowings - current',                               2149),
('Current income tax liabilities',                      770),
('Employee benefits and other provisions - current',    198),
('Bank overdrafts and other short-term facilities',      12),
('Liabilities directly associated with assets held for sale', 1426),
('Total current liabilities',                         47217),
-- Totals
('Total liabilities',                                 97173),
('Total equity and liabilities',                     130789);

-- Typo check: this should return ZERO rows
SELECT l.ItemName AS UnmatchedName
FROM #Load AS l
LEFT JOIN dbo.LineItemDefinition AS li ON li.ItemName = l.ItemName
WHERE li.ItemID IS NULL;

--PART B - inserting data
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