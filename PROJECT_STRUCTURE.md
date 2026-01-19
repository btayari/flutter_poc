# Project Structure

## Overview
The Flutter tactical lineup project has been successfully split into multiple organized files following best practices for maintainability and scalability.

## File Organization

### Main Application
- `lib/main.dart` - App entry point and theme configuration

### Models
- `lib/models/player.dart` - Player data model and PlayerPosition enum
- `lib/models/formation.dart` - Formation and PlayerPositionData models

### Data Layer
- `lib/data/data_provider.dart` - Static data provider with players and formations

### Screens
- `lib/screens/tactical_lineup_screen.dart` - Main tactical lineup screen

### Widgets
- `lib/widgets/side_menu.dart` - Navigation side menu component
- `lib/widgets/formation_selector.dart` - Formation selection widget (mobile/web responsive)
- `lib/widgets/players_list.dart` - Players list widget
- `lib/widgets/team_stats.dart` - Team statistics widget
- `lib/widgets/pitch_view.dart` - Football pitch view widget
- `lib/widgets/pitch_background.dart` - Pitch background with custom painter
- `lib/widgets/player_node.dart` - Individual player node widget

## Key Features
- ✅ Responsive design (mobile and web layouts)
- ✅ Side menu navigation
- ✅ Formation selector (bottom sheet on mobile, dropdown on web)
- ✅ Interactive pitch view with player positioning
- ✅ Clean architecture with separated concerns
- ✅ Reusable widget components

## Architecture Benefits
1. **Maintainability**: Each component is in its own file
2. **Reusability**: Widgets can be easily reused across different screens
3. **Testability**: Individual components can be tested in isolation
4. **Scalability**: Easy to add new features without modifying existing code
5. **Team Collaboration**: Multiple developers can work on different components simultaneously

## Next Steps
To run the project:
1. Ensure Flutter is installed
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` for mobile or `flutter run -d chrome` for web

## Dependencies Required
- `google_fonts` - Already included in pubspec.yaml
- Player images should be placed in `assets/players/` directory
- User avatar should be placed as `assets/user_avatar.jpg`
