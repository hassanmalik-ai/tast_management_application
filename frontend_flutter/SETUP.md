# Quick Setup Guide

## 5-Minute Integration

### Step 1: Copy Files to Your Flutter Project

```bash
# If you're starting fresh:
flutter create task_management_app
cd task_management_app

# Copy all lib/ files from this project to your lib/ directory
# Copy pubspec.yaml dependencies to your pubspec.yaml
```

### Step 2: Update pubspec.yaml

Replace the `dependencies` section in your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  provider: ^6.0.0
  shared_preferences: ^2.2.0
  intl: ^0.19.0
  flutter_svg: ^2.0.0
```

Then run:
```bash
flutter pub get
```

### Step 3: Configure API Endpoint

Open `lib/services/api_service.dart` and update the `baseUrl`:

```dart
static const String baseUrl = 'http://YOUR_BACKEND_URL:8000/api';
```

**Common configurations:**
- **Local Development (Android)**: `http://10.0.2.2:8000/api`
- **Local Development (iOS)**: `http://localhost:8000/api`
- **Physical Device**: `http://YOUR_MACHINE_IP:8000/api`
- **Production**: `https://your-domain.com/api`

### Step 4: Run the App

```bash
flutter run
```

That's it! ✅

---

## Backend Integration Checklist

Your FastAPI backend needs these endpoints:

### Endpoints Checklist
- [ ] `GET /api/tasks` - Returns list of tasks
- [ ] `GET /api/tasks/{id}` - Returns single task
- [ ] `POST /api/tasks` - Creates task, returns created task with ID
- [ ] `PUT /api/tasks/{id}` - Updates task, returns updated task
- [ ] `DELETE /api/tasks/{id}` - Deletes task (returns 200 or 204)
- [ ] `PATCH /api/tasks/{id}/toggle` - Toggles completion status

### Response Format Checklist

Ensure your API returns tasks in this format:

```json
{
  "id": 1,
  "title": "Sample Task",
  "description": "Task description",
  "is_completed": false,
  "priority": "medium",
  "due_date": "2024-12-31T00:00:00",
  "created_at": "2024-01-01T00:00:00",
  "updated_at": "2024-01-01T00:00:00"
}
```

### CORS Configuration

**IMPORTANT**: Enable CORS in your FastAPI app:

```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # For dev only. Use specific IPs for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

---

## Testing the Integration

### 1. Test API Connection

Add this temporary test in your app:

```dart
import 'package:task_management_app/services/api_service.dart';

void testAPI() async {
  try {
    final tasks = await ApiService().getTasks();
    print('Success: ${tasks.length} tasks loaded');
  } catch (e) {
    print('Error: $e');
  }
}
```

### 2. Test Data Flow

1. **Start your backend**: `uvicorn main:app --reload`
2. **Run the Flutter app**: `flutter run`
3. **Check if tasks appear** on the home screen
4. **Try creating a task** using the + button
5. **Verify in backend database** that task was saved

### 3. Test Error Scenarios

- Kill the backend and try to load tasks (should show error with retry)
- Create task with empty title (form should validate)
- Toggle task completion (should update immediately)
- Delete task (should ask for confirmation)

---

## Troubleshooting

### Issue: "Connection refused"

**Solution:**
- Android Emulator: Use `10.0.2.2:8000` instead of `localhost:8000`
- Check if backend is running: `curl http://localhost:8000/api/tasks`

### Issue: "CORS error" or "No 'Access-Control-Allow-Origin'"

**Solution:**
```python
# Add to your FastAPI app
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

### Issue: "Tasks not loading but no error shown"

**Solution:**
1. Check Flutter console logs: `flutter logs`
2. Check backend logs for API errors
3. Verify API response format matches expected structure
4. Test API with Postman or curl:
   ```bash
   curl http://localhost:8000/api/tasks
   ```

### Issue: "Task doesn't update after creation"

**Solution:**
- Ensure API returns full task object with `id` field
- Check that `Task.fromJson()` correctly parses the response
- Verify `is_completed` field is included in response

---

## Environment Configuration (Optional)

For managing different environments, create a config file:

**lib/config/app_config.dart:**
```dart
abstract class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://10.0.2.2:8000/api',
  );
  static const int apiTimeout = 30;
}
```

Then run with:
```bash
flutter run --dart-define=API_URL=http://your-api:8000/api
```

---

## Database Structure Example

If you need to set up the backend database, here's a suggested schema:

### SQLAlchemy/Pydantic Model Example:

```python
from sqlalchemy import Column, Integer, String, Boolean, DateTime
from datetime import datetime
from typing import Optional

class TaskModel(Base):
    __tablename__ = "tasks"

    id = Column(Integer, primary_key=True)
    title = Column(String(200), nullable=False)
    description = Column(String(1000), nullable=True)
    is_completed = Column(Boolean, default=False)
    priority = Column(String(20), default="medium")  # low, medium, high
    due_date = Column(DateTime, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

class TaskSchema(BaseModel):
    title: str
    description: Optional[str] = None
    is_completed: bool = False
    priority: str = "medium"
    due_date: Optional[datetime] = None

    class Config:
        from_attributes = True
```

---

## Production Deployment

### Before Going Live:

1. **Update API URL**: Change from localhost to production domain
2. **Use HTTPS**: Update `http://` to `https://`
3. **Restrict CORS**: Change from `allow_origins=["*"]` to specific IPs
4. **Add Authentication**: Consider adding JWT tokens
5. **Test Thoroughly**: Test on physical devices and different networks
6. **Error Logging**: Implement error tracking (Sentry, etc.)

### Example Production Config:

```dart
static const String baseUrl = 'https://api.yourdomain.com/api';
```

```python
# FastAPI production CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://yourdomain.com"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

---

## Need Help?

1. **Check README.md** for detailed feature documentation
2. **Review API responses** with Postman
3. **Check Flutter logs**: `flutter logs -v`
4. **Verify database**: Check your backend database directly
5. **Test endpoints**: Use curl or Postman before debugging frontend

---

## Success Checklist

- [ ] Dependencies installed (`flutter pub get`)
- [ ] API URL configured correctly
- [ ] Backend is running and accessible
- [ ] Tasks load on app startup
- [ ] Can create new task
- [ ] Can edit existing task
- [ ] Can delete task with confirmation
- [ ] Can toggle task completion
- [ ] Can filter tasks (All, Completed, Pending)
- [ ] Can sort tasks (Date, Priority, Name)
- [ ] Error messages display correctly
- [ ] Refresh works (pull down on task list)

**All checked? You're ready to go! 🎉**
