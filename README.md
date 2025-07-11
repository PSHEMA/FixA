# FixMyArea - Local Services Aggregator

**FixMyArea** is a mobile application built with Flutter, designed to bridge the gap between customers and reliable local service providers in Kigali, Rwanda. It provides a seamless, two-sided marketplace where users can find, book, and review services, while providers can manage their jobs, profile, and customer feedback.

This project was developed as a Capstone for the BSc. in Software Engineering program at ALU.

---

### 🎥 Demo Video
![Demo](./media/App%20Demo.mp4)

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
### 🧪 Testing Results & Demonstration

The application was tested using several strategies to ensure functionality, stability, and a positive user experience.

#### **Demonstration with Different Testing Strategies**

* **User Acceptance Testing (UAT):** The application was tested by simulating the roles of both "Customer" and "Service Provider" using separate accounts. The primary test case involved the end-to-end flow of booking a service. The "Customer" account was used to successfully find a provider, book a job, and leave a review. The "Provider" account successfully received the job notification, managed the booking, and viewed the final review.

    ![Provider's Dashboard](./screenshots/Provider's%20Dashboard.jpg)
    ![Customer's Bookings](./screenshots/Customer's%20bookings%20list.jpg)
* **Integration Testing:** The successful completion of the UAT flow confirmed that all backend services (Firebase Authentication, Firestore, Storage) and core business logic are correctly integrated and functioning as expected. The real-time notification system was validated by observing that the provider account received a job request instantly after submission from the customer account.
* **Cross-Platform Compatibility:** The app was built and tested on an Android device (SAMSUNG), a web browser (Chrome), and a physical iOS device. During testing, initial UI overflow bugs on smaller screens and map loading issues on the web were identified and successfully resolved, ensuring a consistent user experience across platforms.

#### **Demonstration with Different Data Values**
To test the dynamic nature of the app, I tested two provider profiles: one with multiple reviews and another with no reviews.
* **Provider (With Rating):** The profile correctly calculated and displayed an average rating of 4.5 stars and showed a complete list of all submitted reviews during testing.
    ![Provider with Ratings](./screenshots/Provider's%20profile%20screen(customer%20side).jpg)
    ![Notification](./screenshots/Notifications.jpg)

---

### 📊 Analysis of Results

This section analyzes how the final product achieved the initial objectives laid out in the project proposal.

* **Objective 1: Address the difficulty of finding trusted local providers.**
    * **Analysis:** This objective was fully achieved based on the testing results. The implemented review and rating system creates a transparent, merit-based marketplace. It enables customers to make informed decisions based on community feedback, directly building trust and addressing the core issue of relying on inconsistent word-of-mouth recommendations.
* **Objective 2: Build a mobile-first app with core features.**
    * **Analysis:** The objective was successfully met and even exceeded based on the final evaluation. The completed Flutter application includes all specified features: a guided provider onboarding process, comprehensive job management dashboards, real-time chat, and a full booking/review cycle. The decision to switch from the proposed React/Django stack to Flutter proved highly effective for delivering a seamless cross-platform mobile experience.
* **Objective 3: Test the app with a small group and gather feedback.**
    * **Analysis:** This objective was critical to the project's success. Initial testing revealed that the original map-tap location selection for providers was confusing. Based on these observations, I pivoted to a much more user-friendly District/Sector dropdown system, which proved simpler and more relevant to the local context. This demonstrates a successful agile development process where direct testing and iteration improved the final product.

---

### 💬 Discussion

* **Importance of Milestones:** The development process included several critical milestones. Implementing the role-based AuthGate was foundational, enabling tailored experiences for both customer and provider accounts. Another major milestone was integrating a live Google Map and geolocation services, which transformed the app from a simple list-based directory into a modern, location-aware platform. Finally, the implementation of the real-time notification system was a key achievement that made the app feel alive and responsive, significantly enhancing engagement during testing and use.
* **Impact of Results:** The successful creation of this application presents a significant positive impact for the Kigali community. For residents, it offers a secure and efficient platform to find reliable help, saving time and reducing risk. For local service providers, many of whom operate in the informal economy, it provides a free, powerful tool to formalize their business, build a digital reputation, attract more customers, and manage their work professionally, ultimately leading to greater economic stability and growth.

---

### ✅ Recommendations & Future Work

* **Recommendations to the Community:** We recommend that local service providers in Kigali embrace digital tools like these to expand their customer base and professionalize their services. For residents, adopting such platforms can foster a more reliable, transparent, and high-quality local service economy for everyone.
* **Future Work:** The platform is robust but has significant potential for expansion. Future development sprints should focus on:
    * **Payment Integration:** Integrating MTN Mobile Money and Airtel Money to handle secure in-app payments for completed jobs.
    * **Push Notifications:** Implementing a full push notification system (using Firebase Cloud Messaging) so users are alerted to updates even when the app is closed.
    * **APP ICON**: Creating a unique and visually appealing app icon.

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

* **APK:** [FixMyArea](./release/app-release.apk)

