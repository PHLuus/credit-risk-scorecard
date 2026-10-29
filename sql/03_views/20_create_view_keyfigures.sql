-- creating Key Figures in a VIEW
USE CreditRisk;
GO

CREATE OR ALTER VIEW dbo.vw_KeyFigures AS
SELECT
    c.CompanyName,
    p.PeriodID,
    p.FiscalYearEnd,

    -- Balance sheet
    SUM(CASE WHEN li.ItemName = 'Total current assets' THEN v.Amount ELSE 0 END)                                        AS TotalCurrentAssets,
    SUM(CASE WHEN li.ItemName = 'Assets classified as held for sale' THEN v.Amount ELSE 0 END)                          AS HeldForSaleAssets,
    SUM(CASE WHEN li.ItemName = 'Total current liabilities' THEN v.Amount ELSE 0 END) AS TotalCurrentLiabilities,
    SUM(CASE WHEN li.ItemName = 'Liabilities directly associated with assets held for sale' THEN v.Amount ELSE 0 END)   AS HeldForSaleLiabilities,
    SUM(CASE WHEN li.ItemName = 'Inventories' THEN v.Amount ELSE 0 END)                                                 AS Inventories,
    SUM(CASE WHEN li.ItemName = 'Cash and cash equivalents' THEN v.Amount ELSE 0 END)                                   AS Cash,
    SUM(CASE WHEN li.ItemName IN ('Borrowings - non-current', 'Borrowings - current',
                                  'Bank overdrafts and other short-term facilities') THEN v.Amount ELSE 0 END)          AS Borrowings,
    SUM(CASE WHEN li.ItemName IN ('Lease liabilities - non-current',
                                  'Lease liabilities - current') THEN v.Amount ELSE 0 END)                              AS LeaseLiabilities,
    SUM(CASE WHEN li.ItemName = 'Total liabilities' THEN v.Amount ELSE 0 END)                                           AS TotalLiabilities,
    SUM(CASE WHEN li.ItemName = 'Total equity' THEN v.Amount ELSE 0 END)                                                AS TotalEquity,

    -- Income statement (costs are stored as negatives, so the minus sign flips them to positive)
    SUM(CASE WHEN li.ItemName = 'Revenue' THEN v.Amount ELSE 0 END)                                                     AS Revenue,
    SUM(CASE WHEN li.ItemName = 'Sale of merchandise' THEN v.Amount ELSE 0 END)                                         AS SaleOfMerchandise,
    SUM(CASE WHEN li.ItemName = 'Gross profit' THEN v.Amount ELSE 0 END)                                                AS GrossProfit,
    SUM(CASE WHEN li.ItemName = 'Operating profit' THEN v.Amount ELSE 0 END)                                            AS OperatingProfit,
    -SUM(CASE WHEN li.ItemName = 'Depreciation and amortisation' THEN v.Amount ELSE 0 END)                              AS DepreciationAmortisation,
    -SUM(CASE WHEN li.ItemName = 'Finance costs' THEN v.Amount ELSE 0 END)                                              AS FinanceCosts,
    SUM(CASE WHEN li.ItemName = 'Profit for the year' THEN v.Amount ELSE 0 END)                                         AS ProfitForYear
FROM dbo.FinancialStatementValue    AS v
JOIN dbo.FinancialPeriod            AS p  ON p.PeriodID  = v.PeriodID
JOIN dbo.Company                    AS c  ON c.CompanyID = p.CompanyID
JOIN dbo.LineItemDefinition         AS li ON li.ItemID   = v.ItemID
GROUP BY c.CompanyName, p.PeriodID, p.FiscalYearEnd;
GO