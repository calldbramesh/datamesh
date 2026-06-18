from streamlit_ace import st_ace
import streamlit as st

code = st_ace(
    language="python",
    theme="monokai",
    height=400
)

if st.button("Execute"):
    try:
        exec(code)
    except Exception as e:
        st.error(str(e))