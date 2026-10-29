USE CreditRisk;

DROP TABLE IF EXISTS #Load;
--PART A 
CREATE TABLE #Load (ItemName NVARCHAR(150), Amount DECIMAL(19,2));

INSERT INTO #Load (ItemName, Amount) VALUES
-- Operating activities
('Operating profit (cash flow basis)',                                 15380),
('Less: investment income and interest revenue earned',                 -767),
('Non-cash items',                                                      9589),
('Changes in working capital',                                         -2312),
('Cash generated from operations',                                     21890),
('Interest received',                                                    861),
('Interest paid',                                                      -5166),
('Dividends received',                                                   750),
('Dividends paid',                                                     -3985),
('Income tax paid',                                                    -3366),
('Net cash from operating activities',                                 10984),
-- Investing activities
('Investment in PPE and intangibles - expansion',                      -6320),
('Investment in PPE and intangibles - maintenance',                    -1679),
('Payment for investment in insurance cell captive arrangements',        -10),
('Investment in assets classified as held for sale',                     -11),
('Proceeds on disposal of PPE and intangible assets',                    323),
('Cash inflows from outstanding debtor on previously disposed subsidiary', 9),
('Proceeds on disposal of assets classified as held for sale',           774),
('Payments for government bonds and bills',                             -791),
('Proceeds from government bonds and bills',                            1061),
('Loans receivable advanced',                                           -635),
('Loans receivable repaid',                                              578),
('Proceeds on disposal of investment in associate',                        1),
('Investment in associate',                                             -111),
('Cash outflow on acquisition of Pingo Delivery (Pty) Ltd',             -472),
('Cash outflow on acquisition of other subsidiaries and operations',     -82),
('Net cash from investing activities',                                 -7365),
-- Financing activities
('Repayment of lease liability obligations',                           -3870),
('Purchase of treasury shares',                                        -1432),
('Proceeds from treasury shares disposed',                                38),
('Repayment of borrowings',                                            -1083),
('Borrowings raised',                                                   2049),
('Net cash from financing activities',                                -4298),
-- Cash reconciliation
('Net movement in cash and cash equivalents',                           -679),
('Cash and cash equivalents at beginning of year',                     10037),
('Effect of exchange rate movements and hyperinflation on cash',         -35),
('Cash and cash equivalents at end of year',                            9323);

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
      AND p.FiscalYearEnd = '2025-06-29'
      AND p.PeriodType = 'Annual'
);

INSERT INTO dbo.FinancialStatementValue (PeriodID, ItemID, Amount)
SELECT @PeriodID, li.ItemID, l.Amount
FROM #Load AS l
JOIN dbo.LineItemDefinition AS li ON li.ItemName = l.ItemName;

DROP TABLE #Load;