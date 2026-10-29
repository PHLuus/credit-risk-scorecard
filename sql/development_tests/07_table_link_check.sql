--Cheking that tables link with JOIN
SELECT
	c.CompanyName,
	p.FiscalYearEnd,
	li.StatementType,
	li.ItemName,
	v.Amount
FROM dbo.FinancialStatementValue	AS v
JOIN dbo.FinancialPeriod				AS p ON v.PeriodID	= p.PeriodID
JOIN dbo.Company					AS c ON p.CompanyID = c.CompanyID
JOIN dbo.LineItemDefinition			AS li ON v.ItemID	= li.ItemID
ORDER BY c.CompanyName, p.FiscalYearEnd, li.StatementType, li.ItemName