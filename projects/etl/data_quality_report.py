import pandas as pd
import json
import logging


def run_data_quality_tests(df: pd.DataFrame) -> dict:
    """Runs data quality checks and returns a dictionary of the results."""
    report = {
        "total_rows": len(df),
        "null_checks": {},
        "range_checks": {},
        "duplicate_checks": {},
    }

    null_counts = df.isnull().sum()
    report["null_checks"] = null_counts[null_counts > 0].to_dict()

    if "TransactionAmount" in df.columns:
        invalid_amounts = df[df["TransactionAmount"] < 0]
        report["range_checks"]["negative_transaction_amounts"] = len(invalid_amounts)

    if "Quantity" in df.columns:
        invalid_quantity = df[df["Quantity"] <= 0]
        report["range_checks"]["zero_or_negative_quantity"] = len(invalid_quantity)

    if "DiscountPercent" in df.columns:
        invalid_discounts = df[
            (df["DiscountPercent"] < 0) | (df["DiscountPercent"] > 100)
        ]
        report["range_checks"]["out_of_bounds_discount"] = len(invalid_discounts)

    report["duplicate_checks"]["exact_row_duplicates"] = int(df.duplicated().sum())

    if "TransactionID" in df.columns:
        report["duplicate_checks"]["duplicate_transaction_ids"] = int(
            df.duplicated(subset=["TransactionID"]).sum()
        )

    return report


def generate_json_data_quality_report(dq_results: dict, output_path: str):
    """Saves the data quality results dict to a nicely formatted JSON report file."""
    try:
        with open(output_path, "w") as f:
            json.dump(dq_results, f, indent=4)
        logging.info(f"Data quality report successfully generated at: {output_path}")
    except Exception as e:
        logging.error(f"Failed to generate Data Quality report: {e}")
        raise
