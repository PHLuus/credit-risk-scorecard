-- Reset ID counters
USE CreditRisk;
GO
DBCC CHECKIDENT ('dbo.FinancialStatementValue', RESEED, 0);
DBCC CHECKIDENT ('dbo.FinancialPeriod', RESEED, 0);
DBCC CHECKIDENT ('dbo.LineItemDefinition', RESEED, 0);
DBCC CHECKIDENT ('dbo.Company', RESEED, 0);
GO