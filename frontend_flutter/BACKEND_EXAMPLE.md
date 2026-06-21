# FastAPI Backend Example

This is a sample FastAPI backend implementation that works with this Flutter frontend.

## Installation

```bash
pip install fastapi uvicorn sqlalchemy pydantic python-dotenv
```

## Minimal FastAPI Setup

Create a file named `main.py`:

```python
from fastapi import FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime
from enum import Enum

# Initialize FastAPI app
app = FastAPI(
    title="Task Management API",
    description="API for task management",
    version="1.0.0"
)

# Enable CORS for Flutter app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # For production, replace with specific domains
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ==================== Models ====================

class TaskPriority(str, Enum):
    LOW = "low"
    MEDIUM = "medium"
    HIGH = "high"

class TaskBase(BaseModel):
    title: str
    description: Optional[str] = None
    is_completed: bool = False
    priority: str = "medium"
    due_date: Optional[datetime] = None

class TaskCreate(TaskBase):
    pass

class TaskUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    is_completed: Optional[bool] = None
    priority: Optional[str] = None
    due_date: Optional[datetime] = None

class Task(TaskBase):
    id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

# ==================== In-Memory Database ====================
# For production, use SQLAlchemy with PostgreSQL/MySQL

tasks_db: List[dict] = []
task_id_counter = 1

# ==================== Routes ====================

@app.get("/")
async def root():
    return {"message": "Task Management API is running"}

@app.get("/api/tasks", response_model=List[Task])
async def get_tasks():
    """Get all tasks"""
    return tasks_db

@app.get("/api/tasks/{task_id}", response_model=Task)
async def get_task(task_id: int):
    """Get a specific task by ID"""
    task = next((t for t in tasks_db if t["id"] == task_id), None)
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    return task

@app.post("/api/tasks", response_model=Task, status_code=201)
async def create_task(task: TaskCreate):
    """Create a new task"""
    global task_id_counter
    
    now = datetime.utcnow()
    new_task = {
        "id": task_id_counter,
        "title": task.title,
        "description": task.description,
        "is_completed": task.is_completed,
        "priority": task.priority,
        "due_date": task.due_date,
        "created_at": now,
        "updated_at": now,
    }
    
    tasks_db.append(new_task)
    task_id_counter += 1
    
    return new_task

@app.put("/api/tasks/{task_id}", response_model=Task)
async def update_task(task_id: int, task_update: TaskUpdate):
    """Update an existing task"""
    task = next((t for t in tasks_db if t["id"] == task_id), None)
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    
    # Update only provided fields
    if task_update.title is not None:
        task["title"] = task_update.title
    if task_update.description is not None:
        task["description"] = task_update.description
    if task_update.is_completed is not None:
        task["is_completed"] = task_update.is_completed
    if task_update.priority is not None:
        task["priority"] = task_update.priority
    if task_update.due_date is not None:
        task["due_date"] = task_update.due_date
    
    task["updated_at"] = datetime.utcnow()
    
    return task

@app.delete("/api/tasks/{task_id}", status_code=204)
async def delete_task(task_id: int):
    """Delete a task"""
    task = next((t for t in tasks_db if t["id"] == task_id), None)
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    
    tasks_db.remove(task)
    return None

@app.patch("/api/tasks/{task_id}/toggle", response_model=Task)
async def toggle_task_status(task_id: int, task_update: dict):
    """Toggle task completion status"""
    task = next((t for t in tasks_db if t["id"] == task_id), None)
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    
    task["is_completed"] = task_update.get("is_completed", not task["is_completed"])
    task["updated_at"] = datetime.utcnow()
    
    return task

# ==================== Health Check ====================

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy"}

# ==================== Main ====================

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
```

## Run the Server

```bash
# Development (with auto-reload)
uvicorn main:app --reload

# Production
uvicorn main:app --host 0.0.0.0 --port 8000
```

Server will be available at: `http://localhost:8000`

## Full SQLAlchemy Implementation

For production, use SQLAlchemy with a real database:

