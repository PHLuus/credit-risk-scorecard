--COUNTING rows in database - Confirming that all is 0 after clearing
USE CreditRisk;

SELECT 'Company' AS TableName, COUNT(*) AS Rows FROM dbo.Company
UNION ALL SELECT 'LineItemDefinition', COUNT(*) FROM dbo.LineItemDefinition
UNION ALL SELECT 'FinancialPeriod', COUNT(*) FROM dbo.FinancialPeriod
UNION ALL SELECT 'FinancialStatementValue', COUNT(*) FROM dbo.FinancialStatementValue