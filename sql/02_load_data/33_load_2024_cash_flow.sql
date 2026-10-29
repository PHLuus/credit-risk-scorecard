USE CreditRisk;

DROP TABLE IF EXISTS #Load;

CREATE TABLE #Load (ItemName NVARCHAR(150), Amount DECIMAL(19,2));

INSERT INTO #Load (ItemName, Amount) VALUES
-- Operating activities
('Operating profit (cash flow basis)',                                 12828),
('Less: investment income and interest revenue earned',                -1009),
('Non-cash items',                                                      8557),
('Changes in working capital',                                          3252),
('Cash generated from operations',                                     23628),
('Interest received',                                                   1212),
('Interest paid',                                                      -4305),
('Dividends received',                                                   568),
('Dividends paid',                                                     -3743),
('Income tax paid',                                                    -3519),
('Net cash from operating activities',                                 13841),
-- Investing activities
('Investment in PPE and intangibles - expansion',                      -5718),
('Investment in PPE and intangibles - maintenance',                    -2012),
('Investment in assets classified as held for sale',                     -32),
('Investment in convertible loans',                                       -5),
('Payment for investments at fair value through OCI',                     -4),
('Proceeds on disposal of PPE and intangible assets',                    400),
('Cash inflows from outstanding debtor on previously disposed subsidiary', 39),
('Proceeds on disposal of assets classified as held for sale',           368),
('Payments for government bonds and bills',                             -339),
('Proceeds from government bonds and bills',                             523),
('Loans receivable advanced',                                           -663),
('Loans receivable repaid',                                              593),
('Decrease in ring-fenced Angola tax guarantees',                        285),
('Investment in associate',                                             -119),
('Cash outflow on acquisition of other subsidiaries and operations',     -44),
('Cash outflow on disposal of investment in subsidiary',                 -51),
('Net cash from investing activities',                                 -6779),
-- Financing activities
('Repayment of lease liability obligations',                           -3386),
('Purchase of treasury shares',                                         -239),
('Proceeds from treasury shares disposed',                                11),
('Repayment of borrowings',                                            -1714),
('Borrowings raised',                                                   1316),
('Net cash from financing activities',                                -4012),
-- Cash reconciliation
('Net movement in cash and cash equivalents',                           3050),
('Cash and cash equivalents at beginning of year',                      7502),
('Effect of exchange rate movements and hyperinflation on cash',        -515),
('Cash and cash equivalents at end of year',                           10037);

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