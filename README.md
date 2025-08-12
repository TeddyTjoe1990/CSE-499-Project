# CSE499 Project - Mobile Cashier App
A Group repository of the 7 Week Senior Project course

> 📖 *Alma 37:6*  
> “By small and simple things are great things brought to pass!”

> 📖 *Jacob 3:1*  
> “But behold, I, Jacob, would speak unto you that are pure in heart. Look unto God with firmness of mind, and pray unto him with exceeding faith, and he will console you in your afflictions, and he will plead your cause, and send down justice upon those who seek your destruction.”

This is an application to manage POS systems and track transactions. Its functionalities are a Cashier Page, a Transaction List Page, and a Search Transactions Page.

## System Requirements

To run this project in your development environment, make sure you have the following components installed:

- Flutter SDK: Version 3.32.6 or higher.

- You can check your current version with flutter --version.

- Android Studio or Visual Studio Code: With the Flutter and Dart extensions installed.

- Git: To clone the repository.

## Installation and Setup Guide

Follow these steps to get the application up and running on your local machine.

1. Clone the Repository
Open your terminal or Git Bash and run the following command:

```
git clone https://github.com/your-username/your-repo.git
```

2. Navigate to the Project Directory
Change into the project folder you just cloned:

```
cd your-repo
```

3. Install Dependencies
Run flutter pub get to install all the packages and dependencies defined in the pubspec.yaml file.

```
flutter pub get
```

4. Android Configuration
If this is the first time you are setting up a Flutter project for Android, you might need to accept the Android SDK licenses.

```
flutter doctor --android-licenses
```

To ensure there are no configuration issues, run the following command:

```
flutter doctor
```

You should see an output similar to this.

5. Run the Application
With an Android device or emulator connected and active, you can run the application with a single command:

```
flutter run
```

If you have multiple devices connected, you can specify which one to use with the device ID:

```
flutter run -d <device_id>
```

## Project Structure

This project follows a modular and organized file structure.

- lib/: Contains all the application's Dart source code.

    - db/: Manages database-related files.

        - kasir.db: The local database file.

        - services/: Holds service classes for business logic.

            - auth_service.dart: Handles user authentication logic.

        - database_helper.dart: The helper class for database operations.

    - features\ItemsAndPayment/: Contains feature-specific code.

    - models/: Defines the data models used in the application.

        - models.dart: (A file that likely exports other models).

        - transaction_model.dart: Defines the structure for transactions.

        - user_model.dart: Defines the user data structure.

    - pages/: Contains the different screens or views of the application.

        - cashier_page.dart: The main cashier interface.

        - home_page.dart: The main home screen.

        - login_page.dart: The user login screen.

        - register_page.dart: The user registration screen.

        - search_transactions.dart: Screen for searching transactions.

        - transaction_list_page.dart: Displays a list of all transactions.

    - main.dart: The main entry point of the application.