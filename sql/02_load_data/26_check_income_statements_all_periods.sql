-- Checking income statment for all periods
WITH IS_Values AS (
    SELECT fv.PeriodID, li.ItemName, fv.Amount
    FROM dbo.FinancialStatementValue AS fv
    JOIN dbo.LineItemDefinition AS li ON li.ItemID = fv.ItemID
    WHERE li.StatementType = 'Income Statement'
)
SELECT PeriodID,
  SUM(CASE WHEN ItemName = 'Revenue' THEN Amount ELSE 0 END)
- SUM(CASE WHEN ItemName IN ('Sale of merchandise','Alternative revenue','Interest revenue') THEN Amount ELSE 0 END)
    AS RevenueDiff,

  SUM(CASE WHEN ItemName = 'Gross profit' THEN Amount ELSE 0 END)
- SUM(CASE WHEN ItemName IN ('Sale of merchandise','Cost of sales') THEN Amount ELSE 0 END)
    AS GrossProfitDiff,

  SUM(CASE WHEN ItemName = 'Trading profit' THEN Amount ELSE 0 END)
- SUM(CASE WHEN ItemName IN ('Gross profit','Alternative revenue','Interest revenue',
        'Share of profit of equity accounted investments','Depreciation and amortisation',
        'Employee benefits expense','Credit impairment losses','Other operating expenses')
        THEN Amount ELSE 0 END)
    AS TradingProfitDiff,

  SUM(CASE WHEN ItemName = 'Operating profit' THEN Amount ELSE 0 END)
- SUM(CASE WHEN ItemName IN ('Trading profit','Exchange rate gain/loss',
        'Profit on lease modifications and terminations','Items of a capital nature')
        THEN Amount ELSE 0 END)
    AS OperatingProfitDiff,

  SUM(CASE WHEN ItemName = 'Profit before income tax' THEN Amount ELSE 0 END)
- SUM(CASE WHEN ItemName IN ('Operating profit','Interest received from bank account balances','Finance costs')
        THEN Amount ELSE 0 END)
    AS PBTDiff,

  SUM(CASE WHEN ItemName = 'Profit from continuing operations' THEN Amount ELSE 0 END)
- SUM(CASE WHEN ItemName IN ('Profit before income tax','Income tax expense') THEN Amount ELSE 0 END)
    AS ContinuingDiff,

  SUM(CASE WHEN ItemName = 'Profit for the year' THEN Amount ELSE 0 END)
- SUM(CASE WHEN ItemName IN ('Profit from continuing operations','Profit/(loss) from discontinued operations')
        THEN Amount ELSE 0 END)
    AS ProfitForYearDiff,

  SUM(CASE WHEN ItemName = 'Total comprehensive income for the year' THEN Amount ELSE 0 END)
- SUM(CASE WHEN ItemName IN ('Profit for the year','Other comprehensive income/(loss), net of tax')
        THEN Amount ELSE 0 END)
    AS ComprehensiveIncomeDiff
FROM IS_Values GROUP BY PeriodID ORDER BY PeriodID;