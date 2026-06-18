# init_db.py

import sqlite3

conn = sqlite3.connect("hr_mesh.db")

with open("database/schema.sql") as f:
    conn.executescript(f.read())

with open("database/seed_data.sql") as f:
    conn.executescript(f.read())

conn.commit()
conn.close()

print("Database created successfully")