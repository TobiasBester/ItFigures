# Quick Start: Publishing to Play Store

Follow these steps in order. For detailed instructions, see `PLAY_STORE_DEPLOYMENT.md`.

## 1️⃣ Generate Icons (2 minutes)

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

## 2️⃣ Create Keystore (5 minutes)

```bash
# Generate keystore
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA \
  -keysize 2048 -validity 10000 -alias upload

# Move to project
mv ~/upload-keystore.jks ./android/upload-keystore.jks

# Configure
cp android/key.properties.template android/key.properties
# Edit android/key.properties with your passwords
```

## 3️⃣ Build App Bundle (5 minutes)

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

## 4️⃣ Create Store Assets (30-60 minutes)

### Screenshots
- Run app: `flutter run --release`
- Take 2-8 screenshots (1080x1920 recommended)
- Save to `playstore/screenshots/`

### Feature Graphic
- Create 1024x500 px image
- Use Canva, Figma, or Photoshop
- Save as `playstore/graphics/feature_graphic.png`

### Privacy Policy
- Edit `playstore/PRIVACY_POLICY_TEMPLATE.md`
- Host it publicly (GitHub Pages, website, etc.)
- Note the URL

## 5️⃣ Set Up Play Console (20-30 minutes)

1. Go to [play.google.com/console](https://play.google.com/console)
2. Create new app
3. Complete all required sections:
   - Store listing
   - Content rating
   - Target audience
   - Data safety
   - App access

## 6️⃣ Upload and Submit (10 minutes)

1. Create production release
2. Upload `app-release.aab`
3. Add release notes
4. Submit for review

## 📋 Pre-Submission Checklist

- [ ] Icons generated
- [ ] Keystore created
- [ ] App bundle built
- [ ] 2+ screenshots ready
- [ ] Feature graphic created
- [ ] Privacy policy hosted
- [ ] All Play Console sections complete
- [ ] App tested on device

## ⏱️ Total Time Estimate

- **First time:** 2-3 hours
- **Updates:** 15-20 minutes

## 🆘 Need Help?

See detailed guide: `PLAY_STORE_DEPLOYMENT.md`

## 🎯 Current Status

**App Name:** It Figures
**Package ID:** com.coolandfunandnice.it_figures
**Version:** 1.0.0+1
**Min SDK:** 21 (Android 5.0+)
**Category:** Games > Puzzle
