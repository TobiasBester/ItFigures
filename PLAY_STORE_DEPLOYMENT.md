# Play Store Deployment Guide for It Figures

This guide will walk you through the complete process of publishing your Flutter app to the Google Play Store.

## Prerequisites

- Flutter SDK installed (run `flutter doctor` to verify)
- Android Studio or Android SDK command-line tools
- A Google Play Developer account ($25 one-time fee)
- JDK 11 or higher

## Step 1: Generate App Icons

The app is configured to use `flutter_launcher_icons` package to generate Android launcher icons.

### 1.1 Customize Your App Icon (Optional)

If you want to use a custom icon instead of the existing web icons:
1. Create a 1024x1024 px PNG image for your app icon
2. Save it as `assets/app_icon.png`
3. Optionally create a foreground version and save as `assets/app_icon_foreground.png`

### 1.2 Generate Icons

```bash
# Install dependencies
flutter pub get

# Generate launcher icons
flutter pub run flutter_launcher_icons
```

This will generate all required Android launcher icon sizes in the appropriate directories.

## Step 2: Create Signing Keystore

### 2.1 Generate the Keystore

Run this command to create your upload keystore:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA \
  -keysize 2048 -validity 10000 -alias upload
```

**Important:**
- You'll be prompted to set passwords - remember these!
- Store the keystore file securely - if you lose it, you can't update your app
- The keystore will be created in your home directory

### 2.2 Move Keystore to Project

```bash
mv ~/upload-keystore.jks ./android/upload-keystore.jks
```

### 2.3 Create key.properties File

Copy the template and fill in your actual passwords:

```bash
cp android/key.properties.template android/key.properties
```

Edit `android/key.properties` with your actual values:

```properties
storePassword=YOUR_ACTUAL_STORE_PASSWORD
keyPassword=YOUR_ACTUAL_KEY_PASSWORD
keyAlias=upload
storeFile=../upload-keystore.jks
```

**Security Note:** The `key.properties` file and keystore are already in `.gitignore` and will not be committed to version control.

## Step 3: Build the App Bundle

### 3.1 Clean Previous Builds

```bash
flutter clean
flutter pub get
```

### 3.2 Build the Release App Bundle

```bash
flutter build appbundle --release
```

The app bundle will be created at: `build/app/outputs/bundle/release/app-release.aab`

### 3.3 Verify the Build

Check the file size and verify it was created:

```bash
ls -lh build/app/outputs/bundle/release/app-release.aab
```

## Step 4: Prepare Play Store Assets

### 4.1 Create Screenshots

1. Run your app on an Android device or emulator:
   ```bash
   flutter run --release
   ```

2. Take screenshots (use Android's built-in screenshot tool or emulator controls)

3. Save screenshots to `playstore/screenshots/` directory
   - Recommended: 1080x1920 px
   - Format: PNG
   - Quantity: 2-8 screenshots

### 4.2 Create Feature Graphic

Create a 1024x500 px image featuring your app. This appears at the top of your store listing.

**Tools you can use:**
- Canva (has Play Store templates)
- Figma
- Photoshop
- GIMP (free)

Save as: `playstore/graphics/feature_graphic.png`

**Design tips:**
- Use the app's theme color: #0175C2
- Include the app name "It Figures"
- Keep it simple and professional
- Avoid small text (won't be readable on mobile)

### 4.3 Privacy Policy

1. Edit `playstore/PRIVACY_POLICY_TEMPLATE.md`
   - Update the date
   - Add your contact email

2. Host it publicly:
   - **Option A:** Use GitHub Pages (if this is a public repo)
   - **Option B:** Create a simple website
   - **Option C:** Use a free hosting service like Google Sites

3. Note the URL - you'll need it for the Play Console

### 4.4 Review Store Listing Text

Edit these files if needed:
- `playstore/listings/en-US_title.txt`
- `playstore/listings/en-US_short_description.txt`
- `playstore/listings/en-US_full_description.txt`

## Step 5: Create Play Console Listing

### 5.1 Create Play Console Account

1. Go to [Google Play Console](https://play.google.com/console)
2. Pay the $25 one-time registration fee
3. Complete your account information

### 5.2 Create New App

1. Click "Create app"
2. Fill in:
   - **App name:** It Figures
   - **Default language:** English (United States)
   - **App or game:** Game
   - **Free or paid:** Free (or Paid, your choice)
3. Accept declarations and click "Create app"

### 5.3 Complete Store Listing

Navigate to "Store presence" > "Main store listing":

1. **App details:**
   - App name: It Figures
   - Short description: (copy from `playstore/listings/en-US_short_description.txt`)
   - Full description: (copy from `playstore/listings/en-US_full_description.txt`)

2. **Graphics:**
   - App icon: Automatically from your app
   - Feature graphic: Upload from `playstore/graphics/feature_graphic.png`
   - Screenshots: Upload from `playstore/screenshots/`

3. **Categorization:**
   - App category: Games > Puzzle
   - Tags: puzzle, math, numbers, brain, challenge
   - Content guidelines: Select appropriate options

4. **Contact details:**
   - Email: Your support email
   - Phone: (optional)
   - Website: (optional)

5. **Privacy policy:**
   - Paste the URL where you hosted your privacy policy

### 5.4 Content Rating

1. Navigate to "Content rating"
2. Fill out the questionnaire
3. For this game app, answer honestly about:
   - Violence: None
   - Sexual content: None
   - Bad language: None
   - Interactive elements: None (unless you add multiplayer)
4. Submit to receive your rating (likely E for Everyone)

### 5.5 App Access

1. Navigate to "App access"
2. Since this is a simple game with no login:
   - Select "All functionality is available without special access"

### 5.6 Ads

1. Navigate to "Ads"
2. Select whether your app contains ads
   - Currently: No (unless you plan to add them)

### 5.7 Target Audience and Content

1. Navigate to "Target audience"
2. Select age groups:
   - Recommended: All ages (or 13+, depending on your preference)

### 5.8 News Apps

1. If prompted, indicate this is not a news app

### 5.9 COVID-19 Contact Tracing/Status Apps

1. If prompted, indicate this is not a COVID-19 app

### 5.10 Data Safety

1. Navigate to "Data safety"
2. Based on your app:
   - **Does your app collect or share user data?** No
   - The app only stores data locally (game progress)
   - No data is collected or transmitted
3. Complete the form accordingly

## Step 6: Upload and Release

### 6.1 Create a Release

1. Navigate to "Release" > "Production"
2. Click "Create new release"

### 6.2 Upload App Bundle

1. Upload the app bundle: `build/app/outputs/bundle/release/app-release.aab`
2. Wait for it to process
3. Google Play will show any errors or warnings

### 6.3 Release Notes

Add release notes for this version:

```
Initial release of It Figures!

