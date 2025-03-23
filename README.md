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

##🛠️ Project Structure
lib/
├── models/
│   ├── bottom_nav_bar.dart        # Custom Bottom Navigation Bar Component
│   ├── shared_preferences.dart    # Local Storage Management
│   ├── medicine.dart              # Medicine Data Model
├── screens/
│   ├── login_signup/              # Login and Signup Screens
│   ├── home.dart                  # Home Page
│   ├── ocr.dart                   # OCR Scanning Screen
│   ├── profile.dart               # Profile Management
│   ├── forum.dart                 # Community Discussion Forum
│   ├── splash.dart                # Splash Screen
└── main.dart                      # App Entry Point

##🧑‍💻 Installation & Setup
**Follow these steps to set up the project locally**:
https://github.com/atharv666/gmr.git
**Follow these steps to set up the project locally**:
cd gmr
**Install Dependencies:**
flutter pub get
**Run the App:**
flutter run

##🛎️ Requirements
- **Flutter 3.10+**
- **Dart 3.0+**
- **Android Studio or Visual Studio Code**
- **Firebase for backend services**
