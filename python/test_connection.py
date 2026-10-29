import pyodbc
from urllib.parse import quote_plus

import pandas as pd
from sqlalchemy import create_engine

print("Drivers found:", pyodbc.drivers())

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

ratios = pd.read_sql("SELECT * FROM dbo.vw_Ratios ORDER BY FiscalYearEnd", engine)
print(ratios.to_string())