# FitnessProject

A comprehensive SwiftUI fitness tracking application featuring workout routines, an exercise database, progress tracking, and HealthKit integration.

## 🎯 Overview

FitnessProject is a native iOS app built with SwiftUI that helps users create custom workout routines, track their fitness progress, and maintain consistent exercise habits. The app demonstrates modern iOS development patterns, clean architecture, and seamless integration with iOS health frameworks.

## ✨ Features

### Core Functionality
- **📋 Exercise Database**: Browse 1000+ exercises with detailed instructions and animations
- **🏋️ Custom Routines**: Create and manage personalized workout routines
- **⏱️ Smart Timer**: Built-in workout timer with pause/resume functionality
- **📊 Progress Tracking**: Visual progress charts and workout history
- **💪 HealthKit Integration**: Sync with Apple Health for step counting and health metrics
<!-- 
## 📱 Screenshots

*[Add 3-4 key screenshots showing main features]*

| Exercise Database | Workout Timer | Progress Tracking |
|-------------------|---------------|-------------------|
| ![Exercise DB](screenshots/exercises.png) | ![Timer](screenshots/timer.png) | ![Progress](screenshots/progress.png) | -->

## 🚀 Quick Start

### Prerequisites
- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

### Installation
```bash
git clone https://github.com/yourusername/FitnessProject.git
cd FitnessProject
open FitnessProject.xcodeproj
```

For detailed setup instructions, see [SETUP.md](docs/SETUP.md).

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [🏗️ Architecture](docs/ARCHITECTURE.md) | Technical architecture, patterns, and design decisions |
| [🛠️ Tech Stack](docs/TECH_STACK.md) | Complete technology overview and dependencies |
| [📁 Project Structure](docs/PROJECT_STRUCTURE.md) | Codebase organization and file structure |
| [⚙️ Setup Guide](docs/SETUP.md) | Detailed installation and configuration |
| [🧪 Testing](docs/TESTING.md) | Testing strategy and running tests |
| [🚧 Development](docs/DEVELOPMENT.md) | Development status and roadmap |
| [🤝 Contributing](docs/CONTRIBUTING.md) | How to contribute to the project |

## 🎨 Code Examples

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

For more examples, see [docs/CODE_EXAMPLES.md](docs/CODE_EXAMPLES.md).

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Kenji Dela Cruz**
- GitHub: [@jkenjidc](https://github.com/jkenjidc)
- LinkedIn: [Kenji Dela Cruz](https://www.linkedin.com/in/jkdc06)
- Email: kenjidckenji@gmail.com

---

*Built with ❤️ using SwiftUI and modern iOS development practices*