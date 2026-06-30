import streamlit as st
from frontend.api import get_tasks, create_task, update_task, delete_task

def tasks_page():
    st.title("Tasks Dashboard")

    if st.session_state.get("token") is None:
        st.warning("Please login to view tasks.")
        return

    # Task Creation Form
    with st.expander("➕ Create New Task"):
        with st.form("create_task_form", clear_on_submit=True):
            new_title = st.text_input("Title")
            new_desc = st.text_area("Description")
            new_status = st.checkbox("Completed")
            submitted = st.form_submit_button("Create Task")
            if submitted:
                if new_title and new_desc:
                    res = create_task(new_title, new_desc, new_status)
                    if res.status_code == 201:
                        st.success("Task created!")
                        st.rerun()
                    else:
                        st.error(f"Failed to create task: {res.text}")
                else:
                    st.error("Title and description are required.")

    st.divider()
    st.subheader("Your Tasks")

    # Fetch and display tasks
    response = get_tasks()
    if response.status_code == 200:
        tasks = response.json()
        if not tasks:
            st.info("No tasks found. Create one above!")
        else:
            for task in tasks:
                task_id = task["id"]
                title = task["title"]
                desc = task["description"]
                status = task["status"]

                status_emoji = "✅" if status else "⏳"
                with st.container():
                    col1, col2, col3 = st.columns([0.6, 0.2, 0.2])
                    
                    with col1:
                        st.markdown(f"**{status_emoji} {title}**")
                        st.caption(desc)
                    
                    with col2:
                        with st.popover("Edit"):
                            with st.form(f"edit_form_{task_id}"):
                                edit_title = st.text_input("Title", value=title)
                                edit_desc = st.text_area("Description", value=desc)
                                edit_status = st.checkbox("Completed", value=status)
                                update_submit = st.form_submit_button("Save")
                                if update_submit:
                                    update_res = update_task(task_id, edit_title, edit_desc, edit_status)
                                    if update_res.status_code == 200:
                                        st.success("Updated!")
                                        st.rerun()
                                    else:
                                        st.error("Failed to update.")
                                        
                    with col3:
                        if st.button("Delete", key=f"delete_{task_id}", type="primary"):
                            del_res = delete_task(task_id)
                            if del_res.status_code == 200:
                                st.success("Deleted!")
                                st.rerun()
                            else:
                                st.error("Failed to delete.")
                    st.divider()
    else:
        st.error(f"Failed to fetch tasks: {response.text}")

tasks_page()
