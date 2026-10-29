-- Check 1: each band must start exactly where the previous one ended (no gaps, no overlaps)
WITH Ordered AS (
    SELECT RatioName, Industry, LowerBound, UpperBound,
           LAG(UpperBound) OVER (PARTITION BY RatioName, Industry
                                 ORDER BY LowerBound) AS PrevUpper
    FROM dbo.ScoreBand
)
SELECT *
FROM Ordered
WHERE PrevUpper IS NOT NULL
  AND LowerBound <> PrevUpper;

-- Check 2: every ratio's bands must run from -999999 to 999999
SELECT RatioName, Industry, MIN(LowerBound) AS FirstLower, MAX(UpperBound) AS LastUpper
FROM dbo.ScoreBand
GROUP BY RatioName, Industry
HAVING MIN(LowerBound) <> -999999 OR MAX(UpperBound) <> 999999;