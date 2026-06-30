import streamlit as st

st.set_page_config(
    page_title="Task Management App",
    page_icon="✅",
    layout="wide",
)

if "token" not in st.session_state:
    st.session_state["token"] = None

def main():
    st.sidebar.title("Navigation")
    
    # Simple logic for navigation based on token existence
    if st.session_state["token"] is None:
        auth_page = st.Page("pages/auth.py", title="Login / Register", icon="🔒")
        pg = st.navigation([auth_page])
    else:
        tasks_page = st.Page("pages/tasks.py", title="Tasks Dashboard", icon="📋")
        auth_page = st.Page("pages/auth.py", title="Logout", icon="🔓")
        pg = st.navigation([tasks_page, auth_page])
        
    pg.run()

if __name__ == "__main__":
    main()
