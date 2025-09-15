# Meeat - GPS-based Social Dining App (SwiftUI)

## Google Maps Setup

### 1. Install CocoaPods Dependencies

Run in the project root directory:

```bash
pod install
```

### 2. Get Google Maps API Key

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing project
3. Enable the following APIs:
   - Maps SDK for iOS
   - Places API
4. Create credentials (API Key)

### 3. Configure API Key

1. Copy `Config.example.swift` to `Config.swift`:
```bash
cp Meeat/Config.example.swift Meeat/Config.swift
```

2. Edit the `Config.swift` file and replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual API Key:

```swift
static let googleMapsAPIKey = "your_actual_api_key"
```

**Important**: The `Config.swift` file has been added to `.gitignore` and will not be committed to version control, ensuring your API Key security.

### 4. Open Project

Open the project using the `.xcworkspace` file (not `.xcodeproj`):

```bash
open Meeat.xcworkspace
```

## Features

- 🗺️ **Google Maps Integration**: Use Google Maps to display locations and routes
- 👥 **Smart Matching**: Match based on interests and food preferences
- 📍 **Location Selection**: Select dining locations on the map
- ⏰ **Time Setting**: Flexible time selection functionality
- 💬 **Real-time Chat**: Chat functionality after successful matching
- 🍽️ **Restaurant Information**: Display restaurant names and addresses

## Technical Architecture

- **SwiftUI**: Modern UI framework
- **Google Maps SDK**: Maps and location services
- **Core Location**: Location services
- **CocoaPods**: Dependency management

## Development Notes

1. Make sure to use the `.xcworkspace` file to open the project
2. Test map functionality on real devices
3. Set up the correct API Key to enable all map features
4. Be aware of Google Maps API usage limits and billing

CocoaPods cannot find your Xcode project file (.xcodeproj), so it cannot automatically install. This is usually because the Podfile doesn't specify the project path, or you're running pod install in the wrong directory.

### Please follow these steps:

#### 1. Confirm you're in the correct directory
You should run `pod install` in the directory containing `Meeat.xcodeproj` and `Podfile`.  
Please run:
```bash
ls
```
You should see `Meeat.xcodeproj` and `Podfile`.

---

#### 2. Modify Podfile to specify project path

Please open your Podfile and add this line at the top (if it's already there, skip this):

```ruby
project 'Meeat.xcodeproj'
platform :ios, '15.0'

target 'Meeat' do
  use_frameworks!
  # ...
end
```

---

#### 3. Save and run again

```bash
pod install
```

---

If you still get error messages, please share them with me!

This error message indicates that your project currently cannot find the Google Maps SDK. Common causes include:

1. **CocoaPods hasn't installed the GoogleMaps package**  
2. **Not using `.xcworkspace` to open the project**  
3. **Podfile location or content is incorrect**  
4. **Haven't run `pod install` or installation failed**

### Please follow these steps to check and fix:

---

#### 1. Check if Podfile exists and contains GoogleMaps

Please confirm that `Meeat/Podfile` exists with the following content:

```ruby
platform :ios, '15.0'
use_frameworks!

target 'Meeat' do
  pod 'GoogleMaps'
  pod 'GooglePlaces'
end
```

---

#### 2. Run pod install in the correct directory

Please run in the directory containing `Podfile` and `Meeat.xcodeproj` (usually `Meeat/`):

```bash
cd Meeat
pod install
```

---

#### 3. Open project with `.xcworkspace`

After installation, **make sure** to open the project with `Meeat.xcworkspace`:

```bash
open Meeat.xcworkspace
```

---

#### 4. Clear Xcode Derived Data (if errors persist)

If you still see `No such module 'GoogleMaps'`, try clearing Derived Data:

1. Close Xcode
2. Delete the Derived Data folder (you can use Xcode > Preferences > Locations > Derived Data > click the arrow on the right > delete that folder)
3. Reopen the project with `.xcworkspace` and Build

---

Please follow the above steps. If any step produces error messages, please share them and I'll help you resolve them!
