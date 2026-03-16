import pandas as pd
from sqlalchemy import create_engine
import urllib

SERVER = "localhost"
DATABASE = "etl_practice_db"
DRIVER = "ODBC Driver 17 for SQL Server"

params = urllib.parse.quote_plus(
    f"DRIVER={{{DRIVER}}};SERVER={SERVER};DATABASE={DATABASE};Trusted_Connection=yes;TrustServerCertificate=yes"
)
engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}")


def populate_test_data():
    data = {
        "product_name": ["Laptop", "Mouse", "Keyboard", "Monitor"],
        "sale_price": [1200.50, 25.00, 75.25, 300.00],
        "sale_date": ["2026-03-10", "2026-03-11", "2026-03-12", "2026-03-13"],
    }
    df = pd.DataFrame(data)

    df["sale_date"] = pd.to_datetime(df["sale_date"])

    print("Data prepared for loading...")
    try:
        df.to_sql("raw_sales_data", con=engine, if_exists="append", index=False)
        print("Successfully populated the database!")
    except Exception as e:
        print(f"Error loading data: {e}")


if __name__ == "__main__":
    populate_test_data()
