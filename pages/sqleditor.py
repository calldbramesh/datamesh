from streamlit_ace import st_ace
import pandas as pd
import sqlite3
import streamlit as st

conn = sqlite3.connect("database/hr_mesh.db")

sql = st_ace(
    language="sql",
    theme="monokai",
    height=300
)

if st.button("Run SQL"):
    try:
        df = pd.read_sql_query(sql, conn)
        st.dataframe(df)
    except Exception as e:
        st.error(str(e))