```python
from fastapi import FastAPI
from sqlalchemy import create_engine, Column, Integer, String, Boolean, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from datetime import datetime
from typing import Optional

# Database setup
DATABASE_URL = "sqlite:///./tasks.db"
# For PostgreSQL: "postgresql://user:password@localhost/dbname"
# For MySQL: "mysql://user:password@localhost/dbname"

engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# Database model
class TaskModel(Base):
    __tablename__ = "tasks"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(200), nullable=False)
    description = Column(String(1000), nullable=True)
    is_completed = Column(Boolean, default=False)
    priority = Column(String(20), default="medium")
    due_date = Column(DateTime, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

# Create tables
Base.metadata.create_all(bind=engine)

# Pydantic schemas
from pydantic import BaseModel

class TaskSchema(BaseModel):
    id: int
    title: str
    description: Optional[str] = None
    is_completed: bool = False
    priority: str = "medium"
    due_date: Optional[datetime] = None
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Routes with database
@app.get("/api/tasks")
async def get_tasks(db: Session = Depends(get_db)):
    return db.query(TaskModel).all()

@app.post("/api/tasks", status_code=201)
async def create_task(task: TaskCreate, db: Session = Depends(get_db)):
    db_task = TaskModel(**task.dict())
    db.add(db_task)
    db.commit()
    db.refresh(db_task)
    return db_task

# ... other routes with database operations
```

## Testing with cURL

```bash
# Get all tasks
curl http://localhost:8000/api/tasks

# Create a task
curl -X POST http://localhost:8000/api/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Buy groceries",
    "description": "Milk, eggs, bread",
    "priority": "medium",
    "due_date": "2024-12-31T23:59:59"
  }'

# Update a task
curl -X PUT http://localhost:8000/api/tasks/1 \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Buy groceries (updated)",
    "is_completed": false
  }'

# Toggle task completion
curl -X PATCH http://localhost:8000/api/tasks/1/toggle \
  -H "Content-Type: application/json" \
  -d '{"is_completed": true}'

# Delete a task
curl -X DELETE http://localhost:8000/api/tasks/1
```

## Testing with Postman

1. Open Postman
2. Create a new collection "Task Management"
3. Add requests:

### GET All Tasks
- URL: `http://localhost:8000/api/tasks`
- Method: GET

### POST Create Task
- URL: `http://localhost:8000/api/tasks`
- Method: POST
- Body (JSON):
```json
{
  "title": "New Task",
  "description": "Task description",
  "priority": "medium",
  "due_date": "2024-12-31T23:59:59"
}
```

### PUT Update Task
- URL: `http://localhost:8000/api/tasks/1`
- Method: PUT
- Body (JSON):
```json
{
  "title": "Updated Task Title"
}
```

### PATCH Toggle Status
- URL: `http://localhost:8000/api/tasks/1/toggle`
- Method: PATCH
- Body (JSON):
```json
{
  "is_completed": true
}
```

### DELETE Task
- URL: `http://localhost:8000/api/tasks/1`
- Method: DELETE

## Environment Variables (.env)

Create a `.env` file:

```env
# Database
DATABASE_URL=sqlite:///./tasks.db

# API
API_HOST=0.0.0.0
API_PORT=8000
API_DEBUG=True

# CORS
ALLOWED_ORIGINS=["*"]
```

Load with:
```python
from dotenv import load_dotenv
import os

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
API_HOST = os.getenv("API_HOST", "0.0.0.0")
API_PORT = int(os.getenv("API_PORT", 8000))
```

## Project Structure

```
backend/
├── main.py           # Main API file
├── models.py         # SQLAlchemy models
├── schemas.py        # Pydantic schemas
├── database.py       # Database configuration
├── requirements.txt  # Dependencies
├── .env             # Environment variables
└── .gitignore
```

## Production Deployment

### Using Gunicorn

```bash
pip install gunicorn

# Run with Gunicorn
gunicorn -w 4 -k uvicorn.workers.UvicornWorker main:app --bind 0.0.0.0:8000
```

### Docker

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

Build and run:
```bash
docker build -t task-api .
docker run -p 8000:8000 task-api
```

## Important Notes for Flutter Integration

1. **CORS**: Ensure CORS is enabled for your Flutter app's domain
2. **Response Format**: Tasks must match the Flutter Task model
3. **DateTime Format**: Use ISO 8601 format (`2024-12-31T23:59:59`)
4. **Status Codes**: Return 200/201 for success, 4xx for client errors, 5xx for server errors
5. **Error Handling**: Return JSON error messages the Flutter app can parse

Example error response:
```json
{
  "detail": "Task not found"
}
```

## Debugging

Enable logging:
```python
import logging

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

@app.get("/api/tasks")
async def get_tasks():
    logger.debug("Getting all tasks")
    return tasks_db
```

Check logs:
```bash
# With auto-reload
uvicorn main:app --reload --log-level debug
```

---

This example gives you a fully functional backend to work with the Flutter frontend! Customize as needed for your requirements.
