import os
import time
from psycopg2 import connect
from psycopg2.extensions import connection


import logging
logging.basicConfig(filename='verify_data_devops.log', level=logging.INFO)

HOST = os.environ['HOST']
PASSWORD = os.environ['PASSWORD']
SCHEMA = os.environ['SCHEMA']
TABLE = os.environ['TABLE']
DB_NAME = os.environ['DB_NAME']
DB_USER = os.environ['DB_USER']


def get_conn() -> connection:
    return connect(f"host={HOST} password={PASSWORD} dbname={DB_NAME} user={DB_USER}")


def verify_data(conn, schema, table, rowres=None) -> None:
    cur = conn.cursor()

    cur.execute(f"SELECT * FROM {schema}.{table} ORDER BY date DESC LIMIT 10")
    res = cur.fetchall()

    if len(res) > 0:
        start_time = time.strftime("%d %b %Y %X", time.gmtime())
        logging.info(f" {start_time} / Querying last 10 rows:")
        for row in res:
            logging.info(f"{row}")
        logging.info(f"END \n")
    else:
        logging.info(f"No data in the table")

    conn.commit()


def main() -> None:
    verify_data(conn=get_conn(), schema=SCHEMA, table=TABLE)


if __name__ == '__main__':
    main()
