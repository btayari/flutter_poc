# 🎨 Web Layout with Side Navigation Menu

## ✅ What's Been Added

A professional **side navigation menu** exclusively for web layout (screens > 900px) with:

### **Three-Column Web Layout**
```
┌─────────────┬──────────────────────┬─────────────────┐
│             │                      │ Match Prediction│
│  LEFT MENU  │    PITCH VIEW       │      ⚙️         │
│  (280px)    │    (Full Height)    │  RIGHT PANEL    │
│             │                      │  (420px)        │
│  - Profile  │    - Football       │  - Team Info    │
│  - Nav      │      Pitch          │  - Formation    │
│  - Logout   │      (Maximized)    │  - Players List │
│             │                      │  - Stats        │
│             │                      │  - Action Btn   │
└─────────────┴──────────────────────┴─────────────────┘
```

---

## 🎯 Side Menu Features

### **1. User Profile Section**

#### Profile Display:
- **Large Avatar**: 80x80px with blue border and glow effect
- **User Name**: "John Manager" (customizable)
- **Email**: john.manager@mancity.com
- **Club Badge**: Manchester City with shield icon

#### Styling:
- Blue glow effect around avatar
- Professional card-style club badge
- Separated by bottom border

---

### **2. Navigation Menu Items**

#### Main Navigation:
1. **🏠 Home** - Dashboard/Home page
   - Icon: `home_rounded`
   
2. **📊 Prediction** - Current page (Active)
   - Icon: `assessment_rounded`
   - Highlighted in blue
   
3. **↔️ Transfers** - Transfer market
   - Icon: `swap_horiz_rounded`
   
4. **🔍 Scouting** - Player scouting
   - Icon: `search_rounded`

#### Team Management Section:
5. **👥 Squad** - Squad management
   - Icon: `people_rounded`
   
6. **📈 Statistics** - Team stats
   - Icon: `bar_chart_rounded`
   
7. **📅 Fixtures** - Match schedule
   - Icon: `event_note_rounded`

#### Settings Section:
8. **⚙️ Settings** - App settings
   - Icon: `settings_rounded`
   
9. **❓ Help & Support** - Support page
   - Icon: `help_rounded`

---

### **3. Footer Section**

- **🚪 Logout Button**
  - Centered with icon
  - Subtle hover effect
  - Clear action indicator

---

## 🎨 Design Features

### **Active State Styling**
```dart
Active Menu Item:
- Blue background (15% opacity)
- Blue border
- Blue icon & text
- Bold text weight
```

### **Inactive State Styling**
```dart
Inactive Menu Item:
- Transparent background
- Grey icon & text
- Normal text weight
- Hover effect on interaction
```

### **Section Headers**
- **"TEAM MANAGEMENT"**
- **"SETTINGS"**
- Small uppercase text
- Grey color with letter spacing
- Visual separation

---

## 📱 Responsive Behavior

### Mobile/Tablet (< 900px):
- ❌ Side menu **hidden**
- ✅ Original vertical layout
- ✅ Mobile-optimized UI

### Web/Desktop (> 900px):
- ✅ Side menu **visible**
- ✅ Three-column layout
- ✅ Full navigation access
- ✅ Professional dashboard look

---

## 🎯 Layout Specifications

### Dimensions:
- **Left Menu**: 280px fixed width
- **Center Pitch**: Flexible (expands)
- **Right Panel**: 420px fixed width
- **Max Width**: 1800px (centered)

### Colors:
- **Background**: `#0d1117` (dark)
- **Borders**: Grey 800
- **Active**: `#0d59f2` (blue)
- **Text**: White/Grey variations

---

## 🔧 Customization Guide

### Change User Information:
```dart
// In _buildUserProfile() method:
const Text('Your Name')       // Line ~355
'your.email@club.com'         // Line ~363
'Your Club Name'              // Line ~385
```

### Change Club Badge Color:
```dart
color: const Color(0xFF6CABDD),  // Light blue for Man City
// Change to your club's color
```

### Add New Menu Items:
```dart
_buildMenuItem(
  icon: Icons.your_icon,
  label: 'Your Label',
  isActive: false,
  onTap: () {
    // Navigation logic
  },
),
```

### Modify Menu Item Order:
Simply reorder the `_buildMenuItem()` calls in `_buildNavigationMenu()`

---

## 🚀 Features & Interactions

### ✅ Interactive Elements:
- **Menu items**: Tap to navigate
- **Profile**: Displays user info
- **Club badge**: Shows team affiliation
- **Logout**: Quick access to sign out
- **Hover effects**: Visual feedback

### ✅ Visual Feedback:
- Active page highlighted
- Hover states on all buttons
- Smooth transitions
- Clear visual hierarchy

---

## 🎨 Icon Reference

All icons from **Material Icons**:

| Icon | Name | Usage |
|------|------|-------|
| 🏠 | `home_rounded` | Home |
| 📊 | `assessment_rounded` | Prediction |
| ↔️ | `swap_horiz_rounded` | Transfers |
| 🔍 | `search_rounded` | Scouting |
| 👥 | `people_rounded` | Squad |
| 📈 | `bar_chart_rounded` | Statistics |
| 📅 | `event_note_rounded` | Fixtures |
| ⚙️ | `settings_rounded` | Settings |
| ❓ | `help_rounded` | Help |
| 🚪 | `logout_rounded` | Logout |
| 🛡️ | `shield` | Club Badge |

