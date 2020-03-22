import os
from psycopg2 import connect
from psycopg2.extensions import connection

from random import randint

HOST = os.environ['HOST']
PASSWORD = os.environ['PASSWORD']
SCHEMA = os.environ['SCHEMA']
TABLE = os.environ['TABLE']
DB_NAME = os.environ['DB_NAME']
DB_USER = os.environ['DB_USER']


def get_conn() -> connection:
    return connect(f"host={HOST} password={PASSWORD} dbname={DB_NAME} user={DB_USER}")


def insert_data(conn, schema, table, data) -> None:
    cur = conn.cursor()

    cur.execute(
        f"INSERT INTO {schema}.{table} VALUES (%s, %s, %s, %s, %s, %s, %s, now())",
        data,
    )

    conn.commit()


def main() -> None:
    data = (randint(1, 100000), 'This', 'is', 'a', 'ga', 'devops', 'exercise')
    insert_data(conn=get_conn(), schema=SCHEMA, table=TABLE, data=data)


if __name__ == '__main__':
    main()
