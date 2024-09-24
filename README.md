# SnapDictionary

**SnapDictionary** is an iOS application that combines the power of on-device OCR (Optical Character Recognition) with a dictionary to provide instant definitions of words captured from your camera. Simply snap a photo of text, tap on any recognized word, and get its definition—all within a seamless and intuitive user interface built with SwiftUI and MVVM architecture.

---

## Table of Contents

- [Features](#features)
- [Screenshots](#screenshots)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Architecture](#architecture)
- [Feature Roadmap](#feature-roadmap)
- [License](#license)
- [Acknowledgments](#acknowledgments)

---

## Features

- **Live Camera Preview**: Utilize your device's camera to capture real-time images of text.
- **On-Device OCR**: Perform fast and private text recognition using Apple's Vision framework.
- **Interactive Text Selection**: Tap on any recognized word directly on the image.
- **Instant Definitions**: Fetch definitions from an online dictionary API and display them in-app.
- **Modern UI**: Enjoy a clean and user-friendly interface designed with SwiftUI.
- **Privacy-Focused**: All image processing is done on-device; your data stays with you.

---

## Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/e7d0433e-6ef5-4110-af90-dd869f4a8b51" alt="Screenshot 1" width="300"/>
  <img src="https://github.com/user-attachments/assets/56fd42a3-8d47-4e4e-8bac-5bad88400813" alt="Screenshot 2" width="300"/>
</p>


---

## Requirements

- **iOS 15.0** or later
- **Xcode 13** or later
- **Swift 5.5** or later

---

## Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/AugustAtSeattle/SnapDictionary.git
   ```

2. **Open the Project**

   - Navigate to the project directory.
   - Open `SnapDictionary.xcodeproj` with Xcode.

3. **Install Dependencies**

   - No external dependencies are required for this project.

4. **Run the App**

   - Select an iOS Simulator or connect your iOS device.
   - Click the **Run** button in Xcode or press `Command + R`.

---

## Usage

1. **Launch the App**

   - Open the SnapDictionary app on your iOS device.

2. **Capture Text**

   - Tap the **Capture Image** button to open the camera.
   - Align text within the camera frame and tap the shutter button to take a photo.

3. **Select Recognized Text**

   - After capturing, the app will display the image with overlays on recognized words.
   - Tap on any overlay to select a word.

4. **View Definitions**

   - A drawer will appear from the bottom, displaying the definition of the selected word.
   - Swipe down or tap the close button to dismiss the definition drawer.

---

## Project Structure

```text
SnapDictionary
├── App
│   ├── SnapDictionaryApp.swift
│   ├── ContentView.swift
│   └── Assets.xcassets
├── Modules
│   ├── Camera
│   │   ├── Views
│   │   │   ├── CameraView.swift
│   │   │   └── CameraPreviewView.swift
│   │   ├── ViewModels
│   │   │   └── CameraViewModel.swift
│   │   └── Services
│   │       └── CameraService.swift
│   ├── OCR
│   │   ├── Views
│   │   │   ├── CapturedImageView.swift
│   │   │   └── TextOverlayView.swift
│   │   ├── ViewModels
│   │   │   └── OCRViewModel.swift
│   │   └── Models
│   │       └── RecognizedText.swift
│   └── Dictionary
│       ├── Views
│       │   └── DictionaryDrawerView.swift
│       ├── ViewModels
│       │   └── DictionaryViewModel.swift
│       └── Services
│           └── DictionaryService.swift
├── Common
│   └── Extensions
│       └── [Any shared extensions]
└── Resources
    └── [Any additional resources]
```

---

## Architecture

The project follows the **MVVM (Model-View-ViewModel)** architectural pattern, promoting a clear separation of concerns:

- **Views**: SwiftUI views that handle the UI components.
- **ViewModels**: `ObservableObject` classes that manage business logic and state.
- **Models**: Data structures representing the application's data.
- **Services**: Classes responsible for handling specific functionalities like networking and camera operations.

---

## Feature Roadmap

This section lists planned features and enhancements to the app.

- **Support Images in Dictionary**: Add support for displaying images related to words in the dictionary drawer.
- **Cache Word Lookup Results**: Implement a caching mechanism to store word lookup results for offline access and faster repeated queries.
- **Support Oxford Dictionaries API**: Integrate with the Oxford Dictionaries API to provide richer, more accurate word definitions.
- **Support Word History UI**: Add a feature to track and display a history of word lookups in the app.
- **Persist Word Lookup Results**: Ensure word lookup results persist between sessions to improve the user experience and reduce data consumption.

---

## License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- **Apple's Vision Framework**: For providing powerful on-device OCR capabilities.
- **dictionaryapi.dev**: For the free dictionary API used to fetch word definitions.
- **SwiftUI**: For enabling the creation of modern and reactive user interfaces.
- **Community Contributors**: Thank you to everyone who has contributed to this project.