Features:
• Daily number puzzle challenges
• Multiple game modes
• Continuous operations for complex puzzles
• Clean, intuitive interface
• Track your progress over time

Challenge your math skills with this addictive puzzle game inspired by NYT Digits and Countdown!
```

### 6.4 Review and Rollout

1. Review the release summary
2. Click "Save"
3. Click "Review release"
4. If everything looks good, click "Start rollout to Production"

### 6.5 Wait for Review

- Google will review your app (usually 1-7 days)
- You'll receive an email when it's approved
- Once approved, your app will be live on the Play Store!

## Step 7: Post-Publication

### 7.1 Monitor

- Check the Play Console dashboard regularly
- Monitor crash reports
- Read user reviews and respond

### 7.2 Updates

When you want to release an update:

1. Update version in `pubspec.yaml`:
   ```yaml
   version: 1.1.0+2  # increment version name and build number
   ```

2. Build new app bundle:
   ```bash
   flutter build appbundle --release
   ```

3. Upload to Play Console as a new release

## Troubleshooting

### Build Errors

**Problem:** `Keystore file not found`
**Solution:** Ensure `android/key.properties` exists and points to the correct keystore file

**Problem:** `Execution failed for task ':app:lintVitalRelease'`
**Solution:** Add to `android/app/build.gradle`:
```gradle
lintOptions {
    checkReleaseBuilds false
}
```

**Problem:** Flutter command not found
**Solution:** Ensure Flutter is in your PATH, or use the full path to flutter

### Play Console Errors

**Problem:** "You need to use a different version code"
**Solution:** Increment the version code in `pubspec.yaml` (the number after the +)

**Problem:** "Upload failed: APK signature invalid"
**Solution:** Rebuild the app bundle and ensure your keystore configuration is correct

## Checklist

Before submitting to Play Store, verify:

- [ ] App name updated to "It Figures"
- [ ] App icons generated via flutter_launcher_icons
- [ ] Keystore created and configured
- [ ] key.properties file created (not committed to git)
- [ ] App bundle built successfully
- [ ] Screenshots taken and ready (2-8 images)
- [ ] Feature graphic created (1024x500 px)
- [ ] Privacy policy written and hosted
- [ ] Store listing text reviewed
- [ ] Content rating questionnaire completed
- [ ] Data safety form completed
- [ ] All Play Console sections marked as "Complete"

## Resources

- [Flutter Android Deployment Guide](https://docs.flutter.dev/deployment/android)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [Android App Bundle Documentation](https://developer.android.com/guide/app-bundle)
- [Play Store Listing Asset Specifications](https://support.google.com/googleplay/android-developer/answer/9866151)

## Support

If you encounter issues:
1. Check Flutter documentation
2. Review Play Console error messages
3. Search Stack Overflow
4. Ask in Flutter Discord/Reddit communities

Good luck with your app launch! 🚀
