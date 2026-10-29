-- Creating View Ratios 
USE CreditRisk;
GO

CREATE OR ALTER VIEW dbo.vw_Ratios AS
SELECT
    CompanyName, PeriodID, FiscalYearEnd,

    -- Liquidity
    ROUND((TotalCurrentAssets - HeldForSaleAssets)
        / NULLIF(TotalCurrentLiabilities - HeldForSaleLiabilities, 0), 2)              AS CurrentRatio,
    ROUND(TotalCurrentAssets / NULLIF(TotalCurrentLiabilities, 0), 2)                  AS CurrentRatio_Reported,
    ROUND((TotalCurrentAssets - HeldForSaleAssets - Inventories)
        / NULLIF(TotalCurrentLiabilities - HeldForSaleLiabilities, 0), 2)              AS QuickRatio,

    -- Leverage
    ROUND(Borrowings / NULLIF(TotalEquity, 0), 2)                                      AS DebtToEquity_ExLeases,
    ROUND((Borrowings + LeaseLiabilities) / NULLIF(TotalEquity, 0), 2)                 AS DebtToEquity_InclLeases,
    CASE WHEN OperatingProfit + DepreciationAmortisation <= 0 THEN 999.99
         ELSE ROUND((Borrowings + LeaseLiabilities - Cash)
              / (OperatingProfit + DepreciationAmortisation), 2)
    END                                                                                AS NetDebtToEBITDA_InclLeases,

    -- Coverage
    ROUND(OperatingProfit / NULLIF(FinanceCosts, 0), 2)                                AS InterestCover,

    -- Profitability (percentages)
    ROUND(GrossProfit / NULLIF(SaleOfMerchandise, 0) * 100, 1)                         AS GrossMarginPct,
    ROUND(OperatingProfit / NULLIF(Revenue, 0) * 100, 1)                               AS OperatingMarginPct,
    ROUND(ProfitForYear / NULLIF(Revenue, 0) * 100, 1)                                 AS NetMarginPct
FROM dbo.vw_KeyFigures;
GO