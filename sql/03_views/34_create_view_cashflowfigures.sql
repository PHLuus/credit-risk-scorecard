-- Creating cash flow VIEW Figures
USE CreditRisk;
GO

CREATE OR ALTER VIEW dbo.vw_CashFlowFigures AS
SELECT
    p.PeriodID,
    SUM(CASE WHEN li.ItemName = 'Cash generated from operations'  THEN v.Amount ELSE 0 END) AS CashGeneratedFromOperations,
    SUM(CASE WHEN li.ItemName = 'Net cash from operating activities' THEN v.Amount ELSE 0 END) AS NetCashFromOperating,

    -- Outflows are stored as negatives, so the minus sign flips them to positive amounts
    -SUM(CASE WHEN li.ItemName = 'Interest paid' THEN v.Amount ELSE 0 END) AS InterestPaid,
    -SUM(CASE WHEN li.ItemName = 'Dividends paid' THEN v.Amount ELSE 0 END) AS DividendsPaid,
    -SUM(CASE WHEN li.ItemName = 'Income tax paid' THEN v.Amount ELSE 0 END) AS IncomeTaxPaid,
    -SUM(CASE WHEN li.ItemName = 'Investment in PPE and intangibles - expansion' THEN v.Amount ELSE 0 END) AS CapexExpansion,
    -SUM(CASE WHEN li.ItemName = 'Investment in PPE and intangibles - maintenance' THEN v.Amount ELSE 0 END) AS CapexMaintenance,
    -SUM(CASE WHEN li.ItemName = 'Repayment of lease liability obligations' THEN v.Amount ELSE 0 END) AS LeaseRepayments,
    -SUM(CASE WHEN li.ItemName IN ('Repayment of borrowings', 'Repayment of short-term facilities')
              THEN v.Amount ELSE 0 END) AS DebtRepayments
FROM dbo.FinancialStatementValue AS v
JOIN dbo.FinancialPeriod        AS p  ON p.PeriodID = v.PeriodID
JOIN dbo.LineItemDefinition     AS li ON li.ItemID  = v.ItemID
GROUP BY p.PeriodID;
GO