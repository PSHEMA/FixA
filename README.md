# FixMyArea - Local Services Aggregator

**FixMyArea** is a mobile application built with Flutter, designed to bridge the gap between customers and reliable local service providers in Kigali, Rwanda. It provides a seamless, two-sided marketplace where users can find, book, and review services, while providers can manage their jobs, profile, and customer feedback.

This project was developed as a Capstone for the BSc. in Software Engineering program at ALU.

---

### 🎥 Demo Video


---

### 🚀 Core Functionalities

#### For Customers:
- **Live Geolocation Map:** View an interactive map centered on your current location.
-  **Service Discovery:** Browse service categories or use a live search to find what you need.
-  **View Provider Listings:** See a list of available providers for a selected category.
-  **Detailed Provider Profiles:** View a provider's bio, services offered, starting rate, and customer reviews.
-  **Direct Communication:** Initiate a phone call or start a real-time chat with a provider directly from their profile.
-  **End-to-End Booking System:** Book a service for a specific date and time.
-  **Booking Management:** View a list of upcoming and past bookings, with options to reschedule or cancel.
-  **Review and Rating System:** Leave a star rating and written review for a provider after a job is completed.

#### For Service Providers:
-  **Guided Onboarding:** A step-by-step process to select services offered and set a business location by District/Sector.
-  **Dynamic Dashboard:** View real-time stats, including total earnings and jobs for the day.
-  **Job Management:** Receive new job requests with real-time notifications and have the ability to accept, decline, or mark jobs as complete.
-  **Log Final Job Price:** Enter the final price for a service upon completion to accurately track earnings.
-  **Review Management:** View a list of all reviews and ratings left by customers.
-  **Profile Management:** Edit personal details, bio, starting rate, and upload a profile picture.
-  **Service Management:** Update the list of offered services at any time.

---

### 💻 Technology Stack

* **Framework:** Flutter
* **Backend & Database:** Firebase (Firestore, Firebase Auth, Firebase Storage)
* **APIs:** Google Maps SDK
* **Core Packages:** `google_maps_flutter`, `geolocator`, `firebase_core`, `cloud_firestore`, `firebase_auth`, `firebase_storage`, `image_picker`, `url_launcher`.

---

### ⚙️ Setup and Installation

Follow these steps to run the application on your local machine.

#### **Step 1: Prerequisites**
- Ensure you have [Flutter installed](https://docs.flutter.dev/get-started/install) on your machine.
- Ensure you have a configured editor like VS Code or Android Studio.
- Run `flutter doctor` to ensure your environment is ready.

#### **Step 2: Firebase Project Setup**
1.  Create a new project on the [Firebase Console](https://console.firebase.google.com/).
2.  Enable **Authentication** (with Email/Password provider), **Firestore Database**, and **Storage**.
3.  Configure the Firestore and Storage security rules as specified in the project documentation (or use test mode for initial setup).
4.  Follow the instructions to add a new **Flutter App** to your Firebase project. This will involve using the `flutterfire_cli` to generate the `lib/firebase_options.dart` file for your project.

#### **Step 3: API Keys**
1.  Go to the [Google Cloud Console](https://console.cloud.google.com/) for your Firebase project.
2.  Enable **Maps SDK for Android** and **Maps SDK for iOS**.
3.  Create an API key from the **APIs & Services > Credentials** page.
4.  Add the API Key to the following files:
    * `android/app/src/main/AndroidManifest.xml`
    * `ios/Runner/AppDelegate.swift`

#### **Step 4: Running the App**
1.  Clone this repository:
    ```bash
    git clone https://github.com/PSHEMA/FixA.git
    ```
2.  Navigate to the project directory:
    ```bash
    cd fix_my_area
    ```
3.  Install the required dependencies:
    ```bash
    flutter pub get
    ```
4.  Run the application on your desired device (emulator or physical device):
    ```bash
    flutter run
    ```

---

### 📦 Deployed Version / Application Package

* **APK:** [FixMyArea](release/app-release.apk)

