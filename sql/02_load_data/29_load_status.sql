SELECT
    p.FiscalYearEnd,
    li.StatementType,
    COUNT(*) AS RowsLoaded
FROM dbo.FinancialStatementValue AS v
JOIN dbo.FinancialPeriod        AS p  ON p.PeriodID = v.PeriodID
JOIN dbo.LineItemDefinition     AS li ON li.ItemID  = v.ItemID
GROUP BY p.FiscalYearEnd, li.StatementType
ORDER BY p.FiscalYearEnd, li.StatementType;