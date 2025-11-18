# TWA Quick Start Guide

Publish your PWA to Google Play Store in 7 steps!

## Prerequisites

```bash
# Install required tools
npm install -g @bubblewrap/cli firebase-tools
```

## Step 1: Deploy Your PWA (15 min)

```bash
# Build
flutter build web --release

# Deploy to Firebase
firebase login
firebase deploy --only hosting
```

Your app is now at: **https://it-figures.web.app**

✅ Verify it works by visiting the URL

## Step 2: Create Keystore (5 min)

```bash
keytool -genkey -v -keystore android/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

📝 **Remember your passwords!**

## Step 3: Get SHA-256 Fingerprint (2 min)

```bash
keytool -list -v -keystore android/upload-keystore.jks \
  -alias upload
```

📋 **Copy the SHA-256 fingerprint** (format: `AB:CD:EF:...`)

## Step 4: Configure Digital Asset Links (5 min)

Edit `web/.well-known/assetlinks.json`:

```json
{
  "sha256_cert_fingerprints": [
    "YOUR_SHA256_FINGERPRINT_HERE"
  ]
}
```

Deploy the updated file:

```bash
# Copy to build
mkdir -p build/web/.well-known
cp web/.well-known/assetlinks.json build/web/.well-known/

# Rebuild and deploy
flutter build web --release
firebase deploy --only hosting
```

✅ Verify: `curl https://it-figures.web.app/.well-known/assetlinks.json`

## Step 5: Build TWA (10 min)

```bash
# Initialize Bubblewrap with the twa-manifest.json
bubblewrap init --manifest=twa-manifest.json

# Build the app bundle
bubblewrap build
```

📦 Output: `android-app/app/build/outputs/bundle/release/app-release-signed.aab`

## Step 6: Create Play Store Assets (45-60 min)

### Screenshots
- Run your PWA on Android device/emulator
- Take 2-8 screenshots (1080x1920 recommended)
- Save to `playstore/screenshots/`

### Feature Graphic
- Create 1024x500 px image using Canva/Figma
- Save as `playstore/graphics/feature_graphic.png`

### Privacy Policy
- Edit `playstore/PRIVACY_POLICY_TEMPLATE.md`
- Host on GitHub Pages, Firebase, or your website
- Save the URL

## Step 7: Upload to Play Console (30 min)

1. Go to [play.google.com/console](https://play.google.com/console)
2. Create new app: "It Figures"
3. Complete all sections:
   - **Store listing** → Use text from `playstore/listings/`
   - **Content rating** → Complete questionnaire
   - **Target audience** → Select age groups
   - **Data safety** → Configure data handling
   - **App access** → All features available
4. **Create release** → Upload the `.aab` file
5. **Submit for review**

## ⏱️ Time Estimate

- **First time:** 2-3 hours
- **PWA updates:** 5 minutes (just deploy website!)
- **TWA version updates:** 15 minutes

## 📋 Pre-Launch Checklist

- [ ] PWA deployed to Firebase and accessible
- [ ] Service worker registered (check DevTools)
- [ ] Keystore created and backed up
- [ ] SHA-256 fingerprint obtained
- [ ] assetlinks.json deployed and accessible
- [ ] TWA built successfully
- [ ] 2+ screenshots ready
- [ ] Feature graphic created
- [ ] Privacy policy hosted
- [ ] All Play Console sections complete

## 🎯 Your App Configuration

**App Name:** It Figures
**Package ID:** com.coolandfunandnice.it_figures
**PWA URL:** https://it-figures.web.app
**Version:** 1.0.0 (Code: 1)
**Category:** Games > Puzzle
**Min SDK:** 21 (Android 5.0+)

## 🔄 Updating Your App

### Update Web Content (Most Common)
```bash
# Make changes to your Flutter app
# Build and deploy
flutter build web --release
firebase deploy --only hosting
```

✨ **Users get updates instantly!** No Play Store review needed.

### Update TWA Wrapper (Rare)

Only needed if changing domain, package name, or for Play Store version tracking:

```bash
# Edit twa-manifest.json - increment appVersionCode
bubblewrap update
bubblewrap build
# Upload new AAB to Play Console
```

## 🆘 Quick Troubleshooting

**TWA shows browser UI?**
- Wait 24-48 hours for Google cache
- Verify assetlinks.json is accessible
- Check SHA-256 fingerprint matches

**Build fails?**
- Check JDK 11+ is installed
- Verify keystore path in twa-manifest.json

**assetlinks.json not found after deploy?**
- Ensure file is in `build/web/.well-known/`
- Check firebase.json headers configuration
- Clear cache and redeploy

## 📚 Full Documentation

See `TWA_DEPLOYMENT_GUIDE.md` for complete step-by-step instructions.

## 🎉 Launch Day!

Once approved (1-7 days), your app will be live on the Play Store!

Share your app: `https://play.google.com/store/apps/details?id=com.coolandfunandnice.it_figures`

---

**Pro Tip:** Bookmark the Firebase deploy command - you'll use it often!
```bash
flutter build web --release && firebase deploy --only hosting
```
