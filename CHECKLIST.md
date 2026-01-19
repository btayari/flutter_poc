# ✅ Installation Checklist

Follow these steps in order to get your Tactical Lineup Editor running:

## Step 1: Install Flutter Packages ⚙️
Open terminal in the project directory and run:
```bash
cd /home/belhassen/StudioProjects/flutter_poc
flutter pub get
```

**What this does:**
- Installs `google_fonts` package for Inter typography
- Resolves all dependencies
- Updates package cache

**Expected output:**
```
Running "flutter pub get" in flutter_poc...
Resolving dependencies...
+ google_fonts 6.2.1
...
Got dependencies!
```

---

## Step 2: Create Assets Folders 📁
Run one of these commands:

**Option A - Using the setup script:**
```bash
chmod +x setup.sh
./setup.sh
```

**Option B - Manual creation:**
```bash
mkdir -p assets/players
```

**Verify:**
```bash
ls -la assets/
# Should show: players/
```

---

## Step 3: Download Player Images 🖼️

### Quick Option - Placeholder Images (for testing):
```bash
chmod +x download_placeholders.sh
./download_placeholders.sh
```

This downloads 11 generic avatar images from pravatar.cc.

### Manual Option - Download Real Images:
Download 11 player images and save as:
1. `assets/players/ederson.jpg`
2. `assets/players/gvardiol.jpg`
3. `assets/players/dias.jpg`
4. `assets/players/akanji.jpg`
5. `assets/players/walker.jpg`
6. `assets/players/kovacic.jpg`
7. `assets/players/rodri.jpg`
8. `assets/players/bernardo.jpg`
9. `assets/players/doku.jpg`
10. `assets/players/haaland.jpg`
11. `assets/players/foden.jpg`

**Image specs:**
- Format: JPG or PNG
- Size: 200-400px square
- Aspect ratio: 1:1

**Where to find images:** See `IMAGES_GUIDE.md`

### Skip Option - Test Without Images:
The app works without images! It shows placeholder icons.

---

## Step 4: Run the App 🚀

```bash
flutter run
```

**For specific device:**
```bash
flutter devices          # List available devices
flutter run -d chrome    # Run on Chrome
flutter run -d android   # Run on Android
```

**Expected behavior:**
- App launches with dark theme
- Shows "Match Prediction" title
- Displays Manchester City lineup
- Football pitch with 11 players visible
- Works with or without player images

---

## Step 5: Verify Everything Works ✓

### Visual Checks:
- [ ] Dark blue-grey background (not white)
- [ ] "Manchester City" title visible
- [ ] Green football pitch with white markings
- [ ] 11 player nodes visible on pitch
- [ ] Formation selector shows "4-3-3 Attack"
- [ ] Blue "Make Prediction" button at bottom
- [ ] Player images or placeholder icons showing
- [ ] Rating badges visible on players

### Interactive Checks:
- [ ] Formation selector is tappable
- [ ] Auto button is tappable
- [ ] Players are tappable
- [ ] Make Prediction button is tappable
- [ ] Back button visible
- [ ] Settings button visible

---

## Troubleshooting 🔧

### ❌ Error: "Target of URI doesn't exist: 'package:google_fonts'"
**Solution:** Run `flutter pub get`

### ❌ Error: "Unable to load asset: assets/players/..."
**Solution:** 
- Check files exist in `assets/players/`
- Check file names match exactly (case-sensitive)
- Run `flutter pub get` again

### ❌ App shows white screen or errors
**Solution:**
1. Run `flutter clean`
2. Run `flutter pub get`
3. Run `flutter run` again

### ❌ Font doesn't look right
**Solution:**
- Ensure internet connection (fonts download on first run)
- Restart the app
- Wait a few seconds on first launch

### ❌ "No devices found"
**Solution:**
- For web: `flutter run -d chrome`
- For Android: Enable USB debugging
- For iOS: Connect device and trust computer

### ⚠️ Warning: "withOpacity is deprecated"
**Not a problem!** These are just warnings. The app works fine.

---

## Quick Start Command Sequence 🏃

Copy and paste these commands:

```bash
# 1. Navigate to project
cd /home/belhassen/StudioProjects/flutter_poc

# 2. Install packages
flutter pub get

# 3. Create folders
mkdir -p assets/players

# 4. Download placeholder images (optional)
chmod +x download_placeholders.sh && ./download_placeholders.sh

# 5. Run the app
flutter run
```

---

## Alternative: Run Without Images First 🎯

Want to see it work immediately?

```bash
cd /home/belhassen/StudioProjects/flutter_poc
flutter pub get
flutter run
```

The app will launch with placeholder icons instead of player photos. You can add images later!

---

## What You Should See 👀

When working correctly, you'll see:

```
┌─────────────────────────────────┐
│  ←  Match Prediction        ⚙️  │
├─────────────────────────────────┤
│ HOME TEAM           86 OVR ↗    │
│ Manchester City                 │
│                                 │
│ [4-3-3 Attack ▼]     [✨ Auto] │
├─────────────────────────────────┤
│         ┌───────────┐           │
│         │           │           │
│         │  PITCH    │           │
│         │  WITH     │           │
│         │  PLAYERS  │           │
│         │           │           │
│         └───────────┘           │
├─────────────────────────────────┤
│ 🟢 All players fit    Avg: 26.4│
│                                 │
│   [ Make Prediction → ]         │
└─────────────────────────────────┘
```

---

## Success Indicators ✨

You're ready when:
1. ✅ No compile errors
2. ✅ App launches successfully
3. ✅ Dark theme applied
4. ✅ Pitch and players visible
5. ✅ Buttons respond to taps
6. ✅ Google Fonts loads (Inter typography)

---

## Need Help? 📖

Check these documents:
- `SETUP.md` - Detailed setup guide
- `IMAGES_GUIDE.md` - Image download instructions
- `IMPLEMENTATION_SUMMARY.md` - Complete overview

---

## Ready to Customize? 🎨

Once working, you can:
- Change team name
- Update player names/ratings
- Modify formation
- Adjust colors
- Add new features

See comments in `lib/main.dart` for guidance.

---

**Estimated setup time:** 5-10 minutes
**Required skills:** Basic terminal usage
**Prerequisites:** Flutter SDK installed

**You're all set! Happy coding! 🚀**
