# Trusted Web Activity (TWA) Deployment Guide

This guide explains how to publish your Progressive Web App (PWA) to the Google Play Store using a Trusted Web Activity (TWA).

## What is a TWA?

A Trusted Web Activity is a way to display your web app in a native Android app container, providing:
- ✅ Your PWA on the Play Store without rewriting code
- ✅ Full-screen experience (no browser UI)
- ✅ Automatic updates when you update your website
- ✅ Access to some device features via Web APIs
- ✅ Much smaller APK size than native apps

## Prerequisites

- **Node.js** 16+ and npm
- **JDK** 11 or higher
- **Google Play Developer account** ($25 one-time fee)
- **Your PWA deployed** to a public URL (Firebase Hosting, Vercel, etc.)

## Architecture Overview

```
Your Web App (it-figures.web.app)
         ↓
Digital Asset Links (verification)
         ↓
TWA Android App (minimal wrapper)
         ↓
Google Play Store
```

## Step 1: Deploy Your PWA

### 1.1 Build the Flutter Web App

```bash
flutter build web --release
```

### 1.2 Deploy to Firebase Hosting

```bash
# Install Firebase CLI if not already installed
npm install -g firebase-tools

# Login to Firebase
firebase login

# Deploy
firebase deploy --only hosting
```

Your app will be available at: **https://it-figures.web.app** (or your custom domain)

### 1.3 Verify PWA Requirements

Visit your deployed site and check:
- [ ] App loads correctly
- [ ] `manifest.json` is accessible at `/manifest.json`
- [ ] Icons are loading
- [ ] Service worker is registered (check DevTools > Application)
- [ ] HTTPS is enabled (required for TWA)

## Step 2: Install Bubblewrap CLI

Bubblewrap is Google's official tool for creating TWAs.

```bash
npm install -g @bubblewrap/cli
```

Verify installation:
```bash
bubblewrap --version
```

## Step 3: Initialize TWA Project

The `twa-manifest.json` file has already been created for you. Review and update if needed:

```bash
# Open and review twa-manifest.json
# Update the "host" field if using a custom domain instead of it-figures.web.app
```

**Important fields in `twa-manifest.json`:**
- `host`: Your PWA domain (currently: `it-figures.web.app`)
- `packageId`: Android package name (`com.coolandfunandnice.it_figures`)
- `name`: Full app name
- `launcherName`: Name shown on device home screen
- `themeColor`: Brand color for Android system UI

### 3.1 If Using Custom Domain

If you deployed to a custom domain, update `twa-manifest.json`:

```json
{
  "host": "yourdomain.com",
  "webManifestUrl": "https://yourdomain.com/manifest.json",
  "iconUrl": "https://yourdomain.com/icons/Icon-512.png",
  "maskableIconUrl": "https://yourdomain.com/icons/Icon-maskable-512.png"
}
```

## Step 4: Create Signing Keystore

### 4.1 Generate Upload Keystore

```bash
keytool -genkey -v -keystore android/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

**Important:**
- Remember your passwords!
- Answer the prompts (organization, location, etc.)
- The keystore will be created in `android/upload-keystore.jks`
- **Backup this file securely** - you can't update your app without it!

### 4.2 Get Your SHA-256 Fingerprint

```bash
keytool -list -v -keystore android/upload-keystore.jks \
  -alias upload -storepass YOUR_PASSWORD -keypass YOUR_PASSWORD
```

Look for the **SHA-256** fingerprint in the output. It looks like:
```
E7:12:34:56:78:9A:BC:DE:F0:12:34:56:78:9A:BC:DE:F0:12:34:56:78:9A:BC:DE:F0:12:34:56:78:9A:BC:DE
```

**Copy this fingerprint** - you'll need it in the next step.

## Step 5: Configure Digital Asset Links

Digital Asset Links verify that you own both the website and the Android app.

### 5.1 Update assetlinks.json

Edit `web/.well-known/assetlinks.json` and replace `REPLACE_WITH_YOUR_SHA256_FINGERPRINT` with your actual SHA-256 fingerprint from Step 4.2:

```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.coolandfunandnice.it_figures",
      "sha256_cert_fingerprints": [
        "E7:12:34:56:78:9A:BC:DE:F0:12:34:56:78:9A:BC:DE:F0:12:34:56:78:9A:BC:DE:F0:12:34:56:78:9A:BC:DE"
      ]
    }
  }
]
```

### 5.2 Deploy assetlinks.json

The assetlinks.json file must be accessible at `https://your-domain/.well-known/assetlinks.json`

