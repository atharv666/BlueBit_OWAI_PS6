# PS6: AI-Powered Prescription Scanner & Generic Medicine Recommender

## Project Overview

The AI-Powered Prescription Scanner and Generic Medicine Recommender is a Flutter-based mobile application that enables users to scan prescriptions and receive recommendations for generic medicines based on the scanned data. This app leverages Optical Character Recognition (OCR) to extract text from prescriptions and uses leverages AI to suggest cost-effective generic alternatives.

## 📌Features
- **Prescription Scanner**: Utilizes OCR technology to scan and extract text from prescriptions.
- **Generic Medicine Recommender**: Based on the extracted prescription data, it recommends generic alternatives to branded medicines.
- **User Authentication**: Allows users to log in and sign up using their credentials.
- **Profile Management**: Users can view and update their profiles.
- **Community Forum**: A forum where users can engage with others regarding healthcare, medicine, and prescriptions.
- **Splash Screen**: A welcome screen that introduces the app to users.

## 🛠️ Project Structure
lib/
├── models/<br>
│   ├── bottom_nav_bar.dart        # Custom Bottom Navigation Bar Component<br>
│   ├── shared_preferences.dart    # Local Storage Management<br>
│   ├── medicine.dart              # Medicine Data Model<br>
├── screens/<br>
│   ├── login_signup/              # Login and Signup Screens<br>
│   ├── home.dart                  # Home Page<br>
│   ├── ocr.dart                   # OCR Scanning Screen<br>
│   ├── profile.dart               # Profile Management<br>
│   ├── forum.dart                 # Community Discussion Forum<br>
│   ├── splash.dart                # Splash Screen<br>
└── main.dart                      # App Entry Point<br>

## 🧑‍💻 Installation & Setup
**Follow these steps to set up the project locally**:<br>
https://github.com/atharv666/gmr.git<br>
**Navigate to Project Directory**:<br>
cd gmr<br>
**Install Dependencies:**<br>
flutter pub get<br>
**Run the App:**<br>
flutter run<br>

## 🛎️ Requirements
- **Flutter 3.10+**
- **Dart 3.0+**
- **Android Studio or Visual Studio Code**
- **Firebase for backend services**
