# Product List App

A modern, robust Flutter application for managing a product inventory. This app features a complete authentication flow (Login/Register) and comprehensive CRUD (Create, Read, Update, Delete) operations for products, communicating seamlessly with a REST backend. 

It implements clean architecture principles using GetX for routing, state management, and dependency injection, delivering a performant, scalable, and responsive user interface across Android, iOS, and beyond.

## Features

- **Authentication System:** Secure email & password-based login and registration.
- **Product Management:** Full CRUD capabilities functionality to efficiently manage your inventory.
  - List all products.
  - View individual product details.
  - Add new products.
  - Edit existing products.
  - Delete products cleanly.

- **Modern UI/UX:** Responsive interface with cool animations (`flutter_staggered_animations`), network image caching 

(`cached_network_image`), and elegant fonts (`google_fonts`).

- **Dark Theme:** Beautiful out-of-the-box Dark Mode styling.
- **State Management & Routing:** Fully customized routing and state lifecycle hooks using the powerful GetX library.
- **Local Storage / Caching:** Efficient local storage setup using `shared_preferences` to persist secure user sessions.

## Tech Stack

- **Framework:** Flutter (Dart)
- **State Management, Navigation, & DI:** [GetX](https://pub.dev/packages/get)
- **Networking/API:** [http](https://pub.dev/packages/http)
- **Local Storage:** [shared_preferences](https://pub.dev/packages/shared_preferences)
- **UI Enhancements:**
  - `flutter_staggered_animations` (Staggered list pop-up animations)
  - `google_fonts` (Custom typography)
  - `cached_network_image` (Performant image loading & caching)
- **Date/Time Formatting:** `intl`

**Backend Service Integration:** 
Hosted on Render: `https://product-list-app-backend-h7hw.onrender.com/api/v1`


## Project Structure

This project follows a feature-first approach organized under the GetX structure for high maintainability:

lib/
├── app/
│   ├── bindings/        # Dependency injection logic linking Controllers and Views
│   ├── controllers/     # Business logic and GetX Controllers (Auth & Products)
│   ├── data/
│   │   ├── models/      # Data models representing API schema
│   │   └── services/    # Data sources: ApiService (backend) & StorageService (local)
│   ├── routes/          # Navigation paths and app pages directory
│   └── views/           # UI Screens (Splash, Auth, Products)
├── core/
│   └── theme/           # App-wide UI configuration and custom Dark Theme (AppTheme)
└── main.dart            # Flutter application entry point

## Prerequisites

Before you begin, ensure you have the following installed on your machine:

1. **Flutter SDK:** [Install Flutter](https://docs.flutter.dev/get-started/install) (Version `3.0.0` or higher according to `pubspec.yaml`).
2. **Dart SDK:** Usually comes bundled with Flutter.
3. **IDE:** Android Studio, VS Code, or IntelliJ IDEA with Flutter/Dart plugins installed.
4. An Emulator or physical device (Android/iOS) to run the app.


## Step-by-Step Getting Started

Follow these instructions to set up the project locally:

### 1. Clone the repository

```bash
git clone https://github.com/nazmul332/product-List-Flutter-Project.git
cd product-List-Flutter-Project

### 2. Install dependencies

Run the following command to download all necessary Dart & Flutter packages defined in `pubspec.yaml`:

```bash
flutter pub get


### 3. Run the App

Ensure your emulator is running or device is connected, then compile and launch the app:

```bash
flutter run
```

### 4. Build for Production (Optional)

If you need to generate an APK (for Android) or IPA (for iOS), run the build command:

**For Android (APK):**
```bash
flutter build apk --release
```
**For Android (App Bundle):**
```bash
flutter build appbundle --release
```
**For iOS:**
```bash
flutter build ios --release


## API Endpoints Used

The app dynamically communicates with backend endpoints including:

- `POST /auth/register` - Registers a new user.
- `POST /auth/login` - Authenticates existing users and returns a token.
- `GET /products/` - Fetches the product list.
- `GET /products/:id` - Fetches specific product details.
- `POST /products/` - Submits and creates a new product.
- `PUT /products/:id` - Updates an existing product.
- `DELETE /products/:id` - Permanently deletes a product.

*Note: All product CRUD routes expect a Bearer Token provided by the `/auth/login` and retrieved securely from `StorageService`.*

---

## Contributing

1. Fork the repository
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request
