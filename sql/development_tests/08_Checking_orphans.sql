-- Checking for orphans
SELECT v.*
FROM dbo.FinancialStatementValue AS v
LEFT JOIN dbo.FinancialPeriod AS p ON v.PeriodID = p.PeriodID
WHERE p.PeriodID IS NULL;