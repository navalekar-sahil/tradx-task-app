#TradX Task App
This is a Flutter-based application built as part of a task to demonstrate how to structure a scalable app with clean architecture, state management, and local data handling.
The idea behind the app is simple — simulate a stock tracking experience where users can log in, view stock movements, and interact with the data through search, filters, and interval updates.

#Authentication
To keep things simple and focused on the app structure, I have implemented a basic mock authentication flow.
You can log in using:
Username: test
Password: test@123
I have also added biometric authentication support, so if your device allows it, you can log in using fingerprint or device lock. This was mainly to make the flow feel closer to a real-world app.
This is not connected to any backend — it’s just to demonstrate the login experience.

#What the App Does
Once logged in, the user lands on a screen that shows a list of stocks along with their price movements.
Stocks are marked as either gaining or losing
The list updates based on a selected time interval
The UI is designed to be simple and readable
It’s not pulling real market data — the focus here is on how the data is handled and displayed

#Search and Filters
To make the list easier to work with:
There’s a search option to quickly find stocks
Users can filter the list by:
All
Gainers
Losers

#Interval Updates
Users can choose how frequently the stock data updates (for example, every 5 or 10 seconds).
This helped me demonstrate:
State updates
UI reactivity
Handling timed changes cleanly

#Theme Support
the app support by default system theme also you can choose both light and dark mode.
Theme switching is handled using Provider, so the UI updates instantly without needing to restart anything

#Local Storage
I have used hive and shared_preferences to store data locally.
This keeps things fast and avoids needing any backend setup. It also allowed me to structure data persistence cleanly

#How the App Flows
The app starts and initializes local storage
Splash screen redirect to login screen after 2 sec
User logs in (or uses biometrics)
Stock data is loaded
User can:
Search
Apply filters
Change update interval
UI updates automatically through Provider

#Project Structure
I followed a simple MVVM-style structure to keep the code organized and easy to scale as the app grows.
lib/
├── model/        // Data models
├── view/         // UI screens
├── view_model/   // Business logic & state (Provider)
├── repository/   // Data handling (API/local/Hive) ( in this app i have create stock.json file in  app leven  asset filder and load data from it)
├── res/          // App resources 
├── utils/        // Routes and helper classes
└── main.dart


TradX app video Url
https://drive.google.com/file/d/10GU-1zVMGdA9YFJODHhD6Z7h8QZCW_bs/view?usp=sharing


