USE CreditRisk;

INSERT INTO dbo.ScoreBand (RatioName, Industry, LowerBound, UpperBound, Points) VALUES
-- Liquidity
('CurrentRatio',  'Default', -999999, 0.8,    1),
('CurrentRatio',  'Default', 0.8,     1.0,    2),
('CurrentRatio',  'Default', 1.0,     1.2,    3),
('CurrentRatio',  'Default', 1.2,     1.5,    4),
('CurrentRatio',  'Default', 1.5,     999999, 5),

('QuickRatio',    'Default', -999999, 0.4,    1),
('QuickRatio',    'Default', 0.4,     0.6,    2),
('QuickRatio',    'Default', 0.6,     0.8,    3),
('QuickRatio',    'Default', 0.8,     1.0,    4),
('QuickRatio',    'Default', 1.0,     999999, 5),

-- Leverage (lower is better; a negative ratio means negative equity, so it scores worst)
('DebtToEquity_InclLeases', 'Default', -999999, 0,      1),
('DebtToEquity_InclLeases', 'Default', 0,       0.5,    5),
('DebtToEquity_InclLeases', 'Default', 0.5,     1.0,    4),
('DebtToEquity_InclLeases', 'Default', 1.0,     2.0,    3),
('DebtToEquity_InclLeases', 'Default', 2.0,     3.0,    2),
('DebtToEquity_InclLeases', 'Default', 3.0,     999999, 1),

('NetDebtToEBITDA_InclLeases', 'Default', -999999, 1.0,    5),
('NetDebtToEBITDA_InclLeases', 'Default', 1.0,     2.0,    4),
('NetDebtToEBITDA_InclLeases', 'Default', 2.0,     3.0,    3),
('NetDebtToEBITDA_InclLeases', 'Default', 3.0,     4.0,    2),
('NetDebtToEBITDA_InclLeases', 'Default', 4.0,     999999, 1),

-- Coverage and cash flow
('InterestCover', 'Default', -999999, 1.5,    1),
('InterestCover', 'Default', 1.5,     2.5,    2),
('InterestCover', 'Default', 2.5,     4.0,    3),
('InterestCover', 'Default', 4.0,     6.0,    4),
('InterestCover', 'Default', 6.0,     999999, 5),

('DebtServiceCover', 'Default', -999999, 1.0,    1),
('DebtServiceCover', 'Default', 1.0,     1.25,   2),
('DebtServiceCover', 'Default', 1.25,    1.75,   3),
('DebtServiceCover', 'Default', 1.75,    2.5,    4),
('DebtServiceCover', 'Default', 2.5,     999999, 5),

('CashConversion', 'Default', -999999, 0.5,    1),
('CashConversion', 'Default', 0.5,     0.75,   2),
('CashConversion', 'Default', 0.75,    0.9,    3),
('CashConversion', 'Default', 0.9,     1.0,    4),
('CashConversion', 'Default', 1.0,     999999, 5),

('FreeCashFlowToDebtPct', 'Default', -999999, 2,      1),
('FreeCashFlowToDebtPct', 'Default', 2,       6,      2),
('FreeCashFlowToDebtPct', 'Default', 6,       12,     3),
('FreeCashFlowToDebtPct', 'Default', 12,      20,     4),
('FreeCashFlowToDebtPct', 'Default', 20,      999999, 5),

('DividendCover', 'Default', -999999, 0.5,    1),
('DividendCover', 'Default', 0.5,     1.0,    2),
('DividendCover', 'Default', 1.0,     1.5,    3),
('DividendCover', 'Default', 1.5,     2.0,    4),
('DividendCover', 'Default', 2.0,     999999, 5),

-- Profitability
('OperatingMarginPct', 'Default', -999999, 3,      1),
('OperatingMarginPct', 'Default', 3,       6,      2),
('OperatingMarginPct', 'Default', 6,       10,     3),
('OperatingMarginPct', 'Default', 10,      15,     4),
('OperatingMarginPct', 'Default', 15,      999999, 5),

('NetMarginPct', 'Default', -999999, 1,      1),
('NetMarginPct', 'Default', 1,       3,      2),
('NetMarginPct', 'Default', 3,       6,      3),
('NetMarginPct', 'Default', 6,       10,     4),
('NetMarginPct', 'Default', 10,      999999, 5);