-- Balance sheet check: A=E+L
SELECT
    v.PeriodID,
    SUM(CASE WHEN li.ItemName = 'Total assets' THEN v.Amount ELSE 0 END) AS TotalAssets,
    SUM(CASE WHEN li.ItemName IN ('Total equity', 'Total liabilities') THEN v.Amount ELSE 0 END) AS EquityPlusLiabilities
FROM dbo.FinancialStatementValue AS v
JOIN dbo.LineItemDefinition AS li ON li.ItemID = v.ItemID
WHERE li.StatementType = 'Balance Sheet'
GROUP BY v.PeriodID
ORDER BY v.PeriodID;