```bash
# Copy to build output
cp web/.well-known/assetlinks.json build/web/.well-known/

# Deploy to Firebase
flutter build web --release
firebase deploy --only hosting
```

### 5.3 Verify Digital Asset Links

Check that your assetlinks.json is publicly accessible:

```bash
curl https://it-figures.web.app/.well-known/assetlinks.json
```

You can also verify using Google's tool:
https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://it-figures.web.app&relation=delegate_permission/common.handle_all_urls

## Step 6: Build the TWA Android App

### 6.1 Initialize Bubblewrap (if not already done)

```bash
bubblewrap init --manifest=twa-manifest.json
```

This creates an `android-app/` directory with the TWA wrapper.

### 6.2 Build the App Bundle

```bash
cd android-app
./gradlew bundleRelease
```

Or using Bubblewrap:
```bash
bubblewrap build
```

The app bundle will be created at:
`android-app/app/build/outputs/bundle/release/app-release-signed.aab`

### 6.3 Verify the Build

```bash
ls -lh android-app/app/build/outputs/bundle/release/app-release-signed.aab
```

The file should be relatively small (2-5 MB) since it's just a wrapper.

## Step 7: Test Your TWA

### 7.1 Install on Test Device

You can test the signed AAB using bundletool:

```bash
# Install bundletool
npm install -g bundletool

# Generate APKs from AAB
bundletool build-apks \
  --bundle=android-app/app/build/outputs/bundle/release/app-release-signed.aab \
  --output=my_app.apks \
  --mode=universal

# Install on connected device
bundletool install-apks --apks=my_app.apks
```

Or upload to **Google Play Console Internal Testing** for easier testing.

### 7.2 Verify TWA Functionality

On your test device, check:
- [ ] App opens in full screen (no browser UI)
- [ ] App icon and name are correct
- [ ] Theme colors match your branding
- [ ] All PWA features work (if applicable)
- [ ] No "Not verified" warnings in the address bar area

If you see verification warnings, double-check your Digital Asset Links configuration.

## Step 8: Prepare Play Store Assets

### 8.1 Screenshots

Take screenshots of your TWA running on Android:

**Requirements:**
- Minimum: 2 screenshots
- Maximum: 8 screenshots
- Size: 1080x1920 px recommended (phone portrait)
- Format: PNG or JPEG

Save to: `playstore/screenshots/`

**Tips:**
- Show your best features
- Include the actual gameplay/usage
- Don't include device frames (Play Store adds these)
- Ensure good contrast and readability

### 8.2 Feature Graphic

Create a 1024x500 px banner image.

**Tools:**
- Canva (has Play Store templates)
- Figma
- Adobe Express
- GIMP (free)

Save as: `playstore/graphics/feature_graphic.png`

