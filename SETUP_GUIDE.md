# Meeat Google Maps Setup Guide

## Step 1: Install CocoaPods

If you haven't installed CocoaPods yet, install it first:

```bash
sudo gem install cocoapods
```

## Step 2: Install Dependencies

Run in the project root directory:

```bash
pod install
```

## Step 3: Get Google Maps API Key

### 3.1 Create Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Click "Select Project" → "New Project"
3. Enter project name (e.g., Meeat Maps)
4. Click "Create"

### 3.2 Enable Required APIs

In Google Cloud Console:

1. Go to "APIs & Services" → "Library"
2. Search and enable the following APIs:
   - **Maps SDK for iOS**
   - **Places API**
   - **Geocoding API**

### 3.3 Create API Key

1. Go to "APIs & Services" → "Credentials"
2. Click "Create Credentials" → "API Key"
3. Copy the generated API Key

### 3.4 Restrict API Key (Optional but Recommended)

1. Click on the newly created API Key
2. In "Application restrictions" select "iOS apps"
3. Add your Bundle ID (e.g., com.meeat.app)
4. In "API restrictions" select "Restrict key"
5. Only select necessary APIs:
   - Maps SDK for iOS
   - Places API
   - Geocoding API

## Step 4: Configure Project

### 4.1 Update API Key

1. Copy `Config.example.swift` to `Config.swift`:
```bash
cp Meeat/Config.example.swift Meeat/Config.swift
```

2. Edit the `Config.swift` file and replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual API Key:

```swift
static let googleMapsAPIKey = "YOUR_ACTUAL_API_KEY_HERE"
```

### 4.2 Open Project

Open the project using the `.xcworkspace` file:

```bash
open Meeat.xcworkspace
```

**Important**: Do not use the `.xcodeproj` file, you must use the `.xcworkspace` file.

## Step 5: Testing

1. Select iOS Simulator or real device
2. Run the project
3. Test if map functionality displays correctly

## Common Issues

### Q: Map not displaying
A: Check if the API Key is correctly set up and if the necessary APIs are enabled.

### Q: Compilation errors
A: Make sure to open the project with the `.xcworkspace` file, not `.xcodeproj`.

### Q: Location permission issues
A: Check if location permission descriptions in Info.plist are correctly set up.

### Q: API quota exceeded
A: Check API usage in Google Cloud Console and upgrade quota if necessary.

## Cost Considerations

Google Maps API has usage limits and billing:

- **Free Quota**: $200 free credit per month
- **Billing Items**:
  - Maps SDK for iOS: $7 per 1000 loads
  - Places API: $17 per 1000 requests
  - Geocoding API: $5 per 1000 requests

It's recommended to monitor API usage during development to avoid unexpected charges.