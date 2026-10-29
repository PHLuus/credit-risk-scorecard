-- loading food retailer bands into score band
USE CreditRisk;

INSERT INTO dbo.ScoreBand (RatioName, Industry, LowerBound, UpperBound, Points) VALUES
('CurrentRatio', 'Retail - Food and Grocery', -999999, 0.7,    1),
('CurrentRatio', 'Retail - Food and Grocery', 0.7,     0.9,    2),
('CurrentRatio', 'Retail - Food and Grocery', 0.9,     1.1,    3),
('CurrentRatio', 'Retail - Food and Grocery', 1.1,     1.3,    4),
('CurrentRatio', 'Retail - Food and Grocery', 1.3,     999999, 5),

('QuickRatio', 'Retail - Food and Grocery', -999999, 0.2,    1),
('QuickRatio', 'Retail - Food and Grocery', 0.2,     0.3,    2),
('QuickRatio', 'Retail - Food and Grocery', 0.3,     0.45,   3),
('QuickRatio', 'Retail - Food and Grocery', 0.45,    0.6,    4),
('QuickRatio', 'Retail - Food and Grocery', 0.6,     999999, 5),

('OperatingMarginPct', 'Retail - Food and Grocery', -999999, 1.5,    1),
('OperatingMarginPct', 'Retail - Food and Grocery', 1.5,     3,      2),
('OperatingMarginPct', 'Retail - Food and Grocery', 3,       5,      3),
('OperatingMarginPct', 'Retail - Food and Grocery', 5,       7,      4),
('OperatingMarginPct', 'Retail - Food and Grocery', 7,       999999, 5),

('NetMarginPct', 'Retail - Food and Grocery', -999999, 0.5,    1),
('NetMarginPct', 'Retail - Food and Grocery', 0.5,     1.5,    2),
('NetMarginPct', 'Retail - Food and Grocery', 1.5,     2.5,    3),
('NetMarginPct', 'Retail - Food and Grocery', 2.5,     4,      4),
('NetMarginPct', 'Retail - Food and Grocery', 4,       999999, 5);