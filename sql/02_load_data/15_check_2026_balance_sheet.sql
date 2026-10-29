-- Verification Query

SELECT COUNT(*) AS RowsLoaded FROM dbo.FinancialStatementValue;   -- expect 42

SELECT
    SUM(CASE WHEN li.ItemName = 'Total assets'      THEN v.Amount END) AS TotalAssets,
    SUM(CASE WHEN li.ItemName = 'Total equity'      THEN v.Amount END)
  + SUM(CASE WHEN li.ItemName = 'Total liabilities' THEN v.Amount END) AS EquityPlusLiabilities
FROM dbo.FinancialStatementValue AS v
JOIN dbo.LineItemDefinition AS li ON li.ItemID = v.ItemID
WHERE v.PeriodID = 1;