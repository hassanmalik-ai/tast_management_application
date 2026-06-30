import streamlit as st
from frontend.api import login, register

def auth_page():
    if st.session_state["token"] is not None:
        st.title("Logout")
        st.write("You are currently logged in.")
        if st.button("Logout"):
            st.session_state["token"] = None
            st.rerun()
        return

    st.title("Authentication")
    tab1, tab2 = st.tabs(["Login", "Register"])

    with tab1:
        st.header("Login")
        with st.form("login_form"):
            username = st.text_input("Username")
            password = st.text_input("Password", type="password")
            submit_login = st.form_submit_button("Login")

            if submit_login:
                if not username or not password:
                    st.error("Please fill in both fields.")
                else:
                    response = login(username, password)
                    if response.status_code == 200:
                        data = response.json()
                        st.session_state["token"] = data.get("token")
                        st.success("Logged in successfully!")
                        st.rerun()
                    else:
                        st.error(f"Login failed: {response.text}")

    with tab2:
        st.header("Register")
        with st.form("register_form"):
            name = st.text_input("Name")
            reg_username = st.text_input("Username")
            email = st.text_input("Email")
            phone = st.text_input("Phone")
            reg_password = st.text_input("Password", type="password")
            submit_register = st.form_submit_button("Register")

            if submit_register:
                if not name or not reg_username or not email or not phone or not reg_password:
                    st.error("Please fill in all fields.")
                else:
                    response = register(name, reg_username, email, phone, reg_password)
                    if response.status_code == 201:
                        st.success("Registration successful! Please login.")
                    else:
                        st.error(f"Registration failed: {response.text}")

auth_page()
