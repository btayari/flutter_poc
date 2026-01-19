# Tactical Lineup Editor - Setup Guide

## Overview
This is a clean, reusable Flutter implementation of a tactical lineup editor for football/soccer teams. The UI is based on a modern dark theme with smooth animations and responsive design.

## Package Installation

### 1. Install Dependencies
Run the following command in your terminal:
```bash
cd /home/belhassen/StudioProjects/flutter_poc
flutter pub get
```

This will install:
- **google_fonts**: For the Inter font family (modern, clean typography)

## Assets Setup

### 2. Create Directory Structure
Create the following folders if they don't exist:
```bash
mkdir -p assets/players
```

### 3. Required Player Images
Download or create player images (circular headshots work best) and place them in `assets/players/` with these names:

**Goalkeeper:**
- `ederson.jpg` - Goalkeeper image (suggested: neutral expression, clear face)

**Defenders:**
- `gvardiol.jpg`
- `dias.jpg`
- `akanji.jpg`
- `walker.jpg`

**Midfielders:**
- `kovacic.jpg`
- `rodri.jpg` (Star player - will have blue glow effect)
- `bernardo.jpg`

**Forwards:**
- `doku.jpg`
- `haaland.jpg` (Star player - will have blue glow effect)
- `foden.jpg`

**Image Specifications:**
- Format: JPG or PNG
- Recommended size: 200x200px to 400x400px
- Aspect ratio: 1:1 (square)
- Background: Can be any (will be cropped to circle)
- Quality: High resolution for best results

### 4. Optional: Pitch Pattern Image
For a textured pitch background (optional):
- Create/download: `assets/pitch_pattern.png`
- This is used as a subtle texture overlay on the pitch
- Suggested: Grass texture or subtle pattern
- The app will work without this (solid color fallback)

## Icons and Visual Elements

All icons are using Flutter's built-in Material Icons, so no additional icon packages are needed:

- ✓ Back arrow (Icons.arrow_back)
- ✓ Settings (Icons.settings)
- ✓ Trending up (Icons.trending_up)
- ✓ Dropdown (Icons.arrow_drop_down)
- ✓ Auto awesome/AI (Icons.auto_awesome)
- ✓ Arrow forward (Icons.arrow_forward)
- ✓ Person fallback (Icons.person)

## Where to Download Assets

### Player Images:
1. **Official Club Websites** - Manchester City's media section
2. **Getty Images** (with proper licensing)
3. **Unsplash** or **Pexels** - Search for "soccer player portrait"
4. **FIFA/EA Sports** - If you have rights to use their assets
5. **Create Placeholders** - Use https://pravatar.cc/ for testing

Example placeholder URLs for testing (download these):
```
https://i.pravatar.cc/300?img=1  → ederson.jpg
https://i.pravatar.cc/300?img=2  → gvardiol.jpg
https://i.pravatar.cc/300?img=3  → dias.jpg
... and so on
```

### Pitch Texture (Optional):
1. **Textures.com** - Search for "grass texture"
2. **Subtle Patterns** - subtlepatterns.com
3. **Create Your Own** - Any grass or green subtle pattern

## Code Architecture

### Components Overview:

1. **MyApp** - Root application widget with theme configuration
2. **TacticalLineupScreen** - Main screen (StatefulWidget)
3. **Player Model** - Data model for player information
4. **PlayerPosition Enum** - Position categorization
5. **PitchBackground** - Pitch visualization with custom painting
6. **PitchPainter** - CustomPainter for pitch markings
7. **PlayerNode** - Reusable player display component

### Key Features:

✅ **Clean Architecture**: Separated concerns with reusable widgets
✅ **Responsive Design**: Works on various screen sizes
✅ **Custom Painting**: Professional pitch markings
✅ **Type Safety**: Strongly typed models and enums
✅ **Error Handling**: Graceful fallbacks for missing images
✅ **Modern UI**: Dark theme with smooth shadows and effects

### Customization:

To change team or formation, modify:
- Player list in `_TacticalLineupScreenState`
- Player positions in `_buildPlayersOnPitch()`
- Formation text in `_buildTeamHeader()`

### Color Scheme:
- Background: `#101622` (Dark blue-grey)
- Card background: `#1e2736` (Lighter blue-grey)
- Primary accent: `#0d59f2` (Bright blue)
- Pitch: `#1e3a28` (Dark green)
- Text: White with various opacities

## Running the App

After completing setup:
```bash
flutter run
```

For hot reload during development:
- Press `r` in terminal
- Or use your IDE's hot reload feature

## Testing Without Images

The app includes error handling that shows placeholder icons if images are missing, so you can test the layout immediately without downloading all assets.

## Future Enhancements

Consider adding:
- [ ] Drag & drop player positioning
- [ ] Multiple formation presets
- [ ] Player substitution panel
- [ ] Team statistics dashboard
- [ ] Save/load lineup functionality
- [ ] Animation transitions
- [ ] Player detail modal
- [ ] Export lineup as image

## Troubleshooting

**Issue:** "Unable to load asset"
- Solution: Check file names match exactly (case-sensitive)
- Solution: Run `flutter pub get` after adding assets to pubspec.yaml

**Issue:** Font not applying
- Solution: Ensure internet connection for google_fonts to download fonts
- Solution: Restart the app after first run

**Issue:** Layout overflow
- Solution: The design is responsive, but test on various screen sizes
- Solution: Adjust padding/sizes in code if needed for your device

## License
This is a demo/POC project. Ensure you have proper rights to any images you use.