---

## 📂 Required Assets

### User Avatar (Optional):
- **Path**: `assets/user_avatar.jpg`
- **Size**: 200x200px or larger
- **Format**: JPG or PNG
- **Fallback**: Grey circle with person icon

If image doesn't exist, displays placeholder icon automatically.

---

## 💡 Usage Examples

### Navigate to Different Page:
```dart
_buildMenuItem(
  icon: Icons.home_rounded,
  label: 'Home',
  isActive: false,
  onTap: () {
    Navigator.pushNamed(context, '/home');
  },
),
```

### Add Section Divider:
```dart
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: Text(
    'YOUR SECTION',
    style: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.bold,
      color: Colors.grey[500],
      letterSpacing: 1.2,
    ),
  ),
),
```

### Highlight Active Page:
Set `isActive: true` for the current page's menu item.

---

## 🎯 Best Practices

### Navigation:
- ✅ Use `Navigator` for page transitions
- ✅ Update `isActive` state per route
- ✅ Handle back button in web
- ✅ Maintain state across navigation

### User Profile:
- ✅ Load from authentication system
- ✅ Display real user data
- ✅ Handle profile image errors
- ✅ Update club badge dynamically

### Performance:
- ✅ Menu only renders on web
- ✅ Efficient state management
- ✅ Minimal rebuilds
- ✅ Smooth animations

---

## 🔄 Future Enhancements

Could add:
- [ ] Collapsible menu for more space
- [ ] Notifications badge on menu items
- [ ] Dark/Light theme toggle
- [ ] Quick actions dropdown
- [ ] User status indicator (online/offline)
- [ ] Recent activities feed
- [ ] Keyboard shortcuts hints
- [ ] Search bar for quick navigation
- [ ] Customizable menu order
- [ ] Pin favorite pages

---

## 🐛 Troubleshooting

### Issue: Menu not showing on web
**Solution**: Ensure screen width > 900px

### Issue: User avatar not loading
**Solution**: Check `assets/user_avatar.jpg` exists or use fallback

### Issue: Menu items not clickable
**Solution**: Verify `onTap` callbacks are defined

### Issue: Active state not updating
**Solution**: Update `isActive` parameter based on current route

---

## 📐 Layout Architecture

```dart
Web Layout Structure:
├── Side Menu (280px)
│   ├── User Profile
│   │   ├── Avatar (80x80)
│   │   ├── Name
│   │   ├── Email
│   │   └── Club Badge
│   ├── Navigation Menu
│   │   ├── Main Items
│   │   ├── Team Management
│   │   └── Settings
│   └── Footer (Logout)
├── Pitch View (Flexible)
│   ├── App Bar
│   └── Football Pitch
└── Right Panel (420px)
    ├── Team Info
    ├── Formation
    ├── Players List
    ├── Stats
    └── Action Button
```

---

## ✨ Key Components

### Methods Added:
- `_buildSideMenu()` - Main side menu container
- `_buildUserProfile()` - User profile section
- `_buildNavigationMenu()` - Navigation items list
- `_buildMenuItem()` - Individual menu item
- `_buildSideMenuFooter()` - Footer with logout

### Widgets:
- Professional profile card
- Interactive menu items
- Section headers
- Club badge
- Logout button

---

## 🎉 Result

You now have a **professional web dashboard layout** with:
- ✅ User profile display
- ✅ Full navigation menu
- ✅ Club affiliation
- ✅ 9+ navigation items
- ✅ Organized sections
- ✅ Beautiful icons
- ✅ Active state highlighting
- ✅ Responsive design
- ✅ Professional appearance

**The layout automatically switches between mobile (vertical) and web (three-column) based on screen size!**

---

## 📸 Visual Layout

### Web View (> 900px):
```
╔═══════════════════════════════════════════════════════════╗
║ [Avatar]          │                      │ Manchester City ║
║ John Manager      │   Match Prediction   │                ║
║ john@mancity.com  │         ⚙️          │ FORMATION       ║
║ 🛡️ Man City       │                      │ 4-3-3 Attack ▼  ║
║─────────────────  │   ┌──────────────┐  │ [Auto Fill]     ║
║ 🚪 Logout         │                      │                 ║
║ ↔️ Transfers      │   │              │  │ [Auto Fill]     ║
║ 🔍 Scouting       │   │    PITCH     │  │                 ║
║                   │   │     FULL     │  │ STARTING XI     ║
║ TEAM MANAGEMENT   │   │    HEIGHT    │  │ • Ederson  8.4  ║
║ 👥 Squad          │   │              │  │ • Gvardiol 7.8  ║
║ 📈 Statistics     │   │              │  │ • Dias     8.1  ║
║ 📅 Fixtures       │   │              │  │ ...             ║
║                   │   └──────────────┘  │                 ║
║ SETTINGS          │                      │ TEAM STATS      ║
║ ⚙️ Settings       │                      │ Avg Age: 26.4   ║
║ ❓ Help           │                      │ Rating: 86      ║
║─────────────────  │                      │                 ║
║ 🚪 Logout         │                      │ [Make          ║
║                   │                      │  Prediction →] ║
╚═══════════════════════════════════════════════════════════╝
```

**Your professional football management dashboard is ready! 🎉⚽**
