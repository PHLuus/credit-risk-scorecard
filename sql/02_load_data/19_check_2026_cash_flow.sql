WITH CF AS (
    SELECT li.ItemName, li.Category, fv.Amount
    FROM dbo.FinancialStatementValue AS fv
    JOIN dbo.LineItemDefinition AS li ON li.ItemID = fv.ItemID
    WHERE fv.PeriodID = 1
      AND li.StatementType = 'Cash Flow'
)
SELECT
  SUM(CASE WHEN ItemName = 'Cash generated from operations' THEN Amount ELSE 0 END)
- SUM(CASE WHEN ItemName IN ('Operating profit (cash flow basis)',
        'Less: investment income and interest revenue earned',
        'Non-cash items','Changes in working capital') THEN Amount ELSE 0 END)
    AS CashGeneratedDiff,

  SUM(CASE WHEN ItemName = 'Net cash from operating activities' THEN Amount ELSE 0 END)
- SUM(CASE WHEN ItemName IN ('Cash generated from operations','Interest received',
        'Interest paid','Dividends received','Dividends paid','Income tax paid')
        THEN Amount ELSE 0 END)
    AS OperatingDiff,

  SUM(CASE WHEN ItemName = 'Net cash from investing activities' THEN Amount ELSE 0 END)
- SUM(CASE WHEN Category = 'Investing Activities'
        AND ItemName <> 'Net cash from investing activities' THEN Amount ELSE 0 END)
    AS InvestingDiff,

  SUM(CASE WHEN ItemName = 'Net cash from financing activities' THEN Amount ELSE 0 END)
- SUM(CASE WHEN Category = 'Financing Activities'
        AND ItemName <> 'Net cash from financing activities' THEN Amount ELSE 0 END)
    AS FinancingDiff,

  SUM(CASE WHEN ItemName = 'Net movement in cash and cash equivalents' THEN Amount ELSE 0 END)
- SUM(CASE WHEN ItemName IN ('Net cash from operating activities',
        'Net cash from investing activities','Net cash from financing activities')
        THEN Amount ELSE 0 END)
    AS NetMovementDiff,

  SUM(CASE WHEN ItemName = 'Cash and cash equivalents at end of year' THEN Amount ELSE 0 END)
- SUM(CASE WHEN ItemName IN ('Net movement in cash and cash equivalents',
        'Cash and cash equivalents at beginning of year',
        'Effect of exchange rate movements and hyperinflation on cash')
        THEN Amount ELSE 0 END)
    AS ClosingCashDiff
FROM CF;