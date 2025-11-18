# Play Store Assets Guide (TWA)

This directory contains all the assets and metadata needed for publishing your PWA to the Google Play Store using a Trusted Web Activity (TWA).

**What is TWA?** A lightweight Android wrapper that displays your web app in fullscreen without browser UI. Your PWA remains the source of truth, and updates happen instantly when you update your website!

## Required Assets

### 1. App Icon
- Already configured via flutter_launcher_icons
- Will be generated from `assets/app_icon.png`
- Size: 512x512 px (minimum)

### 2. Screenshots
Location: `playstore/screenshots/`

**Requirements:**
- **Minimum:** 2 screenshots
- **Maximum:** 8 screenshots
- **Size:** 16:9 or 9:16 aspect ratio
- **Dimensions:** Minimum 320px, maximum 3840px
- **Format:** PNG or JPEG (24-bit)
- **Recommended:** 1080x1920 px (phone portrait)

**To capture:**
Run your app on an Android device or emulator and take screenshots of:
- Main game screen
- Daily challenge mode
- Gameplay in action
- Win/success screen
- Any unique features

### 3. Feature Graphic
Location: `playstore/graphics/feature_graphic.png`

**Requirements:**
- **Size:** 1024 x 500 px
- **Format:** PNG or JPEG (24-bit)
- **Purpose:** Displayed at the top of your store listing

**Design tips:**
- Use your brand colors (#0175C2)
- Include app name "It Figures"
- Show app icon or gameplay preview
- Keep text minimal and readable
- No transparency

### 4. Privacy Policy
**Required:** Yes (apps that handle user data)

**Actions needed:**
1. Create a privacy policy (even if minimal)
2. Host it on a publicly accessible URL
3. Add the URL in Play Console during setup

**Sample for this app:**
Since the app uses `flutter_secure_storage`, you should mention:
- What data is collected (game progress, settings)
- Where it's stored (locally on device)
- That no data is shared with third parties

### 5. Content Rating
**Required:** Yes

**Process:**
1. Complete the content rating questionnaire in Play Console
2. Based on your game description, likely rating: E (Everyone)

### 6. App Category
**Suggested:** Games > Puzzle

## Store Listing Text Files

The following text files have been created in `playstore/listings/`:
- `en-US_title.txt` - App title (30 characters max)
- `en-US_short_description.txt` - Short description (80 characters max)
- `en-US_full_description.txt` - Full description (4000 characters max)

Feel free to edit these to better match your vision!

## Additional Metadata Needed in Play Console

When you set up your app in Play Console, you'll also need to provide:
1. **App name:** It Figures (already set)
2. **Package name:** com.coolandfunandnice.it_figures (already set)
3. **Default language:** English (US)
4. **Contact email:** Your support email
5. **Category:** Games > Puzzle
6. **Tags:** puzzle, math, numbers, brain training, etc.

## Next Steps

1. Create screenshots by running the app
2. Design a feature graphic (can use tools like Canva, Figma, or Photoshop)
3. Write a simple privacy policy
4. Review and edit the listing text files
5. Follow the deployment documentation to build and upload your app
