# 🛠️ Technology Stack

## Core Technologies

| Category | Technologies | Purpose |
|----------|-------------|---------|
| **UI Framework** | SwiftUI | Modern declarative UI development |
| **Architecture** | MVVM, Service Layer | Clean separation of concerns |
| **Networking** | URLSession, async/await | HTTP requests and API integration |
| **Data Persistence** | UserDefaults, Core Data | Local data storage and caching |
| **Health Integration** | HealthKit Framework | iOS health data integration |
| **Charts & Visualization** | Swift Charts | Data visualization and progress tracking |
| **Testing** | SwiftTesting, XCUI Testing | Unit and integration testing |

## Dependencies

### First-Party Apple Frameworks
- **SwiftUI**: Primary UI framework
- **HealthKit**: Health data integration
- **Charts**: Data visualization

### Third-Party Libraries
- **Firebase Auth**: Authentication SDK
- **Firebase Firestore & DB**: Cloud-storage Library

## API Integration

### Exercise Database API
- **Provider**: ExerciseDB (RapidAPI)
- **Purpose**: Exercise data and instructions
- **Caching**: Custom URLCache implementation
- **Rate Limiting**: AsyncSemaphore for request throttling

### Future Integrations
- **Firebase Crashlytics**: Error Reporting
- **Nutrition DB**: Potential Meal Tracking Feature

