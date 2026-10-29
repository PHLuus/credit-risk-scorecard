--Loading cash flow values

USE CreditRisk;

DROP TABLE IF EXISTS #Load;
--PART A
CREATE TABLE #Load (ItemName NVARCHAR(150), Amount DECIMAL(19,2));

INSERT INTO #Load (ItemName, Amount) VALUES
-- Operating activities
('Operating profit (cash flow basis)',                                 15921),
('Less: investment income and interest revenue earned',                 -635),
('Non-cash items',                                                     10658),
('Changes in working capital',                                          1632),
('Cash generated from operations',                                     27576),
('Interest received',                                                    841),
('Interest paid',                                                      -5441),
('Dividends received',                                                   487),
('Dividends paid',                                                     -4366),
('Income tax paid',                                                    -3078),
('Net cash from operating activities',                                 16019),
-- Investing activities
('Investment in PPE and intangibles - expansion',                      -5509),
('Investment in PPE and intangibles - maintenance',                    -1307),
('Payment for investment in insurance cell captive arrangements',        -62),
('Investment in assets classified as held for sale',                     -12),
('Proceeds on disposal of PPE and intangible assets',                    142),
('Proceeds on disposal of assets classified as held for sale',           372),
('Proceeds from government bonds and bills',                             285),
('Loans receivable advanced',                                           -517),
('Loans receivable repaid',                                              496),
('Investment in associate',                                             -108),
('Cash outflow on acquisition of other subsidiaries and operations',     -26),
('Net cash from investing activities',                                 -6246),
-- Financing activities
('Repayment of lease liability obligations',                           -4307),
('Purchase of treasury shares',                                         -343),
('Proceeds from treasury shares disposed',                                31),
('Repayment of short-term facilities',                                 -1200),
('Repayment of borrowings',                                             -451),
('Borrowings raised',                                                    139),
('Net cash from financing activities',                                 -6131),
-- Cash reconciliation
('Net movement in cash and cash equivalents',                           3642),
('Cash and cash equivalents at beginning of year',                      9323),
('Effect of exchange rate movements and hyperinflation on cash',         -13),
('Cash and cash equivalents at end of year',                           12952);

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
      AND p.FiscalYearEnd = '2026-06-28'
      AND p.PeriodType = 'Annual'
);

INSERT INTO dbo.FinancialStatementValue (PeriodID, ItemID, Amount)
SELECT @PeriodID, li.ItemID, l.Amount
FROM #Load AS l
JOIN dbo.LineItemDefinition AS li ON li.ItemName = l.ItemName;

DROP TABLE #Load;
