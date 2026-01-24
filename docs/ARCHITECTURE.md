# 🏗️ Architecture & Technical Design

## Architecture Pattern

```
├── 🏛️ Model View + Services Architecture
├── 🎯 Environment Based Dependency Injection
└── 📱 SwiftUI Lifecycle
└── ⬿ Coordinator Pattern for Routing
```

## Key Technical Implementations

### State Management
- `@Observable` macro for modern state management
- Centralized `Router` for navigation flow
- Service-layer architecture for data management

### Network Layer
```swift
// Clean API abstraction with error handling
class ExerciseService {
    enum NetworkState {
        case loading
        case loaded(exercises: [ExerciseV2])
        case error(ExerciseServiceError)
    }
}
```
- **Async/Await**: Modern concurrency patterns
- **Caching Strategy**: Smart caching to minimize API calls
- **Data Validation**: Input sanitization and validation

## Design Patterns & Best Practices

### Clean Code Principles
- **Single Responsibility**: Each class has one clear purpose
- **Dependency Injection**: Services injected via `.environment`
- **Error Handling**: Comprehensive error states and recovery
- **Type Safety**: Strong typing throughout the codebase

### SwiftUI Best Practices
- **View Composition**: Small, focused view components
- **State Management**: Proper use of @State, @Binding, @Observable
- **Accessibility**: VoiceOver support and semantic labels
