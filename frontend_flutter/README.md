# Task Management App - Flutter Frontend

A clean, systematic Flutter frontend for a task management application. This app integrates with a FastAPI backend to provide complete CRUD operations for tasks.

## Features

- ✅ **View Tasks**: Display all tasks with filtering and sorting options
- ✅ **Create Tasks**: Add new tasks with title, description, priority, and due date
- ✅ **Update Tasks**: Edit existing tasks
- ✅ **Delete Tasks**: Remove tasks with confirmation dialog
- ✅ **Toggle Status**: Mark tasks as complete/incomplete
- ✅ **Filter Tasks**: Filter by All, Completed, or Pending
- ✅ **Sort Tasks**: Sort by Due Date, Priority, or Name
- ✅ **Task Statistics**: View progress metrics and task counts
- ✅ **Responsive Design**: Clean and intuitive UI
- ✅ **Error Handling**: User-friendly error messages with retry options

## Project Structure

```
lib/
├── main.dart                 # App entry point with theme setup
├── models/
│   └── task_model.dart       # Task data model
├── providers/
│   └── task_provider.dart    # State management with Provider
├── services/
│   └── api_service.dart      # API communication with FastAPI backend
├── screens/
│   ├── home_screen.dart      # Main task list screen
│   └── add_task_screen.dart  # Create/Edit task screen
└── widgets/
    ├── task_card.dart        # Individual task display
    ├── task_stats.dart       # Task statistics widget
    └── filter_sort_bar.dart  # Filter and sort controls
```

## Installation & Setup

### 1. **Prerequisites**
- Flutter SDK >= 3.0.0
- FastAPI backend running (see Configuration below)

### 2. **Clone/Add to Your Project**
```bash
# Copy all Flutter files to your project
# Or clone this repository
```

### 3. **Install Dependencies**
```bash
flutter pub get
```

### 4. **Configure API Endpoint**
Edit `lib/services/api_service.dart` and update the `baseUrl`:

```dart
static const String baseUrl = 'http://your-api-url:8000/api';
```

**Important**: For development:
- Android Emulator: Use `http://10.0.2.2:8000/api` (Maps to localhost)
- iOS Simulator: Use `http://localhost:8000/api`
- Physical Device: Use your machine's IP address (e.g., `http://192.168.x.x:8000/api`)

### 5. **Run the App**
```bash
flutter run
```

## API Endpoints Expected

Your FastAPI backend should implement these endpoints:

### Tasks
- `GET /api/tasks` - Get all tasks
- `GET /api/tasks/{id}` - Get task by ID
- `POST /api/tasks` - Create new task
- `PUT /api/tasks/{id}` - Update task
- `DELETE /api/tasks/{id}` - Delete task
- `PATCH /api/tasks/{id}/toggle` - Toggle task completion status

## Expected Request/Response Format

### Task Model (JSON)
```json
{
  "id": 1,
  "title": "Task Title",
  "description": "Task description",
  "is_completed": false,
  "priority": "medium",
  "due_date": "2024-12-31T00:00:00",
  "created_at": "2024-01-01T00:00:00",
  "updated_at": "2024-01-01T00:00:00"
}
```

### Create Task Request
```json
{
  "title": "New Task",
  "description": "Optional description",
  "priority": "medium",
  "due_date": "2024-12-31T00:00:00"
}
```

## FastAPI Backend Example

Here's a minimal FastAPI setup that works with this frontend:

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional
from datetime import datetime

app = FastAPI()

# Enable CORS for Flutter app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class TaskCreate(BaseModel):
    title: str
    description: Optional[str] = None
    priority: str = "medium"
    due_date: Optional[datetime] = None
    is_completed: bool = False

class Task(TaskCreate):
    id: int
    created_at: datetime
    updated_at: datetime

# Your database and routes here...
tasks_db = []

@app.get("/api/tasks")
async def get_tasks():
    return tasks_db

@app.post("/api/tasks", status_code=201)
async def create_task(task: TaskCreate):
    # Implementation...
    pass

# ... other endpoints
```

## State Management

The app uses **Provider** for state management:
- `TaskProvider`: Manages tasks list, loading state, and filtering/sorting
- Automatic UI updates when tasks change
- Error handling with user feedback

## Features Breakdown

### Task Statistics
- Shows total, completed, and pending task counts
- Displays progress bar
- Updates in real-time

### Task Filtering
- **All**: Show all tasks
- **Completed**: Show only completed tasks
- **Pending**: Show only pending tasks

### Task Sorting
- **Due Date**: Sort by due date (earliest first)
- **Priority**: Sort by priority (high → medium → low)
- **Name**: Sort alphabetically by title

### Task Card
- Checkbox to toggle completion status
- Priority badge with color coding
- Due date badge (highlights overdue tasks in red)
- Edit and delete options
- Strikethrough text for completed tasks

## Customization

### Change App Theme
Edit the `ThemeData` in `lib/main.dart`:
```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue, // Change this color
  ),
  // ... other theme properties
),
```

### Add More Task Properties
1. Update `Task` model in `lib/models/task_model.dart`
2. Add fields to JSON serialization
3. Update `AddTaskScreen` form
4. Update `TaskCard` display

### Change API Timeout
Edit `lib/services/api_service.dart`:
```dart
static const Duration timeout = Duration(seconds: 30); // Change value
```

## Error Handling

The app handles common errors:
- Network connection failures
- API errors (with status codes)
- Form validation errors
- Empty lists with helpful empty state message

## Testing

### Test with Mock API
1. Create a simple mock server (e.g., using MockServer or Firebase Emulator)
2. Update `baseUrl` in `ApiService`
3. Run the app and test all CRUD operations

### Test Features
- Create a task
- Edit a task
- Delete a task
- Toggle completion status
- Test filtering and sorting
- Test error scenarios (disconnect WiFi, etc.)

## Performance Optimization

### Implemented
- ✅ Efficient list rendering with `ListView.builder`
- ✅ Provider for state management (minimal rebuilds)
- ✅ Proper resource cleanup (dispose controllers)
- ✅ Request timeout handling
- ✅ Refresh indicator for manual sync

### Future Improvements
- Add pagination for large task lists
- Implement local caching with Hive or Sqflite
- Add offline mode support
- Add animations and transitions
- Add task search functionality
- Add recurring tasks support

## Troubleshooting

### "Connection refused" Error
- **Android Emulator**: Use `10.0.2.2:8000` instead of `localhost:8000`
- **iOS Simulator**: Make sure backend is running on `localhost:8000`
- **Physical Device**: Use your machine's actual IP address

### Tasks Not Loading
1. Check if FastAPI backend is running
2. Verify API endpoint in `api_service.dart`
3. Check CORS settings in FastAPI
4. Look at network tab in device logs

### Form Validation Issues
- Ensure title is at least 3 characters
- Verify date format in JSON responses
- Check Flutter console for validation errors

## Dependencies

- **http**: For API requests
- **provider**: For state management
- **shared_preferences**: For local storage (optional)
- **intl**: For date formatting
- **flutter_svg**: For SVG support (optional)

## License

This project is open source and available under the MIT License.

## Support

For issues or questions:
1. Check the Troubleshooting section
2. Review the API endpoint implementations
3. Verify your FastAPI backend matches the expected format
4. Check Flutter console logs for detailed error messages

---

**Note**: This is a frontend-only implementation. Ensure your FastAPI backend is properly configured and running before using this app.
