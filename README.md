# FitnessProject

A comprehensive SwiftUI fitness tracking application featuring workout routines, exercise databases, progress tracking, and HealthKit integration.

## 🎯 Overview

FitnessProject is a native iOS app built with SwiftUI that helps users create custom workout routines, track their fitness progress, and maintain consistent exercise habits. The app demonstrates modern iOS development patterns, clean architecture, and seamless integration with iOS health frameworks.

## ✨ Features

### Core Functionality
- **📋 Exercise Database**: Browse 1000+ exercises with detailed instructions and animations
- **🏋️ Custom Routines**: Create and manage personalized workout routines
- **⏱️ Smart Timer**: Built-in workout timer with pause/resume functionality
- **📊 Progress Tracking**: Visual progress charts and workout history
- **💪 HealthKit Integration**: Sync with Apple Health for step counting and health metrics

### User Experience
- **🎨 Modern UI**: Clean SwiftUI interface with smooth animations
- **🌙 Dark Mode**: Full dark mode support
- **📱 Native Feel**: iOS-native navigation and interactions
- **⚡ Offline Support**: Cached exercise data for offline use

## 🏗️ Architecture & Technical Highlights

### Architecture Pattern
```
├── 🏛️ MVVM + Coordinator Architecture 
├── 🎯 Environment based Dependency Injection
└── 📱 Pure SwiftUI Interface
```

### Key Technical Implementations

#### **State Management**
- `@Observable` macro for modern state management
- Centralized `Router` for navigation flow
- Service-layer architecture for data management

#### **Network Layer**
```swift
// Clean API abstraction with error handling and Data Transfer Object Layer
class ExerciseService {
    enum NetworkState {
        case loading
        case loaded(exercises: [ExerciseV2])
        case error(ExerciseServiceError)
    }
}
```

#### **Caching Strategy**
- **URLCache** for API responses with custom expiration
- **UserDefaults** for user preferences and settings
- **Persistent storage** for workout history

#### **Concurrency**
- **Swift Concurrency** (async/await) for network operations
- **TaskGroup** for concurrent image loading
- **AsyncSemaphore** for rate limiting API calls

## 🛠️ Tech Stack

| Category | Technologies |
|----------|-------------|
| **UI Framework** | SwiftUI |
| **Architecture** | MVVM, Service Layer |
| **Networking** | URLSession, async/await |
| **Data Persistence** | UserDefaults, Core Data |
| **Health Integration** | HealthKit Framework |
| **Charts & Visualization** | Swift Charts |
| **Testing** | XCTest, UI Testing |

## 📱 Screenshots

| Exercise Database | Workout Timer | Progress Tracking |
|-------------------|---------------|-------------------|
| ![Exercise DB](screenshots/exercises.png) | ![Timer](screenshots/timer.png) | ![Progress](screenshots/progress.png) |

## 🚀 Getting Started

### Prerequisites
- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

### Installation
1. Clone the repository
```bash
git clone https://github.com/yourusername/FitnessProject.git
cd FitnessProject
```

2. Open in Xcode
```bash
open FitnessProject.xcodeproj
```

3. Add API Keys (if needed)
```swift
// Add to your environment or config
struct API {
    static let exerciseDBKey = "your_api_key_here"
}
```

4. Build and run on simulator or device

## 🏗️ Project Structure

```
FitnessProject/
├── 📁 Core/                    # Business logic & services
│   ├── ExerciseService.swift   # Exercise data management
│   ├── HealthKitManager.swift  # Health integration
│   └── DataManager.swift       # User data persistence
├── 📁 Views/                   # SwiftUI views
│   ├── Tabs/                   # Tab-based navigation
│   ├── ComponentViews/         # Reusable components
│   └── CoreViews/              # Main navigation
├── 📁 DataModels/              # Data structures
├── 📁 Utilities/               # Helpers & extensions
└── 📁 Resources/               # Assets & configuration
```

## 🎨 Design Patterns & Best Practices

### **Clean Code Principles**
- **Single Responsibility**: Each class has one clear purpose
- **Dependency Injection**: Services injected via environment
- **Error Handling**: Comprehensive error states and recovery
- **Type Safety**: Strong typing throughout the codebase

### **SwiftUI Best Practices**
- **View Composition**: Small, focused view components
- **State Management**: Proper use of @State, @Binding, @Observable
- **Performance**: Lazy loading and efficient list rendering
- **Accessibility**: VoiceOver support and semantic labels

### **Networking & Data**
- **Async/Await**: Modern concurrency patterns
- **Error Recovery**: Graceful fallbacks and retry logic
- **Caching Strategy**: Smart caching to minimize API calls
- **Data Validation**: Input sanitization and validation

## 🔧 Code Examples

### Custom View Modifier
```swift
struct CapsuleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .fontWeight(.medium)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.secondary)
            .clipShape(Capsule())
    }
}
```

### Service Layer Implementation
```swift
@Observable
class ExerciseService {
    var networkState: NetworkState = .idle
    
    func fetchExercises() async {
        networkState = .loading
        do {
            let exercises = try await fetchFromAPI()
            networkState = .loaded(exercises: exercises)
        } catch {
            networkState = .error(error)
        }
    }
}
```

## 🧪 Testing Strategy

- **Unit Tests**: Core business logic and data models
- **Integration Tests**: Service layer and API interactions  
- **UI Tests**: Critical user flows and navigation
- **Snapshot Tests**: Visual regression testing

## 📈 Performance Optimizations

- **Lazy Loading**: Exercise lists with pagination
- **Image Caching**: Efficient GIF loading and storage
- **Memory Management**: Proper cleanup and weak references
- **Network Optimization**: Request batching and rate limiting

## 🚧 Current Development Status

### ✅ Completed Features
- [x] Exercise database with search/filter
- [x] Custom routine creation
- [x] Workout timer functionality
- [x] Basic progress tracking
- [x] HealthKit step counter integration

### 🔄 In Progress
- [ ] General app polish
- [ ] Advanced progress analytics
- [ ] Apple Watch companion app
- [ ] Workout recommendations

### 📋 Future Enhancements
- [ ] Nutrition tracking
- [ ] Advanced workout analytics
- [ ] CoreML driven smart notifications

## 🤝 Contributing

While this is primarily a personal project, feedback and suggestions are welcome! Please feel free to:
- Open issues for bugs or feature requests
- Submit pull requests for improvements
- Share feedback on architecture or implementation

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Kenji Dela Cruz**
- GitHub: [@jkenjidc](https://github.com/jkenjidc)
- LinkedIn: [Kenji Dela Cruz](https://www.linkedin.com/in/jkdc06)
- Email: kenjidckenji@gmail.com

---

*Built with ❤️ using SwiftUI and modern iOS development practices*
