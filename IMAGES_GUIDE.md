# Quick Image Download Guide

## Required Images (11 total)

Place all images in: `assets/players/`

### Image List:

1. **ederson.jpg** - Goalkeeper
2. **gvardiol.jpg** - Left Defender
3. **dias.jpg** - Center Defender
4. **akanji.jpg** - Center Defender
5. **walker.jpg** - Right Defender
6. **kovacic.jpg** - Left Midfielder
7. **rodri.jpg** - Center Midfielder ⭐ (Star Player)
8. **bernardo.jpg** - Right Midfielder
9. **doku.jpg** - Left Forward
10. **haaland.jpg** - Center Forward ⭐ (Star Player)
11. **foden.jpg** - Right Forward

---

## Quick Test with Placeholder Images

For quick testing, you can use online placeholders:

### Option 1: Using pravatar.cc (Download via browser)
```
https://i.pravatar.cc/300?img=1  → Save as ederson.jpg
https://i.pravatar.cc/300?img=2  → Save as gvardiol.jpg
https://i.pravatar.cc/300?img=3  → Save as dias.jpg
https://i.pravatar.cc/300?img=4  → Save as akanji.jpg
https://i.pravatar.cc/300?img=5  → Save as walker.jpg
https://i.pravatar.cc/300?img=6  → Save as kovacic.jpg
https://i.pravatar.cc/300?img=7  → Save as rodri.jpg
https://i.pravatar.cc/300?img=8  → Save as bernardo.jpg
https://i.pravatar.cc/300?img=9  → Save as doku.jpg
https://i.pravatar.cc/300?img=10 → Save as haaland.jpg
https://i.pravatar.cc/300?img=11 → Save as foden.jpg
```

### Option 2: Use wget/curl (Terminal)
```bash
cd assets/players

curl -o ederson.jpg "https://i.pravatar.cc/300?img=1"
curl -o gvardiol.jpg "https://i.pravatar.cc/300?img=2"
curl -o dias.jpg "https://i.pravatar.cc/300?img=3"
curl -o akanji.jpg "https://i.pravatar.cc/300?img=4"
curl -o walker.jpg "https://i.pravatar.cc/300?img=5"
curl -o kovacic.jpg "https://i.pravatar.cc/300?img=6"
curl -o rodri.jpg "https://i.pravatar.cc/300?img=7"
curl -o bernardo.jpg "https://i.pravatar.cc/300?img=8"
curl -o doku.jpg "https://i.pravatar.cc/300?img=9"
curl -o haaland.jpg "https://i.pravatar.cc/300?img=10"
curl -o foden.jpg "https://i.pravatar.cc/300?img=11"
```

---

## Real Player Images

### Recommended Sources:

1. **Manchester City Official Website**
   - https://www.mancity.com/players
   - High quality player headshots
   - Check terms of use

2. **Getty Images** (Paid/Licensed)
   - Professional sports photography
   - Requires licensing for commercial use

3. **Wikimedia Commons**
   - https://commons.wikimedia.org
   - Search for individual player names
   - Check licenses (CC-BY-SA usually)

4. **Unsplash/Pexels** (Free for testing)
   - Search "soccer player portrait" or "football player"
   - Free for personal/commercial use
   - Not actual players but good for UI testing

---

## Image Specifications

- **Format:** JPG or PNG
- **Size:** 200x200px to 400x400px (will be displayed at ~40-48px)
- **Aspect Ratio:** 1:1 (square) - circular crop applied automatically
- **Quality:** Medium to high (compressed is fine since displayed small)
- **Background:** Any (will be masked to circle)

---

## Testing Without Images

The app will work without images! It shows:
- Gray placeholder circle
- Person icon
- All functionality remains the same

So you can:
1. Run `flutter pub get`
2. Run `flutter run`
3. See the layout with placeholders
4. Add images gradually

---

## Optional: Pitch Texture

For realistic grass texture:
- File: `assets/pitch_pattern.png`
- Source: https://www.transparenttextures.com/ or Google "grass texture seamless"
- Size: 512x512px or larger
- Will be displayed very subtle (3% opacity)
- Not required - solid color fallback works great!
