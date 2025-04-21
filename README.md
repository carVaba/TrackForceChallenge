
⸻

📱 TrackForce Weather Challenge

This app was developed as part of the TrackForce mobile coding challenge. It displays the current weather and a 7-day forecast for the user’s location.

## This is reference image

![UI Reference](Reference%20Image%20-%20Project%20.png)

⸻

✅ Architecture

The app follows Clean Architecture and the MVP (Model-View-Presenter) pattern.
It separates concerns across layers to improve testability, maintainability, and scalability.

Layers:
	•	Presentation: UI logic using MVP (View + Presenter)
	•	Domain: Use cases and business models
	•	Data: Network, caching, and external services (e.g. location, API)

⸻

🛠 Minimum Deployment Target: iOS 11

After reviewing the existing TrackForce apps on the App Store, I noticed that some of them support iOS 11 and iOS 12.
To ensure compatibility with your user base, this app was built with iOS 11 as the minimum supported version.

⸻

🎯 Design Patterns Used

Category	Pattern Used	Where It’s Applied
Creational	Dependency Injection (via builder)	WeatherModuleBuilder creates and injects modules
Structural	Adapter	DefaultLocationService adapts CLLocationManager
Behavioral	Delegate Pattern	Used with CLLocationManagerDelegate for updates



⸻

🧪 Run the project
- Please use the lastest Xcode version
- Don't need to configure your apple account 

⸻