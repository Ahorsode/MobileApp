# Mid-Semester Exam — Walkthrough

## What Was Built

A Flutter **Student Profile & Task Manager** app that satisfies all requirements from Question 4, Section B.

---

## Part A: Project Setup & Data Models ✅

**Folder structure created:**
```
lib/
├── models/
│   ├── student.dart
│   └── task.dart
├── screens/
│   ├── profile_screen.dart
│   └── task_list_screen.dart
└── widgets/
```

**[Student](file:///c:/Users/ahors/Documents/mobile_app/MobileApp/midsem_exam/lib/models/student.dart#2-16) model** ([lib/models/student.dart](file:///c:/Users/ahors/Documents/mobile_app/MobileApp/midsem_exam/lib/models/student.dart)):
- Fields: `name`, `studentId`, `programme`, `level`
- Named constructor with required parameters

**[Task](file:///c:/Users/ahors/Documents/mobile_app/MobileApp/midsem_exam/lib/models/task.dart#2-17) model** ([lib/models/task.dart](file:///c:/Users/ahors/Documents/mobile_app/MobileApp/midsem_exam/lib/models/task.dart)):
- Fields: `title`, `courseCode`, `dueDate`, `isComplete` (default `false`)
- Named constructor with required parameters

---

## Part B: Profile Screen with Navigation ✅

**[ProfileScreen](file:///c:/Users/ahors/Documents/mobile_app/MobileApp/midsem_exam/lib/screens/profile_screen.dart#6-86)** ([lib/screens/profile_screen.dart](file:///c:/Users/ahors/Documents/mobile_app/MobileApp/midsem_exam/lib/screens/profile_screen.dart)):
- `CircleAvatar` showing the student's initial
- `Card` widget displaying name, ID, programme, and level
- **"Edit Profile"** `ElevatedButton` (UI only, no action required)
- **"View Tasks"** `ElevatedButton` that navigates to [TaskListScreen](file:///c:/Users/ahors/Documents/mobile_app/MobileApp/midsem_exam/lib/screens/task_list_screen.dart#6-12)

**[TaskListScreen](file:///c:/Users/ahors/Documents/mobile_app/MobileApp/midsem_exam/lib/screens/task_list_screen.dart#6-12)** ([lib/screens/task_list_screen.dart](file:///c:/Users/ahors/Documents/mobile_app/MobileApp/midsem_exam/lib/screens/task_list_screen.dart)):
- `ListView` of at least 3 hardcoded tasks
- Each tile shows: task title, course code, due date (`dd/MM/yyyy`), and a checkbox

---

## Part C: State Management ✅

**[TaskListScreen](file:///c:/Users/ahors/Documents/mobile_app/MobileApp/midsem_exam/lib/screens/task_list_screen.dart#6-12) converted to `StatefulWidget`:**
- `FloatingActionButton` opens a dialog with two `TextField` widgets (title, course code) and a **date picker**
- On save, new [Task](file:///c:/Users/ahors/Documents/mobile_app/MobileApp/midsem_exam/lib/models/task.dart#2-17) is added to the list via `setState()`
- Checkbox tapping toggles `isComplete` via `setState()`, and completed tasks show with a **strikethrough**

---

## Verification

- `dart analyze` run on all 5 files — **No issues found**
- App runs without errors on device/simulator
- Git commits made at each major milestone:
  1. Initial project structure & data models
  2. ProfileScreen & TaskListScreen with navigation
  3. Stateful TaskListScreen with add-task dialog
  4. Final polish: const constructor fix
