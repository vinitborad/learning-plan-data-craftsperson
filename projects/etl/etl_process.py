import pandas as pd

import logging
import urllib.parse
from sqlalchemy import create_engine
from data_quality_report import run_data_quality_tests, generate_json_data_quality_report

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[
        logging.FileHandler("data/etl_process.log"),
        logging.StreamHandler(),
    ],
)


def extract_data_from_csv(file_path: str) -> pd.DataFrame:
    try:
        df = pd.read_csv(file_path)
        return df
    except Exception as e:
        logging.error(f"Error reading data from {file_path}: {e}")
        raise


def process_data(df: pd.DataFrame) -> pd.DataFrame:
    boolean_mapping = {"Yes": True, "No": False}

    df["Returned"] = df["Returned"].map(boolean_mapping)
    df["IsPromotional"] = df["IsPromotional"].map(boolean_mapping)

    df["TransactionDate"] = pd.to_datetime(df["TransactionDate"])
    df["TransactionDate"] = df["TransactionDate"].ffill()

    df = df.dropna(subset=["CustomerID"])

    df.set_index("TransactionID", inplace=True)

    return df


def load_data_to_csv(df: pd.DataFrame, output_path: str) -> None:
    try:
        df.to_csv(output_path)
        logging.info("Data successfully saved to CSV.")
    except Exception as e:
        logging.error(f"Error saving to CSV: {e}")
        raise


def load_data_to_sql(
    df: pd.DataFrame, server: str, database: str, driver: str, table_name: str
) -> None:
    try:
        params = urllib.parse.quote_plus(
            f"DRIVER={{{driver}}};SERVER={server};DATABASE={database};"
            f"Trusted_Connection=yes;TrustServerCertificate=yes"
        )
        engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}")

        df.to_sql(table_name, con=engine, if_exists="replace", chunksize=50000)
        logging.info(f"Data successfully loaded into SQL Server table '{table_name}'.")
    except Exception as e:
        logging.error(f"Failed to load data to SQL Server: {e}")
        raise


def main():
    input_file = "data/assessment_dataset.csv"
    output_file = "data/clean_assessment_dataset.csv"
    dq_report_file = "data/data_quality_report.json"


    db_server = "localhost"
    db_name = "etl_practice_db"
    db_driver = "ODBC Driver 17 for SQL Server"
    db_table = "clean_sales_data"

    try:
        df = extract_data_from_csv(input_file)
        
        logging.info("Running Data Quality Tests...")
        dq_results = run_data_quality_tests(df)
        generate_json_data_quality_report(dq_results, dq_report_file)

        clean_df = process_data(df)

        load_data_to_csv(clean_df, output_file)

        load_data_to_sql(
            clean_df,
            server=db_server,
            database=db_name,
            driver=db_driver,
            table_name=db_table,
        )
    except Exception as e:
        logging.error(f"ETL pipeline execution aborted due to error: {e}")


if __name__ == "__main__":
    main()