**Design guidelines:**
- Use your brand color (#0175C2)
- Include app name "It Figures"
- Show app icon or key visual
- Keep text large and readable
- No device mockups

### 8.3 Privacy Policy

Edit `playstore/PRIVACY_POLICY_TEMPLATE.md` and host it publicly.

**Options for hosting:**
- GitHub Pages (free, works if repo is public)
- Firebase Hosting (add a `/privacy` page)
- Google Sites (free)
- Your own website

**For GitHub Pages:**
1. Enable GitHub Pages in your repo settings
2. Your privacy policy will be at: `https://yourusername.github.io/ItFigures/playstore/PRIVACY_POLICY_TEMPLATE`

### 8.4 Review Store Listings

The following files contain your Play Store text:
- `playstore/listings/en-US_title.txt` (30 char max)
- `playstore/listings/en-US_short_description.txt` (80 char max)
- `playstore/listings/en-US_full_description.txt` (4000 char max)

Edit these to match your vision!

## Step 9: Upload to Google Play Console

### 9.1 Create Play Console Account

1. Go to [Google Play Console](https://play.google.com/console)
2. Pay $25 registration fee (one-time)
3. Complete your developer profile

### 9.2 Create New App

1. Click **"Create app"**
2. Fill in:
   - **App name:** It Figures
   - **Default language:** English (United States)
   - **App or game:** Game
   - **Free or paid:** Free
   - **Declarations:** Check all boxes
3. Click **"Create app"**

### 9.3 Complete All Dashboard Tasks

Work through each required section in the Play Console:

#### A. Store Settings

**App Details:**
- App name: It Figures
- Short description: (from `playstore/listings/en-US_short_description.txt`)
- Full description: (from `playstore/listings/en-US_full_description.txt`)
- App icon: Auto-detected from your PWA
- Feature graphic: Upload from `playstore/graphics/feature_graphic.png`
- Screenshots: Upload from `playstore/screenshots/`
- Category: Games → Puzzle
- Tags: puzzle, math, numbers, brain, digits

**Contact details:**
- Email: Your support email
- Website: https://it-figures.web.app (or your domain)
- Privacy policy: Your hosted privacy policy URL

#### B. Content Rating

1. Navigate to **"Content rating"**
2. Fill out the questionnaire:
   - App type: Game
   - Violence: None
   - Sexual content: None
   - Language: None
   - Controlled substances: None
   - Gambling: None
3. Submit for rating (likely **E for Everyone**)

#### C. Target Audience

1. Select target age groups (likely: Everyone / Ages 13+)
2. Answer if your app appeals primarily to children (likely: No)

#### D. Data Safety

Since this is a PWA with local storage only:

1. **Data collection:** Select "No" for all categories
   - Or select "Yes" if you use analytics
2. **Data sharing:** No
3. **Security practices:** Encryption in transit (HTTPS)

**Note:** Even though the app stores data locally, it's via the browser, not the app itself.

#### E. App Access

Select: **"All functionality is available without special access"**

#### F. Ads

Select whether your app contains ads:
- Currently: **No** (unless you add them to your PWA)

#### G. Government Apps

If prompted: Not a government app

#### H. Financial Features

No financial features (unless you add payments)

### 9.4 Create Production Release

1. Navigate to **"Release" → "Production"**
2. Click **"Create new release"**
3. Upload: `android-app/app/build/outputs/bundle/release/app-release-signed.aab`
4. Wait for processing (1-5 minutes)
5. Set **Release name**: "1.0.0"
6. Add **Release notes**:

```
Initial release of It Figures!

Features:
• Daily number puzzle challenges inspired by NYT Digits
• Multiple game modes with increasing difficulty
• Continuous operations for complex calculations
• Clean, intuitive interface
• Track your progress and scores

Challenge your math skills with this addictive puzzle game!
```

7. Review any warnings (usually safe to proceed for TWAs)
8. Click **"Save"**

### 9.5 Review and Submit

1. Review all sections - ensure they're all marked "Complete" ✅
2. Click **"Send X items for review"**
3. Confirm submission

### 9.6 Wait for Review

- **Review time:** Usually 1-7 days
- **Status:** Check in Play Console dashboard
- **Notifications:** You'll receive emails about the review process
- **Approval:** Once approved, your app goes live automatically!

## Step 10: Post-Launch

### 10.1 Update Your PWA

The beauty of TWA: **Just update your website!**

```bash
# Make changes to your Flutter app
# ...

# Build and deploy
flutter build web --release
firebase deploy --only hosting
```

Users get updates instantly when they open the app - no Play Store review needed for content updates!

### 10.2 Update the TWA Wrapper (Rare)

You only need to update the TWA wrapper if:
- You change your domain
- You want to update the Android version code (for Play Store tracking)
- You change the app package name (not recommended)

To update:
1. Increment version in `twa-manifest.json`:
   ```json
   "appVersionCode": 2,
   "appVersionName": "1.0.1"
   ```

2. Rebuild and upload new AAB to Play Console:
   ```bash
   bubblewrap build
   ```

## Troubleshooting

### TWA Not Verified (Shows Browser UI)

**Problem:** App opens but shows browser address bar

**Solutions:**
1. Verify assetlinks.json is accessible at `https://your-domain/.well-known/assetlinks.json`
2. Check SHA-256 fingerprint matches your keystore
3. Wait 24-48 hours for Google's cache to update
4. Clear app data and cache on test device

**Debug:**
```bash
# Check Digital Asset Links
curl https://it-figures.web.app/.well-known/assetlinks.json

# Verify with Google's API
curl "https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://it-figures.web.app&relation=delegate_permission/common.handle_all_urls"
```

### Build Errors

**Problem:** `JAVA_HOME not set`
**Solution:**
```bash
export JAVA_HOME=$(/usr/libexec/java_home)  # macOS
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64  # Linux
```

**Problem:** `Keystore not found`
**Solution:** Ensure `android/upload-keystore.jks` exists and path in `twa-manifest.json` is correct

### Firebase Deployment Issues

**Problem:** `assetlinks.json` not accessible after deploy

**Solution:**
```bash
# Ensure the file is in the build output
mkdir -p build/web/.well-known
cp web/.well-known/assetlinks.json build/web/.well-known/

# Rebuild and deploy
flutter build web --release
firebase deploy --only hosting

# Verify
curl https://it-figures.web.app/.well-known/assetlinks.json
```

**Problem:** Changes not showing

**Solution:** Clear Firebase cache:
```bash
firebase hosting:channel:deploy preview
# Test on preview channel first
```

### Play Console Upload Errors

**Problem:** "You uploaded a debuggable APK"
**Solution:** Ensure you built with `--release` flag

**Problem:** "Version code 1 has already been used"
**Solution:** Increment `appVersionCode` in `twa-manifest.json` and rebuild

## Best Practices

### 1. PWA Performance
- Keep your PWA fast and responsive
- Implement proper caching strategies
- Test on slow connections
- Use lazy loading for images

### 2. Regular Updates
- Update your PWA frequently (users get changes instantly)
- Only update the TWA wrapper when necessary (requires Play Store review)
- Monitor analytics to see user engagement

### 3. Testing
- Test your PWA on multiple Android devices
- Verify Digital Asset Links on each release
- Use Play Console's internal testing track before production

### 4. User Experience
- Ensure your PWA works offline (service worker)
- Match your theme colors to your brand
- Provide clear error messages
- Add a "Install to Home Screen" prompt for users who visit via browser

## Security Checklist

- [ ] Upload keystore backed up securely
- [ ] Upload keystore NOT committed to git (check .gitignore)
- [ ] HTTPS enabled on your domain
- [ ] Digital Asset Links properly configured
- [ ] Privacy policy publicly accessible
- [ ] No API keys exposed in client code
- [ ] Content Security Policy configured

## Resources

- [Google TWA Documentation](https://developer.chrome.com/docs/android/trusted-web-activity/)
- [Bubblewrap Documentation](https://github.com/GoogleChromeLabs/bubblewrap)
- [Digital Asset Links Guide](https://developer.android.com/training/app-links/verify-site-associations)
- [Play Store Asset Specifications](https://support.google.com/googleplay/android-developer/answer/9866151)
- [Firebase Hosting Docs](https://firebase.google.com/docs/hosting)

## Quick Command Reference

```bash
# Build Flutter web app
flutter build web --release

# Deploy to Firebase
firebase deploy --only hosting

# Build TWA
bubblewrap build

# Get SHA-256 fingerprint
keytool -list -v -keystore android/upload-keystore.jks -alias upload

# Verify assetlinks.json
curl https://it-figures.web.app/.well-known/assetlinks.json

# Test Digital Asset Links
curl "https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://it-figures.web.app&relation=delegate_permission/common.handle_all_urls"
```

## Support

If you need help:
1. Check the troubleshooting section above
2. Review [Bubblewrap issues on GitHub](https://github.com/GoogleChromeLabs/bubblewrap/issues)
3. Ask on [Stack Overflow](https://stackoverflow.com/questions/tagged/trusted-web-activity)
4. Check [Chrome Developers Discord](https://discord.gg/googlechrome)

Good luck with your TWA launch! 🚀

---

**Remember:** With TWA, your website IS your app. Update your website, and your users get the latest version instantly!
