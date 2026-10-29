-- Creating VIEW for cash flow ratios
USE CreditRisk;
GO

CREATE OR ALTER VIEW dbo.vw_CashFlowRatios AS
SELECT
    k.CompanyName, k.PeriodID, k.FiscalYearEnd,

    -- Debt service cover: cash available for debt service / (interest + lease + debt repayments)
    ROUND((cf.CashGeneratedFromOperations - cf.IncomeTaxPaid - cf.CapexMaintenance)
        / NULLIF(cf.InterestPaid + cf.LeaseRepayments + cf.DebtRepayments, 0), 2)  AS DebtServiceCover,

    -- Cash conversion: cash generated / EBITDA
    ROUND(cf.CashGeneratedFromOperations
        / NULLIF(k.OperatingProfit + k.DepreciationAmortisation, 0), 2)            AS CashConversion,

    -- Free cash flow (before dividends, after capex and lease repayments), as % of revenue
    ROUND((cf.NetCashFromOperating + cf.DividendsPaid
           - cf.CapexExpansion - cf.CapexMaintenance - cf.LeaseRepayments)
        / NULLIF(k.Revenue, 0) * 100, 1)                                           AS FreeCashFlowMarginPct,

    -- Free cash flow as % of total debt (borrowings + leases)
    ROUND((cf.NetCashFromOperating + cf.DividendsPaid
           - cf.CapexExpansion - cf.CapexMaintenance - cf.LeaseRepayments)
        / NULLIF(k.Borrowings + k.LeaseLiabilities, 0) * 100, 1)                   AS FreeCashFlowToDebtPct,

    -- Dividend cover: how many times free cash flow covers dividends paid
    ROUND((cf.NetCashFromOperating + cf.DividendsPaid
           - cf.CapexExpansion - cf.CapexMaintenance - cf.LeaseRepayments)
        / NULLIF(cf.DividendsPaid, 0), 2)                                          AS DividendCover
FROM dbo.vw_KeyFigures      AS k
JOIN dbo.vw_CashFlowFigures AS cf ON cf.PeriodID = k.PeriodID;
GO