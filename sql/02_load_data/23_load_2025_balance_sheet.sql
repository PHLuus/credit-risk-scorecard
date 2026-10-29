-- loading values into balance sheet 
USE CreditRisk;

DROP TABLE IF EXISTS #Load;
--PART A Creating tep table
CREATE TABLE #Load (ItemName NVARCHAR(150), Amount DECIMAL(19,2));

INSERT INTO #Load (ItemName, Amount) VALUES
-- Non-current assets
('Property, plant and equipment',                     22536),
('Investment properties',                               128),
('Right-of-use assets',                               36090),
('Intangible assets',                                  5700),
('Equity accounted investments',                       2452),
('Investments at fair value through OCI',                74),
('Insurance cell captive investments - non-current',     39),
('Government bonds and bills - non-current',            539),
('Loans receivable - non-current',                      487),
('Deferred income tax assets',                         3447),
('Trade and other receivables - non-current',           585),
('Total non-current assets',                          72077),
-- Current assets
('Inventories',                                       29748),
('Trade and other receivables - current',              5706),
('Current income tax assets',                           740),
('Insurance cell captive investments - current',         92),
('Government bonds and bills - current',                 33),
('Loans receivable - current',                         1009),
('Restricted cash',                                       5),
('Cash and cash equivalents',                          9946),
('Assets classified as held for sale',                 5588),
('Total current assets',                              52867),
('Total assets',                                     124944),
-- Equity
('Stated capital',                                     7516),
('Treasury shares',                                   -3756),
('Reserves',                                          26434),
('Non-controlling interest',                            -77),
('Total equity',                                      30117),
-- Non-current liabilities
('Lease liabilities - non-current',                   43116),
('Borrowings - non-current',                           6504),
('Deferred income tax liabilities',                       8),
('Employee benefits and other provisions - non-current', 582),
('Trade and other payables - non-current',               76),
('Total non-current liabilities',                     50286),
-- Current liabilities
('Trade and other payables - current',                34084),
('Contract liabilities',                               1064),
('Lease liabilities - current',                        3904),
('Borrowings - current',                                489),
('Current income tax liabilities',                      677),
('Employee benefits and other provisions - current',    158),
('Bank overdrafts and other short-term facilities',    1863),
('Liabilities directly associated with assets held for sale', 2302),
('Total current liabilities',                         44541),
-- Totals
('Total liabilities',                                 94827),
('Total equity and liabilities',                     124944);

-- Typo check: this should return ZERO rows
SELECT l.ItemName AS UnmatchedName
FROM #Load AS l
LEFT JOIN dbo.LineItemDefinition AS li ON li.ItemName = l.ItemName
WHERE li.ItemID IS NULL;

--PART B loading actual values into table
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