import streamlit as st

st.set_page_config(
    page_title="HR Metadata Mesh",
    page_icon="📊",
    layout="wide",
    initial_sidebar_state="expanded"
)

# ==========================
# SIDEBAR
# ==========================

with st.sidebar:

    st.title("🏢 HR Metadata Mesh")

    st.markdown("---")

    page = st.radio(
        "Navigation",
        [
            "🏠 Home",
            "📚 Metadata Catalog",
            "📦 Data Products",
            "📊 Dashboards",
            "📝 SQL Editor",
            "🐍 Python Editor",
            "🤖 AI Copilot",
            "🔗 Lineage"
        ]
    )

    st.markdown("---")

    st.subheader("Environment")

    st.success("SQLite Connected")

    st.caption("Version 1.0.0")

# ==========================
# PAGE ROUTING
# ==========================

if page == "🏠 Home":
    st.title("🏠 Home")
    st.write("Executive overview of the HR Metadata Mesh.")

elif page == "📚 Metadata Catalog":
    st.title("📚 Metadata Catalog")
    st.write("Domains, Entities, Attributes, Metrics")

elif page == "📦 Data Products":
    st.title("📦 Data Products")
    st.write("Gold Views and Consumption Datasets")

elif page == "📊 Dashboards":
    st.title("📊 Dashboards")
    st.write("Dashboard Factory and Analytics")

elif page == "📝 SQL Editor":
    st.title("📝 SQL Editor")
    st.write("Run ad-hoc SQL against SQLite")

elif page == "🐍 Python Editor":
    st.title("🐍 Python Editor")
    st.write("Execute Python snippets")

elif page == "🤖 AI Copilot":
    st.title("🤖 AI Copilot")
    st.write("Ask business questions using metadata")

elif page == "🔗 Lineage":
    st.title("🔗 Lineage")
    st.write("View metadata lineage")