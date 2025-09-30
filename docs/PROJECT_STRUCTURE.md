# 📁 Project Structure

## High-Level Organization

```
FitnessProject/
├── 📁 Core/                    # Business logic & services
├── 📁 Views/                   # SwiftUI views & UI components
├── 📁 DataModels/              # Data structures & models
├── 📁 Utilities/               # Helpers, extensions & utilities
├── 📁 Resources/               # Assets, configs & static files
└── 📁 Tests/                   # Unit & integration tests
```

## Detailed Structure

### 📁 Core/
**Business logic and service layer**
- Migration is underway to convert the managers to have more robust error handling and follow service pattern
```
Core/
├── ExerciseService.swift        # Exercise data management
├── HealthKitManager.swift       # Health integration service
├── DataManager.swift            # User data persistence
├── Router.swift                 # Navigation coordination
└── AuthManager.swift            # Authentication handling
```

### 📁 Views/
**SwiftUI views organized by feature**
```
Views/
├── 📁 Tabs/                         # Tab-based screens
│   ├── ExercisesTab/                # Exercise browsing & details
│   ├── RoutineTab/                  # Workout routines & timer
│   └── ProgressTab/                 # Progress tracking & charts
├── 📁 ComponentViews/               # Reusable UI components
│   ├── SearchBar.swift              # Search input component
│   ├── EntryFieldView.swift         # Form input fields
│   └── ShimmerLoadingView.swift     # Loading animations
├── 📁 CoreViews/                    # App-level navigation
│   ├── MainNavigationView.swift     # Tab navigation
│   └── RootView.swift               # App entry point
└── 📁 Modals/                       # Modal presentations
    ├── RoutineDetailModal.swift     # Routine detail popup
    └── WeightEntryModal.swift       # Weight input modal
```

### 📁 DataModels/
**Data structures and model objects**
```
DataModels/
├── ExerciseV2.swift            # Exercise data model
├── Routine.swift               # Workout routine model
├── User.swift                  # User profile model
├── RoutineHistoryRecord.swift  # Workout history
```

### 📁 Utilities/
**Helper functions and extensions**
```
Utilities/
├── 📁 Extensions/              # Swift extensions
│   ├── Date+Extensions.swift   # Date helper methods
│   ├── Array+Extensions.swift  # Array Helpers
├── 📁 Networking/              # Network layer
│   ├── APIRequest.swift        # Request protocols
│   ├── ExerciseV2Request.swift # Exercise API requests
│   └── DTOs/                   # Data transfer objects
├── 📁 ViewModifiers/           # Utility classes
│   ├── ModalModifier.swift     # Repeated Style Modifier
│   └── InjectServices.swift    # Convenience Service Injector
```

## Architecture Principles

### 📦 **Modular Design**
- Each folder represents a distinct layer of the application
- Clear separation between UI, business logic, and data

### 🔄 **Dependency Flow**
```
Views → Core Services → Data Models → Utilities
```
- Views depend on services, not the other way around
- Services handle business logic and data management
- Models are pure data structures with minimal logic

### 🎯 **Single Responsibility**
- Each file has a clear, single purpose
- Large files are broken into smaller, focused components
- Related functionality is grouped together

### 🧪 **Testability**
- Business logic separated from UI for easier testing
- Services can be mocked and tested independently
- Clear interfaces between layers

## File Naming Conventions

### **Views**
- `*View.swift` - SwiftUI views
- `*Screen.swift` - Full-screen views
- `*Modal.swift` - Modal presentations

### **Services**
- `*Manager.swift` - Singleton services
- `*Service.swift` - Stateful services

### **Models**
- `*.swift` - Simple naming for data models
- `*DTO.swift` - Data transfer objects
- `*Request.swift` - API request objects

This structure promotes maintainability, testability, and clear separation of concerns throughout the application.

