from urllib.parse import quote_plus

import pandas as pd
from sqlalchemy import create_engine, text

# ---------- 1. Connect to SQL Server ----------
SERVER = r"Hugo\SQLEXPRESS"
DATABASE = "CreditRisk"

conn_str = (
    "DRIVER={ODBC Driver 18 for SQL Server};"
    f"SERVER={SERVER};"
    f"DATABASE={DATABASE};"
    "Trusted_Connection=yes;"
    "TrustServerCertificate=yes;"
)
engine = create_engine("mssql+pyodbc:///?odbc_connect=" + quote_plus(conn_str))

# ---------- 2. Read everything from SQL ----------
ratios = pd.read_sql("""
    SELECT r.CompanyName, c.Industry, r.PeriodID, r.FiscalYearEnd,
           r.CurrentRatio, r.QuickRatio,
           r.DebtToEquity_InclLeases, r.NetDebtToEBITDA_InclLeases,
           r.InterestCover, cf.DebtServiceCover, cf.CashConversion,
           cf.FreeCashFlowToDebtPct, cf.DividendCover,
           r.OperatingMarginPct, r.NetMarginPct
    FROM dbo.vw_Ratios AS r
    JOIN dbo.vw_CashFlowRatios AS cf ON cf.PeriodID = r.PeriodID
    JOIN dbo.Company AS c ON c.CompanyName = r.CompanyName
""", engine)

bands      = pd.read_sql("SELECT RatioName, Industry, LowerBound, UpperBound, Points FROM dbo.ScoreBand", engine)
categories = pd.read_sql("SELECT RatioName, Category FROM dbo.RatioDefinition", engine)
weights    = pd.read_sql("SELECT WeightSet, Category, Weight FROM dbo.CategoryWeight", engine)
grades     = pd.read_sql("SELECT Grade, LowerScore, UpperScore FROM dbo.GradeBand", engine)

# ---------- 3. One row per ratio value (wide table -> long table) ----------
id_cols = ["CompanyName", "Industry", "PeriodID", "FiscalYearEnd"]
long = ratios.melt(id_vars=id_cols, var_name="RatioName", value_name="Value")
long["Value"] = pd.to_numeric(long["Value"])


# ---------- 4. Turn each ratio into points using the bands ----------
def find_points(ratio, industry, value):
    """Use the industry's bands if they exist for this ratio, otherwise the Default bands."""
    if pd.isna(value):
        return None  # ratio not applicable (e.g. no dividend paid)
    for band_set in (industry, "Default"):
        b = bands[(bands["RatioName"] == ratio) & (bands["Industry"] == band_set)]
        if not b.empty:
            hit = b[(b["LowerBound"] <= value) & (value < b["UpperBound"])]
            if not hit.empty:
                return hit.iloc[0]["Points"]
    return None


long["Points"] = long.apply(
    lambda row: find_points(row["RatioName"], row["Industry"], row["Value"]), axis=1
)
long["Points"] = pd.to_numeric(long["Points"])
long = long.merge(categories, on="RatioName")

# ---------- 5. Category scores (average of the ratio points; empty ratios are skipped) ----------
cat_scores = (
    long.groupby(["CompanyName", "PeriodID", "FiscalYearEnd", "Category"])["Points"]
    .mean()
    .reset_index(name="CategoryScore")
)

# ---------- 6. Overall score for each weight set ----------
scored = cat_scores.merge(weights, on="Category")
scored["Weighted"] = scored["CategoryScore"] * scored["Weight"]

overall = (
    scored.groupby(["CompanyName", "PeriodID", "FiscalYearEnd", "WeightSet"])
    .agg(Weighted=("Weighted", "sum"), WeightUsed=("Weight", "sum"))
    .reset_index()
)
overall["Average"] = overall["Weighted"] / overall["WeightUsed"]       # between 1 and 5
overall["Score"] = ((overall["Average"] - 1) / 4 * 100).round(1)        # rescaled to 0-100


def to_grade(score):
    for _, g in grades.iterrows():
        if g["LowerScore"] <= score < g["UpperScore"]:
            return g["Grade"]
    return None


overall["Grade"] = overall["Score"].apply(to_grade)

# ---------- 7. Show the results ----------
pd.set_option("display.width", 200)

print("\nPOINTS PER RATIO (5 = strongest)")
print(long.pivot_table(index=["Category", "RatioName"], columns="FiscalYearEnd", values="Points"))

print("\nCATEGORY SCORES (1-5)")
print(cat_scores.pivot_table(index="Category", columns="FiscalYearEnd", values="CategoryScore").round(2))

print("\nOVERALL SCORE AND GRADE")
print(
    overall[["FiscalYearEnd", "WeightSet", "Score", "Grade"]]
    .sort_values(["WeightSet", "FiscalYearEnd"])
    .to_string(index=False)
)
# ---------- 8. Save the results back to SQL Server ----------
ratio_out = long[["PeriodID", "RatioName", "Category", "Value", "Points"]].rename(
    columns={"Value": "RatioValue"}
)
category_out = cat_scores[["PeriodID", "Category", "CategoryScore"]]
risk_out = overall[["PeriodID", "WeightSet", "Average", "Score", "Grade"]].rename(
    columns={"Average": "AverageScore"}
)

with engine.begin() as conn:  # one transaction: either everything is saved or nothing is
    for table in ("RiskScore", "CategoryScore", "RatioScore"):
        conn.execute(text(f"DELETE FROM dbo.{table}"))   # clear the previous run's results

    ratio_out.to_sql("RatioScore", conn, schema="dbo", if_exists="append", index=False)
    category_out.to_sql("CategoryScore", conn, schema="dbo", if_exists="append", index=False)
    risk_out.to_sql("RiskScore", conn, schema="dbo", if_exists="append", index=False)

print("\nResults saved to SQL Server.")