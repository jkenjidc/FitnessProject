# ⚙️ Setup Guide

## Prerequisites

Before you begin, ensure you have the following installed:

- **macOS**: 13.0 (Ventura) or later
- **Xcode**: 15.0 or later
- **iOS Simulator**: iOS 16.0 or later
- **Git**: For version control
- **Apple Developer Account**: For device testing (optional)

## Installation Steps

### 1. Clone the Repository

```bash
# Clone the repository
git clone https://github.com/yourusername/FitnessProject.git

# Navigate to the project directory
cd FitnessProject
```

### 2. Open in Xcode

```bash
# Open the project in Xcode
open FitnessProject.xcodeproj
```

Alternatively, you can:
- Launch Xcode
- File → Open → Navigate to `FitnessProject.xcodeproj`

### 3. Configure API Keys (Optional)

If you plan to use the exercise database features:

1. **Get ExerciseDB API Key**:
   - Visit [RapidAPI ExerciseDB](https://rapidapi.com/justin-WFnsXH_t6/api/exercisedb)
   - Subscribe to get your API key
   - Remember to add this file to your .gitignore file list

2. **Add API Configuration**:
   ```swift
   // In FitnessProject/Utilities/Constants/API.swift
   struct API {
       static let key = "your_rapidapi_key_here"
       static let header = "exercisedb.p.rapidapi.com"
   }
   ```

### 3. Build and Run

1. **Select Target**:
   - Choose `FitnessProject` scheme
   - Select iOS Simulator or connected device

2. **Build the Project**:
   - Press `Cmd + B` to build
   - Resolve any build errors if they occur

3. **Run the App**:
   - Press `Cmd + R` to run
   - The app should launch in the simulator

## Configuration Options

### HealthKit Setup

To enable HealthKit features:

1. **Add HealthKit Capability**:
   - Project Settings → Signing & Capabilities
   - Click `+ Capability`
   - Add `HealthKit`

2. **Configure Info.plist**:
   ```xml
   <key>NSHealthShareUsageDescription</key>
   <string>This app needs access to read your health data to track fitness progress.</string>
   ```

### Development Team Setup

For device testing:

1. **Configure Signing**:
   - Project Settings → Signing & Capabilities
   - Select your development team
   - Choose automatic signing

2. **Bundle Identifier**:
   - Update to your preferred bundle ID
   - Ensure it's unique across your developer account

## Troubleshooting

### Common Build Issues

**"No such module 'HealthKit'"**
```bash
# Solution: Ensure HealthKit capability is added
# Project → Signing & Capabilities → + Capability → HealthKit
```

**"Could not find developer disk image"**
```bash
# Solution: Update Xcode or use a compatible iOS version
# Xcode → Preferences → Components → Download iOS simulators
```

**API Key Not Working**
```bash
# Solution: Verify API key is correctly configured
# Check API.swift file or environment variables
# Ensure RapidAPI subscription is active
```

### Simulator Issues

**App Crashes on Launch**
```bash
# Reset simulator
# Device → Erase All Content and Settings
# Or try different simulator device
```

**HealthKit Not Available**
```bash
# HealthKit is not available in simulator
# Use physical device for HealthKit testing
# Or mock HealthKit data for development
```

## Development Environment

### Recommended Xcode Settings

1. **Code Formatting**:
   - Xcode → Preferences → Text Editing → Indentation
   - Use spaces, 4 spaces per tab

2. **Build Settings**:
   - Enable "Treat Warnings as Errors" for production builds
   - Set deployment target to iOS 16.0

3. **Simulator Configuration**:
   - Use iPhone 15 Pro simulator for development
   - Test on multiple screen sizes

### Git Configuration

```bash
# Configure Git for the project
git config user.name "Your Name"
git config user.email "your.email@example.com"

# Set up pre-commit hooks (optional)
# This ensures code quality before commits
```

## Next Steps

After successful setup:

1. **Explore the Code**: Start with `RootView.swift` to understand app flow
2. **Run Tests**: Press `Cmd + U` to run the test suite
3. **Try Features**: Navigate through tabs to see implemented functionality
4. **Check Documentation**: Review other docs for architecture details

## Getting Help

If you encounter issues:

1. **Check Issues**: Look at GitHub issues for known problems
2. **Xcode Clean**: Try `Product → Clean Build Folder`
3. **Restart Xcode**: Sometimes helps with build issues
4. **Update Tools**: Ensure Xcode and tools are up to date

## Development Workflow

```bash
# Typical development workflow
git checkout -b feature/new-feature
# Make your changes
git add .
git commit -m "Add new feature"
git push origin feature/new-feature
# Create pull request
```

Your development environment is now ready! 🚀

