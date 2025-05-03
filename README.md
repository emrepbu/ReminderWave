# ReminderWave - iOS To-Do Application

![Status](https://img.shields.io/badge/Status-Development-yellow)
![Purpose](https://img.shields.io/badge/Purpose-Educational-blue)

## Overview
<img src="https://github.com/user-attachments/assets/c0e53aa0-ecd2-4964-8495-10b5a14ce615" width="200"/>

ReminderWave is a modern task reminder and management application developed using SwiftUI and Swift Data. Following the MVVM architecture, this app allows users to organize their tasks, categorize them by priority, and receive reminders when due.

The application is built with modern iOS technologies and includes features such as multilingual support (English and Turkish), persistent data storage, local notifications, and filtering options.

## Architecture

![reminderwave-visual](https://github.com/user-attachments/assets/92e7ad83-80a4-4fcf-94d7-9f2f6ecae207)

*Architecture diagram showing the MVVM structure and relationships between components of the ReminderWave app.*

## Features

### Main Features
- **Task Management**: Create, edit, delete, and complete tasks
- **Priority Setting**: Assign low, medium, or high priority to each task
- **Scheduling**: Set date and time for tasks
- **Notifications**: Receive local notifications when tasks are due
- **Filtering**: View all, active, or completed tasks
- **Multilingual Support**: English and Turkish languages
- **Color Coding**: Visualize approaching deadlines with color codes
- **Persistent Storage**: Securely store data on the device using SwiftData

### Technical Features
- **SwiftUI**: Modern, declarative UI design
- **Swift Data**: Database management
- **MVVM Architecture**: Modular and testable code structure
- **Protocol-Oriented Design**: Extensible and flexible structure
- **Local Notifications**: UserNotifications framework integration
- **Localization**: Full multilingual support
- **Accessibility**: Compliance with iOS accessibility features

## Application Components

### Models
- **Task.swift**: Task data model
- **RWTaskPriority.swift**: Task priority enum

### Services
- **TaskServiceProtocol & SwiftDataTaskService**: Service interface and implementation for data operations
- **NotificationServiceProtocol & LocalNotificationService**: Notification management

### ViewModels
- **TaskListViewModel**: Data and logic management for the main list screen
- **AddTaskViewModel**: Form management for the new task addition screen

### Views
- **ContentView**: Main entry point
- **TaskListView**: Task list screen
- **TaskRowView**: Individual task row component
- **AddTaskView**: New task addition form

## Setup and Running

### Requirements
- iOS 18.0 or higher
- Xcode 16.0 or higher
- Swift 6.0 or higher

### Installation Steps
1. Clone or download the project
2. Open the `ReminderWave.xcodeproj` file with Xcode
3. Select your target device (simulator or physical iOS device)
4. Build and run the application (⌘+R)

## Usage

1. On the main screen, you will see a list of your tasks
2. Tap the + button in the bottom right corner to add a new task
3. For each task, you can specify title, notes, due date, time, and priority
4. If desired, you can receive notifications when the task is due
5. Use swipe actions to mark tasks as completed or delete them
6. Use the segments at the top of the screen to filter tasks
7. Tap the globe icon in the upper right corner to change the language

## Project Status

⚠️ **This project is currently in development.**

This app is being developed as an example project showcasing modern iOS technologies. While the core features are complete, the following enhancements are planned:

## Future Enhancements

Future developments planned for the project:

- [ ] **Firebase Integration**: Cloud synchronization for data
- [ ] **Category System**: Categorize tasks
- [ ] **Recurring Tasks**: Daily, weekly, monthly recurring tasks
- [ ] **Widget Support**: Home screen widgets
- [ ] **Statistics**: Task completion statistics and graphs
- [ ] **Theme Support**: Light/dark and custom themes
- [ ] **Comprehensive Tests**: Unit tests and UI tests
- [ ] **Sharing Features**: Share tasks with other apps or people
- [ ] iOS Live Activities: Real-time notifications on the Lock Screen, in Dynamic Island, and as interactive notifications on the device screen

## Technical Details

- **Data Storage**: Object graph and relational data management with SwiftData
- **UI**: Fully declarative user interface with SwiftUI
- **Asynchronous Operations**: Swift's async/await features
- **Architecture**: MVVM (Model-View-ViewModel) pattern
- **Dependency Injection**: Manual DI approach
- **Modularity**: Modular design for easy extensibility

## Build and Deploy

This project uses GitHub Actions for automated builds and releases. The workflow is triggered when a new tag (v*) is pushed to the repository.

### Build Process
1. The workflow uses Xcode 15.0 to build the application
2. Creates an archive of the app
3. Exports the app as an IPA file

### Release Process
1. Automatically creates a new release on GitHub
2. Attaches the IPA file to the release
3. Includes build information in the release notes

To create a new release:
```bash
git tag -a v1.0.0 -m "Release 1.0.0"
git push origin v1.0.0
```

### Requirements for Build
- A valid Apple Developer Team ID (configured in `exportOptions.plist`)
- GitHub Personal Access Token with appropriate permissions

## Contributing

Contributions are welcome! To add new features, fix bugs, or make improvements, follow these steps:

1. Fork this repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Create a Pull Request

## License

[MIT License](LICENSE)
