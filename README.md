# Smart Safety Dashboard 🛡️

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)](https://firebase.google.com)

A robust, real-time safety monitoring application designed to protect homes and workplaces. This app interfaces with IoT sensors to provide instant alerts and incident history for critical safety hazards like gas leaks, fire, and unauthorized entry.

---

## 🚀 Key Features

- **Real-time Monitoring:** sub-second updates from Gas, Flame, Door, and Iron sensors.
- **Intelligent Alert System:**
  - **Visual:** Dashboard transitions from Green (Secure) to Red (Danger).
  - **Haptic:** Immediate device vibration upon hazard detection.
- **Multilingual Support:** Fully localized for **English, Arabic (RTL), and French**.
- **Incident History:** Persistent logs of all past dangers with timestamps.
- **Secure Access:** Authentication system ensuring only authorized members can access the dashboard.

---

## 🏗️ Hardware Integration & Architecture



The application is designed to sync with hardware (ESP32/Arduino) using the following Firebase Realtime Database structure:

```json
{
  "users": {
    "USER_ID": {
      "sensors": {
        "gas": { "status": "off" },
        "flame": { "status": "off" },
        "door": { "status": "closed" },
        "iron": { "status": "off" }
      },
      "logs": {
        "unique_log_id": {
          "sensor": "gas",
          "timestamp": 1703175934000
        }
      }
    }
  }
}
```

## 🚀 Setup & Installation
  1. Prerequisites
   - Flutter SDK (Stable channel)
   - Firebase account with a project created
   - Dart installed

  2. Clone the Repository
   ```
   git clone [https://github.com/AbdallahJbeli/safety_dashboard_app.git](https://github.com/AbdallahJbeli/safety_dashboard_app.git)

   cd safety_dashboard_app 
   
   ```

  3. Firebase Configuration
   - Register App: Register your Android/iOS app in the Firebase Console.
   - Config Files: 
    - Place google-services.json in android/app/.
    - Place GoogleService-Info.plist in ios/Runner/.
   - Database URL: Ensure the dbUrl variable in your code points to: https://safetyapp-flutte-default-rtdb.europe-west1.firebasedatabase.app

  4. Database Rules
```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    }
  }
}
```

  5. Launch the App
    # Get dependencies
    flutter pub get

    # Setup Native Splash Screen
    dart run flutter_native_splash:create

    # Run the application
    flutter run


``` 

