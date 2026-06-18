# services/db.py

import sqlite3

def get_connection():
    return sqlite3.connect("database/hr_mesh.db")