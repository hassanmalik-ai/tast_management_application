import requests
import streamlit as st

BASE_URL = "http://127.0.0.1:8000"

def get_headers():
    token = st.session_state.get("token")
    if token:
        # Note: Depending on backend implementation, it might expect 'Bearer <token>' or just the token in some other header.
        # Assuming typical Bearer token for now. Wait, FastAPI OAuth2PasswordBearer expects Authorization: Bearer ...
        # Let's check token_authetication in src/utils/helper.py if there are issues later.
        return {"Authorization": f"Bearer {token}"}
    return {}

def login(username, password):
    url = f"{BASE_URL}/users/login"
    payload = {"username": username, "password": password}
    response = requests.post(url, json=payload)
    return response

def register(name, username, email, phone, password):
    url = f"{BASE_URL}/users/register"
    payload = {
        "name": name,
        "username": username,
        "email": email,
        "phone": phone,
        "password": password
    }
    response = requests.post(url, json=payload)
    return response

def get_tasks():
    url = f"{BASE_URL}/tasks/get-all"
    response = requests.get(url, headers=get_headers())
    return response

def create_task(title, description, status=False):
    url = f"{BASE_URL}/tasks/create"
    payload = {
        "title": title,
        "description": description,
        "status": status
    }
    response = requests.post(url, json=payload, headers=get_headers())
    return response

def update_task(task_id, title, description, status):
    url = f"{BASE_URL}/tasks/update/{task_id}"
    payload = {
        "title": title,
        "description": description,
        "status": status
    }
    response = requests.put(url, json=payload, headers=get_headers())
    return response

def delete_task(task_id):
    url = f"{BASE_URL}/tasks/delete/{task_id}"
    response = requests.delete(url, headers=get_headers())
    return response
